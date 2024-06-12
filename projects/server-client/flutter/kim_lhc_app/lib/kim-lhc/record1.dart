import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:kim_lhc_app/kim-lhc/record2.dart';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const Record1());
}

class Record1 extends StatelessWidget {
  const Record1({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(),
    );
  }
}

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  /// 是否正在加載
  bool _isLoading = true;

  /// 是否正在錄影
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    _initCamera();
    super.initState();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  /// 複製檔案至暫存區
  Future<XFile> _copyFileToTempDir(XFile file, String newFileName) async {
    // 取得暫存資料夾路徑
    Directory tmpDir = await getTemporaryDirectory();
    // 設定檔案路徑
    String filePath = path.join(tmpDir.path, newFileName);

    // 複製檔案至暫存資料夾
    File newFile = File(file.path).copySync(filePath);
    // 設定輸出物件
    XFile newXFile = XFile(newFile.path);

    return newXFile;
  }

  /// 初始化相機
  void _initCamera() async {
    final cameras = await availableCameras(); // 可用相機
    // // 前置鏡頭
    // final front = cameras.firstWhere(
    //     (camera) => camera.lensDirection == CameraLensDirection.front);
    // 後置鏡頭
    final back = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back);
    // 相機控制器
    _cameraController = CameraController(back, ResolutionPreset.max);
    // 初始化相機控制器
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  /// 錄製影片
  void _recordVideo() async {
    if (!_isRecording) {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    } else {
      // 停止錄影並儲存檔案
      var cacheVideo = await _cameraController.stopVideoRecording();
      // 將檔案複製到暫存資料夾區域
      var tmpVideo =
          await _copyFileToTempDir(cacheVideo, "${cacheVideo.name}.mp4");

      setState(() => _isRecording = false);

      // 切換畫面
      final route = MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: tmpVideo.path),
      );
      if (mounted) {
        Navigator.push(context, route);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      // 加載圖示
      return Container(
          color: Colors.white,
          child: const Center(child: CircularProgressIndicator()));
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: _isRecording ? Colors.red : Colors.blue,
                onPressed: () => _recordVideo(),
                shape: const CircleBorder(), // 更改按鈕的背景顏色
                child:
                    Icon(_isRecording ? Icons.stop : Icons.circle), // 設置按鈕形狀為圓形
              ),
            ),
          ],
        ),
      );
    }
  }
}
