/// 套件
import * as tf from "@tensorflow/tfjs-node-gpu";

import { makeSquareImage } from "./src/img_process";
import { loadModel, tensorResizeShape } from "./src/tfjs_lib";
import { saveMovenetResult } from "./src/show_tf_result";

/// 常數
const MODEL_PATH = "models/movenet/singlepose/thunder/model.json";
const IMG_PATH = "images/pexels-photo-4384679.jpeg";

/// 主程式
let model = await loadModel(MODEL_PATH); // 模型物件
let imgBuf = await makeSquareImage(IMG_PATH); // 圖片緩衝
let imgTensor = tf.node.decodeImage(imgBuf); // 圖片張量
// 調整張量大小
let resizedTensor = tensorResizeShape(
  imgTensor,
  model.inputs[0].shape,
  "int32"
);
let result = model.predict(resizedTensor) as tf.Tensor; // 使用模型預測結果
await saveMovenetResult("result.png", IMG_PATH, result, 3989/256);
