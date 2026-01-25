enum NotificationType {
  warning, // 忘れ物警告
  success, // 忘れ物なし
  info, // 情報通知
}

class NotificationModel {
  final String id;
  final String message;
  final DateTime timestamp;
  final NotificationType type;

  NotificationModel({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.type,
  });

  // JSONからオブジェクトを生成
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      message: json['message'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
        orElse: () => NotificationType.info,
      ),
    );
  }

  // オブジェクトをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
    };
  }

  // コピーメソッド
  NotificationModel copyWith({
    String? id,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
    );
  }
}
