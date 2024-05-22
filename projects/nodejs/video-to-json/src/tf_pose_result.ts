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

/** FullPoseResult 建立器，用於建構 FullPoseResult 類別 */
export class FullPoseResultBuilder {
  // 圖片路徑
  private _pngPath: string = "";
  // 姿勢偵測結果
  public BlazeposeTfjs: Pose[] = [];
  public MovenetML: Pose[] = [];
  public MovenetSL: Pose[] = [];
  public MovenetST: Pose[] = [];
  public PosenetMobileNetV1: Pose[] = [];
  public PosenetResNet50: Pose[] = [];

  /** 建構物件
   * @param pngPath PNG 檔案路徑
   */
  constructor(pngPath: string) {
    this._pngPath = pngPath;
  }

  /** 建構 FullPoseResult 物件
   * @returns FullPoseResult 物件
   */
  public async build() {
    let img = tfn.node.decodePng(fs.readFileSync(this._pngPath));

    this.BlazeposeTfjs = await tf_models.BlazeposeTfjs.estimatePoses(img);
    this.MovenetML = await tf_models.MovenetML.estimatePoses(img);
    this.MovenetSL = await tf_models.MovenetSL.estimatePoses(img);
    this.MovenetST = await tf_models.MovenetST.estimatePoses(img);
    this.PosenetMobileNetV1 = await tf_models.PosenetMobileNetV1.estimatePoses(
      img
    );
    this.PosenetResNet50 = await tf_models.PosenetResNet50.estimatePoses(img);

    img.dispose();
    return new FullPoseResult(this);
  }
}

/** 全部姿勢的結果，會收錄全部模型偵測結果 */
export class FullPoseResult {
  public BlazeposeTfjs: Pose[] = [];
  public MovenetML: Pose[] = [];
  public MovenetSL: Pose[] = [];
  public MovenetST: Pose[] = [];
  public PosenetMobileNetV1: Pose[] = [];
  public PosenetResNet50: Pose[] = [];

  constructor(builder: FullPoseResultBuilder) {
    this.BlazeposeTfjs = builder.BlazeposeTfjs;
    this.MovenetML = builder.MovenetML;
    this.MovenetSL = builder.MovenetSL;
    this.MovenetST = builder.MovenetST;
    this.PosenetMobileNetV1 = builder.PosenetMobileNetV1;
    this.PosenetResNet50 = builder.PosenetResNet50;
  }
}
