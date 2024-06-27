import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1080, 1920), // 設定設計稿的寬高
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter ScreenUtil 範例', style: TextStyle(fontSize: 20.sp)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '這是一個自適應的標題',
              style: TextStyle(fontSize: 24.sp),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {},
              child: Text('點擊我', style: TextStyle(fontSize: 18.sp)),
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
