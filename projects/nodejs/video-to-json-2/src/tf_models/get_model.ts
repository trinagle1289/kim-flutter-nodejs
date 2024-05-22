import { PoseDetectorBuilder, PoseDetector } from "./base.js";
import {
  BlazePoseTfjsModelConfig,
  MoveNetModelConfig,
  PosenetModelConfig,
  SupportedModels,
  movenet,
} from "@tensorflow-models/pose-detection";

export {
  getBlazeposeTfjs,
  getMovenetML,
  getMovenetSL,
  getMovenetST,
  getPosenetMobileNetV1,
  getPosenetResNet50,
};

/** 取得 BlazePose TFjs 模型
 * @returns BlazePose TFjs 模型
 */
async function getBlazeposeTfjs(): Promise<PoseDetector> {
  let cfg: BlazePoseTfjsModelConfig = {
    runtime: "tfjs",
  };
  let model = await new PoseDetectorBuilder()
    .withModel(SupportedModels.BlazePose)
    .withConfig(cfg)
    .build();
  return model;
}

/** 取得 MoveNet MultiPose Lightning 模型
 * @returns MoveNet MultiPose Lightning 模型
 */
async function getMovenetML(): Promise<PoseDetector> {
  let cfg: MoveNetModelConfig = {
    modelType: movenet.modelType.MULTIPOSE_LIGHTNING,
  };
  let model = await new PoseDetectorBuilder()
    .withModel(SupportedModels.MoveNet)
    .withConfig(cfg)
    .build();
  return model;
}

/** 取得 MoveNet SinglePose Lightning 模型
 * @returns MoveNet SinglePose Lightning 模型
 */
async function getMovenetSL(): Promise<PoseDetector> {
  let cfg: MoveNetModelConfig = {
    modelType: movenet.modelType.SINGLEPOSE_LIGHTNING,
  };
  let model = await new PoseDetectorBuilder()
    .withModel(SupportedModels.MoveNet)
    .withConfig(cfg)
    .build();
  return model;
}

/** 取得 MoveNet SinglePose Thunder 模型
 * @returns MoveNet SinglePose Thunder 模型
 */
async function getMovenetST(): Promise<PoseDetector> {
  let cfg: MoveNetModelConfig = {
    modelType: movenet.modelType.SINGLEPOSE_THUNDER,
  };
  let model = await new PoseDetectorBuilder()
    .withModel(SupportedModels.MoveNet)
    .withConfig(cfg)
    .build();
  return model;
}

/** 取得 PoseNet ResNet50 模型
 * @returns PoseNet ResNet50 模型
 */
async function getPosenetResNet50(): Promise<PoseDetector> {
  let cfg: PosenetModelConfig = {
    architecture: "ResNet50",
    outputStride: 16,
    inputResolution: {
      width: 257,
      height: 257,
    },
  };
  let model = await new PoseDetectorBuilder()
    .withModel(SupportedModels.PoseNet)
    .withConfig(cfg)
    .build();
  return model;
}

/** 取得 PoseNet MobileNet v1 模型
 * @returns PoseNet MobileNet v1 模型
 */
async function getPosenetMobileNetV1(): Promise<PoseDetector> {
  let cfg: PosenetModelConfig = {
    architecture: "MobileNetV1",
    outputStride: 16,
    inputResolution: {
      width: 257,
      height: 257,
    },
  };
  let model = await new PoseDetectorBuilder()
    .withModel(SupportedModels.PoseNet)
    .withConfig(cfg)
    .build();
  return model;
}
