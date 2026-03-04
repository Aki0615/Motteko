import 'package:firebase_auth/firebase_auth.dart';

/// Firebase Authentication サービス
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// 現在のユーザーを取得
  User? get currentUser => _auth.currentUser;

  /// ログイン状態の変化を監視
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// 新規ユーザー登録（メール/パスワード）
  ///
  /// 成功時は [UserCredential] を返す。
  /// 失敗時は日本語のエラーメッセージを持つ [Exception] をスロー。
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
