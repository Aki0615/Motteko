import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';

/// Bluetooth設定画面（付近のBLEデバイスをスキャン表示）
class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<bool>? _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    // スキャン状態の監視
    _isScanningSubscription = FlutterBluePlus.isScanning.listen((scanning) {
      if (mounted) {
        setState(() => _isScanning = scanning);
      }
    });

    // スキャン結果の監視
    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
          // デバイス名があるものを優先表示し、名前順にソート
          _scanResults = results
            ..sort((a, b) {
              final aName = a.device.platformName;
              final bName = b.device.platformName;
              if (aName.isNotEmpty && bName.isEmpty) return -1;
              if (aName.isEmpty && bName.isNotEmpty) return 1;
              return aName.compareTo(bName);
            });
        });
      }
    });

    // 自動的にスキャン開始
    _startScan();
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _isScanningSubscription?.cancel();
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<void> _startScan() async {
    try {
      // Bluetoothがオンか確認
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Bluetoothをオンにしてください'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() => _scanResults = []);
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('スキャンに失敗しました: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // ヘッダー
          // ============================================================
          Container(
            width: double.infinity,
            height: 60,
            margin: const EdgeInsets.only(top: 48),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 2, color: Colors.black),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.go('/settings'),
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFB9BFC9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Bluetooth',
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFFFF7B00),
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    height: 0.90,
                  ),
                ),
                const Spacer(),
                // スキャンボタン
                GestureDetector(
                  onTap: _isScanning ? null : _startScan,
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: ShapeDecoration(
                      color: _isScanning
                          ? const Color(0xFFB9BFC9)
                          : const Color(0xFFFF7B00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                    ),
                    child: _isScanning
                        ? const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.refresh,
                            size: 20,
                            color: Colors.white,
                          ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ============================================================
          // スキャン状態の表示
          // ============================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              children: [
                Text(
                  _isScanning ? 'スキャン中...' : '付近のデバイス',
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
                if (_isScanning) ...[
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  '${_scanResults.length} 件',
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF6B7280),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ============================================================
          // デバイスリスト
          // ============================================================
          Expanded(
            child: _scanResults.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth_searching,
                          size: 64,
                          color: const Color(0xFFB9BFC9),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isScanning ? 'デバイスを検索しています...' : 'デバイスが見つかりませんでした',
                          style: GoogleFonts.zenMaruGothic(
                            color: const Color(0xFF6B7280),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (!_isScanning) ...[
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _startScan,
                            child: Text(
                              'もう一度スキャン',
                              style: GoogleFonts.zenMaruGothic(
                                color: const Color(0xFFFF7B00),
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    itemCount: _scanResults.length,
                    itemBuilder: (context, index) {
                      final result = _scanResults[index];
                      return _buildDeviceCard(result);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceCard(ScanResult result) {
    final deviceName = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : '不明なデバイス';
    final deviceId = result.device.remoteId.str;
    final rssi = result.rssi;

    // RSSI値からアイコンの色を設定
    Color signalColor;
    if (rssi > -60) {
      signalColor = const Color(0xFF22C55E); // 強い
    } else if (rssi > -80) {
      signalColor = const Color(0xFFFF7B00); // 中程度
    } else {
      signalColor = const Color(0xFFEF4444); // 弱い
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1.5, color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // Bluetoothアイコン
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF26A5FF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.bluetooth,
              size: 24,
              color: Color(0xFF26A5FF),
            ),
          ),
          const SizedBox(width: 12),
          // デバイス情報
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  deviceId,
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // 電波強度インジケーター
          Column(
            children: [
              Icon(
                Icons.signal_cellular_alt,
                size: 20,
                color: signalColor,
              ),
              Text(
                '${rssi}dBm',
                style: GoogleFonts.zenMaruGothic(
                  color: const Color(0xFF6B7280),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
