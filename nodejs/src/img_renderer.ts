// 套件
import * as fs from "node:fs";
import * as canvasLib from "canvas";
import { Pose } from "@tensorflow-models/pose-detection";

/** 圖片渲染器 */
abstract class ImageRenderer {
  /** 影像Buffer */
  protected _imgBuffer: Buffer;

  /** 取得影像Buffer */
  public get ImageBuffer(): Buffer {
    return this._imgBuffer;
  }

  /** 繪製多個圓圈
   * @param circles 圓圈位置，內容為[[x, y], ......]
   * @param radius 圓圈半徑
   * @param rgb 圓圈顏色[r, g, b]，預設為紅色
   * @returns 此渲染器
   */
  protected async drawCircles(
    circles: number[][],
    radius: number = 10,
    rgb: number[] = [255, 0, 0]
  ): Promise<this> {
    let imgData = await canvasLib.loadImage(this._imgBuffer);
    let canvas = canvasLib.createCanvas(imgData.width, imgData.height);

    // 設定繪圖空間
    let ctx = canvas.getContext("2d");
    // 繪製輸入影像
    ctx.drawImage(imgData, 0, 0);
    // 設定圓圈顏色
    ctx.fillStyle = `rgba(${rgb[0]},${rgb[1]},${rgb[2]},255)`;
    // 繪製圓圈
    circles.forEach((e) => {
      ctx.beginPath();
      ctx.arc(e[0], e[1], radius, 0, Math.PI * 2);
      ctx.fill();
    });

    // 儲存結果
    this._imgBuffer = canvas.toBuffer("image/jpeg");
    return this;
  }
  /** 繪製多個線條
   * @param lines 線條 [[[起點X座標 , 起點X座標], [終點X座標, 終點Y座標]], ...]
   * @param rgb 線條顏色[r, g, b]，預設為黑色
   * @returns 此渲染器
   */
  protected async drawLines(
    lines: number[][][],
    rgb: number[] = [255, 255, 255]
  ): Promise<this> {
    let imgData = await canvasLib.loadImage(this._imgBuffer);
    let canvas = canvasLib.createCanvas(imgData.width, imgData.height);

    // 設定繪圖空間
    let ctx = canvas.getContext("2d");
    // 繪製輸入影像
    ctx.drawImage(imgData, 0, 0);
    // 設定線條顏色
    ctx.fillStyle = `rgba(${rgb[0]},${rgb[1]},${rgb[2]},255)`;
    // 繪製線條
    lines.forEach(([pos1, pos2]) => {
      ctx.beginPath();
      ctx.lineTo(pos1[0], pos1[1]); // 畫線起點
      ctx.lineTo(pos2[0], pos2[1]); // 畫線終點
      ctx.stroke();
    });

    // 儲存結果
    this._imgBuffer = canvas.toBuffer("image/jpeg");
    return this;
  }
  /** 儲存為PNG圖片
   * @param path
   */
  public async savePNG(path: string): Promise<void> {
    let imgOut = await canvasLib.loadImage(this._imgBuffer);
    let canvas = canvasLib.createCanvas(imgOut.width, imgOut.height);
    canvas.getContext("2d").drawImage(imgOut, 0, 0);

    let out = fs.createWriteStream(path); // 檔案輸出物件
    let stream = canvas.createPNGStream(); // 建立 PNG 流
    stream.pipe(out); // PNG 流綁定到檔案輸出物件

    out.on("finish", () => console.log("PNG 圖片檔已成功建立!"));
  }

  /** 取得渲染模型結果
   * @param src 輸入影像路徑
   * @param result 此渲染器
   */
  public abstract renderResult(src: string, result: Pose[]): Promise<this>;
  /** 取得圓圈陣列
   * @param result 圓圈陣列
   */
  protected abstract getCircles(result: Pose[]): number[][];
  /** 取得線條陣列
   * @param result 圓圈陣列
   */
  protected abstract getLines(result: Pose[]): number[][];
}

/** MoveNet單人姿勢結果渲染器 */
export class SinglePoseRenderer extends ImageRenderer {
  public async renderResult(src: string, result: Pose[]): Promise<this> {
    this._imgBuffer = fs.readFileSync(src); // 設定影像Buffer
    let circles = this.getCircles(result); // 取得圓圈
    this._imgBuffer = (await this.drawCircles(circles, 10))._imgBuffer; // 畫圈
    return this;
  }

  protected getCircles(result: Pose[]): number[][] {
    let kpts: number[][] = []; // 關鍵點座標
    // 提取關鍵點
    result[0].keypoints.forEach((e) => {
      kpts.push([Math.floor(e.x), Math.floor(e.y)]);
    });
    return kpts;
  }

  protected getLines(result: Pose[]): number[][] {
    return [];
  }
}
