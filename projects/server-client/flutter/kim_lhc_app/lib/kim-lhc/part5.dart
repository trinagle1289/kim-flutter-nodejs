import 'package:flutter/material.dart';
import 'package:kim_lhc_app/kim-lhc/part1.dart';

void main() {
  runApp(const LhcPart5());
}

int selectedOption = 0;

class LhcPart5 extends StatelessWidget {
  const LhcPart5({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '選擇頁面',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SelectionPage(),
    );
  }
}

class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {

  final int _option1 = 0; // 新增變數給第一個選項
  final int _option2 = 2; // 新增變數給第二個選項
  final int _option3 = 4; // 新增變數給第三個選項
  String _imagePath = 'assets/picture/LHC/hands.png'; // 初始顯示的圖片

  void _selectOption(int option) {
    setState(() {
      selectedOption = option;
      if (option == _option1) {
        _imagePath = 'assets/picture/LHC/hands.png';
      } else {
        _imagePath = 'assets/picture/LHC/hand.png';
      }
    });
  }

  Widget _buildOption(int option, String text, double fontSize) {
    return GestureDetector(
      onTap: () => _selectOption(option),
      child: Row(
        children: <Widget>[
          Container(
            width: 20.0,
            height: 40.0,
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: selectedOption == option ? Colors.blue : Colors.black, width: 2.0),
              color: selectedOption == option ? Colors.blue : Colors.transparent,
            ),
            child: selectedOption == option
                ? const Icon(Icons.check, size: 16.0, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10.0),
          Text(
            text,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFC9D6DE),
        title: RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Load handling conditions: ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              TextSpan(
                text: '$selectedOption',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const TextSpan(
                text: ' points',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 40.0), // 圖片與AppBar之間的距離
              Center(
                child: Image.asset(
                  _imagePath,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              const SizedBox(height: 20.0), // 圖片與白色框之間的距離
              Expanded(
                child: Center(
                  child: Container(
                    width: 500.0,
                    height: 300.0,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black, width: 4.0),
                      color: const Color(0xFFF0F5F9).withOpacity(1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildOption(_option1, 'Use both hands symmetrically', 20.0),
                        const SizedBox(height: 30.0),
                        _buildOption(_option2, 'Temporarily use one hand', 20.0),
                        const SizedBox(height: 30.0),
                        _buildOption(_option3, 'Always use one hand', 20.0),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 150.0), // 白色框與按鈕之間的距離
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
    );
  }
}
