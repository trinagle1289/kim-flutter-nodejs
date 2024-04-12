// 常數
const VIDEO_TAG = "A1-A3";
const VIDEO_PATH = `../../resources/video/20240401/${VIDEO_TAG}.mp4`;
const VIDEO_SIZE = "1080x1920";
const VIDEO_FRAME_RATE = 0;
const OUTPUT_PATH = `./tmp2/`;
const JSON_PATH = `${OUTPUT_PATH}${VIDEO_TAG}.json`;

import { TmpDir } from "./src/directory.js";
import { createVideoFrames } from "./src/image_processing/ffmpeg_utils.js";
import { Pose } from "@tensorflow-models/pose-detection";
import * as fs from "node:fs";
import * as tfn from "@tensorflow/tfjs-node-gpu";
import { getBlazeposeTfjs } from "./src/tf_models/get_model.js";

let tmpDir = new TmpDir(`tmp/${VIDEO_TAG}/`, true, true);
let tmp2Dir = new TmpDir(`${OUTPUT_PATH}`, false, true);

// 1. 建立影像幀
await createVideoFrames(
  VIDEO_PATH,
  `${tmpDir.DirPath}${VIDEO_TAG}(%03d).png`,
  VIDEO_SIZE,
  VIDEO_FRAME_RATE
);
console.log(`Finish creating video frame.`);

// 2. 分析影像幀後，儲存為 json 檔
let poses: Pose[][] = []; // 姿勢序列
let model = await getBlazeposeTfjs(); // 模型物件
await tmpDir.handleAllFilesFuture(async (path, parsed) => {
  console.log(`Handling file: ${parsed.name}`);
  let imgTensor = tfn.node.decodePng(fs.readFileSync(path));
  let result = await model.estimatePoses(imgTensor);
  poses.push(result);
});
fs.writeFileSync(JSON_PATH, JSON.stringify(poses));
console.log(`Finish saving json data.`);
