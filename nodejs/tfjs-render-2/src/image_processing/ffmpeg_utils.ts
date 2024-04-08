import ffmpeg from "ffmpeg";

/** 建立影片幀
 * @param videoPath 影片路徑
 * @param outputPath 輸出路徑
 * @param videoSize 影片尺寸
 * @param videoFrame 影片幀率
 * @param videoCodec 影片編解碼器
 */
export async function createVideoFrames(
  videoPath: string,
  outputPath: string,
  videoSize: string = "1920x1080",
  videoFrame: number = 0,
  videoCodec: string = ""
): Promise<void> {
  // 建立物件
  let video = await new ffmpeg(videoPath);
  // 設定影片
  video.setVideoSize(videoSize, true, true);
  if (videoFrame > 0) video.setVideoFrameRate(videoFrame);
  if (videoCodec != "") video.setVideoCodec(videoCodec);
  // 儲存影片
  await video.save(outputPath);
}
