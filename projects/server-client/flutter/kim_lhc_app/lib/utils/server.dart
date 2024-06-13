import 'package:camera/camera.dart';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';

/// 伺服器 IP(包含通訊埠)
var serverIp = "10.0.2.2:8022"; // Android 到本地開發機器的 IP
/// 伺服器用於分析檔案的路徑
var serverFilePath = "/analyze/test_video"; // 需要將資料上傳至相應路徑才可順利運行

/// 上傳檔案到伺服器
Future<String> uploadToServer(String filePath) async {
  var result = "None"; // 回傳結果
  var file = XFile(filePath); // 影片檔

  // dio 物件設定
  var dio = Dio(BaseOptions(baseUrl: Uri.http(serverIp).toString(), headers: {
    "Connection": "keep-alive", // 保持連線
    "Content-Type": "multipart/form-data", // 傳輸多格式資料
  }));
  var uploader = ChunkedUploader(dio); // 上傳器

  // 傳輸資料
  int reloadTimes = 10; // 設定重新傳輸資料的次數
  for (var i = 0; i < reloadTimes; i++) {
    try {
      // 傳輸資料並取得伺服器的回應
      final response = await uploader.uploadUsingFilePath(
        filePath: file.path,
        fileName: file.name,
        path: serverFilePath,
        onUploadProgress: (p0) {
          debugPrint("upload progress: {0:.2f}%".format(p0 * 100));
        },
      );
      result = response.toString(); // 取得回應結果
      break; // 成功傳輸後，就離開迴圈
    } catch (e) {
      if (i + 1 < reloadTimes) {
        // 有時會出現斷線的狀況，會等待 1 秒後才會重新傳輸
        debugPrint("Error: ${e.toString()}");
        await Future.delayed(const Duration(seconds: 1));
      } else {
        // 運行最後一次時，顯示傳輸失敗訊息
        debugPrint("Upload Failed...");
      }
    }
  }

  return result;
}
