import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// M5StackへのWi-Fi設定用BLE通信サービス
class BleConfigService {
  static const String deviceName = "Motteko-Setup";
  static const String serviceUuidStr = "12345678-1234-5678-1234-56789abcdef0";
  static const String charUuidSsidStr = "12345678-1234-5678-1234-56789abcdef1";
  static const String charUuidPassStr = "12345678-1234-5678-1234-56789abcdef2";

  final Guid serviceUuid = Guid(serviceUuidStr);
  final Guid charUuidSsid = Guid(charUuidSsidStr);
  final Guid charUuidPass = Guid(charUuidPassStr);

  /// デバイスをスキャンしてSSIDとパスワードを書き込む
  ///
  /// 処理の流れ:
  /// 1. デバイス名が一致するデバイスをスキャン
  /// 2. 接続
  /// 3. サービスを検索
  /// 4. 指定されたキャラクタリスティックにSSID/パスワードを書き込み
  /// 5. 切断
  Future<void> sendWifiInfo(String ssid, String password) async {
    // 既にスキャン中なら停止
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    BluetoothDevice? targetDevice;

    // スキャン開始 (タイムアウト10秒)
    await FlutterBluePlus.startScan(
      withNames: [deviceName],
      timeout: const Duration(seconds: 10),
    );

    // デバイスが見つかるまで待機
    await for (final scanResults in FlutterBluePlus.scanResults) {
      if (scanResults.isNotEmpty) {
        for (final result in scanResults) {
          if (result.device.advName == deviceName ||
              result.device.platformName == deviceName) {
            targetDevice = result.device;
            break;
          }
        }
      }
      if (targetDevice != null) {
        break; // 見つかったらスキャン完了
      }
    }

    await FlutterBluePlus.stopScan();

    if (targetDevice == null) {
      throw Exception('デバイス($deviceName)が見つかりませんでした。本体が設定モードになっているか確認してください。');
    }

    // デバイスに接続
    try {
      await targetDevice.connect(timeout: const Duration(seconds: 5));
    } catch (e) {
      throw Exception('デバイスへの接続に失敗しました: $e');
    }

    try {
      // サービスを検索
      List<BluetoothService> services = await targetDevice.discoverServices();
      BluetoothService? targetService;

      for (var service in services) {
        if (service.serviceUuid == serviceUuid) {
          targetService = service;
          break;
        }
      }

      if (targetService == null) {
        throw Exception('該当するBLEサービスが見つかりませんでした。');
      }

      BluetoothCharacteristic? ssidChar;
      BluetoothCharacteristic? passChar;

      for (var characteristic in targetService.characteristics) {
        if (characteristic.characteristicUuid == charUuidSsid) {
          ssidChar = characteristic;
        } else if (characteristic.characteristicUuid == charUuidPass) {
          passChar = characteristic;
        }
      }

      if (ssidChar == null || passChar == null) {
        throw Exception('データの書き込み口(Characteristic)が見つかりませんでした。');
      }

      // SSIDを書き込み
      await ssidChar.write(utf8.encode(ssid), withoutResponse: false);

      // パスワードを書き込み
      await passChar.write(utf8.encode(password), withoutResponse: false);
    } finally {
      // 処理が終わったら必ず切断する
      await targetDevice.disconnect();
    }
  }
}
