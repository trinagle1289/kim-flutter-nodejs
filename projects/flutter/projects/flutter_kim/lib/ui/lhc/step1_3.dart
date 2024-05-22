import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';

var _bodyPostureTable = 'assets/lhc/Body_Posture/table_en_2.png';

void main() => runApp(const Step1of3App());

class Step1of3App extends StatelessWidget {
  const Step1of3App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: Step1of3Field());
  }
}

class Step1of3Field extends StatefulWidget {
  const Step1of3Field({super.key});

  @override
  Step1of3FieldState createState() => Step1of3FieldState();
}

class Step1of3FieldState extends State<Step1of3Field> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTitleAppBar('Step 1(3/3)'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                color: const Color(0xFFFFDCB2),
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: const Text(
                  'Please select the appropriate rating points based on the posture rating chart below.',
                  style: TextStyle(color: Colors.black, fontSize: 19),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // 身體姿勢表格
              Image.asset(_bodyPostureTable, width: 370, height: 370),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  'Rating Points:',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                    value: step1of2Data.toInt().toString(),
                    items: [
                      '0',
                      '3',
                      '5',
                      '7',
                      '9',
                      '10',
                      '13',
                      '15',
                      '18',
                      '20',
                    ].map((rating) {
                      return DropdownMenuItem<String>(
                        value: rating,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1.2,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            rating,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        step1of2Data = double.parse(value!);
                      });
                    }),
              ]),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => getLhcApp("2")),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(170, 50)),
                ),
                child: const Text('Next',
                    style: TextStyle(fontSize: 30, color: Colors.white)),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
