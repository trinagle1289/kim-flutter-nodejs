import { PoseRenderer } from "./src/img_renderer";
import {
  BlazeposeTfjs,
  MovenetML,
  MovenetSL,
  MovenetST,
  PosenetResNet50,
  PosenetMobileNetV1,
} from "./src/tf_models";

import * as fs from "node:fs";
import * as tfn from "@tensorflow/tfjs-node-gpu";

// 常數
const IMG_PATH = "assets/images/girl-4051811_960_720.jpg"; // 影像路徑
const CIRCLE_RADIUS = 5; // 繪圖圓圈半徑
const SAVED_PATH = "./result/1/"; // 圖片儲存路徑

// 設定運算後端
console.log(
  (await tfn.setBackend("tensorflow"))
    ? `Finish setting backend: ${tfn.getBackend()}`
    : "Failed to set backend 'tensorflow'"
);

// 取得影像張量
let imgTensor = tfn.node.decodeImage(fs.readFileSync(IMG_PATH)) as tfn.Tensor3D;

// 進行模型運算
let blazeposeTfjsResult = await BlazeposeTfjs.estimatePoses(imgTensor);
let movenetMLResult = await MovenetML.estimatePoses(imgTensor);
let movenetSLResult = await MovenetSL.estimatePoses(imgTensor);
let movenetSTResult = await MovenetST.estimatePoses(imgTensor);
let posenetResNet50Result = await PosenetResNet50.estimatePoses(imgTensor);
let posenetMobileNetV1Result = await PosenetMobileNetV1.estimatePoses(
  imgTensor
);

// 將運算結果繪製到圖片上
await (
  await new PoseRenderer()
    .withCircleRadius(CIRCLE_RADIUS)
    .renderResult(IMG_PATH, blazeposeTfjsResult)
).savePNG(`${SAVED_PATH}BlazeposeTfjs.png`);
await (
  await new PoseRenderer()
    .withCircleRadius(CIRCLE_RADIUS)
    .renderResult(IMG_PATH, movenetMLResult)
).savePNG(`${SAVED_PATH}movenetML.png`);
await (
  await new PoseRenderer()
    .withCircleRadius(CIRCLE_RADIUS)
    .renderResult(IMG_PATH, movenetSLResult)
).savePNG(`${SAVED_PATH}movenetSL.png`);
await (
  await new PoseRenderer()
    .withCircleRadius(CIRCLE_RADIUS)
    .renderResult(IMG_PATH, movenetSTResult)
).savePNG(`${SAVED_PATH}movenetST.png`);
await (
  await new PoseRenderer()
    .withCircleRadius(CIRCLE_RADIUS)
    .renderResult(IMG_PATH, posenetResNet50Result)
).savePNG(`${SAVED_PATH}posenetResNet50.png`);
await (
  await new PoseRenderer()
    .withCircleRadius(CIRCLE_RADIUS)
    .renderResult(IMG_PATH, posenetMobileNetV1Result)
).savePNG(`${SAVED_PATH}posenetMobileNetV1.png`);
