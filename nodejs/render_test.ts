import * as fs from "node:fs";
import * as pose_detection from "@tensorflow-models/pose-detection";
import * as tf from "@tensorflow/tfjs-node-gpu";
import * as img_renderer from "./src/img_renderer";

const IMG_PATH = "assets/images/maxresdefault.jpg";

await tf.setBackend("tensorflow");
let img = tf.node.decodeImage(fs.readFileSync(IMG_PATH)) as tf.Tensor3D;

let model = pose_detection.SupportedModels.MoveNet;
let cfg: pose_detection.MoveNetModelConfig = {
  modelType: pose_detection.movenet.modelType.MULTIPOSE_LIGHTNING,
};
let detector = await pose_detection.createDetector(model, cfg);

let result = await detector.estimatePoses(img);
console.log(result);

let renderer = new img_renderer.PoseRenderer();
await (await renderer.renderResult(IMG_PATH, result)).savePNG("test4.png");
