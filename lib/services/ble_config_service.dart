import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// M5StackへのWi-Fi設定用BLE通信サービス
class BleConfigService {
  // ⚠️ 注意: 以下の名前とUUIDは、M5Stackの "secrets.h" の中身と完全に一致している必要があります！
  static const String deviceName = "Motteko-Setup";
  static const String serviceUuidStr = "12345678-1234-5678-1234-56789abcdef0";
  static const String charUuidSsidStr = "12345678-1234-5678-1234-56789abcdef1";
  static const String charUuidPassStr = "12345678-1234-5678-1234-56789abcdef2";
  static const String charUuidUidStr = "12345678-1234-5678-1234-56789abcdef3";
  static const String charUuidDeviceIdStr = "12345678-1234-5678-1234-56789abcdef4";

  final Guid serviceUuid = Guid(serviceUuidStr);
  final Guid charUuidSsid = Guid(charUuidSsidStr);
  final Guid charUuidPass = Guid(charUuidPassStr);
  final Guid charUuidUid = Guid(charUuidUidStr);
  final Guid charUuidDeviceId = Guid(charUuidDeviceIdStr);

  Future<void> sendWifiInfo(String ssid, String password) async {
    final mottekoDevice = await _findMottekoDevice();
    try {
      await mottekoDevice.connect(timeout: const Duration(seconds: 5));
      final configService = await _discoverConfigService(mottekoDevice);
      await _writeWifiCredentials(configService, ssid, password);
      await _sendUserIdIfAvailable(configService);
    } finally {
      await mottekoDevice.disconnect();
    }
  }

  /// 指定したデバイスにUIDだけを送信する
  Future<void> sendUid(BluetoothDevice device) async {
    try {
      await device.connect(timeout: const Duration(seconds: 5));
      final configService = await _discoverConfigService(device);

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        throw Exception('ユーザーがログインしていません。');
      }

      final uidCharacteristic = _findCharacteristic(configService, charUuidUid);
      if (uidCharacteristic == null) {
        throw Exception('UID送信用のCharacteristicが見つかりませんでした。');
      }
      await uidCharacteristic.write(utf8.encode(uid), withoutResponse: false);
    } finally {
      await device.disconnect();
    }
  }

  /// デバイスIDをM5Stackへ送信する
  Future<void> sendDeviceId(String deviceId) async {
    final mottekoDevice = await _findMottekoDevice();
    try {
      await mottekoDevice.connect(timeout: const Duration(seconds: 5));
      final configService = await _discoverConfigService(mottekoDevice);

      final deviceIdCharacteristic = _findCharacteristic(configService, charUuidDeviceId);
      if (deviceIdCharacteristic == null) {
        throw Exception('デバイスID送信用のCharacteristicが見つかりませんでした。');
      }

      await deviceIdCharacteristic.write(utf8.encode(deviceId), withoutResponse: false);
    } finally {
      await mottekoDevice.disconnect();
    }
  }

  // ---------------------------------------------------------------------------
  // プライベートヘルパーメソッド
  // ---------------------------------------------------------------------------

  /// 接続済みデバイスまたはBLEスキャンからMottekoデバイスを探す
  Future<BluetoothDevice> _findMottekoDevice() async {
    // まず接続済みデバイスの中を探す
    for (var device in FlutterBluePlus.connectedDevices) {
      if (device.platformName == deviceName || device.advName == deviceName) {
        return device;
      }
    }

    // 見つからなければBLEスキャンで探す
    BluetoothDevice? foundDevice;

    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    final scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (var result in results) {
        if (result.device.platformName == deviceName ||
            result.device.advName == deviceName) {
          foundDevice = result.device;
          FlutterBluePlus.stopScan();
          break;
        }
      }
    });

    // UIブロックを防ぐため、スキャンは最大5秒に制限
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    // デバイス発見時は即座にstopScan()されるため、まだスキャン中の場合のみ完了を待つ
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.isScanning.where((val) => val == false).first;
    }
    scanSubscription.cancel();

    if (foundDevice == null) {
      throw Exception(
          'デバイス($deviceName)が見つかりませんでした。本体がBluetoothモードになっているか確認してください。');
    }
    return foundDevice!;
  }

  /// デバイスからMotteko設定用BLEサービスを検索する
  Future<BluetoothService> _discoverConfigService(
      BluetoothDevice device) async {
    final services = await device.discoverServices();
    for (var service in services) {
      if (service.serviceUuid == serviceUuid) {
        return service;
      }
    }
    throw Exception('BLEサービスが見つかりませんでした。アプリとM5StackのUUIDが一致しているか確認してください。');
  }

  /// サービス内から指定UUIDのCharacteristicを探す（見つからなければnull）
  BluetoothCharacteristic? _findCharacteristic(
      BluetoothService service, Guid uuid) {
    for (var characteristic in service.characteristics) {
      if (characteristic.characteristicUuid == uuid) {
        return characteristic;
      }
    }
    return null;
  }

  /// SSIDとパスワードをBLE経由でデバイスに書き込む
  Future<void> _writeWifiCredentials(
      BluetoothService service, String ssid, String password) async {
    final ssidCharacteristic = _findCharacteristic(service, charUuidSsid);
    final passwordCharacteristic = _findCharacteristic(service, charUuidPass);

    if (ssidCharacteristic == null || passwordCharacteristic == null) {
      throw Exception('書き込み先のCharacteristicが見つかりませんでした。');
    }

    await ssidCharacteristic.write(utf8.encode(ssid), withoutResponse: false);
    // M5Stack側のCharacteristic書き込み処理完了を待つ。
    // この待機がないと次の書き込みがデバイス側で取りこぼされる。
    await Future.delayed(const Duration(milliseconds: 500));
    await passwordCharacteristic.write(utf8.encode(password),
        withoutResponse: false);
  }

  /// Firebase UIDが取得可能であればデバイスに送信する
  Future<void> _sendUserIdIfAvailable(BluetoothService service) async {
    final uidCharacteristic = _findCharacteristic(service, charUuidUid);
    if (uidCharacteristic == null) return;

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await uidCharacteristic.write(utf8.encode(uid), withoutResponse: false);
    }
  }
}
