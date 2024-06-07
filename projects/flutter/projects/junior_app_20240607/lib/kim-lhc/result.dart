import 'package:flutter/material.dart';
import 'package:junior_app_20240607/kim-lhc/part1.dart';
import 'package:junior_app_20240607/text/lhc_result.dart';

void main() {
  runApp(const Result());
}

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KIM_LHC_result',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //int final_score = 100;   //test final_score num
    String final_score2 = final_score.toString().replaceAll(RegExp(r"([.]0$)"), "");

    // 根據 num 值選擇顏色
    Color boxColor;
    int risk_level = 1;
    if (final_score < 20) {
      boxColor = Color(0xFF93FF93);
      risk_level = 1;
    } else if (final_score >= 20 && final_score < 50) {
      boxColor = Color(0xFFB7FF4A);
      risk_level = 2;
    } else if (final_score >= 50 && final_score < 100) {
      boxColor = Color(0xFFFFE153);
      risk_level = 3;
    } else {
      boxColor = Color(0xFFFF002F);
      risk_level = 4;
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


    //六個內容及其分數
    List<Map<String, dynamic>> items = [
      {'text': ' Unfavorable working conditions', 'score': (Unfavorable_result * 100).toInt(), 'callback': lhc_result1},
      {'text': ' Frequency', 'score': (Frequency_result * 100).toInt(), 'callback': lhc_result2},
      {'text': ' Total body posture', 'score': (Total_result * 100).toInt(), 'callback': lhc_result3},
      {'text': ' Effective load weight', 'score': (Effective_result * 100).toInt(), 'callback': lhc_result4},
      {'text': ' Load handling conditions', 'score': (Load_result * 100).toInt(), 'callback': lhc_result5},
      {'text': ' Work organization ', 'score': (Work_result * 100).toInt(), 'callback': lhc_result6},
    ];

    // 根據分數對列表進行排序
    items.sort((a, b) => b['score'].compareTo(a['score']));

    // 選取分數最高的前三個內容
    List<Map<String, dynamic>> topItems = items.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color(0xFFC9D6DE),
        backgroundColor: boxColor,
        title: Center(
          child: Text(
            'Assessment Report',
            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView(   //ListView(滑動螢幕)，Column(垂直排列)
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),  //外框距離手機邊框
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 5.0),
                //circle
                Container(
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
                              final_score2.toString(),
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
                SizedBox(height: 15.0),

                //主體
                Container(    //框框1
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(   // 背景框
                    color: Color(0xFFF0F5F9).withOpacity(1), // 背景色
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
                                  TextSpan(text: 'Total risk score:', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                  TextSpan(text: ' $final_score2 ', style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold)),
                                  TextSpan(text: 'point', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text('Risk level: $risk_level', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10.0),
                          ],
                        ),
                      ),
                      Align(  // ▲內容
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
                                    Text('$index. ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                    Expanded(child: Text('${item['text']}: ${item['score']}%', style: TextStyle(fontSize: 14.0, color: Colors.black)),),
                                    //Expanded(child: Text('${item['text']}: ${percentage.toStringAsFixed(2)}%', style: TextStyle(fontSize: 14.0, color: Colors.black)),),
                                    Tooltip(
                                      message: 'more information。',
                                      child: IconButton(
                                        icon: Icon(Icons.help_outline, size: 20,),
                                        color: Colors.black,
                                        onPressed: () {
                                          item['callback'](context);
                                        },
                                      ),
                                    ),
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


                SizedBox(height: 30.0),
                Container(    //框框2
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(   // 背景框
                    color: Color(0xFFF0F5F9).withOpacity(1), // 背景色
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
                            Text('Recommendations for improvement', style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold)),
                            SizedBox(height: 18.0),

                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(    //建議1
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('1.  ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text('Reduce load weight.', style: TextStyle(fontSize: 14.0, color: Colors.black)),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(    //建議2
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('2.  ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text('Reduce the frequency of this sub-activity.', style: TextStyle(fontSize: 14.0, color: Colors.black)),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(    //建議3
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('3.  ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text('Provide lower seats, change to sitting position.', style: TextStyle(fontSize: 14.0, color: Colors.black)),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(    //建議4
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('4.  ', style: TextStyle(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Text('Increase the height of the console.', style: TextStyle(fontSize: 14.0, color: Colors.black)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 55.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, right: 10), // 調整按鈕間距
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push( // 點擊按鈕時導航到第二個畫面
                            context,
                            MaterialPageRoute(builder: (context) => Lhc_Part1()),
                          );
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF8EC0E4)),
                          minimumSize: MaterialStateProperty.all<Size>(const Size(170, 50)), // 調整按鈕的最小尺寸
                        ),
                        child: const Text(
                          'Revise',
                          style: TextStyle(fontSize: 27, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, right: 10), // 調整按鈕間距
                      child: ElevatedButton(
                        onPressed: () {

                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF8EC0E4)),
                          minimumSize: MaterialStateProperty.all<Size>(const Size(170, 50)), // 調整按鈕的最小尺寸
                        ),
                        child: const Text(
                          'Download',
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
