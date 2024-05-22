import ffmpeg from "ffmpeg";

// 影片路徑
let videoPath = "../../video/20240315/A1-A2.mp4";

// 圖片輸出資訊
let savedPath = "./output";
let savedFileName = "";
let savedSize = "1080x1920";

try {
  let process = new ffmpeg(videoPath);
  process.then(async function (video) {
    video.fnExtractFrameToJPG(savedPath, {
      size: savedSize,
      number: 5,
      every_n_frames: 5,
      file_name: savedFileName,
    });
  });
} catch (e) {
  console.log(`Error code: ${e.code}`);
  console.log(`Error message: ${e.msg}`);
}
