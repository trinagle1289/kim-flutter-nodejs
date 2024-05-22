import 'package:flutter/material.dart';
import 'package:flutter_kim/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(const ProviderScope(child: Step7App()));

class Step7App extends StatelessWidget {
  const Step7App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Step 7',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Step7Field());
}

class Step7Field extends StatefulWidget {
  const Step7Field({super.key});

  @override
  Step7FieldState createState() => Step7FieldState();
}

class Step7FieldState extends State<Step7Field> {
  String? selectedOption;

  void goToPreviousPage() {
    Navigator.pop(context);
  }

  void goToNextPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => getLhcApp("8")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getTitleAppBar('Step 7'),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('                ', style: TextStyle(fontSize: 20)),
            const Align(
              alignment: Alignment.center,
              child: Text('Work organisation / temporal distribution',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            const Text('                ', style: TextStyle(fontSize: 20)),
            ListTile(
              title: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 0),
                    child: Text('Good', style: TextStyle(fontSize: 30))),
              ),
              subtitle: const Text(
                  'Frequent variation of the physical workload situation due to other activities',
                  style: TextStyle(fontSize: 20)),
              leading: Radio<String>(
                  value: 'Good',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                      switch (value) {
                        case 'Good':
                          step7Data = 0.0;
                          break;
                        case 'Restricted':
                          step7Data = 2.0;
                          break;
                        case 'Unfavourable':
                          step7Data = 4.0;
                          break;
                      }
                    });
                  }),
            ),
            ListTile(
              title: const Text('Restricted', style: TextStyle(fontSize: 30)),
              subtitle: const Text(
                  'Rare variation of the physical workload situation due to other activities',
                  style: TextStyle(fontSize: 20)),
              leading: Radio<String>(
                  value: 'Restricted',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                      switch (value) {
                        case 'Good':
                          step7Data = 0.0;
                          break;
                        case 'Restricted':
                          step7Data = 2.0;
                          break;
                        case 'Unfavourable':
                          step7Data = 4.0;
                          break;
                      }
                    });
                  }),
            ),
            ListTile(
              title: const Text('Unfavourable', style: TextStyle(fontSize: 30)),
              subtitle: const Text(
                  'No/hardly any variation of the physical workload ituation due to other activities',
                  style: TextStyle(fontSize: 20)),
              leading: Radio<String>(
                  value: 'Unfavourable',
                  groupValue: selectedOption,
                  onChanged: (String? value) {
                    setState(() {
                      selectedOption = value;
                      switch (value) {
                        case 'Good':
                          step7Data = 0.0;
                          break;
                        case 'Restricted':
                          step7Data = 2.0;
                          break;
                        case 'Unfavourable':
                          step7Data = 4.0;
                          break;
                      }
                    });
                  }),
            ),
            const Expanded(child: SizedBox()),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 5, 25),
                  child: ElevatedButton(
                      onPressed: goToPreviousPage,
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.infinity, 50))),
                      child: const Text('Back',
                          style: TextStyle(fontSize: 30, color: Colors.white))),
                ),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 10, 25),
                  child: ElevatedButton(
                      onPressed: goToNextPage,
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(double.infinity, 50))),
                      child: const Text('Next',
                          style: TextStyle(fontSize: 30, color: Colors.white))),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
