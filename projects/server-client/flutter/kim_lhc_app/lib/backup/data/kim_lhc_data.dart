/// KIM LHC 資料物件
class KimLhcData {
  /* 單例模式 */
  KimLhcData._internal(); // 建構子變成私有
  static final KimLhcData _instance = KimLhcData._internal();
  static KimLhcData get instance => _instance; // 提供一個公共的訪問點

  /* 資料物件 */
  final TotalBodyPostureData _totalBodyPostureData = TotalBodyPostureData();

  /* 評級分數 */
  /// 時間評級
  double timeRatingPoint = 0.0;

  /// 力量傳遞 / 負重條件
  int effectiveLoadWeight = 0;

  /// 身體姿勢
  double get totalBodyPosture =>
      _totalBodyPostureData.bpRatingPoints +
      _totalBodyPostureData.additionalPoints;

  /// 不良工作條件
  int unfavourableWorkingConditions = 0;

  /// 工作協調 / 時間分佈
  int workOrganisationOrTemporalDistribution = 0;
}

/// 姿勢種類
/// A0: 無姿勢(表示未進行設定)
/// A1: 站立姿勢, A2: 抬高姿勢, A3: 微彎腰, A4: 大彎腰, A5: 蹲跪、跪坐姿勢
// ignore: constant_identifier_names
enum PoseType { A0, A1, A2, A3, A4, A5 }

/// 身體姿勢
class TotalBodyPostureData {
  /// 姿勢評級
  int bpRatingPoints = 0;

  /// 額外加分
  double additionalPoints = 0.0;

  /// 姿勢評級開始姿勢
  PoseType startPose = PoseType.A0;

  /// 姿勢評級結束姿勢
  PoseType endPose = PoseType.A0;

  /// 設定姿勢
  void setPoses(PoseType start, PoseType end) {
    startPose = start;
    endPose = end;
  }
}

/// 不良工作條件
class UnfavourableWorkingConditionsData {}
