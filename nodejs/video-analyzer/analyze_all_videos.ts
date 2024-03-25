import * as fs from "node:fs";
import * as pth_lib from "node:path";
import ffmpeg from "ffmpeg";
import * as tfn from "@tensorflow/tfjs-node-gpu";
import { Pose } from "@tensorflow-models/pose-detection";
import * as models from "./src/tf_models";
import * as render_img from "./src/img_renderer";
import { ResourceDir, TmpDir } from "./src/utils";

const VIDEO_DIR_PATH = "../../resources/video/20240321"; // 影片資料夾路徑
const VIDEO_SIZE = "1080x1920"; // 影片大小
const OUTPUT_DIR_PATH = "./output";

await tfn.setBackend("tensorflow");

let tmpDir = new TmpDir("./tmp1", true, false);
let resDir = new ResourceDir(VIDEO_DIR_PATH);

await resDir.handleAllFiles(async (_file, _path) => {
  // 轉換影片為 PNG 圖片
  await new ffmpeg(_path, (_err, video) => {
    video
      .setVideoSize(VIDEO_SIZE, true, true)
      .setVideoFrameRate(1)
      .save(`${tmpDir.DirPath}/${_file}(%02d).png`);
  });

  // 設定檔案輸出儲存路徑
  let savedPath = `${OUTPUT_DIR_PATH}/${pth_lib.parse(_file).name}/`;
  console.log(savedPath);
  fs.mkdirSync(savedPath, { recursive: true });

  // 轉換 PNG 圖片為姿勢判斷過後的圖片，並儲存在特定檔案位置上
  await tmpDir.handleAllFiles(async (_f, _p) => {
    let result: Pose[] = [];
    let imgTensor = tfn.node.decodePng(fs.readFileSync(_p));

    result = await models.BlazeposeTfjs.estimatePoses(imgTensor);
    await (
      await new render_img.PoseRenderer().renderResult(_p, result)
    ).savePNG(`${savedPath}/BlazeposeTfjs_${_f}`);

    result = await models.MovenetML.estimatePoses(imgTensor);
    await (
      await new render_img.PoseRenderer().renderResult(_p, result)
    ).savePNG(`${savedPath}/MovenetML_${_f}`);

    result = await models.MovenetSL.estimatePoses(imgTensor);
    await (
      await new render_img.PoseRenderer().renderResult(_p, result)
    ).savePNG(`${savedPath}/MovenetSL_${_f}`);

    result = await models.MovenetST.estimatePoses(imgTensor);
    await (
      await new render_img.PoseRenderer().renderResult(_p, result)
    ).savePNG(`${savedPath}/MovenetST_${_f}`);

    result = await models.PosenetMobileNetV1.estimatePoses(imgTensor);
    await (
      await new render_img.PoseRenderer().renderResult(_p, result)
    ).savePNG(`${savedPath}/PosenetMobileNetV1_${_f}`);

    result = await models.PosenetResNet50.estimatePoses(imgTensor);
    await (
      await new render_img.PoseRenderer().renderResult(_p, result)
    ).savePNG(`${savedPath}/PosenetResNet50_${_f}`);

    imgTensor.dispose(); // 程式優化(將 imgTensor 物件刪除)
  });
});

tmpDir.deleteAllFiles();
// fs.rmSync(tmpDir.DirPath, { recursive: true });
