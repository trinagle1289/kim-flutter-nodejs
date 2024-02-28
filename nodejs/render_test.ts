import * as fs from "node:fs";
import * as pose_detection from "@tensorflow-models/pose-detection";
import * as tf from "@tensorflow/tfjs-node-gpu";
import * as img_renderer from "./src/img_renderer";

const IMG_PATH = "assets/images/pexels-photo-4384679.jpeg";

await tf.setBackend("tensorflow");
let img = tf.node.decodeImage(fs.readFileSync(IMG_PATH)) as tf.Tensor3D;

let model = pose_detection.SupportedModels.BlazePose;
let cfg: pose_detection.BlazePoseTfjsModelConfig = {
  runtime: "tfjs",
  modelType: "full",
};
let detector = await pose_detection.createDetector(model, cfg);

await tf.setBackend("cpu");
let result = await detector.estimatePoses(img);
console.log(result[0].keypoints);

let renderer = new img_renderer.SinglePoseRenderer();
await(await renderer.renderResult(IMG_PATH, result)).savePNG("test3.png");
