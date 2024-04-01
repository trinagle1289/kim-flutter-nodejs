import * as tfn from "@tensorflow/tfjs-node-gpu";
import * as fs from "node:fs";
import * as tf_models from "./tf_models.js";
import { Pose } from "@tensorflow-models/pose-detection";
import { PoseDetector } from "./pose_models.js";

/** 取得 PNG 偵測結果
 * @param pngPath PNG 檔案路徑
 * @param model tf_models 中的模型
 * @returns 偵測姿勢結果
 */
export async function getPngResult(
  pngPath: string,
  model: PoseDetector
): Promise<Pose[]> {
  let img = tfn.node.decodePng(fs.readFileSync(pngPath));
  let pose = await model.estimatePoses(img);
  img.dispose();
  return pose;
}

export async function getAllPngResult(pngPath: string): Promise<void> {
  let img = tfn.node.decodePng(fs.readFileSync(pngPath));
  img.dispose();
}

export class FullPoseResult {
  private _blazeposeTfjs: Pose[];
  private _movenetML: Pose[];
  private _movenetSL: Pose[];
  private _movenetST: Pose[];
  private _posenetMobileNetV1: Pose[];
  private _posenetResNet50: Pose[];
}
