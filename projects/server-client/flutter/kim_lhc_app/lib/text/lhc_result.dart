import 'package:flutter/material.dart';

//1
void lhc_result1(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Information',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'These three items are the ones where you scored higher in the assessment (but still need improvement). '
          'The percentage calculation is: score for this item / total score.',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

//2
void lhc_result2(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Detailed information',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your rating is among the top three. The percentage score is calculated as your score divided by the total possible score.',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              'Close',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

//3
void lhc_result3(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Detailed information',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your rating is among the top three. The percentage score is calculated as your score divided by the total possible score.',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '關閉',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

//4
void lhc_result4(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Detailed information',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your rating is among the top three. The percentage score is calculated as your score divided by the total possible score.',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '關閉',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

//5
void lhc_result5(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Detailed information',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your rating is among the top three. The percentage score is calculated as your score divided by the total possible score.',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '關閉',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}

//6
void lhc_result6(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Detailed information',
          style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Your rating is among the top three. The percentage score is calculated as your score divided by the total possible score.',
          style: TextStyle(
            color: Colors.blue, // 文字顏色
            fontSize: 24.0, // 文字大小
            fontWeight: FontWeight.bold, // 文字粗細
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              '關閉',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
