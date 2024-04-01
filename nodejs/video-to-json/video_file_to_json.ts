const VIDEO_FILE_PATH = "../../resources/video/20240321";
const VIDEO_SIZE = "1080x1920";

import * as fs from "node:fs";
import * as utils from "./src/utils.js";
import * as model from "./src/tf_models.js";
import { createVideoFrames } from "./src/ffmpeg_utils.js";
import * as tfn from "@tensorflow/tfjs-node-gpu";
import { Pose } from "@tensorflow-models/pose-detection";

let tmpBaseDir = new utils.TmpDir("tmp");
let jsonBaseDir = new utils.TmpDir("json");
let resDir = new utils.ResourceDir(VIDEO_FILE_PATH);

let tmpDirList: utils.TmpDir[] = [];

resDir.handleAllFiles(async (path, parsed) => {
  let name = parsed.name;

  let savedDir = new utils.TmpDir("tmp/" + name, true);
  tmpDirList.push(savedDir);

  await createVideoFrames(
    path,
    `${savedDir.DirPath}/${name}(%05d).png`,
    "1080x1920"
  );
});
console.log("Finish creat frames");

for (let tmpDir of tmpDirList) {
  await tmpDir.handleAllFiles(async (path, parsed, idx) => {

  });
}

