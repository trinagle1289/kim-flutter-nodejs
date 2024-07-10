import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:kim_lhc_app/kim-lhc/record1.dart';
import 'package:kim_lhc_app/kim-lhc/part1.dart';
import 'package:kim_lhc_app/utils/utils.dart' as utils;
import 'package:kim_lhc_app/utils/server.dart' as server_api;

// 姿勢圖片路徑
var imgA1Path = 'assets/picture/LHC/Poses/A1.png';
var imgA23Path = 'assets/picture/LHC/Poses/A2-A3.png';
var imgA4Path = 'assets/picture/LHC/Poses/A4.png';
var imgA5Path = 'assets/picture/LHC/Poses/A5.png';

// 起始結束姿勢(預設為空畫面)
var startImgPath = 'assets/picture/LHC/Poses/A0.png';
var endImgPath = 'assets/picture/LHC/Poses/A0.png';

// 額外姿勢分數
//變數posture1~8,sumofposture,totalposture
int posture1 = 0; //表格內變數 // 軀幹偶爾扭轉、側傾
int posture2 = 0; // 軀幹經常扭轉、側傾
int posture3 = 0; // 負重重心或手偶爾遠離身體
int posture4 = 0; // 負重重心或手經常遠離身體
double posture5 = 0; // 手臂偶爾需抬舉，手位於手肘與肩膀之間
int posture6 = 0; // 手臂經常需抬舉，手位於手肘與肩膀之間
int posture7 = 0; // 手偶爾會高過肩膀
int posture8 = 0; // 手經常會高過肩膀

/// 額外姿勢總分數
double sumofposture = 0;
//additonl points

/// 姿勢評級分數
int bodyposture = 0;
//int totalbodyposture = sumofposture + bodyposture;
/// 身體姿勢總分數
double totalbodyposture = 0;
String totalbodyposture2 = "0";
String sumofposture2 = "0";
String posture5_2 = "0";

bool hasUploaded = false; // 已經上傳檔案了

void main() {
  runApp(const Record1());
}

class VideoPage extends StatefulWidget {
  final String filePath;
  const VideoPage({super.key, required this.filePath});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    if (!hasUploaded) {
      _uploadVideo();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  //// 更新介面
  void _updateView(Map<String, dynamic> jsonRequest) {
    setState(() {
      //// 設定分數
      bodyposture = int.parse(jsonRequest["pose score"]!); // 姿勢評級分數
      sumofposture = double.parse(jsonRequest["extra score"]!); // 額外加分總分數
      totalbodyposture = double.parse(jsonRequest["total score"]!); // 身體姿勢總分

      //// 設定初始和結束姿勢圖片
      switch (jsonRequest["start"]) {
        case "A1":
          startImgPath = imgA1Path;
          break;
        case "A2":
        case "A3":
          startImgPath = imgA23Path;
          break;
        case "A4":
          startImgPath = imgA4Path;
          break;
        case "A5":
          startImgPath = imgA5Path;
          break;
        default:
          break;
      }
      switch (jsonRequest["end"]) {
        case "A1":
          endImgPath = imgA1Path;
          break;
        case "A2":
        case "A3":
          endImgPath = imgA23Path;
          break;
        case "A4":
          endImgPath = imgA4Path;
          break;
        case "A5":
          endImgPath = imgA5Path;
          break;
        default:
          break;
      }

      //// 設定額外加分項資訊
      // 軀幹扭轉/側傾的頻率
      switch (jsonRequest["extra 1"]) {
        case "FREQUENTLY_OR_CONSTANTLY":
          posture1 = 0;
          posture2 = 3;
          break;
        case "OCCASIONALLY":
          posture1 = 1;
          posture2 = 0;
          break;
        default:
          posture1 = 0;
          posture2 = 0;
          break;
      }
      // 手或重心遠離身體的頻率
      switch (jsonRequest["extra 2"]) {
        case "FREQUENTLY_OR_CONSTANTLY":
          posture3 = 0;
          posture4 = 3;
          break;
        case "OCCASIONALLY":
          posture3 = 1;
          posture4 = 0;
          break;
        default:
          posture3 = 0;
          posture4 = 0;
          break;
      }
      // 手臂抬舉，手的水平位於手肘與肩膀之間的頻率
      switch (jsonRequest["extra 3"]) {
        case "FREQUENTLY_OR_CONSTANTLY":
          posture5 = 0;
          posture6 = 1;
          break;
        case "OCCASIONALLY":
          posture5 = 0.5;
          posture6 = 0;
          break;
        default:
          posture5 = 0;
          posture6 = 0;
          break;
      }
      // 手高過肩膀的頻率
      switch (jsonRequest["extra 4"]) {
        case "FREQUENTLY_OR_CONSTANTLY":
          posture7 = 0;
          posture8 = 2;
          break;
        case "OCCASIONALLY":
          posture7 = 1;
          posture8 = 0;
          break;
        default:
          posture7 = 0;
          posture8 = 0;
          break;
      }
      totalbodyposture2 =
          totalbodyposture.toString().replaceAll(RegExp(r"([.]0$)"), "");
      sumofposture2 =
          sumofposture.toString().replaceAll(RegExp(r"([.]0$)"), "");
      posture5_2 = posture5.toString().replaceAll(RegExp(r"([.]0$)"), "");
    });
  }

  /// 初始化影片播放器
  void _initVideoPlayer() {
    var videoPath = widget.filePath;
    _videoPlayerController = VideoPlayerController.file(File(videoPath));
    _videoPlayerController.initialize().then((_) {
      setState(() {});
      _videoPlayerController.setVolume(0);
      _videoPlayerController.setLooping(true);
      _videoPlayerController.play();
    });
  }

  /// 上傳影片
  void _uploadVideo() async {
    debugPrint("Uploading file");

    var server = server_api.Server.instance;
    String ip = server.ip; // 從 Server 實例中獲取當前的 IP 地址
    debugPrint('IP Address: $ip'); // 打印當前 IP 地址

    XFile video = await utils.cacheVideoToMp4File(XFile(widget.filePath));
    String request = await server.uploadFile(video.path);
    debugPrint("Finish Uploading file");
    Map<String, dynamic> jsonRequest = jsonDecode(request);

    //// 更新介面
    _updateView(jsonRequest);

    //// 刪除影片
    File(video.path).deleteSync();

    hasUploaded = true;
  }

  /// 重置所有狀態和資料
  void _resetRecord() {
    //清除資料
    setState(() {
      bodyposture = 0;
      sumofposture = 0;
      totalbodyposture = 0;
      totalbodyposture2 = "0";
      sumofposture2 = "0";
      posture1 = 0;
      posture2 = 0;
      posture3 = 0;
      posture4 = 0;
      posture5 = 0;
      posture6 = 0;
      posture7 = 0;
      posture8 = 0;
      posture5_2 = "0";
      startImgPath = 'assets/picture/LHC/Poses/A0.png';
      endImgPath = 'assets/picture/LHC/Poses/A0.png';
      hasUploaded = false;
    });

    // 刪除當前影片
    File(widget.filePath).deleteSync();

    // 導航回 Record1 重新錄影
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Record1()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFC9D6DE),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                const TextSpan(
                    text: 'Total body posture : ',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: totalbodyposture2,
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                const TextSpan(
                    text: ' points',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width - 26,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F5F9).withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.5,
                      ),
                    ),
                    child: _videoPlayerController.value.isInitialized
                        ? AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio * 1.5,
                            child: Transform.scale(
                              scale: 0.9,
                              child: VideoPlayer(_videoPlayerController),
                            ),
                          )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5F9).withOpacity(1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.5,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Body posture : ',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '$bodyposture ',
                                style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                            const TextSpan(
                                text: 'points',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(startImgPath, width: 100, height: 100),
                        Image.asset('assets/picture/LHC/ginto1.png',
                            width: 50, height: 50),
                        Image.asset(endImgPath, width: 100, height: 100),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5F9).withOpacity(1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.5,
                  ),
                ),
                child: DataTable(
                  columnSpacing: 0.0,
                  headingRowHeight: 40.0,
                  columns: [
                    const DataColumn(
                      label: SizedBox(
                        width: 200,
                        child: Text('Additional Points:',
                            style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    DataColumn(
                      label: SizedBox(
                        width: 46,
                        child: Text('     $sumofposture2'),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(SizedBox(
                        width: 250,
                        child: Text(
                            'Occasional twisting and/or lateral inclination'),
                      )),
                      DataCell(
                        SizedBox(width: 50, child: Text('     +$posture1')),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(SizedBox(
                        width: 250,
                        child: Text(
                            'Frequent/constant twisting and/or lateral inclination'),
                      )),
                      DataCell(
                        SizedBox(width: 50, child: Text('     +$posture2')),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(SizedBox(
                        width: 250,
                        child: Text(
                            'Load center occasionally at a distance from the body'),
                      )),
                      DataCell(
                        SizedBox(width: 50, child: Text('     +$posture3')),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(SizedBox(
                        width: 250,
                        child: Text(
                            'Load center frequently/constantly at a distance from the body'),
                      )),
                      DataCell(
                        SizedBox(width: 50, child: Text('     +$posture4 ')),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(SizedBox(
                        width: 250,
                        child: Text(
                            'Hands occasionally between elbow and shoulder'),
                      )),
                      DataCell(
                        SizedBox(width: 50, child: Text('     +$posture5_2 ')),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(SizedBox(
                        width: 250,
                        child: Text(
                            'Hands frequently/constantly between elbow and shoulder'),
                      )),
                      DataCell(
                        SizedBox(width: 50, child: Text('     +$posture6 ')),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(SizedBox(
                        width: 250,
                        child: Text('Hands occasionally above shoulder height'),
                      )),
                      DataCell(
                        SizedBox(width: 50, child: Text('     +$posture7')),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(SizedBox(
                        width: 250,
                        child: Text(
                            'Hands frequently/constantly above shoulder height'),
                      )),
                      DataCell(
                        SizedBox(width: 50, child: Text('     +$posture8')),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 主軸方向置中
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, right: 10), // 調整按鈕間距
                  child: ElevatedButton(
                    onPressed: _resetRecord,
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF8EC0E4)),
                      minimumSize: WidgetStateProperty.all<Size>(
                          const Size(130, 50)), // 調整按鈕的最小尺寸
                    ),
                    child: const Text(
                      'Re-record',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 10), // 調整按鈕間距
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LhcPart1()),
                      );
                    },
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                          const Color(0xFF8EC0E4)),
                      minimumSize: WidgetStateProperty.all<Size>(
                          const Size(130, 50)), // 調整按鈕的最小尺寸
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
