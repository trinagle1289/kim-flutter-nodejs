const VIDEO_TAG = "A4_2-A2";
const VIDEO_PATH = `../../resources/video/20240401/${VIDEO_TAG}.mp4`;
const VIDEO_SIZE = "1080x1920";
const VIDEO_FRAME = 0;
const OUTPUT_PATH = `tmp_render/${VIDEO_TAG}/`;

const BLAZEPOSE_TFJS_PATH = `${OUTPUT_PATH}BlazePose TFjs/`;
const MOVENET_ML_PATH = `${OUTPUT_PATH}MoveNet Multipose Lightning/`;
const MOVENET_SL_PATH = `${OUTPUT_PATH}MoveNet Singlepose Lightning/`;
const MOVENET_ST_PATH = `${OUTPUT_PATH}MoveNet Singlepose Thunder/`;
const POSENET_MOBILENET_V1_PATH = `${OUTPUT_PATH}PoseNet MobileNetV1/`;
const POSENET_RESNET50_PATH = `${OUTPUT_PATH}PoseNet ResNet50/`;

import { createVideoFrames } from "./src/image_processing/ffmpeg_utils.js";
import { TmpDir } from "./src/directory.js";
import * as fs from "node:fs";
import * as path_lib from "node:path";
import { FullPoseResultBuilder } from "./src/tf_models/model_result.js";
import { PoseRenderer } from "./src/image_processing/img_renderer.js";

// 1. 建立暫存資料夾，並將影片轉換成多張圖片
let tmpdir = new TmpDir(`tmp/${VIDEO_TAG}`, false, true);
await createVideoFrames(
  VIDEO_PATH,
  `${tmpdir.DirPath}${VIDEO_TAG}(%03d).png`,
  VIDEO_SIZE,
  VIDEO_FRAME
);
console.log(`Finish creating frames from ${VIDEO_PATH}`);

// 2. 建立輸出資料夾
let outputPath = [
  BLAZEPOSE_TFJS_PATH,
  MOVENET_ML_PATH,
  MOVENET_SL_PATH,
  MOVENET_ST_PATH,
  POSENET_MOBILENET_V1_PATH,
  POSENET_RESNET50_PATH,
];
outputPath.forEach((val) => {
  let path = path_lib.normalize(val);
  if (!fs.existsSync(path)) {
    fs.mkdirSync(path, { recursive: true });
    console.log(`Create Folder in ${path}`);
  }
});
console.log(`Finish creating folders at ${outputPath}`);

// 3. 將暫存資料夾中的圖片進行根據姿勢模型進行渲染，並將結果儲存於輸出資料夾中
await tmpdir.handleAllFilesFuture(async (path, parsed) => {
  console.log(`Rendering image: ${parsed.name}`);

  // 取得所有模型的運算結果
  let results = await new FullPoseResultBuilder(path).build();
  // 渲染運算結果
  let renderBlazeposeTfjs = await new PoseRenderer()
    .withCircleRadius(5)
    .renderResult(path, results.BlazeposeTfjs);
  let renderMovenetML = await new PoseRenderer()
    .withCircleRadius(5)
    .renderResult(path, results.MovenetML);
  let renderMovenetSL = await new PoseRenderer()
    .withCircleRadius(5)
    .renderResult(path, results.MovenetSL);
  let renderMovenetST = await new PoseRenderer()
    .withCircleRadius(5)
    .renderResult(path, results.MovenetST);
  let renderPosenetMobileNetV1 = await new PoseRenderer()
    .withCircleRadius(5)
    .renderResult(path, results.PosenetMobileNetV1);
  let renderPosenetResNet50 = await new PoseRenderer()
    .withCircleRadius(5)
    .renderResult(path, results.PosenetResNet50);

  // 將渲染過的圖片進行儲存
  renderBlazeposeTfjs.savePNG(`${BLAZEPOSE_TFJS_PATH}${parsed.name}.png`, true);
  renderMovenetML.savePNG(`${MOVENET_ML_PATH}${parsed.name}.png`, true);
  renderMovenetSL.savePNG(`${MOVENET_SL_PATH}${parsed.name}.png`, true);
  renderMovenetST.savePNG(`${MOVENET_ST_PATH}${parsed.name}.png`, true);
  renderPosenetMobileNetV1.savePNG(
    `${POSENET_MOBILENET_V1_PATH}${parsed.name}.png`,
    true
  );
  renderPosenetResNet50.savePNG(
    `${POSENET_RESNET50_PATH}${parsed.name}.png`,
    true
  );
  console.log(`Finish Saving Image: ${parsed.name}`);
});
