import 'package:flutter/material.dart';
import 'package:kim_lhc_app/kim-lhc/part1.dart';

double lhcPart3Slider = 0; // 初始值为0，以便在刚开始时显示第一个选项
double timeLevel = 1.0; // 将timeLevel的类型更改为double

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Two(),
  ));
}

class Two extends StatefulWidget {
  const Two({super.key});

  @override
  State<Two> createState() => _Part2State();
}

class _Part2State extends State<Two> {
  List<int> sliderValues = [
    5,
    20,
    50,
    100,
    150,
    220,
    300,
    500,
    750,
    1000,
    1500,
    2000,
    2500
  ];

  String formatTimeLevel(double level) {
    if (level % 1 == 0) {
      return level.toInt().toString();
    } else {
      return level.toString();
    }
  }

  double frquency(int value) {
    if (value <= 5) {
      return 2.0;
    } else if (value <= 20) {
      return 2.5;
    } else if (value <= 50) {
      return 3.0;
    } else if (value <= 100) {
      return 3.5;
    } else if (value <= 150) {
      return 4.0;
    } else if (value <= 220) {
      return 4.5;
    } else if (value <= 300) {
      return 5.0;
    } else if (value <= 500) {
      return 6.0;
    } else if (value <= 750) {
      return 7.0;
    } else if (value <= 1000) {
      return 8.0;
    } else if (value <= 1500) {
      return 9.0;
    } else if (value <= 2000) {
      return 10.0;
    } else {
      return 11.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    var appBody = Stack(
      children: [
        Container(
          width: 350,
          height: 395,
          margin: const EdgeInsets.only(left: 15, top: 50, right: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F5F9).withOpacity(1),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: Colors.black,
              width: 2.5,
            ),
          ),
        ),
        /*
        Positioned(
          top: 55,
          right: 30,
          child: Transform.scale(
            scale: 1.3,
            child: Tooltip(
              message: 'more information。',
              child: IconButton(
                icon: const Icon(Icons.help_outline, color: Colors.black),
                onPressed: () {
                  lhc_part3_text(context);
                },
              ),
            ),
          ),
        ),
        */
        Column(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 55),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Frequency\n',
                                    style: TextStyle(
                                      fontSize: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                    '[up to...times per \nsub-activity and working day]',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8EC0E4),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Text(
                                  '${sliderValues[lhcPart3Slider.toInt()]}',
                                  style: const TextStyle(
                                    fontSize: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 7,
                                  activeTrackColor: Colors.blue,
                                  inactiveTrackColor: Colors.grey,
                                  thumbColor: Colors.blueAccent,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 12),
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 16),
                                  valueIndicatorShape:
                                  const PaddleSliderValueIndicatorShape(),
                                ),
                                child: Slider(
                                  value: lhcPart3Slider,
                                  onChanged: (newValue) {
                                    setState(() {
                                      lhcPart3Slider = newValue;
                                      timeLevel = frquency(
                                          sliderValues[lhcPart3Slider.toInt()]);
                                    });
                                  },
                                  min: 0,
                                  max: sliderValues.length - 1.toDouble(),
                                  divisions: sliderValues.length - 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 50),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (lhcPart3Slider > 0) {
                                          lhcPart3Slider -= 1;
                                          timeLevel = frquency(sliderValues[
                                          lhcPart3Slider.toInt()]);
                                        }
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(15),
                                      side: const BorderSide(
                                          width: 2,
                                          color: Colors.black), // 设置按钮的边框样式
                                    ),
                                    child: const Icon(Icons.remove,
                                        size: 30, color: Colors.black),
                                  ),
                                  const SizedBox(width: 90),
                                  OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        if (lhcPart3Slider <
                                            sliderValues.length - 1) {
                                          lhcPart3Slider += 1;
                                          timeLevel = frquency(sliderValues[
                                          lhcPart3Slider.toInt()]);
                                        }
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      shape: const CircleBorder(),
                                      padding: const EdgeInsets.all(15),
                                      side: const BorderSide(
                                          width: 2, color: Colors.black),
                                      backgroundColor:
                                      Colors.white, // 修改按钮填充颜色为蓝色
                                    ),
                                    child: const Icon(Icons.add,
                                        size: 30,
                                        color: Colors.black), // 修改图标颜色为白色
                                  ),
                                ],
                              ),
                              const SizedBox(width: 50),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LhcPart1()),
                    );
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    backgroundColor:
                    WidgetStateProperty.all<Color>(const Color(0xFF8EC0E4)),
                    minimumSize:
                    WidgetStateProperty.all<Size>(const Size(170, 50)),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFFC9D6DE),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Frequency : ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ' ${formatTimeLevel(timeLevel - 1)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.blue,
                ),
              ),
              const Text(
                ' points ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        body: appBody,
      ),
    );
  }
}
