import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img_lib;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:vector_math/vector_math.dart';
import 'package:media_info/media_info.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'step1_1_loading.g.dart';

var modelPath = "assets/model/singlepose-thunder-3.tflite";

void main() => runApp(Step1of1LoadingApp());

/// 步驟 1-1 的載入介面(用於計算身體姿勢結果)
class Step1of1LoadingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "Loading Screen",
        home: Scaffold(
          appBar: getTitleAppBar("步驟一(1/3)"),
          body: ProviderScope(child: _BodyField()),
        ),
      );
}

/// 介面身體區域
class _BodyField extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BodyFieldState();
}

class _BodyFieldState extends ConsumerState<ConsumerStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    /// 加載文字
    var loadingText = ref.watch(_loadingTextProvider);

    return Center(
      child: Text(
        loadingText,
        style: const TextStyle(fontSize: 40),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // 分析影片，結束後導向到下一個頁面
    analyze().then(
      (_) async {
        // 設定介面文字，然後 Delay 1 秒，最後導向到介面 1-2
        ref.read(_loadingTextProvider.notifier).finish();
        Future.delayed(const Duration(seconds: 2));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => getLhcApp("1-2")));
      },
    );
  }
}

/// 加載文字
@riverpod
class _LoadingText extends _$LoadingText {
  final _text = "正在評估姿勢結果...\n請勿離開此畫面";

  @override
  String build() => _text;

  /// 完成評估
  void finish() => state = "評估結束";
}

/// 將影片內容進行分析
/// 會讓使用者先選取剛剛錄製的影片，之後會對此影片進行分析
Future<void> analyze() async {
  // 取得影片路徑
  var videoPath =
      (await ImagePicker().pickVideo(source: ImageSource.gallery))?.path;

  // 獲取影片資訊
  var videoInfo = await MediaInfo().getMediaInfo(videoPath!);
  var durationMs = videoInfo["durationMs"]; // 影片的總毫秒數

  // 設定起始和結束的所抓到的圖片
  var startFrames = [];
  var endFrames = [];

  var numOfFrames = 5; // 設定即將取得影像幀的數量
  var interval = 30; // 每張影像所抓的時間間隔
  for (var i = 0; i < numOfFrames && i < durationMs; i++) {
    var startImg = img_lib.decodeImage((await VideoThumbnail.thumbnailData(
        video: videoPath, timeMs: i * interval))!);
    startFrames.add(startImg);

    var endImg = img_lib.decodeImage((await VideoThumbnail.thumbnailData(
        video: videoPath, timeMs: durationMs - i * interval))!);
    endFrames.add(endImg);

    debugPrint("save image times: ${i + 1}");
  }

  step1of1Data = (await getBodyPostureRatingPoints(startFrames, endFrames))
      .map((e) => e.toString())
      .toList();
  debugPrint("start: \"${step1of1Data[0]}\", end:\"${step1of1Data[1]}\"");
}

/// 取得姿勢評級
Future<List> getBodyPostureRatingPoints(List start, List end) async {
  // 設定起始和結束標籤
  var startLabels = [];
  var endLabels = [];

  var interpreter = await Interpreter.fromAsset(modelPath); // 建立模型解釋器

  // 計算影片開頭的身體姿勢所使用的標籤
  for (var frame in start) {
    var out = runPoseModel(interpreter, frame);
    startLabels.add(getLabel(out));

    // var path = "${(await getApplicationCacheDirectory()).path}/test1.png";
    // await img_lib.writeFile(path, img_lib.encodePng(drawCircle(frame, out)));
    // await Gal.putImage(path, album: "Start");
  }
  // 計算影片結尾的身體姿勢所使用的標籤
  for (var frame in end) {
    var out = runPoseModel(interpreter, frame);
    endLabels.add(getLabel(out));

    // var path = "${(await getApplicationCacheDirectory()).path}/test1.png";
    // await img_lib.writeFile(path, img_lib.encodePng(drawCircle(frame, out)));
    // await Gal.putImage(path, album: "End");
  }

  interpreter.close(); // 關閉模型解釋器

  // 計算並設定起始結尾中最多數量的標籤字串
  var poseLabels = [
    maxNumOfLabelInList(startLabels),
    maxNumOfLabelInList(endLabels)
  ];

  return poseLabels;
}

/// 從 list 中取得最多數量的標籤字串
String maxNumOfLabelInList(List list) {
  // 計算各標籤數量
  var count = {"A1": 0, "A2": 0, "A3": 0, "A4": 0, "A5": 0};
  for (var element in list) {
    count[element] = count[element]! + 1;
  }

  // 尋找最大數值的標籤字串
  var maxNum = 0;
  var result = "";
  count.forEach((key, value) {
    if (value > maxNum) {
      maxNum = value;
      result = key;
    }
  });

  return result;
}

/// 執行姿態模型
List runPoseModel(Interpreter interpreter, img_lib.Image imgIn) {
  // 取得輸入輸出的格式資料
  var shapeIn = interpreter.getInputTensor(0).shape;
  var shapeOut = interpreter.getOutputTensor(0).shape;

  var edge = shapeIn[1]; // 輸入影像邊長的長度
  var resizedImg = resizeImgInSquare(imgIn, edge); // 縮放過後的圖片

  // 計算模型輸出攤平過後的數量
  var inLen = 1;
  for (var element in shapeIn) {
    inLen *= element;
  }
  // 設定模型輸入
  var input = List<double>.filled(inLen, 0).reshape(shapeIn);
  for (var i = 0; i < edge; i++) {
    for (var j = 0; j < edge; j++) {
      input[0][i][j] =
          resizedImg.getPixel(i, j).map((e) => e.toDouble()).toList();
    }
  }

  // 計算模型輸出攤平過後的數量
  var outLen = 1;
  for (var element in shapeOut) {
    outLen *= element;
  }
  // 設定模型輸出
  var output = List<double>.filled(outLen, 0.0).reshape(shapeOut);

  // 運行模型
  interpreter.run(input, output);

  return output;
}

/// 等比例縮放圖片為正方形大小(其他區域會被繪製成黑色)
img_lib.Image resizeImgInSquare(img_lib.Image imgIn, int edge) {
  // 圖片長寬所除的數值
  var divNum = max(imgIn.width / edge, imgIn.height / edge);

  // 等比例縮放後的圖片
  var resizedImg = img_lib.copyResize(imgIn,
      width: imgIn.width ~/ divNum, height: imgIn.height ~/ divNum);

  // 建立輸出影像
  var imgOut = img_lib.Image(width: edge, height: edge);

  // 將縮放後的圖片和輸出影像進行合成(輸出影像為背景)
  if (resizedImg.height > resizedImg.width) {
    var moveX = (edge - resizedImg.width) ~/ 2;
    imgOut = img_lib.compositeImage(imgOut, resizedImg, dstX: moveX);
  } else {
    var moveY = (edge - resizedImg.height) ~/ 2;
    imgOut = img_lib.compositeImage(imgOut, resizedImg, dstY: moveY);
  }

  return imgOut;
}

/// 取得身體姿勢標籤
/// kptList 格式為 [1, 1, 17, 3]
String getLabel(List kptList) {
  var result = "";

  /// 關鍵點角度字典
  /// key: 被計算的關鍵角度，Value: 和 Key 點連結的兩個關鍵點
  var kptAngleDic = {
    5: [7, 11], // 左肩膀
    6: [8, 12], // 右肩膀
    11: [5, 13], // 左腰部
    12: [6, 14], // 右腰部
    13: [11, 15], // 左膝蓋
    14: [12, 16], // 右膝蓋
  };

  // 將關鍵點的資訊轉換成 [17, 2] 的角度
  var positions = [];
  for (var kpt in kptList[0][0]) {
    positions.add(Vector2(kpt[0], kpt[1]));
  }

  // 根據關鍵點角度字典，得到此專案會使用到的所有角度
  var angles = [];
  kptAngleDic.forEach((key, value) {
    angles.add(
        getAngle(positions[key], positions[value[0]], positions[value[1]]));
  });

  // 設定左右角度
  var leftAngles = [];
  var rightAngles = [];
  for (var i = 0; i < angles.length; i += 2) {
    leftAngles.add(angles[i]);
    rightAngles.add(angles[i + 1]);
  }

  // 辨別姿勢標籤
  if (0 <= rightAngles[2] && rightAngles[2] <= 90) {
    result = "A5";
  } else {
    if (0 <= rightAngles[1] && rightAngles[1] <= 120) {
      result = "A4";
    } else if (120 < rightAngles[1] && rightAngles[1] <= 160) {
      result = "A3";
    } else {
      if (90 <= rightAngles[0] && rightAngles[0] <= 180) {
        result = "A2";
      } else {
        result = "A1";
      }
    }
  }

  return result;
}

/// 取得角度(取得 pA 的角度)
/// 使用餘弦定理進行計算
/// lineA = 邊BC
/// lineB = 邊AC
/// lineC = 邊AB
double getAngle(Vector2 pA, Vector2 pB, Vector2 pC) {
  // 計算各向量邊長
  var lineA = (pB - pC).length;
  var lineB = (pA - pC).length;
  var lineC = (pA - pB).length;

  // 計算角度
  var result = degrees(acos(
      (pow(lineB, 2) + pow(lineC, 2) - pow(lineA, 2)) / (2 * lineB * lineC)));

  return result;
}

/// 繪製關鍵點
img_lib.Image drawCircle(img_lib.Image imgIn, List positions) {
  var edge = 1280;
  img_lib.Image imgOut = resizeImgInSquare(imgIn, edge);

  for (var pos in positions[0][0]) {
    imgOut = img_lib.drawCircle(imgOut,
        x: (pos[0] * edge).toInt(),
        y: (pos[1] * edge).toInt(),
        radius: 5,
        color: img_lib.ColorRgba8(255, 0, 0, 255));
  }
  return imgOut;
}
