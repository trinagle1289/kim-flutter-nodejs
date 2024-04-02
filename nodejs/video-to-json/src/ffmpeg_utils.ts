import ffmpeg from "ffmpeg";

/**
 * 建立影片幀
 * @param videoPath 影片路徑
 * @param outputPath 輸出路徑
 */
export async function createVideoFrames(
  videoPath: string,
  outputPath: string,
  videoSize: string = "1920x1080",
  videoFrame: number = null,
  videoCodec: string = null
): Promise<void> {
  // 建立物件
  let video = await new ffmpeg(videoPath);
  // 設定影片
  video.setVideoSize(videoSize, true, true);
  if (videoFrame != null) video.setVideoFrameRate(videoFrame);
  if (videoCodec != null) video.setVideoCodec(videoCodec);
  // 儲存影片
  await video.save(outputPath);
}
