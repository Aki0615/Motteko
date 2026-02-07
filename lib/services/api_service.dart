import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // APIのエンドポイントURL（末尾のスラッシュ問題を修正済み）
  static const String _baseUrl =
      'https://notification-api-235258683606.asia-northeast1.run.app';

  /// 指定されたユーザーIDの通知を取得する
  Future<List<dynamic>> fetchNotifications(
      {String userId = 'test_user'}) async {
    final url = Uri.parse('$_baseUrl/notifications?userId=$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // ボディをUTF-8でデコードしてからJSONパース（文字化け対策）
        final decodedBody = utf8.decode(response.bodyBytes);
        final data = json.decode(decodedBody);

        // データの型に応じてリストとして返す
        if (data is List) {
          return data;
        } else if (data is Map && data.containsKey('notifications')) {
          // { "notifications": [...] } の形式の場合
          return data['notifications'] as List;
        } else {
          // 想定外の形式だが、空リストでエラー回避
          print('Unexpected JSON format: $data');
          return [];
        }
      } else {
        throw Exception('Failed to load notifications: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching notifications: $e');
    }
  }
}
