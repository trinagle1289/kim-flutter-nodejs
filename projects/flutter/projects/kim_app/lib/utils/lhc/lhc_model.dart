class LHCModel {
  /// 時間評級
  double time = 0;

  /// 負重評級
  int load = 0;

  /// 力量傳遞/負重條件
  int loadHandlingConditions = 0;

  /// 姿勢評級(含額外加分)
  double bodyPosture = 0;

  /// 不良工作條件
  int unfavourableWorkingConditions = 0;

  /// 工作協調/時間分布
  int workOrganisationAndEmporalDistribution = 0;

  /// 取得風險值
  double getRiskScore() {
    return time *
        (load +
            loadHandlingConditions +
            bodyPosture +
            unfavourableWorkingConditions +
            workOrganisationAndEmporalDistribution);
  }
}
