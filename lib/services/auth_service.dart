import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase Authentication サービス
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 現在のユーザーを取得
  User? get currentUser => _auth.currentUser;

  /// ログイン状態の変化を監視
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 新規ユーザー登録（メール/パスワード）
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String nickname,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // ニックネームをdisplayNameに設定
      await credential.user?.updateDisplayName(nickname);
      await credential.user?.reload();

      // Firestoreにユーザーの初期データを作成
      final uid = credential.user?.uid;
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,                  // 検索用に保持
          'name': nickname,            // 画面表示用
          'email': email,              // 管理用
          'current_mode': '',          // 既存項目
          'is_home': true,             // 💡 追加：チームが実装した「外出/帰宅」ステータスの初期値
          'essential_items': [],       // 💡 Pythonが読み取るリスト
          'fcm_token': '',             // 通知用
          'item_features': {},         // Map形式に変更（エラー防止）
          'scene_items': {},           // Map形式に変更（エラー防止）
          'created_at': FieldValue.serverTimestamp(), // 💡 追加：作成日時
        });
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  /// メール/パスワードでログイン
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMessage(e.code));
    }
  }

  /// ログアウト
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Firebase Authエラーコードを日本語メッセージに変換
  String _getErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'このメールアドレスは既に使用されています';
      case 'invalid-email':
        return 'メールアドレスの形式が正しくありません';
      case 'weak-password':
        return 'パスワードが弱すぎます（6文字以上で入力してください）';
      case 'user-not-found':
        return 'このメールアドレスのユーザーが見つかりません';
      case 'wrong-password':
        return 'パスワードが間違っています';
      case 'invalid-credential':
        return 'メールアドレスまたはパスワードが正しくありません';
      case 'user-disabled':
        return 'このアカウントは無効化されています';
      case 'too-many-requests':
        return 'リクエストが多すぎます。しばらく待ってからお試しください';
      case 'network-request-failed':
        return 'ネットワークエラーが発生しました';
      default:
        return 'エラーが発生しました（$code）';
    }
  }
}