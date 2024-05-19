import 'dart:io';

import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

// Android To DevCP Local IP:
var serverIp = "10.0.2.2:5000";

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
    // // 設定要抓的影片資料
    // var video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    // if (video == null) {
    //   debugPrint("Cannot get video");
    //   return;
    // }

    // // 設定傳輸資料
    // var formData = FormData.fromMap({
    //   'file': await MultipartFile.fromFile(video.path, filename: video.name)
    // });

    // // 建立 Dio 和 ChunkedUploader 物件
    // var dio = Dio(BaseOptions(baseUrl: Uri.http(serverIp).toString()));
    // var uploader = ChunkedUploader(dio);

    // // 傳輸資料
    // debugPrint("File Path: ${video.path}");
    // var response = await uploader.upload(fileDataStream: , fileName: fileName, fileSize: fileSize, path: path)

    // var response = await dio.get("/success");
    // if (response.statusCode == 200) {
    //   debugPrint("Status Code: ${response.statusCode}");
    //   debugPrint("response: ${response.data}");
    // } else {
    //   debugPrint("Error Code: ${response.statusCode}");
    // }
  }
}
