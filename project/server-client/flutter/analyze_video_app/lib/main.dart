import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:format/format.dart';

/// 伺服器 IP(包含通訊埠)
var serverIp = "10.0.2.2:8022"; // Android 到本地開發機器的 IP
/// 伺服器用於分析檔案的路徑
var serverFilePath = "/analyze/test_video"; // 需要將資料上傳至相應路徑才可順利運行

/// 連線設定
var options = BaseOptions(
    baseUrl: Uri.http(serverIp).toString(), // 連接網址
    headers: {
      "Connection": "keep-alive", // 保持連線
      "Content-Type": "multipart/form-data", // 傳輸多格式資料
    });

/// 主程式
void main() => runApp(const MainApp());

/// 主要介面
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Scaffold(body: Center(child: PoseResult())));
  }
}

/// 姿勢結果
class PoseResult extends StatefulWidget {
  const PoseResult({super.key});

  @override
  State<StatefulWidget> createState() => PoseResultState();
}

/// 姿勢結果狀態
class PoseResultState extends State<PoseResult> {
  /// HTTP 回應資料
  String httpResponse = "None";

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      OutlinedButton(
        onPressed: () {
          uploadVideo();
        },
        child: const Text("Test"),
      ),
      Text(httpResponse)
    ]);
  }

  /// 傳輸影片
  void uploadVideo() async {
    // 傳輸影片物件
    var video = (await FilePicker.platform
            .pickFiles(type: FileType.video, withReadStream: true))!
        .files
        .single;

    // 設定讀取串流的物件
    Stream<List<int>> readStream = video.readStream!;

    // 當未選擇影片時
    if (video.path == null) {
      debugPrint("No video file selected.");
      return;
    }

    // 建立 Dio 和 ChunkedUploader 物件
    var dio = Dio(options);
    var uploader = ChunkedUploader(dio);

    // 傳輸資料
    var reloadTimes = 3; // 設定重新傳輸資料的次數
    for (var i = 0; i < reloadTimes; i++) {
      try {
        // 取得伺服器回應
        var response = await uploader.upload(
          fileDataStream: readStream,
          fileName: video.name,
          fileSize: video.size,
          path: serverFilePath,
          onUploadProgress: (p0) {
            debugPrint("upload progress: {0:.2f}%".format(p0 * 100));
          },
        );
        debugPrint("response: ${response.toString()}");
        setState(() {
          httpResponse = response.toString();
        });
        break; // 成功運行時，則離開此迴圈
      } catch (e) {
        // 重新建立讀取串流的物件
        readStream = File(video.path!).openRead();

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
  }
}
