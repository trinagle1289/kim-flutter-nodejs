import 'package:flutter/material.dart';

void lhc_part7(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Detailed information',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: const Text(
            '"Good: The workload frequently fluctuates due to other activities. It includes various types of tasks without concentrating on a single high-intensity workload within a single day.\n'
                'Restricted: The workload rarely changes due to other activities. Occasionally, there is a focus on a single high-intensity workload within a single day.\n'
                'Unfavorable: The workload is hardly affected by other activities. It often focuses on a single high-intensity workload within a single day, frequently reaching peak load.',
            style: TextStyle(
              color: Colors.blue, // 文字顏色
              fontSize: 24.0, // 文字大小
              fontWeight: FontWeight.bold, // 文字粗細
            ),
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
