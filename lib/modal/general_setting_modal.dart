class GeneralSettingModal {
  double adminCommissionInPer;
  double serviceFeeInPercent;
  double minWithdrawalLimit;

  GeneralSettingModal({
    required this.adminCommissionInPer,
    required this.serviceFeeInPercent,
    this.minWithdrawalLimit = 1000,
  });

  factory GeneralSettingModal.fromJson(Map<String, dynamic> json) {
    return GeneralSettingModal(
      adminCommissionInPer:
          double.parse(json['adminCommissionInPer'].toString()),
      serviceFeeInPercent: double.parse(json['serviceFeeInPercent'].toString()),
      minWithdrawalLimit:
          double.parse((json['minWithdrawalLimit'] ?? '1000').toString()),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['adminCommissionInPer'] = adminCommissionInPer;
    data['serviceFeeInPercent'] = serviceFeeInPercent;
    data['minWithdrawalLimit'] = minWithdrawalLimit;
    return data;
  }
}
