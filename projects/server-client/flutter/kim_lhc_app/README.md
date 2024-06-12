# kim_lhc_app

運行 KIM LHC 判斷的應用程式。

## Android 所需設定


## Packages
1. camera: ^0.11.0+1
    * 需要在 `android\app\build.gradle` 中新增 `minSdkVersion 21`
2. chunked_uploader: ^1.1.0
3. dio: ^5.4.3+1
4. format: ^1.5.2
5. gal: ^2.3.0
    * 需要在 ```android/app/src/main/AndroidManifest.xml``` 中新增
        * API <= 29
            ```xml
            <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" android:maxSdkVersion="29" />
            ```
        * API  > 29
            ```xml
            <application android:requestLegacyExternalStorage="true" />
            ```
6. path_provider: ^2.1.3
7. video_player: ^2.8.6