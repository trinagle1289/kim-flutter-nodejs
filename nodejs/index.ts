import * as http from "node:http";
import * as fs from "node:fs";
import * as tf from "@tensorflow/tfjs-node-gpu";
import * as canvasLib from "canvas";

// 常數
const MODEL_PATH = "models/movenet/singlepose/lightning/model.json";
const IMG_PATH = "images/pexels-photo-4384679.jpeg";

// 函式
/** 加載模型 */
async function loadModel(path: string) {
  return tf.loadGraphModel(`file://${path}`);
}
/** 影像輸入轉換 */
function tensorResizeShape(image, shape?) {
    let resizedImage = tf.image.resizeBilinear(image, [shape[1], shape[2]]);
    return tf.reshape(resizedImage, shape);
}
/** 製作方形圖片 */
async function makeSquareImage(imgIn: Buffer | string) {
  let img = await canvasLib.loadImage(imgIn); // 載入圖片

  let widthIsBigger = img.width > img.height; // 圖片是否寬大於高

  let size = widthIsBigger ? img.width : img.height; // 設定畫布大小
  let canvas = canvasLib.createCanvas(size, size); // 建立畫布

  // 設定圖片繪製位置
  let drawPosX = widthIsBigger ? 0 : Math.floor((img.height - img.width) / 2);
  let drawPosY = widthIsBigger ? -Math.floor((img.height - img.width) / 2) : 0;

  // 進行繪圖，並將圖片放置於中心
  let ctx = canvas.getContext("2d");
  ctx.fillStyle = "rgba(0,0,0,255)"; // 設定背景顏色(黑色)
  ctx.fillRect(0, 0, canvas.width, canvas.height); // 繪製背景顏色
  ctx.drawImage(img, drawPosX, drawPosY); // 繪製圖片

  return canvas.toBuffer("image/png");
}
/** 儲存PNG圖片 */
async function savePNGImage(path: string, imgIn: Buffer | string) {
  let img = await canvasLib.loadImage(imgIn); // 取得圖片資料
  let canvas = canvasLib.createCanvas(img.width, img.height); // 建立畫布
  canvas.getContext("2d").drawImage(img, 0, 0); // 進行繪圖

  let out = fs.createWriteStream(path);
  let stream = canvas.createPNGStream();
  stream.pipe(out);

  out.on("finish", () => console.log("PNG 圖片檔已成功建立!"));
}

// 主程式
let model = await loadModel(MODEL_PATH); // 模型物件
let imgBuf = await makeSquareImage(IMG_PATH); // 圖片緩衝區
let imgTensor = tf.node.decodeImage(imgBuf);
let inputSize = model.inputs[0].shape!;
let resizedTensor = await tensorResizeShape(imgTensor, inputSize)
let result = model.predict(resizedTensor);