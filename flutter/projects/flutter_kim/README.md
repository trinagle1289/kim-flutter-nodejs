# flutter_kim_lhc

此 Flutter 專案用於人因危害風險的評估，主要檢測 KIM-LHC(人工物料搬運) 的風險值評估，目前注重於 Android 的開發
<br>

### 注意事項
切記!一定要先將模型放置於 assets/model/ 資料夾下  
並且將其命名為 singlepose-thunder-3.tflite

### 使用插件:
* camera: ^0.10.5+5
* flutter_launcher_icons: ^0.13.1
* flutter_riverpod: ^2.4.4
* flutter_storage_path: ^1.0.4
* gal: ^2.1.2
* image: ^4.1.3
* image_picker: ^1.0.4
* media_info: ^0.12.0+2
* path: ^1.8.3
* path_provider: ^2.1.1
* permission_handler: ^11.0.1
* riverpod_annotation: ^2.2.1
* tflite_flutter: ^0.10.3
* vector_math: ^2.1.4
* video_thumbnail: ^0.5.3
<br>

### 開發專用插件:
* build_runner: ^2.4.6
* custom_lint: ^0.5.5
* riverpod_generator: ^2.3.5
* riverpod_lint: ^2.3.2
<br>

### Android Manifest 所需權限:
* android.permission.READ_EXTERNAL_STORAGE
* android.permission.WRITE_EXTERNAL_STORAGE
* android.permission.MANAGE_EXTERNAL_STORAGE
* android.permission.CAMERA
<br>

### Android build.gradle 所需設定:
* minSdkVersion 26
* compileSdkVersion 33
<br>

### Android Manifest 添加權限方法:
以 android.permission.READ_EXTERNAL_STORAGE 為例，將此段程式碼放置於 android/app/src/main/AndroidManifest.xml 內的第二行中
```html
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
```
<br>

### Android build.gradle 設定方法:
1. 修改 android/app/build.gradle 中的 minSdkVersion 和 compileSdkVersion 的參數為相應數值
2. 以 minSdkVersion 為例，從 android/app/build.gradle 中進行修改，
   改為 minSdkVersion localProperties.getProperty('flutter.minSdkVersion').toInteger()。
   接著再新增 android/local.properties 內容為 flutter.minSdkVersion=26
<br>

### 新增 Flutter 套件指令
```bat
REM 此段為安裝專案使用套件
$ flutter pub add camera flutter_riverpod flutter_storage_path gal image image_picker path path_provider permission_handler riverpod_annotation tflite_flutter vector_math video_thumbnail media_info

REM 此段為安裝開發使用套件
$ flutter pub add dev:build_runner dev:custom_lint dev:flutter_launcher_icons dev:riverpod_generator dev:riverpod_lint
```
<br>

### Flutter 插件連結
* [camera](https://pub.dev/packages/camera)
* [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
* [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)
* [flutter_storage_path](https://pub.dev/packages/flutter_storage_path)
* [gal](https://pub.dev/packages/gal)
* [image](https://pub.dev/packages/image)
* [image_picker](https://pub.dev/packages/image_picker)
* [media_info](https://pub.dev/packages/media_info)
* [path](https://pub.dev/packages/path)
* [path_provider](https://pub.dev/packages/path_provider)
* [permission_handler](https://pub.dev/packages/permission_handler)
* [tflite_flutter](https://pub.dev/packages/tflite_flutter)
* [vector_math](https://pub.dev/packages/vector_math)
* [video_thumbnail](https://pub.dev/packages/video_thumbnail) 
<br>

### Git Commit 參考

#### 標題行的標準術語
**中文版:**
| 標頭 | 定義 |
| - | - |
| Add | 建立一個功能，例如：特性、測試、依賴性。 |
| Cut | 移除一個功能，例如：特性、測試、依賴性。 |
| Fix | 解決問題，例如：bug、錯字、意外、誤述。 |
| Bump | 增加某些東西的版本，例如：依賴性。 |
| Make | 變更建置流程、工具或基礎架構。 |
| Start | 開始做某些事情，例如：創建一個功能標誌。 |
| Stop | 結束做某些事情，例如：刪除一個功能標誌。 |
| Refactor | 程式碼的修改必須只能是一個重構。 |
| Reformat | 格式的重構，例如：省略空格。 |
| Optimize | 效能的重構，例如：加快代碼速度。 |
| Document | 文檔的重構，例如：幫助文件。 |

**英文版:**
| First Word | Meaning |
| - | - |
| Add | Create a capability e.g. feature, test, dependency. |
| Cut | Remove a capability e.g. feature, test, dependency. |
| Fix | Fix an issue e.g. bug, typo, accident, misstatement. |
| Bump | Increase the version of something e.g. dependency. |
| Make | Change the build process, or tooling, or infra. |
| Start | Begin doing something; e.g. create a feature flag. |
| Stop | End doing something; e.g. remove a feature flag. |
| Refactor | A code change that MUST be just a refactoring. |
| Reformat | Refactor of formatting, e.g. omit whitespace. |
| Optimize | Refactor of performance, e.g. speed up code. |
| Document | Refactor of documentation, e.g. help files. |
<br>

*參考資料*

> [Git Commit Message Standard](https://gist.github.com/tonibardina/9290fbc7d605b4f86919426e614fe692)
> <br>
> [Git Commit Message 這樣寫會更好，替專案引入規範與範例](https://wadehuanglearning.blogspot.com/2019/05/commit-commit-commit-why-what-commit.html)

### 使用模型
#### MoveNet

此專案使用 TFLite 格式的模型
版本為 singlepose-thunder
需要將此模型放置於 assets/model/ 資料夾底下
