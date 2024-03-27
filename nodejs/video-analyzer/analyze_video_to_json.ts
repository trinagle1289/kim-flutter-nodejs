import * as fs from "node:fs";
import * as pth_lib from "node:path";
import * as utils from "./src/utils.js";
import * as model from "./src/tf_models.js";
import * as tfn from "@tensorflow/tfjs-node-gpu";
import { Pose } from "@tensorflow-models/pose-detection";
import ffmpeg from "ffmpeg";

// 常數
const VIDEO_PATH = "../../resources/video/20240321/A1-A5_1.mp4";
const VIDEO_SIZE = "1080x1920";
const JSON_PATH = "./pose_result.json";

let tmp = new utils.TmpDir("./tmp", true);
let vid_name = pth_lib.parse(VIDEO_PATH).name;
let poses: Pose[][] = [];

// Create Video Frames
let video = await new ffmpeg(VIDEO_PATH);
await video
  .setVideoSize(VIDEO_SIZE, true, true)
  .setVideoFrameRate(1)
  .save(`${tmp.DirPath}/${vid_name}(%02d).png`);

// Get Pose Result In Frames
console.log("2");
await tmp.handleAllFiles(async (f, pth) => {
  let img = tfn.node.decodePng(fs.readFileSync(pth));
  let pose = await model.BlazeposeTfjs.estimatePoses(img);
  img.dispose();
//   console.log(`${pth_lib.parse(f).name}:\n`);
  poses.push(pose);
});

fs.writeFileSync(JSON_PATH, JSON.stringify(poses));
console.log("end");
