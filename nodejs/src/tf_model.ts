// 套件
import * as tf from "@tensorflow/tfjs-node-gpu";

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
