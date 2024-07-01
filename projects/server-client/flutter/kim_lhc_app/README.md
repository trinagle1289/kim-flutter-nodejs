# kim_lhc_app

運行 KIM LHC 判斷的應用程式。

## Packages

1. camera: ^0.11.0+1
   - 需要在 `android\app\build.gradle` 中新增 `minSdkVersion 21`
2. chunked_uploader: ^1.1.0
3. dio: ^5.4.3+1
4. format: ^1.5.2
5. image_picker: ^1.1.2
   - 需要在 `android\app\build.gradle` 中新增 `minSdkVersion 21`
6. path: ^1.8.3
7. path_provider: ^2.1.3
   - 需要在 `android\app\build.gradle` 中新增 `minSdkVersion 16`
8. video_compress_plus: ^1.0.0
9.  video_player: ^2.8.6
   - 需要在 `android\app\build.gradle` 中新增 `minSdkVersion 16`
10. flutter_screenutil: ^5.9.0
11. restart_app: ^1.2.1
12. fluttertoast: ^8.2.6

## Android 額外設定

- 需要在 `android\app\src\main\AndroidManifest.xml` 中添加下列程式碼，<br>
  否則編譯成發行版時無法順利進行連線
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  ```

## 開發套件

1. flutter_launcher_icons: ^0.13.1
   - 使用 `flutter pub run flutter_launcher_icons` 指令生成應用程式圖標
