class SensorStatus {
  final bool isPersonPresent;
  final DateTime lastDetectedTime;

  SensorStatus({
    required this.isPersonPresent,
    required this.lastDetectedTime,
  });

  // JSONからオブジェクトを生成
  factory SensorStatus.fromJson(Map<String, dynamic> json) {
    return SensorStatus(
      isPersonPresent: json['isPersonPresent'] as bool,
      lastDetectedTime: DateTime.parse(json['lastDetectedTime'] as String),
    );
  }

  // オブジェクトをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'isPersonPresent': isPersonPresent,
      'lastDetectedTime': lastDetectedTime.toIso8601String(),
    };
  }

  // コピーメソッド
  SensorStatus copyWith({
    bool? isPersonPresent,
    DateTime? lastDetectedTime,
  }) {
    return SensorStatus(
      isPersonPresent: isPersonPresent ?? this.isPersonPresent,
      lastDetectedTime: lastDetectedTime ?? this.lastDetectedTime,
    );
  }

  // デフォルトの初期値
  factory SensorStatus.initial() {
    return SensorStatus(
      isPersonPresent: false,
      lastDetectedTime: DateTime.now(),
    );
  }
}
