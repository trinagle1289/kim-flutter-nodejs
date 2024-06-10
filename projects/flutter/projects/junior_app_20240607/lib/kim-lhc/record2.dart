import 'dart:io';
import 'package:flutter/material.dart';
import 'package:junior_app_20240607/kim-lhc/record1.dart';
import 'package:video_player/video_player.dart';
import 'package:junior_app_20240607/kim-lhc/part1.dart';

//變數posture1~8,sumofposture,totalposture
int posture1 = 1; //表格內變數
int posture2 = 0;
int posture3 = 0;
int posture4 = 0;
int posture5 = 0;
int posture6 = 0;
int posture7 = 0;
int posture8 = 2;

int sumofposture = posture1 +
    posture2 +
    posture3 +
    posture4 +
    posture5 +
    posture6 +
    posture7 +
    posture8;
//additonl points

int bodyposture = 10;
//int totalbodyposture = sumofposture + bodyposture;
int totalbodyposture = 0;

class VideoPage extends StatefulWidget {
  final String filePath;
  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _initVideoPlayer() {
    var videoPath = widget.filePath;
    _videoPlayerController = VideoPlayerController.file(File(videoPath));
    _videoPlayerController.initialize().then((_) {
      setState(() {});
      _videoPlayerController.setLooping(true);
      _videoPlayerController.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFC9D6DE),
        title: Center(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: 'Total body posture:',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: ' 13 ',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold)),
                TextSpan(
                    text: 'point',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: MediaQuery.of(context).size.height / 1.7,
                width: MediaQuery.of(context).size.width - 26,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F5F9).withOpacity(1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.5,
                      ),
                    ),
                    child: _videoPlayerController.value.isInitialized
                        ? AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio * 1.5,
                            child: Transform.scale(
                              scale: 0.9,
                              child: VideoPlayer(_videoPlayerController),
                            ),
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF0F5F9).withOpacity(1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.5,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 15),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Body posture:',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: '$bodyposture ',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text: 'point',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/picture/LHC/p2.png'),
                        Image.asset(
                          'assets/picture/LHC/ginto1.png',
                          width: 50,
                          height: 50,
                        ),
                        Image.asset('assets/picture/LHC/CDDD.png'),
                      ],
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF0F5F9).withOpacity(1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.5,
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 20.0,
                    headingRowHeight: 50.0,
                    columns: [
                      DataColumn(
                          label: SizedBox(
                              width: 250,
                              child: Text('Additional Points:',
                                  style: TextStyle(fontSize: 20)))),
                      DataColumn(
                          label: SizedBox(
                              width: 50, child: Text(' $sumofposture Points'))),
                    ],
                    rows: [
                      DataRow(cells: [
                        DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Occasional twisting and/or lateral inclination'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture1'))),
                      ]),
                      DataRow(cells: [
                        DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Frequent/constant twisting and/or lateral inclination'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture2'))),
                      ]),
                      DataRow(cells: [
                        DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Load center occasionally at a distance from the body'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture3'))),
                      ]),
                      DataRow(cells: [
                        DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Load center frequently/constantly at a distance from the body'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture4 '))),
                      ]),
                      DataRow(cells: [
                        DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Hands occasionally between elbow and shoulder'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture5 '))),
                      ]),
                      DataRow(cells: [
                        DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Hands frequently/constantly between elbow and shoulder'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture6 '))),
                      ]),
                      DataRow(cells: [
                        DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Hands occasionally above shoulder height'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture7'))),
                      ]),
                      DataRow(cells: [
                        DataCell(SizedBox(
                            width: 250,
                            child: Text(
                                'Hands frequently/constantly above shoulder height'))),
                        DataCell(
                            SizedBox(width: 50, child: Text('  +$posture8'))),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // 主軸方向置中
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, right: 10), // 調整按鈕間距
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        // 點擊按鈕時導航到第二個畫面
                        context,
                        MaterialPageRoute(builder: (context) => record1()),
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF8EC0E4)),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(170, 50)), // 調整按鈕的最小尺寸
                    ),
                    child: const Text(
                      'Re-record',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 10), // 調整按鈕間距
                  child: ElevatedButton(
                    onPressed: () {
                      totalbodyposture = 13;
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
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF8EC0E4)),
                      minimumSize: MaterialStateProperty.all<Size>(
                          const Size(170, 50)), // 調整按鈕的最小尺寸
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
