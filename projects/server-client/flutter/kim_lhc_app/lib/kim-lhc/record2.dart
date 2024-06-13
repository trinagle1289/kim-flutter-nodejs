import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:format/format.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_compress_plus/video_compress_plus.dart';

import 'package:kim_lhc_app/kim-lhc/record1.dart';
import 'package:kim_lhc_app/kim-lhc/part1.dart';
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
int posture1 = 0; //表格內變數 // 軀幹經常扭轉、側傾
int posture2 = 0; // 軀幹偶爾扭轉、側傾
int posture3 = 0; // 負重重心或手經常遠離身體
int posture4 = 0; // 負重重心或手偶爾遠離身體
double posture5 = 0; // 手臂經常需抬舉，手位於手肘與肩膀之間
int posture6 = 0; // 手臂偶爾需抬舉，手位於手肘與肩膀之間
int posture7 = 0; // 手經常會高過肩膀
int posture8 = 0; // 手偶爾會高過肩膀

/// 額外姿勢總分數
double sumofposture = posture1 +
    posture2 +
    posture3 +
    posture4 +
    posture5 +
    posture6 +
    posture7 +
    posture8;
//additonl points

/// 姿勢評級分數
int bodyposture = -1;
//int totalbodyposture = sumofposture + bodyposture;
/// 身體姿勢總分數
double totalbodyposture = 0;

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
    _uploadVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  /// 複製檔案至暫存資料夾
  Future<File> _copyFileToTempDir(String filePath, String newFileName) async {
    // 暫存資料夾路徑
    Directory? cacheDir = await getDownloadsDirectory();
    // 暫存檔案路徑
    String cacheFilePath = path.join(cacheDir!.path, newFileName);
    // 複製檔案至暫存資料夾
    File cacheFile = File(filePath).copySync(cacheFilePath);
    return cacheFile;
  }

  /// 暫存影片轉換成 Mp4 檔案
  Future<XFile> _cacheVideoToMp4File(XFile video) async {
    // 移動檔案至暫存資料夾
    File cacheFile = await _copyFileToTempDir(video.path, "${video.name}.mp4");
    // 將暫存檔案轉換成 mp4 檔
    MediaInfo? info = await VideoCompress.compressVideo(cacheFile.path,
        quality: VideoQuality.DefaultQuality, deleteOrigin: false);

    cacheFile.deleteSync(); // 刪除暫存檔
    XFile mp4File = XFile(info!.path!); // 設定輸出資料

    return mp4File;
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
          posture1 = 3;
          posture2 = 0;
          break;
        case "OCCASIONALLY":
          posture1 = 0;
          posture2 = 1;
          break;
        default:
          posture1 = 0;
          posture2 = 0;
          break;
      }
      // 手或重心遠離身體的頻率
      switch (jsonRequest["extra 2"]) {
        case "FREQUENTLY_OR_CONSTANTLY":
          posture3 = 3;
          posture4 = 0;
          break;
        case "OCCASIONALLY":
          posture3 = 0;
          posture4 = 1;
          break;
        default:
          posture3 = 0;
          posture4 = 0;
          break;
      }
      // 手臂抬舉，手的水平位於手肘與肩膀之間的頻率
      switch (jsonRequest["extra 3"]) {
        case "FREQUENTLY_OR_CONSTANTLY":
          posture5 = 0.5;
          posture6 = 0;
          break;
        case "OCCASIONALLY":
          posture5 = 0;
          posture6 = 1;
          break;
        default:
          posture5 = 0;
          posture6 = 0;
          break;
      }
      // 手高過肩膀的頻率
      switch (jsonRequest["extra 4"]) {
        case "FREQUENTLY_OR_CONSTANTLY":
          posture7 = 2;
          posture8 = 0;
          break;
        case "OCCASIONALLY":
          posture7 = 0;
          posture8 = 1;
          break;
        default:
          posture7 = 0;
          posture8 = 0;
          break;
      }
    });
  }

  /// 初始化影片播放器
  void _initVideoPlayer() {
    var videoPath = widget.filePath;
    _videoPlayerController = VideoPlayerController.file(File(videoPath));
    _videoPlayerController.initialize().then((_) {
      setState(() {});
      _videoPlayerController.setLooping(true);
      _videoPlayerController.play();
    });
  }

  /// 上傳影片
  void _uploadVideo() async {
    //// 將影片轉換成 mp4 檔
    XFile video = await _cacheVideoToMp4File(XFile(widget.filePath));

    //// 與伺服器進行連接
    var server = server_api.Server(); // 建立伺服器
    String request = await server.uploadToServer(video.path); // 上傳檔案至伺服器
    Map<String, dynamic> jsonRequest = jsonDecode(request); // 解碼伺服器回應

    _updateView(jsonRequest); // 更新介面

    // 刪除影片
    File(video.path).deleteSync();
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
                    text: 'Total body posture:',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ' {0:.1f} '.format(totalbodyposture),
                    style: const TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                const TextSpan(
                    text: 'point',
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
                                text: 'Body posture:',
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
                                text: 'point',
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
                        Image.asset(startImgPath, width: 150, height: 150),
                        Image.asset('assets/picture/LHC/ginto1.png',
                            width: 50, height: 50),
                        Image.asset(endImgPath, width: 150, height: 150),
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20.0,
                    headingRowHeight: 50.0,
                    columns: [
                      const DataColumn(
                          label: SizedBox(
                              width: 250,
                              child: Text('Additional Points:',
                                  style: TextStyle(fontSize: 20)))),
                      DataColumn(
                          label: SizedBox(
                              width: 50, child: Text(' $sumofposture Points'))),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Occasional twisting and/or lateral inclination'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture1'))),
                      ]),
                      DataRow(cells: [
                        const DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Frequent/constant twisting and/or lateral inclination'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture2'))),
                      ]),
                      DataRow(cells: [
                        const DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Load center occasionally at a distance from the body'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture3'))),
                      ]),
                      DataRow(cells: [
                        const DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Load center frequently/constantly at a distance from the body'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture4 '))),
                      ]),
                      DataRow(cells: [
                        const DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Hands occasionally between elbow and shoulder'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture5 '))),
                      ]),
                      DataRow(cells: [
                        const DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Hands frequently/constantly between elbow and shoulder'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture6 '))),
                      ]),
                      DataRow(cells: [
                        const DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Hands occasionally above shoulder height'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture7'))),
                      ]),
                      DataRow(cells: [
                        const DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Hands frequently/constantly above shoulder height'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture8'))),
                      ]),
                    ],
                  ),
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
                    onPressed: () {
                      Navigator.push(
                        // 點擊按鈕時導航到第二個畫面
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Record1()),
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
                          const Size(170, 50)), // 調整按鈕的最小尺寸
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
                      totalbodyposture = 13;
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
                          const Size(170, 50)), // 調整按鈕的最小尺寸
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
