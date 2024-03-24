import { PoseDetectorBuilder } from "./pose_models";

import * as tfn from "@tensorflow/tfjs-node-gpu";
import * as pose_detection from "@tensorflow-models/pose-detection";
import { SupportedModels } from "@tensorflow-models/pose-detection";

// 對外使用變數
export {
  BlazeposeTfjs,
  MovenetML,
  MovenetSL,
  MovenetST,
  PosenetResNet50,
  PosenetMobileNetV1,
};

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
/** BlazePose TFJS 版 */
var BlazeposeTfjs = await new PoseDetectorBuilder()
  .withModel(SupportedModels.BlazePose)
  .withConfig(blazeposeTfjsCfg)
  .build();
/** MoveNet Multipose Lightning */
var MovenetML = await new PoseDetectorBuilder()
  .withModel(SupportedModels.MoveNet)
  .withConfig(movenetMLCfg)
  .build();
/** MoveNet Single Pose Lightning */
var MovenetSL = await new PoseDetectorBuilder()
  .withModel(SupportedModels.MoveNet)
  .withConfig(movenetSLCfg)
  .build();
/** MoveNet Single Pose Thunder */
var MovenetST = await new PoseDetectorBuilder()
  .withModel(SupportedModels.MoveNet)
  .withConfig(movenetSTCfg)
  .build();
/** PoseNet ResNet50 */
var PosenetResNet50 = await new PoseDetectorBuilder()
  .withModel(SupportedModels.PoseNet)
  .withConfig(posenetResNet50Cfg)
  .build();
/** Posenet MobileNetV1 */
var PosenetMobileNetV1 = await new PoseDetectorBuilder()
  .withModel(SupportedModels.PoseNet)
  .withConfig(posenetMobileNetV1Cfg)
  .build();
console.log("Finish Building Models");
