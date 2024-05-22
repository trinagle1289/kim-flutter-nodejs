import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gal/gal.dart';

part 'step1_1.g.dart';

late List<CameraDescription> _cameras; // 相機列表
late CameraController _controller; // 相機控制器
var _videoAlbum = "KIM_Videos"; // 儲存影像的相簿

void main() => runApp(ProviderScope(child: Step1of1App()));

/// 步驟 1-1 介面
// ignore: use_key_in_widget_constructors
class Step1of1App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp(
        home:
            Scaffold(appBar: getTitleAppBar("Step 1(1/3)"), body: _BodyField()),
      );
}

/// 介面的身體區域
class _BodyField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 錄影按鈕資料
    var recordBtnColor = ref.watch(_recordBtnColorProvider);
    var recordBtnText = ref.watch(_recordBtnTextProvider);

    return Scaffold(
      body: Stack(children: [
        // 相機區域
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(width: 350, height: 500, child: _CameraField()),
          ),
        ),

        // 介紹欄
        Positioned(
          top: 510,
          left: 0,
          right: 0,
          child: Container(
            color: const Color(0xFFFFDCB2),
            height: 70,
            child: const Center(
                child: Text(
              'Please shoot directly to the right of your subject.',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            )),
          ),
        ),

        // 錄影按鈕
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ElevatedButton(
              onPressed: () async {
                // 檢查目前是否正在錄影
                var isRecording =
                    ref.read(_recordBtnColorProvider.notifier).isRecording();

                // 更改按鈕狀態
                ref.read(_recordBtnColorProvider.notifier).changeState();
                ref.read(_recordBtnTextProvider.notifier).changeState();

                if (!isRecording) {
                  // 如果現在沒有進行錄影，開始錄影
                  await _controller.startVideoRecording();
                } else {
                  // 如果正在錄影，停止錄影並儲存檔案，最後再切換畫面
                  stopRecording().then(
                    (_) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => getLhcApp("1-1-Load")),
                    ),
                  );
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0))),
                backgroundColor:
                    MaterialStateProperty.all<Color>(recordBtnColor),
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(170, 50)),
              ),
              child: Text(recordBtnText,
                  style: const TextStyle(fontSize: 30, color: Colors.white)),
            ),
          ),
        ),
      ]),
    );
  }
}

/// 相機區域
class _CameraField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CameraFieldState();
}

/// 相機區域狀態
class _CameraFieldState extends State<_CameraField> {
  @override
  Widget build(BuildContext context) {
    Widget emptyWidget = Container();

    try {
      if (!_controller.value.isInitialized) {
        return emptyWidget;
      } else {
        return MaterialApp(
          home: CameraPreview(_controller),
        );
      }
    } catch (e) {
      return emptyWidget;
    }
  }

  @override
  void initState() {
    super.initState();
    initCameraState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 設定相機參數
  Future<void> setCameraData() async {
    await requestPermissions(); // 請求權限

    // 尋找可用相機
    _cameras = await availableCameras();

    // 設定相機控制器
    _controller = CameraController(
      _cameras[0],
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );
  }

  /// 初始化相機狀態
  Future<void> initCameraState() async {
    await setCameraData();

    // 初始化控制器
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((Object e) {
      debugPrint("Camera Error: ${e.toString()}");
    });
  }
}

/// 錄影按鈕顏色
@riverpod
class _RecordBtnColor extends _$RecordBtnColor {
  final _color = Colors.blue;

  @override
  Color build() => _color;

  /// 是否正在錄影
  bool isRecording() => state == Colors.red ? true : false;

  /// 切換狀態
  void changeState() =>
      state == Colors.red ? state = Colors.blue : state = Colors.red;
}

/// 錄影按鈕文字
@riverpod
class _RecordBtnText extends _$RecordBtnText {
  @override
  String build() => "Start";

  /// 是否正在錄影
  bool isRecording() => state == "Finish" ? true : false;

  /// 切換狀態
  void changeState() => state == "Finish" ? state = "Start" : state = "Finish";
}

/// 請求權限
Future<void> requestPermissions() async =>
    await [Permission.camera, Permission.storage].request();

/// 停止錄影
Future<void> stopRecording() async {
  var cacheVideo = await _controller.stopVideoRecording(); // 暫時儲存影片
  await Gal.putVideo(cacheVideo.path, album: _videoAlbum); // 將影片儲存在本地端的相簿中
  debugPrint("file path: ${cacheVideo.path}");
}
