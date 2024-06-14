import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:video_compress_plus/video_compress_plus.dart';

/// 複製檔案至暫存資料夾
Future<File> copyFileToTempDir(String filePath, String newFileName) async {
  Directory cacheDir = await getTemporaryDirectory(); // 暫存資料夾路徑
  String cacheFilePath = path.join(cacheDir.path, newFileName); // 暫存檔案路徑
  File cacheFile = File(filePath).copySync(cacheFilePath); // 複製檔案至暫存資料夾
  return cacheFile;
}

/// 暫存影片轉換成 Mp4 檔案(用於將 camera 錄製的影片進行格式轉換)
Future<XFile> cacheVideoToMp4File(XFile video) async {
  // 移動檔案至暫存資料夾
  File cacheFile = await copyFileToTempDir(video.path, "${video.name}.mp4");
  // 將暫存檔案轉換成 mp4 檔
  MediaInfo? info = await VideoCompress.compressVideo(cacheFile.path,
      quality: VideoQuality.DefaultQuality, deleteOrigin: false);

  cacheFile.deleteSync(); // 刪除暫存檔
  XFile mp4File = XFile(info!.path!); // 設定輸出資料

  return mp4File;
}
