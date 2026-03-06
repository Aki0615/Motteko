import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

/// M5StackへのWi-Fi設定用BLE通信サービス
class BleConfigService {
  // ⚠️ 注意: 以下の名前とUUIDは、M5Stackの "secrets.h" の中身と完全に一致している必要があります！
  static const String deviceName = "Motteko-Setup"; 
  static const String serviceUuidStr = "12345678-1234-5678-1234-56789abcdef0";
  static const String charUuidSsidStr = "12345678-1234-5678-1234-56789abcdef1";
  static const String charUuidPassStr = "12345678-1234-5678-1234-56789abcdef2";

  final Guid serviceUuid = Guid(serviceUuidStr);
  final Guid charUuidSsid = Guid(charUuidSsidStr);
  final Guid charUuidPass = Guid(charUuidPassStr);

  Future<void> sendWifiInfo(String ssid, String password) async {
    BluetoothDevice? targetDevice;

    // 前の画面で「すでに接続済み」のデバイスの中にいるかチェック
    for (var device in FlutterBluePlus.connectedDevices) {
      if (device.platformName == deviceName || device.advName == deviceName) {
        targetDevice = device;
        break;
      }
    }

    // 接続済みの中にいなければ、スキャンして探す
    if (targetDevice == null) {
      if (FlutterBluePlus.isScanningNow) {
        await FlutterBluePlus.stopScan();
      }

      final subscription = FlutterBluePlus.scanResults.listen((results) {
        for (var r in results) {
          if (r.device.platformName == deviceName || r.device.advName == deviceName) {
            targetDevice = r.device;
            FlutterBluePlus.stopScan(); // 見つかったらスキャンを強制終了
            break;
          }
        }
      });

      // 5秒間だけスキャンを実行（無限ループのフリーズを防止）
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
      await FlutterBluePlus.isScanning.where((val) => val == false).first;
      subscription.cancel();
    }

    // それでも見つからなければエラー
    if (targetDevice == null) {
      throw Exception('デバイス($deviceName)が見つかりませんでした。本体がBluetoothモードになっているか確認してください。');
    }

    try {
      // 「!」をつけてNullエラーを回避しつつ接続
      await targetDevice!.connect(timeout: const Duration(seconds: 5));

      // サービス（データの箱のまとまり）を検索
      List<BluetoothService> services = await targetDevice!.discoverServices();
      BluetoothService? targetService;

      for (var service in services) {
        if (service.serviceUuid == serviceUuid) {
          targetService = service;
          break;
        }
      }

      if (targetService == null) {
        throw Exception('BLEサービスが見つかりませんでした。アプリとM5StackのUUIDが一致しているか確認してください。');
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
        throw Exception('書き込み先のCharacteristicが見つかりませんでした。');
      }

      // 1. SSIDを送信
      await ssidChar.write(utf8.encode(ssid), withoutResponse: false);
      
      // 取りこぼし防止の0.5秒待機（ここが超重要！）
      await Future.delayed(const Duration(milliseconds: 500));
      
      // 2. パスワードを送信
      await passChar.write(utf8.encode(password), withoutResponse: false);

    } finally {
      // 処理が終わったら必ず切断する（安全のため ? を使用）
      await targetDevice?.disconnect();
    }
  }
}