// 常數
const VIDEO_PATH = "../../resources/video/20240401/A1-A5_1.mp4";
const VIDEO_SIZE = "1080x1920";
const VIDEO_FRAME_RATE = 20;
const JSON_PATH = "./tmp2/A1-A5_1";

import { TmpDir } from "./src/directory.js";
import * as path_lib from "node:path";
import { createVideoFrames } from "./src/ffmpeg_utils.js";
import { Pose } from "@tensorflow-models/pose-detection";
import { FullPoseResultBuilder } from "./src/tf_pose_result.js";
import * as fs from "node:fs";

let tmp = new TmpDir("tmp", true, true);
let tmp2 = new TmpDir(JSON_PATH, true, true);
let videoPath = path_lib.parse(VIDEO_PATH);

// 1. 建立影像幀
await createVideoFrames(
  VIDEO_PATH,
  `${tmp.DirPath}${videoPath.name}(%03d).png`,
  VIDEO_SIZE,
  VIDEO_FRAME_RATE
);

// 2. 計算關鍵點並儲存成陣列
let blazeposeTfjs: Pose[][] = [];
let movenetML: Pose[][] = [];
let movenetSL: Pose[][] = [];
let movenetST: Pose[][] = [];
let posenetMobileNetV1: Pose[][] = [];
let posenetResNet50: Pose[][] = [];
await tmp.handleAllFiles(async (path) => {
  console.log(`Handling file: ${path}`);
  let builder = await new FullPoseResultBuilder(path).build();

  blazeposeTfjs.push(builder.BlazeposeTfjs);
  movenetML.push(builder.MovenetML);
  movenetSL.push(builder.MovenetSL);
  movenetST.push(builder.MovenetST);
  posenetMobileNetV1.push(builder.PosenetMobileNetV1);
  posenetResNet50.push(builder.PosenetResNet50);
});

// 3. 將陣列物件儲存成 json 檔案
fs.writeFileSync(
  `${tmp2.DirPath}BlazeposeTfjs.json`,
  JSON.stringify(blazeposeTfjs)
);
fs.writeFileSync(`${tmp2.DirPath}MovenetML.json`, JSON.stringify(movenetML));
fs.writeFileSync(`${tmp2.DirPath}MovenetSL.json`, JSON.stringify(movenetSL));
fs.writeFileSync(`${tmp2.DirPath}MovenetST.json`, JSON.stringify(movenetST));
fs.writeFileSync(
  `${tmp2.DirPath}PosenetMobileNetV1.json`,
  JSON.stringify(posenetMobileNetV1)
);
fs.writeFileSync(
  `${tmp2.DirPath}PosenetResNet50.json`,
  JSON.stringify(posenetResNet50)
);

console.log("Finish saving json files.");
