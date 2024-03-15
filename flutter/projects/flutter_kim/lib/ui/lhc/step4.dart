import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

enum Gender { man, woman }

Gender? selectedGender;

void main() => runApp(const Step4App());

class Step4App extends StatelessWidget {
  const Step4App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: getTitleAppBar('Step 4'),
          body: const Center(child: RadioExample())),
    );
  }
}

//enum gender{MAN,WOMAN}

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  //gender? selectergender;
  String? selectedOption;
  String? selectedOption2;
  String? nothing;

  List<String> dropdownOptions = [
    '3-5公斤',
    '大於5-10公斤',
    '大於10-15公斤',
    '大於15-20公斤',
    '大於20-25公斤',
    '大於25-30公斤',
    '大於30-35公斤',
    '大於35-40公斤',
    '大於40公斤'
  ];
  List<String> dropdownOptions2 = [
    ' 3-5公斤',
    '大於5-10公斤',
    '大於10-15公斤',
    '大於15-20公斤',
    '大於20-25公斤',
    '大於25-30公斤',
    '大於30-35公斤',
    '大於35-40公斤',
    '大於40公斤'
  ];
  List<String> dropdownOptions3 = [''];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text('               ', style: TextStyle(fontSize: 20)),
      const Center(
        child: Text(
          'Effective load weight',
          style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
      const Text('               ', style: TextStyle(fontSize: 20)),
      Row(children: [
        Expanded(
          child: RadioListTile<Gender>(
              title: const Text('Male', style: TextStyle(fontSize: 25)),
              value: Gender.man,
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                  step4GenderData = selectedGender == Gender.man ? "男" : "女";
                });
              }),
        ),
        Expanded(
          child: RadioListTile<Gender>(
              title: const Text('Female', style: TextStyle(fontSize: 25)),
              value: Gender.woman,
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value;
                  step4GenderData = selectedGender == Gender.man ? "男" : "女";
                });
              }),
        ),
      ]),
      const Text('               ', style: TextStyle(fontSize: 20)),
      const Text('Effective load weight(kg)', style: TextStyle(fontSize: 30)),
      const Text('               ', style: TextStyle(fontSize: 20)),
      Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.black, width: 1.2)),
        child: IgnorePointer(
          ignoring: selectedGender == null,
          child: DropdownButton<String>(
              hint: const Text('approx.',
                  style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
              value: selectedOption,
              items: dropdownOptions.map((option) {
                return DropdownMenuItem<String>(
                    value: option, child: Text(option));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                  if (selectedOption != null && selectedGender != null) {
                    if (selectedGender == Gender.man) {
                      if (selectedOption == '3-5公斤') {
                        step4Data = 4.0;
                      } else if (selectedOption == '大於5-10公斤') {
                        step4Data = 6.0;
                      } else if (selectedOption == '大於10-15公斤') {
                        step4Data = 8.0;
                      } else if (selectedOption == '大於15-20公斤') {
                        step4Data = 11.0;
                      } else if (selectedOption == '大於20-25公斤') {
                        step4Data = 15.0;
                      } else if (selectedOption == '大於25-30公斤') {
                        step4Data = 25.0;
                      } else if (selectedOption == '大於30-35公斤') {
                        step4Data = 35.0;
                      } else if (selectedOption == '大於35-40公斤') {
                        step4Data = 75.0;
                      } else if (selectedOption == '大於40公斤') {
                        step4Data = 100.0;
                      }
                    } else if (selectedGender == Gender.woman) {
                      if (selectedOption == '3-5公斤') {
                        step4Data = 6.0;
                      } else if (selectedOption == '大於5-10公斤') {
                        step4Data = 9.0;
                      } else if (selectedOption == '大於10-15公斤') {
                        step4Data = 12.0;
                      } else if (selectedOption == '大於15-20公斤') {
                        step4Data = 25.0;
                      } else if (selectedOption == '大於20-25公斤') {
                        step4Data = 75.0;
                      } else if (selectedOption == '大於25-30公斤') {
                        step4Data = 85.0;
                      } else if (selectedOption == '大於30-35公斤') {
                        step4Data = 100.0;
                      } else if (selectedOption == '大於35-40公斤') {
                        step4Data = 100.0;
                      } else if (selectedOption == '大於40公斤') {
                        step4Data = 100.0;
                      }
                    }
                  }
                });
              }),
        ),
      ),
      const SizedBox(height: 20),
      const Spacer(),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        // 上一步按鈕
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize: MaterialStateProperty.all<Size>(Size(170, 50))),
              child: const Text('Back',
                  style: TextStyle(fontSize: 30, color: Colors.white))),
        ),

        const SizedBox(width: 13),

        // 下一步按鈕
        Padding(
          padding: const EdgeInsets.only(bottom: 30.0),
          child: ElevatedButton(
              onPressed: () {
                print(nothing);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => getLhcApp("5")));
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize: MaterialStateProperty.all<Size>(Size(170, 50))),
              child: const Text('Next',
                  style: TextStyle(fontSize: 30, color: Colors.white))),
        ),
      ]),
    ]);
  }
}
