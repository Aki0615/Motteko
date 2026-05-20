# 🎉 通知システム作成ガイド（Python版）- バックエンド初学者向け

> **最初に伝えたいこと**: Pythonは読みやすくて初心者に優しい言語です！一つずつステップを踏めば必ずできます。焦らず進めていきましょう💪

---

## 📋 全体の流れ


1. [ ] 環境準備（開発の準備）
2. [ ] Firebaseセットアップ
3. [ ] API作成（Flask使用）
4. [ ] デプロイ（サーバーに公開）
5. [ ] テスト

---

## 🚀 ステップ1: 環境準備

### 1-1. Python確認
ターミナルで以下を実行:
```bash
python3 --version
```
`Python 3.x.x` と表示されればOK！

### 1-2. プロジェクト作成
```bash
mkdir notification-backend
cd notification-backend
```

### 1-3. 仮想環境を作成
「仮想環境」は、このプロジェクト専用の作業場です。
```bash
python3 -m venv venv
source venv/bin/activate
```

### 1-4. 必要なライブラリをインストール
```bash
pip install flask firebase-admin python-dotenv gunicorn
```

| ライブラリ | 役割 |
|-----------|------|
| flask | Webアプリを作るツール |
| firebase-admin | Firebaseと連携するツール |
| python-dotenv | 設定ファイルを読むツール |
| gunicorn | サーバーを動かすツール |

> **🎯 ここまでできた？** 素晴らしい！環境構築は一番大変なところ。ここを越えたあなたはすごい！

---

## 🔥 ステップ2: Firebaseセットアップ

### 2-1. Firebase Console設定
1. [Firebase Console](https://console.firebase.google.com/) を開く
2. プロジェクト設定 > サービスアカウント
3. 「新しい秘密鍵を生成」をクリック
4. ダウンロードしたJSONファイルを `serviceAccountKey.json` にリネーム
5. プロジェクトフォルダに配置

⚠️ **重要**: このファイルは絶対に公開しないでください！

### 2-2. .gitignoreファイル作成
```
# .gitignore
serviceAccountKey.json
venv/
__pycache__/
.env
```

---

## 🔌 ステップ3: API作成

### 3-1. メインファイル作成
`app.py` を作成して以下を書く:

```python
# app.py - 通知システムのメインファイル

from flask import Flask, request, jsonify
import firebase_admin
from firebase_admin import credentials, firestore, messaging
from datetime import datetime

# ========================================
# 初期設定
# ========================================

# Flaskアプリを作成
app = Flask(__name__)

# Firebaseを初期化
cred = credentials.Certificate("serviceAccountKey.json")
firebase_admin.initialize_app(cred)

# Firestoreへの接続
db = firestore.client()


# ========================================
# 通知を取得するAPI
# ========================================
@app.route("/notifications", methods=["GET"])
def get_notifications():
    """
    ユーザーの通知一覧を取得する
    使い方: GET /notifications?userId=xxx
    """
    try:
        # URLからユーザーIDを取得
        user_id = request.args.get("userId")
        
        # ユーザーIDがなければエラー
        if not user_id:
            return jsonify({"error": "userIdが必要です"}), 400
        
        # Firestoreから通知を取得
        notifications_ref = db.collection("notifications")
        query = notifications_ref.where("userId", "==", user_id)
        query = query.order_by("timestamp", direction=firestore.Query.DESCENDING)
        query = query.limit(50)
        
        # 結果を配列に変換
        notifications = []
        for doc in query.stream():
            data = doc.to_dict()
            data["id"] = doc.id
            # timestampを文字列に変換
            if data.get("timestamp"):
                data["timestamp"] = data["timestamp"].isoformat()
            notifications.append(data)
        
        return jsonify({"notifications": notifications}), 200
        
    except Exception as e:
        print(f"エラー: {e}")
        return jsonify({"error": "サーバーエラーが発生しました"}), 500


# ========================================
# 新しい通知を作成するAPI
# ========================================
@app.route("/notifications", methods=["POST"])
def create_notification():
    """
    新しい通知を作成する
    使い方: POST /notifications
    ボディ: {"userId": "xxx", "message": "xxx", "type": "info"}
    """
    try:
        # リクエストからデータを取得
        data = request.get_json()
        
        user_id = data.get("userId")
        message = data.get("message")
        notif_type = data.get("type", "info")
        
        # 必須チェック
        if not user_id or not message:
            return jsonify({"error": "userIdとmessageは必須です"}), 400
        
        # 新しい通知データ
        new_notification = {
            "userId": user_id,
            "message": message,
            "type": notif_type,
            "timestamp": firestore.SERVER_TIMESTAMP,
            "isRead": False
        }
        
        # Firestoreに保存
        doc_ref = db.collection("notifications").add(new_notification)
        
        return jsonify({
            "success": True,
            "id": doc_ref[1].id,
            "message": "通知を作成しました！"
        }), 201
        
    except Exception as e:
        print(f"エラー: {e}")
        return jsonify({"error": "サーバーエラーが発生しました"}), 500


# ========================================
# プッシュ通知を送信するAPI
# ========================================
@app.route("/push", methods=["POST"])
def send_push():
    """
    プッシュ通知を送信する
    使い方: POST /push
    ボディ: {"token": "xxx", "title": "xxx", "body": "xxx"}
    """
    try:
        data = request.get_json()
        
        token = data.get("token")
        title = data.get("title")
        body = data.get("body")
        
        if not all([token, title, body]):
            return jsonify({"error": "token, title, bodyは必須です"}), 400
        
        # プッシュ通知メッセージを作成
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=body
            ),
            token=token
        )
        
        # 送信
        response = messaging.send(message)
        
        return jsonify({
            "success": True,
            "messageId": response
        }), 200
        
    except Exception as e:
        print(f"プッシュ通知エラー: {e}")
        return jsonify({"error": "通知の送信に失敗しました"}), 500


# ========================================
# 通知を既読にするAPI
# ========================================
@app.route("/notifications/<notification_id>/read", methods=["PUT"])
def mark_as_read(notification_id):
    """
    通知を既読にする
    使い方: PUT /notifications/xxx/read
    """
    try:
        doc_ref = db.collection("notifications").document(notification_id)
        doc_ref.update({"isRead": True})
        
        return jsonify({"success": True}), 200
        
    except Exception as e:
        print(f"エラー: {e}")
        return jsonify({"error": "更新に失敗しました"}), 500


# ========================================
# サーバー起動
# ========================================
if __name__ == "__main__":
    print("🚀 サーバーを起動中...")
    app.run(debug=True, port=5000)
```

> **💡 コードの読み方ヒント**:
> - `@app.route()` は「このURLにアクセスしたら」という意味
> - `def 関数名():` は処理のかたまり
> - `try: ... except:` はエラーを安全に処理する仕組み

---

## 📤 ステップ4: デプロイ

### 4-1. ローカルでテスト
まずは自分のPCで動かしてみましょう:
```bash
python app.py
```
`Running on http://127.0.0.1:5000` と出たら成功！

### 4-2. 本番用ファイル作成

**requirements.txt**（使うライブラリ一覧）:
```
flask==3.0.0
firebase-admin==6.2.0
python-dotenv==1.0.0
gunicorn==21.2.0
```

**Procfile**（Cloud Run用）:
```
web: gunicorn app:app
```

### 4-3. Google Cloud Runにデプロイ

```bash
# Google Cloud CLIをインストール（まだの場合）
# https://cloud.google.com/sdk/docs/install からダウンロード

# ログイン
gcloud auth login

# プロジェクト設定
gcloud config set project あなたのプロジェクトID

# デプロイ
gcloud run deploy notification-api \
  --source . \
  --region asia-northeast1 \
  --allow-unauthenticated
```

成功するとURLが表示されます！🎉

---

## ✅ ステップ5: テスト

### ブラウザでテスト
```
https://あなたのURL/notifications?userId=test_user
```

### curlでテスト
```bash
# 通知作成
curl -X POST https://あなたのURL/notifications \
  -H "Content-Type: application/json" \
  -d '{"userId":"test_user","message":"テスト通知！","type":"success"}'

# 通知取得
curl https://あなたのURL/notifications?userId=test_user
```

---

## 🏆 完成おめでとうございます！

### 学んだこと
- ✅ PythonとFlaskでAPI作成
- ✅ Firebaseとの連携
- ✅ Cloud Runへのデプロイ

---

## 🆘 困ったときは

| エラー | 解決法 |
|-------|-------|
| `ModuleNotFoundError` | `pip install ライブラリ名` |
| `Permission denied` | Firestoreルールを確認 |
| `Connection refused` | サーバーが起動しているか確認 |

> **最後に**: Pythonでバックエンドを作れるようになったあなたは素晴らしい！この経験はきっと将来役立ちます🌟
