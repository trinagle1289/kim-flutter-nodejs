const VIDEO_FILE_PATH = "../../resources/video/20240401";
const VIDEO_SIZE = "1080x1920";
const OUTPUT_JSON_PATH = "./json";

import { createVideoFrames } from "./src/ffmpeg_utils.js";
import * as utils from "./src/utils.js";
import * as fs from "node:fs";
import * as path_lib from "node:path";
import * as tf_pose_result from "./src/tf_pose_result.js";
import { Pose } from "@tensorflow-models/pose-detection";

let resDir = new utils.ResourceDir(VIDEO_FILE_PATH);
let tmpDir = new utils.TmpDir("tmp");
let jsonDir = new utils.TmpDir(OUTPUT_JSON_PATH);
let tmpDirList: utils.TmpDir[] = [];

// 1. 處理全部來源檔案
await resDir.handleAllFiles(async (path, parsed) => {
  let name = parsed.name;
  let savedDir = new utils.TmpDir("tmp/" + name, false, true);
  await createVideoFrames(
    path,
    `${savedDir.DirPath}${name}(%03d).png`,
    VIDEO_SIZE
  );
});
console.log("Finish create frames");

// 2. 將新建資料夾整理成陣列
await tmpDir.handleAllFiles(async (path) => {
  tmpDirList.push(new utils.TmpDir(path, false, true));
});

// 3. 將輸出圖片轉換成 json 檔案
for (let tmpDir of tmpDirList) {
  // 建立各個姿勢估計結果物件
  let blazeposeTfjs: Pose[][] = [];
  let movenetML: Pose[][] = [];
  let movenetSL: Pose[][] = [];
  let movenetST: Pose[][] = [];
  let posenetMobileNetV1: Pose[][] = [];
  let posenetResNet50: Pose[][] = [];

  // 將檔案中圖片進行姿勢估計，並將資料儲存至陣列中
  console.log(`Handling files in ${tmpDir.DirPath}`);
  await tmpDir.handleAllFiles(async (path, parsed) => {
    console.log(`Handling ${parsed.name}`);
    let poseResults = await new tf_pose_result.FullPoseResultBuilder(
      path
    ).build();
    blazeposeTfjs.push(poseResults.BlazeposeTfjs);
    movenetML.push(poseResults.MovenetML);
    movenetSL.push(poseResults.MovenetSL);
    movenetST.push(poseResults.MovenetST);
    posenetMobileNetV1.push(poseResults.PosenetMobileNetV1);
    posenetResNet50.push(poseResults.PosenetResNet50);
  });

  // 切割路徑，並取得當前檔案資料夾的名稱
  let splitedPath = tmpDir.DirPath.split(path_lib.sep);
  let outputPath = path_lib.normalize(
    splitedPath[splitedPath.length - 2] + "/"
  );

  // 將運算結果進行儲存
  console.log(`Saving Json Files In ${jsonDir.DirPath}${outputPath}`);
  if (!fs.existsSync(jsonDir.DirPath + outputPath)) {
    fs.mkdirSync(jsonDir.DirPath + outputPath);
  }
  fs.writeFileSync(
    `${jsonDir.DirPath}${outputPath}/BlazeposeTfjs.json`,
    JSON.stringify(blazeposeTfjs)
  );
  fs.writeFileSync(
    `${jsonDir.DirPath}${outputPath}/MovenetML.json`,
    JSON.stringify(movenetML)
  );
  fs.writeFileSync(
    `${jsonDir.DirPath}${outputPath}/MovenetSL.json`,
    JSON.stringify(movenetSL)
  );
  fs.writeFileSync(
    `${jsonDir.DirPath}${outputPath}/MovenetST.json`,
    JSON.stringify(movenetST)
  );
  fs.writeFileSync(
    `${jsonDir.DirPath}${outputPath}/PosenetMobileNetV1.json`,
    JSON.stringify(posenetMobileNetV1)
  );
  fs.writeFileSync(
    `${jsonDir.DirPath}${outputPath}/PosenetResNet50.json`,
    JSON.stringify(posenetResNet50)
  );
}
