import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;

import 'ui/title.dart';
import 'ui/lhc/step1_1.dart';
import 'ui/lhc/step1_1_loading.dart';
import 'ui/lhc/step1_2.dart';
import 'ui/lhc/step1_3.dart';
import 'ui/lhc/step2.dart';
import 'ui/lhc/step3.dart';
import 'ui/lhc/step4.dart';
import 'ui/lhc/step5.dart';
import 'ui/lhc/step6_1.dart';
import 'ui/lhc/step6_2.dart';
import 'ui/lhc/step6_3.dart';
import 'ui/lhc/step7.dart';
import 'ui/lhc/step8.dart';

/// 主程式
void main() => runApp(const TitleApp());

/// 姿勢評級的開始結束姿勢標籤(2 個字串)
var step1of1Data = List<String>.filled(2, "");

/// 姿態評級
// double step1of2Data = 0.0;
// double step1of2Data = 7.0; // 1
// double step1of2Data = 10.0; // 2
double step1of2Data = 18.0; // 3

/// 身體姿勢 額外加分的部分(總共 4 類，最多計算 6 分)
var step2Data = List<double>.filled(4, 0.0);

/// 時間評級
// double step3Data = 0.0;
// double step3Data = 2.0; // 1
// double step3Data = 2.5; // 2
double step3Data = 3.0; // 3

/// 負重評級
// double step4Data = 0.0;
// double step4Data = 9.0; // 1
// double step4Data = 8.0; // 2
double step4Data = 11.0; // 3

/// 負重評級性別
// String step4GenderData = "男";
// String step4GenderData = "Female"; // 1
String step4GenderData = "Male"; // 2 3

/// 力量傳遞/負重條件
double step5Data = 0.0;
// double step5Data = 2.0; // 2

/// 不良工作條件[搬運/握持受限, 空間條件]
// var step6fo1Data = List<double>.filled(2, 0.0);
// var step6fo1Data = [2, 0.0]; // 1
var step6fo1Data = [3, 0.0]; // 3

/// 不良工作條件[手/手臂的位置與動作, 氣候條件]
var step6fo2Data = List<double>.filled(2, 0.0);

/// 不良工作條件[力量傳遞/應用受限, 衣服條件]
var step6fo3Data = List<double>.filled(2, 0.0);

/// 工作協調/時間分佈
// double step7Data = 0.0;
// double step7Data = 4.0; // 2
double step7Data = 2.0; // 3

/// 取得 LHC 介面
Widget getLhcApp(String idx) {
  Widget widget;

  switch (idx) {
    case "1-1":
      widget = ProviderScope(child: Step1of1App());
      break;
    case "1-1-Load":
      widget = Step1of1LoadingApp();
      break;
    case "1-2":
      widget = ProviderScope(child: Step1of2App());
      break;
    case "1-3":
      widget = const Step1of3App();
      break;
    case "2":
      widget = const Step2App();
      break;
    case "3":
      widget = const Step3App();
      break;
    case "4":
      widget = const Step4App();
      break;
    case "5":
      widget = const Step5App();
      break;
    case "6-1":
      widget = const Step6of1App();
      break;
    case "6-2":
      widget = const Step6of2App();
      break;
    case "6-3":
      widget = const Step6of3App();
      break;
    case "7":
      widget = const Step7App();
      break;
    case "8":
      widget = const ProviderScope(child: Step8App());
      break;
    default:
      widget = const TitleApp();
      break;
  }

  return widget;
}

/// 頂端工具列
AppBar getTitleAppBar(String title) => AppBar(
    centerTitle: true,
    automaticallyImplyLeading: false,
    backgroundColor: Colors.blue,
    flexibleSpace: Container(color: Colors.blue),
    title:
        Text(title, style: const TextStyle(fontSize: 40, color: Colors.white)));

/// 取得身體姿勢評級
double getPoseData() {
  // 身體姿勢額外加分(最多 6 分)
  var bodyExtraData =
      (step2Data[0] + step2Data[1] + step2Data[2] + step2Data[3]) < 6
          ? (step2Data[0] + step2Data[1] + step2Data[2] + step2Data[3])
          : 6.0;
  // 身體姿勢
  var bodyData = step1of2Data + bodyExtraData;
  return bodyData;
}

/// 取得工作條件評級
double getWorkingConditionsData() {
  return step6fo1Data[0] +
      step6fo1Data[1] +
      step6fo2Data[0] +
      step6fo2Data[1] +
      step6fo3Data[0] +
      step6fo3Data[1];
}

/// 取得風險值
double getRiskLevel() =>
    step3Data *
    (step4Data +
        step5Data +
        getPoseData() +
        getWorkingConditionsData() +
        step7Data);

/// 重置全部資訊
void resetAllData() {
  step1of1Data = List<String>.filled(2, ""); // 姿勢評級的開始結束姿勢標籤(2 個字串)
  step1of2Data = 0.0; // 姿勢評級
  step2Data = List<double>.filled(4, 0.0); // 身體姿勢 額外加分的部分(總共 4 類，最多計算 6 分)
  step3Data = 0.0; // 時間評級
  step4Data = 0.0; // 負重評級
  step4GenderData = "男"; // 負重評級性別
  step5Data = 0.0; // 力量傳遞/負重條件
  step6fo1Data = List<double>.filled(2, 0.0); // 不良工作條件[搬運/握持受限, 空間條件]
  step6fo2Data = List<double>.filled(2, 0.0); // 不良工作條件[手/手臂的位置與動作, 氣候條件]
  step6fo3Data = List<double>.filled(2, 0.0); // 不良工作條件[力量傳遞/應用受限, 衣服條件]
  step7Data = 0.0; // 工作協調/時間分佈
}
