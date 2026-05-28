import firebase_admin
from firebase_admin import credentials, firestore, messaging
import sys

import os

SERVICE_ACCOUNT_PATH = os.environ.get(
    "FIREBASE_SERVICE_ACCOUNT_KEY",
    os.path.join(os.path.dirname(__file__), "serviceAccountKey.json"),
)

cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
firebase_admin.initialize_app(cred)

db = firestore.client()

users_ref = db.collection("users")
docs = users_ref.stream()

fcm_token = None
for doc in docs:
    data = doc.to_dict()
    token = data.get("fcm_token")
    if token:
        fcm_token = token
        print(f"FCMトークン発見 (uid: {doc.id})")
        break

if not fcm_token:
    print("FCMトークンが見つかりません。アプリにログインしてください。")
    sys.exit(1)

title = sys.argv[1] if len(sys.argv) > 1 else "⚠️ 忘れ物があります！"
body = sys.argv[2] if len(sys.argv) > 2 else "財布が見つかりません。確認してください。"

message = messaging.Message(
    notification=messaging.Notification(
        title=title,
        body=body,
    ),
    token=fcm_token,
)

response = messaging.send(message)
print(f"通知送信成功: {response}")
