import * as fs from "node:fs";
import * as tfn from "@tensorflow/tfjs-node-gpu";
import ffmpeg from "ffmpeg";
import { PoseRenderer } from "./src/img_renderer";
import { MovenetST } from "./src/tf_models";
import { TmpDir } from "./src/utils";

// 影片路徑
const VIDEO_DIR = "../../resources/video/20240321";
const VIDEO_NAME = "A1-A5_1";
const VIDEO_TYPE = ".mp4";
const VIDEO_PATH = `${VIDEO_DIR}/${VIDEO_NAME}${VIDEO_TYPE}`;

// 設定 tfjs 後端
await tfn.setBackend("tensorflow");

// 清理並建立暫存資料夾
let tmp = new TmpDir("./tmp", true);
let tmp2 = new TmpDir("./tmp2", true);
let tmp3 = new TmpDir("./tmp3", true);

// 建立所有影像幀
let vidIn = await new ffmpeg(VIDEO_PATH);
await vidIn
  .setVideoSize("1080x1920", true, true)
  .save(`${tmp.DirPath}/${VIDEO_NAME}(%03d).png`);

// 儲存渲染後的所有圖片
await tmp.handleAllFiles(async (_name, _path) => {
  tfn.engine().startScope(); // 用於清理 Tensor 資料，跟 endScope() 搭配
  let img = tfn.node.decodePng(fs.readFileSync(_path));
  let result = await MovenetST.estimatePoses(img);
  let renderer = await new PoseRenderer().renderResult(_path, result);
  await renderer.savePNG(`${tmp2.DirPath}/${_name}`);
  tfn.engine().endScope(); // 用於清理 Tensor 資料，跟 startScope() 搭配
});
