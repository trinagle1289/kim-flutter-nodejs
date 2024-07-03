import 'package:flutter/material.dart';

void lhc_part7(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Information',
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: const Text(
            'Good: "Frequent variation of the physical workload situation due to other activities (including other types of physical '
                    'workload) / without a tight sequence of higher physical workloads within one type of physical workload during a single '
                    'working day."\n'
            'Restricted: "Rare variation of the physical workload situation due to other activities (including other types of physical '
                          'workload) / occasional tight sequence of higher physical workloads within one type of physical workload during a '
                          'single working day"\n'
            'Unfavorable: "No/Hardly any variation of the physical workload situation due to other activities (including other types '
                          'of physical workload) / frequent tight sequence of higher physical workloads within one type of physical workload '
                          'during a single working day with concurrent high load peaks."',
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
              'Close',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
