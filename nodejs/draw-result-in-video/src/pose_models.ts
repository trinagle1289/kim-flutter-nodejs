import * as pose_detection from "@tensorflow-models/pose-detection";
import { SupportedModels } from "@tensorflow-models/pose-detection";
import * as tf from "@tensorflow/tfjs-node-gpu";

/** 姿勢偵測器建構器 */
export class PoseDetectorBuilder {
  /** 模型設定 */
  private _modelCfg:
    | pose_detection.PosenetModelConfig
    | pose_detection.BlazePoseTfjsModelConfig
    | pose_detection.BlazePoseMediaPipeModelConfig
    | pose_detection.MoveNetModelConfig
    | undefined = undefined;

  /** 模型種類 */
  public modelType: SupportedModels;
  /** 偵測器 */
  public detector: pose_detection.PoseDetector;

  /** 設定模型 */
  public withModel(model: pose_detection.SupportedModels): this {
    this.modelType = model;
    return this;
  }

  /** 進行模型設定 */
  public withConfig(
    cfg:
      | pose_detection.PosenetModelConfig
      | pose_detection.BlazePoseTfjsModelConfig
      | pose_detection.BlazePoseMediaPipeModelConfig
      | pose_detection.MoveNetModelConfig
      | undefined
  ): this {
    this._modelCfg = cfg;
    return this;
  }

  /** 進行建構 */
  public async build(): Promise<PoseDetector> {
    this.detector = await pose_detection.createDetector(
      this.modelType,
      this._modelCfg
    );
    return new PoseDetector(this);
  }
}

/** 姿勢偵測器 */
export class PoseDetector {
  /** 模型種類 */
  public modelType: SupportedModels;
  /** 偵測器 */
  public detector: pose_detection.PoseDetector;

  public constructor(builder: PoseDetectorBuilder) {
    this.modelType = builder.modelType;
    this.detector = builder.detector;
  }

  /** 估計影像或視訊畫面的姿勢。
   * @param image 影像或視訊幀。
   * @param config 可選。有關可用選項，請參閱 “EstimationConfig”。
   * @param timestamp 可選。以毫秒為單位。當圖像是沒有時間戳資訊的張量時，這非常有用。或覆蓋影片中的時間戳。
   * @returns 一個姿勢陣列，每個姿勢包含一個「關鍵點」陣列。
   */
  public async estimatePoses(
    image: pose_detection.PoseDetectorInput,
    config?:
      | pose_detection.PoseNetEstimationConfig
      | pose_detection.BlazePoseTfjsEstimationConfig
      | pose_detection.BlazePoseMediaPipeEstimationConfig
      | pose_detection.MoveNetEstimationConfig,
    timestamp?: number
  ): Promise<pose_detection.Pose[]> {
    let originBackend = tf.getBackend();

    if (this.modelType == SupportedModels.MoveNet) {
      tf.setBackend(originBackend);
    } else {
      tf.setBackend("cpu");
    }
    let poses = await this.detector.estimatePoses(image, config, timestamp);

    tf.setBackend(originBackend);
    return poses;
  }
}
