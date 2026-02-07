import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_service.dart';

class DetectionService {
  final NotificationService _notificationService = NotificationService();
  bool _isListening = false;

  void startListening() {
    if (_isListening) return;
    _isListening = true;

    FirebaseFirestore.instance
        .collection('detections')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
      // 初回ロード時やデータがない場合は無視する制御
      // ここでは仕様に合わせて「追加された」イベントのみを処理する
      if (snapshot.docChanges.isEmpty) return;

      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data() as Map<String, dynamic>;
          final message = data['message'] as String? ?? '解析完了';
          final missingItems = data['missing_items'] as List<dynamic>? ?? [];
          final imageUrl = data['image_url'] as String?;

          _showNotification(message, missingItems, imageUrl);
        }
      }
    });
  }

  Future<void> _showNotification(
      String message, List<dynamic> missingItems, String? imageUrl) async {
    String title = missingItems.isNotEmpty ? "⚠️ 忘れ物があります！" : "✅ 忘れ物なし";

    if (imageUrl != null && imageUrl.isNotEmpty) {
      await _notificationService.showBigPictureNotification(
        id: 0,
        title: title,
        body: message,
        imageUrl: imageUrl,
      );
    } else {
      await _notificationService.showNotification(
        id: 0,
        title: title,
        body: message,
      );
    }
  }
}
