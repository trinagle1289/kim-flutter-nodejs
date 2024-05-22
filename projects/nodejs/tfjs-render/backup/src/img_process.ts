import * as fs from "node:fs";
import * as canvasLib from "canvas";

/** 製作方形圖片 */
export async function makeSquareImage(imgIn: Buffer | string) {
  let img = await canvasLib.loadImage(imgIn); // 載入圖片

  let widthIsBigger = img.width > img.height; // 圖片是否寬大於高

  let size = widthIsBigger ? img.width : img.height; // 設定畫布大小
  let canvas = canvasLib.createCanvas(size, size); // 建立畫布

  // 設定圖片繪製位置
  let drawPosX = widthIsBigger ? 0 : Math.floor((img.height - img.width) / 2);
  let drawPosY = widthIsBigger ? Math.floor((img.width - img.height) / 2) : 0;

  // 進行繪圖，並將圖片放置於中心
  let ctx = canvas.getContext("2d");
  ctx.fillStyle = "rgba(0,0,0,255)"; // 設定背景顏色(黑色)
  ctx.fillRect(0, 0, canvas.width, canvas.height); // 繪製背景顏色
  ctx.drawImage(img, drawPosX, drawPosY); // 繪製圖片

  return canvas.toBuffer("image/jpeg");
}

/** 在圖片中繪製圓圈 */
export async function drawCirclesInImage(
  imgIn: Buffer | string,
  circles: number[][],
  radius: number
) {
  let img = await canvasLib.loadImage(imgIn); // 載入圖片
  let canvas = canvasLib.createCanvas(img.width, img.height); // 建立畫布

  let ctx = canvas.getContext("2d"); // 進行繪圖
  ctx.drawImage(img, 0, 0); // 繪製載入的圖片

  // 畫圓形(紅色)
  ctx.fillStyle = "rgba(255,0,0,255)";
  circles.forEach((e) => {
    ctx.beginPath();
    ctx.arc(e[0], e[1], radius, 0, 2 * Math.PI);
    ctx.fill();
  });

  return canvas.toBuffer("image/jpeg");
}

/** 儲存PNG圖片 */
export async function savePNGImage(path: string, imgIn: Buffer | string) {
  let img = await canvasLib.loadImage(imgIn); // 取得圖片資料
  let canvas = canvasLib.createCanvas(img.width, img.height); // 建立畫布
  canvas.getContext("2d").drawImage(img, 0, 0); // 進行繪圖

  let out = fs.createWriteStream(path); // 檔案輸出物件
  let stream = canvas.createPNGStream(); // 建立 PNG 流
  stream.pipe(out); // PNG 流綁定到檔案輸出物件
  out.on("finish", () => console.log("PNG 圖片檔已成功建立!"));
}
