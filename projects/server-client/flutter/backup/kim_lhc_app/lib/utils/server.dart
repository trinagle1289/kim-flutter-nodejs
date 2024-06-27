import 'package:camera/camera.dart';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';

class Server {
  static final Server _instance = Server._internal();
  // 將構造函數設為私有
  Server._internal();

  // 提供一個公共的訪問點
  static Server get instance => _instance;

  /// 伺服器 IP(包含通訊埠)[預設為 Android 到本地開發機器的 IP]
  String ip = "10.0.2.2:8022";

  /// 伺服器用於分析檔案的路徑(需要將資料上傳至相應路徑才可順利運行)
  String analyzeFilePath = "/analyze/test_video";

  /// 更新伺服器 IP
  void updateServerIP(String newIP) {
    ip = newIP;
    debugPrint('已成功更新伺服器 IP 為 $ip');
  }

  /// 上傳檔案
  Future<String> uploadFile(String filePath) async {
    // 預設回傳結果
    var result = """{
        "video id": "null",
        "start": "null",
        "end": "null",
        "extra 1": "null",
        "extra 2": "null",
        "extra 3": "null",
        "extra 4": "null",
        "pose score": "-1",
        "extra score": "-1",
        "total score": "-1",
    }""";
    var file = XFile(filePath); // 影片檔

    // dio 物件設定
    var dio = Dio(BaseOptions(baseUrl: Uri.http(ip).toString(), headers: {
      "Connection": "keep-alive", // 保持連線
      "Content-Type": "multipart/form-data", // 傳輸多格式資料
    }));
    var uploader = ChunkedUploader(dio); // 上傳器

    // 傳輸資料
    int reloadTimes = 5; // 設定重新傳輸資料的次數
    for (var i = 0; i < reloadTimes; i++) {
      try {
        // 傳輸資料並取得伺服器的回應
        var response = await uploader.uploadUsingFilePath(
            filePath: file.path,
            fileName: file.name,
            path: analyzeFilePath,
            onUploadProgress: (p0) =>
                debugPrint("upload progress: {0:.2f}%".format(p0 * 100)));
        result = response.toString(); // 取得回應結果
        break; // 成功傳輸後，就離開迴圈
      } catch (e) {
        if (i + 1 < reloadTimes) {
          // 有時會出現斷線的狀況，會等待 500 毫秒後才會重新傳輸
          debugPrint("Error To Connect Server: ${e.toString()}");
          await Future.delayed(const Duration(milliseconds: 500));
        } else {
          debugPrint("Upload Failed..."); // 運行最後一次時，顯示傳輸失敗訊息
        }
      }
    }

    return result;
  }
}
