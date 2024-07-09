import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:kim_lhc_app/kim-lhc/part1.dart';
import 'package:kim_lhc_app/kim-lhc/part3.dart';
import 'package:kim_lhc_app/text/lhc_result.dart';

void main() {
  runApp(const Result());
}

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIM LHC 量表評估工具 - 榮靜計畫',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const resultPage(),
    );
  }
}



class resultPage extends StatelessWidget {
  const resultPage({super.key});

  @override
  Widget build(BuildContext context) {
    //int final_score = 100;   //test final_score num
    String finalScore2 =
    finalScore.toString().replaceAll(RegExp(r"([.]0$)"), "");

    // 根據 num 值選擇顏色
    Color boxColor;
    int riskLevel = 1;
    if (finalScore < 20) {
      boxColor = const Color(0xFF93FF93);
      riskLevel = 1;
    } else if (finalScore >= 20 && finalScore < 50) {
      boxColor = const Color(0xFFB7FF4A);
      riskLevel = 2;
    } else if (finalScore >= 50 && finalScore < 100) {
      boxColor = const Color(0xFFFFE153);
      riskLevel = 3;
    } else {
      boxColor = const Color(0xFFFF002F);
      riskLevel = 4;
    }
    /*

    // test
    List<Map<String, dynamic>> items = [
      {'text': ' Unfavorable working conditions', 'score': 76, 'callback': lhc_result1},
      {'text': ' Frequency', 'score': 70, 'callback': lhc_result2},
      {'text': ' Total body posture', 'score': 65, 'callback': lhc_result3},
      {'text': ' Effective load weight', 'score': 60, 'callback': lhc_result4},
      {'text': ' Load handling conditions', 'score': 55, 'callback': lhc_result5},
      {'text': ' Work organization ', 'score': 50, 'callback': lhc_result6},
    ];
    */

    ///六個內容及其分數
    List<Map<String, dynamic>> items = [
      {
        'text': ' Working Conditions',
        'score': (unfavorableResult * 100).toInt(),
        'num': 1,
      },
      {
        'text': ' Total Body Posture',
        'score': (totalResult * 100).toInt(),
        'num': 2,
      },
      {
        'text': ' Effective Load Weight',
        'score': (effectiveResult * 100).toInt(),
        'num': 3,
      },
      {
        'text': ' Load Handling Conditions',
        'score': (loadResult * 100).toInt(),
        'num': 4,
      },
      {
        'text': ' Work Organization ',
        'score': (workResult * 100).toInt(),
        'num': 5,
        //'callback': lhc_result6
      },
    ];

    // 根據分數對列表進行排序
    items.sort((a, b) => b['score'].compareTo(a['score']));

    // 選取分數最高的前三個內容
    List<Map<String, dynamic>> topItems = items.take(3).toList();

    ///新增Suggestions內容
    List<String> Suggestions = [
      conditionresult(),
      resultPosture(),
      'It can be carried by two people to reduce individual load, or the goods can be divided to lessen the weight of each item.',
      'In work, effort should be applied evenly to prevent excessive force on one side, which can cause harm.',
      'Discuss work plans with your supervisor or colleagues, listen to their advice, and adjust as needed.',
    ];

    ///根據前三個項目產生建議
    List<String> topSuggestions = topItems.map((item) {
      int num = item['num'];
      return Suggestions[num - 1];
    }).toList();

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFFC9D6DE),
        backgroundColor: boxColor,
        title: const Center(
          child: Text(
            'Assessment Report',
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView(
        //ListView(滑動螢幕)，Column(垂直排列)
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0), //外框距離手機邊框
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 5.0),
                //circle
                SizedBox(
                  height: 170,
                  child: Center(
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: boxColor,
                          width: 17,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              finalScore2.toString(),
                              style: TextStyle(
                                fontSize: 42,
                                color: boxColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15.0),

                ///主體risk
                Container(
                  //框框1
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    // 背景框
                    color: const Color(0xFFF0F5F9).withOpacity(1), // 背景色
                    borderRadius: BorderRadius.circular(20), // 圆角邊角
                    border: Border.all(
                      color: Colors.black, // 邊框颜色
                      width: 2.5, // 邊框宽度
                    ),
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: 'Total risk score:',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: ' $finalScore2 ',
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
                            const SizedBox(height: 10.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 95, // 调整这里的宽度以移动文字
                                ),
                                Expanded(
                                  child: Text('Risk level: $riskLevel',
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                ),
                                Tooltip(
                                  message: 'more information',
                                  child: IconButton(
                                    icon: const Icon(Icons.help_outline,
                                        color: Colors.black),
                                    onPressed: () {
                                      lhc_result1(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Align(
                        // ▲內容
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: topItems.asMap().entries.map((entry) {
                            int index = entry.key + 1; // 項目編號
                            Map<String, dynamic> item = entry.value;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Text('$index. ',
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 40,
                                    ),
                                    Expanded(
                                      child: Text(
                                          '${item['text']}: ${item['score']}%',
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black)),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    /*
                                    Tooltip(
                                      message: 'more information。',
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.help_outline,
                                          size: 20,
                                        ),
                                        color: Colors.black,
                                        onPressed: () {
                                          item['callback'](context);
                                        },
                                      ),
                                    ),
                                    */
                                  ],
                                ),
                                //SizedBox(height: 10.0),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Frequency
                SizedBox(height: 30.0),
                Container(
                  //框框2
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    // 背景框
                    color: const Color(0xFFFFFCF2).withOpacity(1), // 背景色
                    borderRadius: BorderRadius.circular(20), // 圆角邊角
                    border: Border.all(
                      color: Colors.black, // 邊框颜色
                      width: 2.5, // 邊框宽度
                    ),
                  ),

                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: [
                            const Text('Frequency  Suggestions',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 18.0),
                            Column(
                              children: [
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(' Frequency:  ',
                                        style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
                                    if (frequencyResult <3)
                                      Expanded(
                                        child: Text('Moderate.',
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black)),
                                      )else if(frequencyResult >=3 && frequencyResult <6)
                                      Expanded(
                                        child: Text('Slightly high.',
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black)),
                                      )else if(frequencyResult >=6)
                                        Expanded(child: Text('excessively high.',
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black)),
                                        ),
                                  ],
                                ),
                                SizedBox(height: 20.0),
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Suggestion:  ',
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (frequencyResult <3)
                                      Expanded(
                                        child: Text('The frequency is acceptable, please continue to maintain it.',
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black)),
                                      )
                                    else if(frequencyResult >=3 && frequencyResult <6)
                                      Expanded(
                                        child: Text('With higher frequency, it may be necessary to adjust working hours or wear protective gear depending on the situation.',
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black)),
                                      )else if(frequencyResult >=6)
                                        Expanded(child: Text('With excessively high frequency, it is necessary to adjust working hours or undergo a physical examination.',
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black)),
                                        ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                ///suggestion
                const SizedBox(height: 30.0),
                Container(
                  //框框3
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    // 背景框
                    color: const Color(0xFFF0F5F9).withOpacity(1), // 背景色
                    borderRadius: BorderRadius.circular(20), // 圆角邊角
                    border: Border.all(
                      color: Colors.black, // 邊框颜色
                      width: 2.5, // 邊框宽度
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Column(
                          children: [
                            const Text('Other Suggestions ',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 18.0),
                            ...topSuggestions.asMap().entries.map((entry) {
                              int index = entry.key + 1;
                              String Suggestions = entry.value;
                              return Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('$index.  ',
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Expanded(
                                        child: Text(Suggestions,
                                            style: const TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20.0),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 55.0),
                ///按鈕
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20, right: 10), // 調整按鈕間距
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            // 點擊按鈕時導航到第二個畫面
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LhcPart1()),
                          );
                        },
                        style: ButtonStyle(
                          shape:
                          WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF8EC0E4)),
                          minimumSize: WidgetStateProperty.all<Size>(
                              const Size(150, 50)), // 調整按鈕的最小尺寸
                        ),
                        child: const Text(
                          'Revise',
                          style: TextStyle(fontSize: 27, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(bottom: 20, right: 0), // 調整按鈕間距
                      child: ElevatedButton(
                        onPressed: () {
                          Restart.restartApp();
                        },
                        style: ButtonStyle(
                          shape:
                          WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF8EC0E4)),
                          minimumSize: WidgetStateProperty.all<Size>(
                              const Size(150, 50)), // 調整按鈕的最小尺寸
                        ),
                        child: const Text(
                          'Finish',
                          style: TextStyle(fontSize: 27, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}