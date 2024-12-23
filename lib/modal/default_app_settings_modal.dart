class DefaultAppSettingModal {
  int appVersionIos;
  int appVersionAndroid;
  int hardUpdateVersionAndroid;
  int hardUpdateVersionIos;
  bool updatePopup;
  bool hideOnSubmit;
  String? googleApiKey;
  String updateUrlAndroid;
  String updateUrlIos;
  String updateMessage;

  DefaultAppSettingModal({
    required this.appVersionIos,
    required this.appVersionAndroid,
    required this.hardUpdateVersionAndroid,
    required this.hardUpdateVersionIos,
    required this.updatePopup,
    required this.hideOnSubmit,
    required this.googleApiKey,
    required this.updateUrlAndroid,
    required this.updateUrlIos,
    required this.updateMessage,
  });

  factory DefaultAppSettingModal.fromJson(Map json) {
    return DefaultAppSettingModal(
      appVersionIos: json['appVersionIos'],
      appVersionAndroid: json['appVersionAndroid'],
      hardUpdateVersionAndroid: json['hardUpdateVersionAndroid'],
      hardUpdateVersionIos: json['hardUpdateVersionIos'],
      updatePopup: json['updatePopup'],
      hideOnSubmit: json['hideOnSubmit'] ?? false,
      googleApiKey: json['googleApiKey'],
      updateUrlAndroid: json['updateUrlAndroid'],
      updateUrlIos: json['updateUrlIos'],
      updateMessage: json['updateMessage'],
    );
  }
}
