class ZegoCloudDataModel {
  final String appId;
  final String appSign;
  final String prefilledSMSText;
  ZegoCloudDataModel({
    required this.appId,
    required this.appSign,
    required this.prefilledSMSText,
  });

  Map<String, dynamic> toMap() {
    return {
      'appId': appId,
      'appSign': appSign,
      'prefilledSMSText': prefilledSMSText,
    };
  }

  factory ZegoCloudDataModel.fromMap(Map<String, dynamic> map) {
    return ZegoCloudDataModel(
      appId: map['appId'] ?? '',
      appSign: map['appSign'] ?? '',
      prefilledSMSText: map['prefilledSMSText'] ?? '',
    );
  }
}
