import { PoseRenderer } from "./src/img_renderer";
import { PoseDetectorBuilder } from "./src/pose_models";

import * as fs from "node:fs";
import * as tfn from "@tensorflow/tfjs-node-gpu";
import * as pose_detection from "@tensorflow-models/pose-detection";
import { SupportedModels } from "@tensorflow-models/pose-detection";

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

// 模型設定
let blazeposeTfjsCfg: pose_detection.BlazePoseTfjsModelConfig = {
  runtime: "tfjs",
};
let movenetMLCfg: pose_detection.MoveNetModelConfig = {
  modelType: pose_detection.movenet.modelType.MULTIPOSE_LIGHTNING,
};
let movenetSLCfg: pose_detection.MoveNetModelConfig = {
  modelType: pose_detection.movenet.modelType.SINGLEPOSE_LIGHTNING,
};
let movenetSTCfg: pose_detection.MoveNetModelConfig = {
  modelType: pose_detection.movenet.modelType.SINGLEPOSE_THUNDER,
};
let posenetResNet50Cfg: pose_detection.PosenetModelConfig = {
  architecture: "ResNet50",
  outputStride: 16,
  inputResolution: {
    width: 257,
    height: 257,
  },
};
let posenetMobileNetV1Cfg: pose_detection.PosenetModelConfig = {
  architecture: "MobileNetV1",
  outputStride: 16,
  inputResolution: {
    width: 257,
    height: 257,
  },
};

// 模型物件
let blazeposeTfjs = await new PoseDetectorBuilder()
  .withModel(SupportedModels.BlazePose)
  .withConfig(blazeposeTfjsCfg)
  .build();
let movenetML = await new PoseDetectorBuilder()
  .withModel(SupportedModels.MoveNet)
  .withConfig(movenetMLCfg)
  .build();
let movenetSL = await new PoseDetectorBuilder()
  .withModel(SupportedModels.MoveNet)
  .withConfig(movenetSLCfg)
  .build();
let movenetST = await new PoseDetectorBuilder()
  .withModel(SupportedModels.MoveNet)
  .withConfig(movenetSTCfg)
  .build();
let posenetResNet50 = await new PoseDetectorBuilder()
  .withModel(SupportedModels.PoseNet)
  .withConfig(posenetResNet50Cfg)
  .build();
let posenetMobileNetV1 = await new PoseDetectorBuilder()
  .withModel(SupportedModels.PoseNet)
  .withConfig(posenetMobileNetV1Cfg)
  .build();
console.log("Finish Building Models");

// 進行模型運算
let blazeposeTfjsResult = await blazeposeTfjs.estimatePoses(imgTensor);
let movenetMLResult = await movenetML.estimatePoses(imgTensor);
let movenetSLResult = await movenetSL.estimatePoses(imgTensor);
let movenetSTResult = await movenetST.estimatePoses(imgTensor);
let posenetResNet50Result = await posenetResNet50.estimatePoses(imgTensor);
let posenetMobileNetV1Result = await posenetMobileNetV1.estimatePoses(
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
