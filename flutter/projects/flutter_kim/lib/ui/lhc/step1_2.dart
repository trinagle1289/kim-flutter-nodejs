import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step1_2.g.dart';

void main() => runApp(ProviderScope(child: Step1of2App()));

/// 步驟 1-2 介面
class Step1of2App extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(home: PoseResultField());
  }
}

/// 評估姿勢結果區域之狀態
class PoseResultField extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 姿態評級分數
    var score = ref.read(_poseturePtsProvider);

    // 開始/結束姿勢圖片
    var pose1ImgPath = ref.read(_startPoseImgPathProvider);
    var pose2ImgPath = ref.read(_endPoseImgPathProvider);

    return Scaffold(
      // 標題欄
      appBar: getTitleAppBar('Step 1(2/3)'),

      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(height: 10),
          const Text('Start     /       Finish',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),

          // width:  增加寬度以獲得更長的橫線
          // height: 增加高度以獲得更長的縱線
          Container(width: 330.0, height: 3.0, color: Colors.black),

          // 姿勢圖片
          Row(
            children: [
              Image.asset(pose1ImgPath, width: 190, height: 250),
              Image.asset(pose2ImgPath, width: 190, height: 250)
            ],
          ),

          const SizedBox(height: 20),

          // 姿勢評級
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            child: Container(
              color: Colors.teal[100], // 青瑩的背景色
              child: Text('Rating Points: $score',
                  // 改變字體大小
                  style: const TextStyle(color: Colors.black, fontSize: 35),
                  textAlign: TextAlign.center),
            ),
          ),

          const SizedBox(height: 20),

          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            // 重新錄影按鈕
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => getLhcApp("1-1")));
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    // 將按鈕大小改回 170x50
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(170, 50))),
                // 更改文字
                child: const Text('Restart',
                    style: TextStyle(fontSize: 30, color: Colors.white))),

            // 手動評估按鈕
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    // 點擊按鈕時導航到手動評估畫面
                    context,
                    MaterialPageRoute(builder: (context) => getLhcApp("1-3")),
                  );
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    // 將按鈕大小改回 170x50
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(170, 50))),
                // 更改文字
                child: const Text('Manual',
                    style: TextStyle(fontSize: 30, color: Colors.white))),
          ]),

          const SizedBox(height: 20),

          // 下一步按鈕
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  // 點擊按鈕時導航到步驟二
                  context,
                  MaterialPageRoute(builder: (context) => getLhcApp("2")),
                );
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                ),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                minimumSize: MaterialStateProperty.all<Size>(
                    const Size(170, 50)), // 將按鈕大小改回 170x50
              ),
              child: const Text('Next',
                  style: TextStyle(fontSize: 30, color: Colors.white))),
          const SizedBox(height: 5),
        ]),
      ),
    );
  }
}

/// 姿勢評級分數
@riverpod
class _PoseturePts extends _$PoseturePts {
  @override
  int build() {
    step1of2Data =
        _getPointByLabels(step1of1Data[0], step1of1Data[1]).toDouble();
    return step1of2Data.toInt();
  }
}

/// 開始姿勢圖片路徑
@riverpod
class _StartPoseImgPath extends _$StartPoseImgPath {
  @override
  String build() => _getPosePath(step1of1Data[0]);
}

/// 結束姿勢圖片路徑
@riverpod
class _EndPoseImgPath extends _$EndPoseImgPath {
  @override
  String build() => _getPosePath(step1of1Data[1]);
}

/// 從標籤中取得姿勢評級
int _getPointByLabels(String start, String end) {
  if (start == "A3") {
    start = "A2";
  }
  if (end == "A3") {
    end = "A2";
  }

  /*
    取得姿態評級(0~20分)
    擷取資料集的開頭和結尾進行判斷
    會根據資料集的 A1 A2 A3 A4 A5 這五類結果進行判斷(A2、A3為同一類別)
    姿態評級(分數:資料集頭尾):
    0:  A1 - A1
    3:  A1 - A2
    5:  A2 - A2
    7:  A1 - A4
    9:  A1 - A5
    10: A2 - A4
    13: A2 - A5
    15: A4 - A4
    18: A4 - A5
    20: A5 - A5
  */

  int result = -1;

  if (end.compareTo(start) < 0) {
    String tmp = start;
    start = end;
    end = tmp;
  }

  // 使用起始和最終身體姿勢進行姿態評級的判斷
  if (start == "A1" && end == "A1") {
    result = 0;
  } else if (start == "A1" && end == "A2") {
    result = 3;
  } else if (start == "A2" && end == "A2") {
    result = 5;
  } else if (start == "A1" && end == "A4") {
    result = 7;
  } else if (start == "A1" && end == "A5") {
    result = 9;
  } else if (start == "A2" && end == "A4") {
    result = 10;
  } else if (start == "A2" && end == "A5") {
    result = 13;
  } else if (start == "A4" && end == "A4") {
    result = 15;
  } else if (start == "A4" && end == "A5") {
    result = 18;
  } else if (start == "A5" && end == "A5") {
    result = 20;
  }

  return result;
}

/// 取得姿勢路徑
String _getPosePath(String label) {
  String result = "assets/lhc/Body_Posture/";

  switch (label) {
    case "A1":
      result += "pose_1.png";
      break;
    case "A2":
      result += "pose_2.png";
      break;
    case "A3":
      result += "pose_3.png";
      break;
    case "A4":
      result += "pose_4.png";
      break;
    default:
      result += "pose_5.png";
      break;
  }

  return result;
}
