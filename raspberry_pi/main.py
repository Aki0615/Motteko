import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import storage
import cv2
import time
import os
import uuid
from datetime import datetime

# ==========================================
# 設定
# ==========================================
# スクリプトのあるディレクトリを基準にする
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
# サービスアカウントキーのパス（同じディレクトリに配置することを想定）
CRED_PATH = os.path.join(BASE_DIR, 'serviceAccountKey.json')
# Firebase Storageのバケット名（gs://... の ... 部分）
# コンソールで確認するか、ここをあなたのバケット名に書き換えてください
STORAGE_BUCKET = 'test-513df.firebasestorage.app'

# カメラ初期化
# PiCameraを使う場合はライブラリが異なりますが、今回は汎用的なOpenCVを使用
def take_photo(filename='photo.jpg'):
    print("Taking photo...")
    cap = cv2.VideoCapture(0) # 0番目のカメラデバイス
    
    # カメラのウォームアップ
    time.sleep(2)
    
    if not cap.isOpened():
        print("Cannot open camera")
        return False
    
    ret, frame = cap.read()
    if ret:
        cv2.imwrite(filename, frame)
        print(f"Photo saved to {filename}")
    else:
        print("Failed to capture image")
    
    cap.release()
    return ret

def upload_photo(filename):
    print(f"Uploading {filename}...")
    bucket = storage.bucket()
    blob = bucket.blob(f"camera_uploads/{os.path.basename(filename)}")
    
    # アップロード
    blob.upload_from_filename(filename)
    
    # 公開URLを取得（期限付きURLではなく、永続的な公開設定を行う場合は別の手順が必要だが、
    # ここでは簡易的に署名付きURLを発行するか、make_publicする）
    
    # make_publicはIAM権限が必要な場合があるため、
    # 簡易的にダウンロードURLを生成する方法をとる（metadataのmediaLinkはトークンが必要）
    # ここでは署名付きURL（有効期限が必要）を発行する例
    # url = blob.generate_signed_url(expiration=3600) # 1時間有効
    
    # アプリ側で表示するために、永続的な公開アクセス（またはlong-lived token）が望ましい
    # 今回はmake_publicを試みる
    blob.make_public()
    return blob.public_url

def main():
    # Firebase初期化
    if not os.path.exists(CRED_PATH):
        print(f"Error: {CRED_PATH} found found. Please place your service account key file here.")
        return

    cred = credentials.Certificate(CRED_PATH)
    firebase_admin.initialize_app(cred, {
        'storageBucket': STORAGE_BUCKET
    })

    db = firestore.client()
    
    print("Listening for camera requests...")
    
    # コールバック関数
    def on_snapshot(col_snapshot, changes, read_time):
        for change in changes:
            if change.type.name == 'MODIFIED' or change.type.name == 'ADDED':
                doc = change.document
                data = doc.to_dict()
                
                # is_requestedがTrueになったら撮影
                if data.get('is_requested') == True:
                    print(f"Request received! Timestamp: {read_time}")
                    
                    # 写真撮影
                    timestamp = int(time.time())
                    filename = f"photo_{timestamp}.jpg"
                    if take_photo(filename):
                        # アップロード
                        try:
                            image_url = upload_photo(filename)
                            print(f"Uploaded: {image_url}")
                            
                            # results (detections) に書き込み
                            db.collection('detections').add({
                                'image_url': image_url,
                                'timestamp': firestore.SERVER_TIMESTAMP,
                                'message': '撮影しました！', # AI解析結果などがここに入る
                                'missing_items': [] # 忘れ物リスト
                            })
                            print("Result written to Firestore")
                            
                            # requestフラグを下ろす
                            doc.reference.update({
                                'is_requested': False,
                                'last_processed': firestore.SERVER_TIMESTAMP
                            })
                            
                            # ローカルファイルを掃除
                            if os.path.exists(filename):
                                os.remove(filename)
                                
                        except Exception as e:
                            print(f"Error during processing: {e}")
                    else:
                        print("Camera capture failed")

    # 監視開始
    doc_ref = db.collection('commands').document('camera_request')
    doc_watch = doc_ref.on_snapshot(on_snapshot)
    
    # プロセス維持
    try:
        while True:
            time.sleep(1)
    except KeyboardInterrupt:
        print("Stopping...")

if __name__ == '__main__':
    main()
