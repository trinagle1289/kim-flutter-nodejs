import * as fs from "node:fs";
import * as tf from "@tensorflow/tfjs-node-gpu";
import { imageMeta } from "image-meta";

import * as img_process from "./img_process";

/**
 * 在圖片上繪製 MoveNet 的預測結果
 * @param path 儲存 PNG 影像路徑
 * @param img 輸入影像路徑
 * @param result MoveNet 預測結果
 * @param radius 繪製紅色圓形的半徑
 * @returns
 */
export async function saveMovenetResult(
  path: string,
  img: string,
  result: tf.Tensor,
  radius: number = 30
) {
  let meta = imageMeta(fs.readFileSync(img));

  // 無法抓到圖片資訊
  if (meta.width == undefined || meta.height == undefined) {
    return;
  }

  // 變數
  let widthIsBigger = meta.width > meta.height; // 確認寬度是否比高度大
  let size = widthIsBigger ? meta.width : meta.height; // 最大的長度
  let diffX = !widthIsBigger ? Math.floor((meta.height - meta.width) / 2) : 0; // 要調整的 X 軸位置
  let diffY = widthIsBigger ? Math.floor((meta.width - meta.height) / 2) : 0; // 要調整的 Y 軸位置

  // 取得關鍵點座標
  let data = (await result.squeeze().array()) as number[][];
  let kpts: number[][] = [[]];
  for (let idx = 0; idx < data.length; idx++) {
    kpts[idx] = [
      Math.floor(data[idx][1] * size - diffX),
      Math.floor(data[idx][0] * size - diffY),
    ];
  }

  // 繪圖並儲存成影像
  await img_process.savePNGImage(
    path,
    await img_process.drawCirclesInImage(img, kpts, radius)
  );
}
