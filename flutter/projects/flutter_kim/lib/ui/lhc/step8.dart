import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'step8.g.dart';

void main() => runApp(const ProviderScope(child: Step8App()));

class Step8App extends ConsumerWidget {
  const Step8App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 風險等級
    var riskLevelText = ref.read(_riskLevelTextProvider);
    var riskLevelColor = ref.read(_riskLevelColorProvider);

    // 7 種評級
    var timeScoreText = ref.read(_timeScoreTextProvider); // 時間評級
    var bearWeightScoreText = ref.read(_bearWeightScoreTextProvider); // 負重評級
    var bearWeightGenderText =
        ref.read(_bearWeightGenderTextProvider); // 負重評級性別
    var powerTransferScoreText =
        ref.read(_powerTransferScoreTextProvider); // 力量傳遞/負重條件
    var bodyPostureScoreText = ref.read(_bodyPostureScoreTextProvider); // 身體姿勢
    var workingConditionsScoreText =
        ref.read(_workingConditionsScoreTextProvider); // 工作條件
    var workCoordinationScoreText =
        ref.read(_workCoordinationScoreTextProvider); // 工作協調

    // 評估建議
    var physiologicalText = ref.read(_physiologicalTextProvider); // 生理過載可能性文字
    var healthConcernText = ref.read(_healthConcernTextProvider); // 健康疑慮文字
    var preventiveMeasuresText =
        ref.read(_preventiveMeasuresTextProvider); // 採取措施文字

    return MaterialApp(
      title: 'FinalPage',
      home: Scaffold(
        appBar: getTitleAppBar('Results Report'),
        body: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 風險等級
                    SizedBox(
                      height: 100,
                      child: Center(
                        child: Container(
                          width: 350,
                          height: 55,
                          decoration: BoxDecoration(
                              color: riskLevelColor,
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                            child: Text(
                              'Risk Value: $riskLevelText',
                              style: const TextStyle(
                                  fontSize: 38, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 350,
                      child: Center(
                        child: Container(
                          width: 350,
                          height: 300,
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(235, 235, 235, 1.0),
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                            // 風險等級計算結果
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Rating Points',
                                    style: TextStyle(
                                        fontSize: 25, color: Colors.black),
                                  ),
                                  RichText(
                                    // 時間評級
                                    text: TextSpan(children: [
                                      const TextSpan(
                                        text: 'Time rating points: ',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: timeScoreText,
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ),
                                    ]),
                                  ),
                                  // 負重評級
                                  RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text:
                                            'Effective load weight ($bearWeightGenderText): ',
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: bearWeightScoreText,
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ),
                                    ]),
                                  ),
                                  // 力量傳遞
                                  RichText(
                                    text: TextSpan(children: [
                                      const TextSpan(
                                          text: 'Load handling conditions: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black)),
                                      TextSpan(
                                        text: powerTransferScoreText,
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.red),
                                      ),
                                    ]),
                                  ),
                                  // 身體姿勢
                                  RichText(
                                    text: TextSpan(children: [
                                      const TextSpan(
                                          text: 'Total body posture: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: bodyPostureScoreText,
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.red)),
                                    ]),
                                  ),
                                  // 工作條件
                                  RichText(
                                    text: TextSpan(children: [
                                      const TextSpan(
                                          text:
                                              'Unfavourable working conditions: ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black)),
                                      TextSpan(
                                          text: workingConditionsScoreText,
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.red)),
                                    ]),
                                  ),
                                  // 工作協調
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(children: [
                                      const TextSpan(
                                        text:
                                            'Work organisation / temporal distribution: ',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.black),
                                      ),
                                      TextSpan(
                                          text: workCoordinationScoreText,
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.red)),
                                    ]),
                                  ),
                                  const Text('      ',
                                      style: TextStyle(fontSize: 15)),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Risk Value\n',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.black),
                                        ),
                                        TextSpan(
                                          text:
                                              "$timeScoreText+$bearWeightScoreText+$powerTransferScoreText+$bodyPostureScoreText+$workingConditionsScoreText+$workCoordinationScoreText=$riskLevelText",
                                          style: const TextStyle(
                                              fontSize: 20, color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // 生理過載可能性+健康疑慮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 生理過載可能性
                        SizedBox(
                          height: 225,
                          child: Center(
                            child: Container(
                              width: 170,
                              height: 225,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(35, 184, 177, 1.0),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '\nProbability of physical overload',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      const Text(
                                        '  ',
                                        style: TextStyle(
                                            fontSize: 3, color: Colors.white),
                                      ),
                                      Text(physiologicalText,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                          textAlign: TextAlign.center),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        // 健康疑慮
                        SizedBox(
                          height: 225,
                          child: Center(
                            child: Container(
                              width: 170,
                              height: 225,
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromRGBO(35, 184, 177, 1.0),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text('\nPossible health consequences',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    const Text(
                                      '  ',
                                      style: TextStyle(
                                          fontSize: 3, color: Colors.white),
                                    ),
                                    Text(healthConcernText,
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.black),
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ), // 可以繼續添加其他框框...
                  ]),
            ),
            const SizedBox(height: 10),
            // 採取措施
            SizedBox(
              height: 200,
              child: Center(
                child: Container(
                  width: 350,
                  height: 175,
                  decoration: BoxDecoration(
                      // 設定背景顏色
                      color: Colors.orange,
                      // 設定圓角半徑
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                    child: Column(children: [
                      const Text(' ', style: TextStyle(fontSize: 10)),
                      const Text('Suggestions:',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold)),
                      const Text(' ', style: TextStyle(fontSize: 10)),
                      Text(' $preventiveMeasuresText',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                          textAlign: TextAlign.center),
                    ]),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 100,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // 儲存資料按鈕
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(170, 50))),
                            child: const Text('Save',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white)),
                          ),

                          const SizedBox(width: 13),

                          // 結束報告按鈕
                          ElevatedButton(
                            onPressed: () {
                              resetAllData();
                              //結束報告+變數清空
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => getLhcApp("")));
                            },
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.blue),
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(170, 50))),
                            child: const Text('Finish',
                                style: TextStyle(
                                    fontSize: 30, color: Colors.white)),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 風險值文字
@riverpod
String _riskLevelText(_RiskLevelTextRef ref) => getRiskLevel().toString();

/// 風險值顏色
@riverpod
Color _riskLevelColor(_RiskLevelColorRef ref) {
  // 輸出顏色
  Color color = Colors.black;
  // 風險值
  var level = getRiskLevel();

  if (level < 20) {
    color = const Color.fromRGBO(0, 255, 0, 1.0);
  } else if (level < 50) {
    color = const Color.fromRGBO(128, 255, 0, 1.0);
  } else if (level < 100) {
    color = const Color.fromRGBO(255, 255, 0, 1.0);
  } else {
    color = const Color.fromRGBO(255, 0, 0, 1.0);
  }

  return color;
}

/// 時間評級文字
@riverpod
String _timeScoreText(_TimeScoreTextRef ref) => step3Data.toString();

/// 負重評級文字
@riverpod
String _bearWeightScoreText(_BearWeightScoreTextRef ref) =>
    step4Data.toInt().toString();

/// 負重評級性別文字
@riverpod
String _bearWeightGenderText(_BearWeightGenderTextRef ref) =>
    step4GenderData.toString();

/// 力量傳遞/負重條件文字
@riverpod
String _powerTransferScoreText(_PowerTransferScoreTextRef ref) =>
    step5Data.toInt().toString();

/// 身體姿勢文字
@riverpod
String _bodyPostureScoreText(_BodyPostureScoreTextRef ref) =>
    getPoseData().toString();

/// 工作條件文字
@riverpod
String _workingConditionsScoreText(_WorkingConditionsScoreTextRef ref) =>
    getWorkingConditionsData().toString();

/// 工作協調文字
@riverpod
String _workCoordinationScoreText(_WorkCoordinationScoreTextRef ref) =>
    step7Data.toInt().toString();

/// 生理過載可能性文字
@riverpod
String _physiologicalText(_PhysiologicalTextRef ref) {
  String result = "";

  // 風險值
  var level = getRiskLevel();
  if (level < 20) {
    result = "Physical overload is unlikely.";
  } else if (level < 50) {
    result = "Physical overload is possible for less resilient persons.";
  } else if (level < 100) {
    result =
        "Physical overload is also possible for normally resilient persons.";
  } else {
    result = "Physical overload is likely.";
  }

  return result;
}

/// 健康疑慮文字
@riverpod
String _healthConcernText(_HealthConcernTextRef ref) {
  String result = "";

  // 風險值
  var level = getRiskLevel();
  if (level < 20) {
    result = "No health risk is to be expected.";
  } else if (level < 50) {
    result =
        "Fatigue, low-grade adaptation problems which can be compensated for during leisure time.";
  } else if (level < 100) {
    result =
        "Disorders (pain), possibly including dysfunctions, reversible in most cases, without morphological manifestation.";
  } else {
    result =
        "More pronounced disorders and/or dysfunctions, structural damage with pathological significance.";
  }

  return result;
}

/// 採取措施文字
@riverpod
String _preventiveMeasuresText(_PreventiveMeasuresTextRef ref) {
  String result = "";

  // 風險值
  var level = getRiskLevel();
  if (level < 20) {
    result = "None";
  } else if (level < 50) {
    result =
        "For less resilient persons, workplace redesign and other prevention measures may be helpful.";
  } else if (level < 100) {
    result =
        "Workplace redesign and other prevention measures should be considered.";
  } else {
    result =
        "Workplace redesign measures are necessary. Other prevention measures should be considered.";
  }

  return result;
}
