import 'package:flutter/material.dart';
import 'package:junior_app_20240607/text/lhc_part7.dart';
import 'package:junior_app_20240607/kim-lhc/part1.dart';

void main() {
  runApp(Lhc_Part7());
}

int selectedOpt = 0;

class Lhc_Part7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '選擇頁面',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: SelectionPage(),
    );
  }
}

class SelectionPage extends StatefulWidget {
  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {

  int _opt1 = 0; // 新增變數給第一個選項
  int _opt2 = 2; // 新增變數給第二個選項
  int _opt3 = 4; // 新增變數給第三個選項

  void _selectOption(int option) {
    setState(() {
      selectedOpt = option;
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
            margin: EdgeInsets.symmetric(horizontal: 15.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: selectedOpt == option ? Colors.blue : Colors.black, width: 2.0),
              color: selectedOpt == option ? Colors.blue : Colors.transparent,
            ),
            child: selectedOpt == option
                ? Icon(Icons.check, size: 16.0, color: Colors.white)
                : null,
          ),
          SizedBox(width: 10.0),
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xFFC9D6DE),
          title: RichText(
            textAlign: TextAlign.center, // 确保文字居中对齐
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Work organization / temporal distribution: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                  text: '$selectedOpt',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue, // 設置顏色為藍色
                  ),
                ),
                TextSpan(
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
          actions: <Widget>[
            Tooltip(
              message: 'more information。',
              child: IconButton(
                icon: Icon(Icons.help_outline),
                color: Colors.black,
                onPressed: () {
                  lhc_part7(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 40.0), // 圖片與AppBar之間的距離
              Center(
                child: Image.asset(
                  'assets/picture/LHC/lifting.png',
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              SizedBox(height: 20.0), // 圖片與白色框之間的距離
              Expanded(
                child: Center(
                  child: Container(
                    width: 500.0,
                    height: 180.0,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black, width: 4.0),
                      color: Color(0xFFF0F5F9).withOpacity(1),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildOption(_opt1, 'Good', 20.0),
                        SizedBox(height: 10.0),
                        _buildOption(_opt2, 'Restricted', 20.0),
                        SizedBox(height: 10.0),
                        _buildOption(_opt3, 'Unfavorable', 20.0),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 150.0), // 白色框與按鈕之間的距離
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
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
                    MaterialPageRoute(builder: (context) => Lhc_Part1()),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Color(0xFF8EC0E4)),
                  minimumSize: MaterialStateProperty.all<Size>(const Size(170, 50)),
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
    );
  }
}
