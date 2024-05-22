// 套件
import * as tf from "@tensorflow/tfjs-node-gpu";
import { IOHandler } from "@tensorflow/tfjs-core/dist/io/types";

/** MoveNet 模型路徑 */
export enum MovenetPath {
  //   MultiposeLightning = "assets/models/movenet/multipose/lightning/model.json",
  SingleposeLightning = "assets/models/movenet/singlepose/lightning/model.json",
  SingleposeThunder = "assets/models/movenet/singlepose/thunder/model.json",
}

/** TFModel 建構器 */
class TFModelBuilder {
  /** 模型物件 */
  public model: tf.GraphModel<string | IOHandler>;
  /** 模型輸入形狀 */
  public inputShape: number[] | undefined;
  /** 模型輸出形狀 */
  public outputShape: number[] | undefined;

  /** 建構 TFModel 物件 */
  protected build(): TFModel {
    return new TFModel(this);
  }

  /** 使用模型物件設定建構器中的模型
   * @param _model 模型物件
   * @returns 建構器自身
   */
  protected withModel(_model: tf.GraphModel<string | IOHandler>) {
    this.model = _model;
    return this;
  }

  /** 設定模型輸入及輸出形狀
   * @param input 輸入形狀
   * @param output 輸出形狀
   * @returns 建構器自身
   */
  protected withShape(
    input: number[] | undefined,
    output: number[] | undefined
  ): this {
    this.inputShape = input;
    this.outputShape = output;
    return this;
  }
}

/** MoveNet 模型建構器 */
export class MovenetBuilder extends TFModelBuilder {
  public async buildWith(path: MovenetPath): Promise<TFModel> {
    let _model = await tf.loadGraphModel(`file://${path}`);
    let _inputShape = _model.inputs[0].shape;
    let _outputShape = [1, 1, 17, 3];
    return this.withModel(_model).withShape(_inputShape, _outputShape).build();
  }
}

/** TensorFlow 模型 */
class TFModel {
  /** 模型物件 */
  protected model: tf.GraphModel<string | IOHandler>;
  /** 輸入形狀 */
  protected inputShape: number[] | undefined;
  /** 輸出形狀 */
  protected outputShape: number[] | undefined;

  /** 需要使用到 builder 進行建構
   * @param builder 模型建構器
   */
  public constructor(builder: TFModelBuilder) {
    this.model = builder.model;
    this.inputShape = builder.inputShape;
    this.outputShape = builder.outputShape;
  }
}

/** 加載模型 */
export function loadModel(path: string) {
  return tf.loadGraphModel(`file://${path}`);
}

/** 影像輸入轉換 */
export function tensorResizeShape(
  image: tf.Tensor3D | tf.Tensor4D,
  shape?: number[] | undefined,
  dtype?: tf.DataType
) {
  // 防止 shape 數值出錯對策
  if (shape == undefined) {
    console.log(`shape 參數為 undefined, 將回傳輸入影像`);
    return image;
  }
  if (shape.length < 3) {
    console.log(`shape 陣列小於 3, 將回傳輸入影像`);
    return image;
  }

  // 調整圖片大小
  let resizedImage = tf.image.resizeBilinear(image, [shape[1], shape[2]]);
  // 設定圖片格式
  if (dtype != undefined) {
    resizedImage = resizedImage.cast(dtype);
  }

  return tf.reshape(resizedImage, shape);
}
