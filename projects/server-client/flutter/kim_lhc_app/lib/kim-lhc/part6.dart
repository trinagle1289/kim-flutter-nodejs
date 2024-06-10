import 'package:flutter/material.dart';
import 'package:kim_lhc_app/text/lhc_part6.dart';
import 'package:kim_lhc_app/kim-lhc/part1.dart';

int selectedOneValue = 0;
int selectedTwoValue = 0;
int selectedThreeValue = 0;
int selectedFourValue = 0;
int selectedFiveValue = 0;
int selectedSixValue = 0;

int part6Score = 0;

void main() {
  runApp(const Workingcondition());
}

class Workingcondition extends StatelessWidget {
  const Workingcondition({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      title: 'Button App',
      initialRoute: '/',
      routes: {
        '/': (context) => const MyHomePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> isOneSelected = [false, false, false];
  List<bool> isTwoSelected = [false, false, false];
  List<bool> isThreeSelected = [false, false];
  List<bool> isFourSelected = [false, false, false];
  List<bool> isFiveSelected = [false, false];
  List<bool> isSixSelected = [false, false, false];

  void updateOneSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isOneSelected.length; i++) {
        if (i == index) {
          isOneSelected[i] = !isOneSelected[i];
          if (isOneSelected[i]) {
            selectedOneValue = getOneValue(i);
          } else {
            selectedOneValue = 0;
          }
        } else {
          isOneSelected[i] = false;
        }
      }
      updatePart6Score(); // 更新 part6_score
    });
  }

  void updateTwoSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isTwoSelected.length; i++) {
        if (i == index) {
          isTwoSelected[i] = !isTwoSelected[i];
          if (isTwoSelected[i]) {
            selectedTwoValue = getTwoValue(i);
          } else {
            selectedTwoValue = 0;
          }
        } else {
          isTwoSelected[i] = false;
        }
      }
      updatePart6Score(); // 更新 part6_score
    });
  }

  void updateThreeSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isThreeSelected.length; i++) {
        if (i == index) {
          isThreeSelected[i] = !isThreeSelected[i];
          if (isThreeSelected[i]) {
            selectedThreeValue = getThreeValue(i);
          } else {
            selectedThreeValue = 0;
          }
        } else {
          isThreeSelected[i] = false;
        }
      }
      updatePart6Score(); // 更新 part6_score
    });
  }

  void updateFourSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isFourSelected.length; i++) {
        if (i == index) {
          isFourSelected[i] = !isFourSelected[i];
          if (isFourSelected[i]) {
            selectedFourValue = getFourValue(i);
          } else {
            selectedFourValue = 0;
          }
        } else {
          isFourSelected[i] = false;
        }
      }
      updatePart6Score(); // 更新 part6_score
    });
  }

  void updateFiveSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isFiveSelected.length; i++) {
        if (i == index) {
          isFiveSelected[i] = !isFiveSelected[i];
          if (isFiveSelected[i]) {
            selectedFiveValue = getFiveValue(i);
          } else {
            selectedFiveValue = 0;
          }
        } else {
          isFiveSelected[i] = false;
        }
      }
      updatePart6Score(); // 更新 part6_score
    });
  }

  void updateSixSelectedIndex(int index) {
    setState(() {
      for (int i = 0; i < isSixSelected.length; i++) {
        if (i == index) {
          isSixSelected[i] = !isSixSelected[i];
          if (isSixSelected[i]) {
            selectedSixValue = getSixValue(i);
          } else {
            selectedSixValue = 0;
          }
        } else {
          isSixSelected[i] = false;
        }
      }
      updatePart6Score(); // 更新 part6_score
    });
  }

  void updatePart6Score() {
    // 计算总分
    part6Score = selectedOneValue +
        selectedTwoValue +
        selectedThreeValue +
        selectedFourValue +
        selectedFiveValue +
        selectedSixValue;

    // 如果 part6_score 需要显示在 AppBar 的标题中，这里需要调用 setState 触发更新
    setState(() {});
  }

  int getOneValue(int index) {
    switch (index) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      default:
        return 0;
    }
  }

  int getTwoValue(int index) {
    switch (index) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      default:
        return 0;
    }
  }

  int getThreeValue(int index) {
    switch (index) {
      case 0:
        return 0;
      case 1:
        return 1;
      default:
        return 0;
    }
  }

  int getFourValue(int index) {
    switch (index) {
      case 0:
        return 0;
      case 1:
        return 1;
      case 2:
        return 2;
      default:
        return 0;
    }
  }

  int getFiveValue(int index) {
    switch (index) {
      case 0:
        return 0;
      case 1:
        return 1;
      default:
        return 0;
    }
  }

  int getSixValue(int index) {
    switch (index) {
      case 0:
        return 0;
      case 1:
        return 2;
      case 2:
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9D6DE),
        title:
        RichText(
          text: TextSpan(
            children: <TextSpan>[
              const TextSpan(text: 'Unfavorable working conditions:', style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold, color: Colors.black)),
              TextSpan(text: ' $part6Score ', style: const TextStyle(fontSize: 20.0, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              const TextSpan(text: 'point', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0), // 设置内边距
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0), // 边框样式
                        borderRadius: BorderRadius.circular(20.0), // 圆角
                        color: const Color(0xFFF0F5F9).withOpacity(1), // 背景色
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'The joint of hand or arm \n has reached its limit',
                            style: TextStyle(fontSize: 22, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10), // 添加上下间距
                          Image.asset(
                            'assets/picture/LHC/hand_and_arm.png',
                            width: 300,
                            height: 70,
                          ), // 添加上下间距
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 10.0), // 在左侧添加间距
                              buildCircularCheckboxOne(0, 'None'),
                              buildCircularCheckboxOne(1, 'Occasionally'),
                              buildCircularCheckboxOne(2, 'Frequently'),
                              const SizedBox(width: 10.0), // 在右侧添加间距
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            //const SizedBox(height: 20),


            /*const Text(
              'The joint of hand or arm \n has reached its limit',
              style: TextStyle(fontSize: 20, color: Colors.black,),
              textAlign: TextAlign.center,
            ),
            Image.asset(
              'assets/picture/LHC/hand_and_arm.png',
              width: 300,
              height: 70,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10.0), // 在左侧添加间距
                    buildCircularCheckboxOne(0, 'None'),
                    buildCircularCheckboxOne(1, 'Occasionally'),
                    buildCircularCheckboxOne(2, 'Frequently'),
                    SizedBox(width: 10.0), // 在右侧添加间距
                  ],
                ),
              ],
            ),*/
            //const SizedBox(height: 25),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0), // 设置内边距
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0), // 边框样式
                        borderRadius: BorderRadius.circular(20.0), // 圆角
                        color: const Color(0xFFFFFCF2).withOpacity(1), // 背景色
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 40, // 调整这里的宽度以移动文字
                              ),
                              const Expanded(
                                child: Text(
                                  'Loads difficult to grip / greater holding forces required',
                                  style: TextStyle(fontSize: 22, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Tooltip(
                                message: 'more information',
                                preferBelow: false, // 将 Tooltip 放在右侧
                                child: IconButton(
                                  icon: const Icon(Icons.help_outline, color: Colors.black),
                                  onPressed: () {
                                    Loads(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 10.0), // 在左侧添加间距
                                  buildCircularCheckboxTwo(0, 'None'),
                                  buildCircularCheckboxTwo(1, 'Occasionally'),
                                  buildCircularCheckboxTwo(2, 'Very'),
                                  const SizedBox(width: 10.0), // 在右侧添加间距
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0), // 设置内边距
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0), // 边框样式
                        borderRadius: BorderRadius.circular(20.0), // 圆角
                        color: const Color(0xFFF0F5F9).withOpacity(1), // 背景色
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 40, // 调整这里的宽度以移动文字
                              ),
                              const Expanded(
                                child: Text(
                                  'Unfavorable weather conditions',
                                  style: TextStyle(fontSize: 22, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Tooltip(
                                message: 'more information',
                                preferBelow: false, // 将 Tooltip 放在右侧
                                child: IconButton(
                                  icon: const Icon(Icons.help_outline, color: Colors.black),
                                  onPressed: () {
                                    Unfavorable(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 10.0), // 在左侧添加间距
                                  buildCircularCheckboxThree(0, 'No'),
                                  buildCircularCheckboxThree(1, 'Yes'),
                                  const SizedBox(width: 10.0), // 在右侧添加间距
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0), // 设置内边距
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0), // 边框样式
                        borderRadius: BorderRadius.circular(20.0), // 圆角
                        color: const Color(0xFFFFFCF2).withOpacity(1), // 背景色
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 40, // 调整这里的宽度以移动文字
                              ),
                              const Expanded(
                                child: Text(
                                  'Spatial conditions',
                                  style: TextStyle(fontSize: 22, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Tooltip(
                                message: 'more information',
                                preferBelow: false, // 将 Tooltip 放在右侧
                                child: IconButton(
                                  icon: const Icon(Icons.help_outline, color: Colors.black),
                                  onPressed: () {
                                    Spatial(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 8.0), // 在左侧添加间距
                                  buildCircularCheckboxFour(0, 'Normal'),
                                  buildCircularCheckboxFour(1, 'Restricted'),
                                  buildCircularCheckboxFour(2, 'Unfavorable'),
                                  const SizedBox(width: 8.0), // 在右侧添加间距
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0), // 设置内边距
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0), // 边框样式
                        borderRadius: BorderRadius.circular(20.0), // 圆角
                        color: const Color(0xFFF0F5F9).withOpacity(1), // 背景色
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 40, // 调整这里的宽度以移动文字
                              ),
                              const Expanded(
                                child: Text(
                                  'Additional clothes or equipment',
                                  style: TextStyle(fontSize: 22, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Tooltip(
                                message: 'more information',
                                preferBelow: false, // 将 Tooltip 放在右侧
                                child: IconButton(
                                  icon: const Icon(Icons.help_outline, color: Colors.black),
                                  onPressed: () {
                                    Additional(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 10.0), // 在左侧添加间距
                                  buildCircularCheckboxFive(0, 'No'),
                                  buildCircularCheckboxFive(1, 'Yes'),
                                  const SizedBox(width: 10.0), // 在右侧添加间距
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0), // 设置内边距
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2.0), // 边框样式
                        borderRadius: BorderRadius.circular(20.0), // 圆角
                        color: const Color(0xFFFFFCF2).withOpacity(1), // 背景色
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 40, // 调整这里的宽度以移动文字
                              ),
                              const Expanded(
                                child: Text(
                                  'Difficulties due to holding/carrying',
                                  style: TextStyle(fontSize: 22, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Tooltip(
                                message: 'more information',
                                preferBelow: false, // 将 Tooltip 放在右侧
                                child: IconButton(
                                  icon: const Icon(Icons.help_outline, color: Colors.black),
                                  onPressed: () {
                                    Difficulties(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildCircularCheckboxSix(0, 'None'),
                              buildCircularCheckboxSix(1, 'Hold for 5~10 seconds or 2~5 m'),
                              buildCircularCheckboxSix(2, 'Hold for >10 seconds or >5 m'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
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
                        backgroundColor: WidgetStateProperty.all(const Color(0xFF8EC0E4)),
                        minimumSize: WidgetStateProperty.all<Size>(const Size(170, 50)),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularCheckboxOne(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // 设置主轴尺寸为最小，避免换行
          children: [
            Checkbox(
              value: isOneSelected[index],
              onChanged: (value) {
                updateOneSelectedIndex(index);
              },
              shape: const CircleBorder(),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              visualDensity: const VisualDensity(horizontal: -4),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularCheckboxTwo(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // 设置主轴尺寸为最小，避免换行
          children: [
            Checkbox(
              value: isTwoSelected[index],
              onChanged: (value) {
                updateTwoSelectedIndex(index);
              },
              shape: const CircleBorder(),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              visualDensity: const VisualDensity(horizontal: -4),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularCheckboxThree(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // 设置主轴尺寸为最小，避免换行
          children: [
            Checkbox(
              value: isThreeSelected[index],
              onChanged: (value) {
                updateThreeSelectedIndex(index);
              },
              shape: const CircleBorder(),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              visualDensity: const VisualDensity(horizontal: -4),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularCheckboxFour(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // 设置主轴尺寸为最小，避免换行
          children: [
            Checkbox(
              value: isFourSelected[index],
              onChanged: (value) {
                updateFourSelectedIndex(index);
              },
              shape: const CircleBorder(),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              visualDensity: const VisualDensity(horizontal: -4),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularCheckboxFive(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // 设置主轴尺寸为最小，避免换行
          children: [
            Checkbox(
              value: isFiveSelected[index],
              onChanged: (value) {
                updateFiveSelectedIndex(index);
              },
              shape: const CircleBorder(),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              visualDensity: const VisualDensity(horizontal: -4),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCircularCheckboxSix(int index, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min, // 设置主轴尺寸为最小，避免换行
          children: [
            Checkbox(
              value: isSixSelected[index],
              onChanged: (value) {
                updateSixSelectedIndex(index);
              },
              shape: const CircleBorder(),
              activeColor: Colors.blue,
              checkColor: Colors.white,
              visualDensity: const VisualDensity(horizontal: -4),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
