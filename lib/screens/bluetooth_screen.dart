import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import '../core/constants/app_colors.dart';
import '../services/ble_config_service.dart';

/// Bluetooth設定画面（付近のBLEデバイスをスキャン表示）
class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final _bleService = BleConfigService();
  bool _isConnecting = false;

  List<ScanResult> _scanResults = [];
  List<BluetoothDevice> _connectedDevices = [];
  bool _isScanning = false;
  StreamSubscription<List<ScanResult>>? _scanSubscription;
  StreamSubscription<bool>? _isScanningSubscription;

  @override
  void initState() {
    super.initState();
    _getConnectedDevices();

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

  void _getConnectedDevices() {
    if (mounted) {
      setState(() {
        _connectedDevices = FlutterBluePlus.connectedDevices;
      });
    }
  }

  Future<void> _startScan() async {
    _getConnectedDevices();
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

  Future<void> _connectAndSendUid(BluetoothDevice device) async {
    if (_isConnecting) return;

    setState(() => _isConnecting = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('デバイスに接続してUIDを送信しています...')),
    );

    try {
      await _bleService.sendUid(device);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Firebase UIDの送信に成功しました！'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('エラー: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isConnecting = false);
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
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildScanStatus(),
          const SizedBox(height: 8),
          _buildDeviceList(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.only(top: 48),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 2, color: Colors.black)),
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
              child: const Icon(Icons.arrow_back_ios_new, size: 16, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Bluetooth',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.primary700,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              height: 0.90,
            ),
          ),
          const Spacer(),
          _buildScanButton(),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: _isScanning ? null : _startScan,
      child: Container(
        width: 35,
        height: 35,
        decoration: ShapeDecoration(
          color: _isScanning ? const Color(0xFFB9BFC9) : AppColors.primary700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
          ),
        ),
        child: _isScanning
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : const Icon(Icons.refresh, size: 20, color: Colors.white),
      ),
    );
  }

  Widget _buildScanStatus() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [
          Text(
            _isScanning ? 'スキャン中...' : '付近のデバイス',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.gray500,
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
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gray500),
            ),
          ],
          const Spacer(),
          Text(
            '${_scanResults.length} 件',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.gray500,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceList() {
    if (_scanResults.isEmpty) return _buildEmptyState();

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 8),
        children: [
          if (_connectedDevices.isNotEmpty) ...[
            ..._connectedDevices
                .map((device) => GestureDetector(
                      onTap: () => _connectAndSendUid(device),
                      child: _buildConnectedDeviceCard(device),
                    ))
                ,
            const SizedBox(height: 16),
            Text(
              'ほかのデバイス',
              style: GoogleFonts.zenMaruGothic(
                color: AppColors.gray500,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
            ),
            const SizedBox(height: 8),
          ],
          ..._scanResults
              .where((r) => !_connectedDevices.any((c) => c.remoteId == r.device.remoteId))
              .map((r) => GestureDetector(
                    onTap: () => _connectAndSendUid(r.device),
                    child: _buildDeviceCard(r),
                  ))
              ,
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bluetooth_searching, size: 64, color: Color(0xFFB9BFC9)),
            const SizedBox(height: 16),
            Text(
              _isScanning ? 'デバイスを検索しています...' : 'デバイスが見つかりませんでした',
              style: GoogleFonts.zenMaruGothic(
                color: AppColors.gray500,
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
                    color: AppColors.primary700,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // デバイスカード（未接続）
  // ============================================================
  Future<void> _connectToDevice(ScanResult result) async {
    final deviceName = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : '不明なデバイス';

    if (_isScanning) FlutterBluePlus.stopScan();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$deviceName に接続中...'), duration: const Duration(seconds: 2)),
    );

    try {
      await result.device.connect(timeout: const Duration(seconds: 5));
      _getConnectedDevices();
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$deviceName に接続しました！'), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('接続に失敗しました。M5Stackを再起動してもう一度お試しください。'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildDeviceCard(ScanResult result) {
    final deviceName = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : '不明なデバイス';
    final deviceId = result.device.remoteId.str;
    final rssi = result.rssi;

    Color signalColor;
    if (rssi > -60) {
      signalColor = AppColors.success;
    } else if (rssi > -80) {
      signalColor = AppColors.primary700;
    } else {
      signalColor = AppColors.error;
    }

    return GestureDetector(
      onTap: () => _connectToDevice(result),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(8),
          ),
          shadows: const [
            BoxShadow(color: Color(0xFF000000), blurRadius: 0, offset: Offset(3, 4.50), spreadRadius: 0),
          ],
        ),
        child: _buildDeviceCardContent(deviceName, deviceId, rssi, signalColor),
      ),
    );
  }

  Widget _buildDeviceCardContent(String deviceName, String deviceId, int rssi, Color signalColor) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF26A5FF).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.bluetooth, size: 24, color: Color(0xFF26A5FF)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                deviceName,
                style: GoogleFonts.zenMaruGothic(
                  color: Colors.black, fontSize: 16, fontWeight: FontWeight.w900, height: 1.20,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                deviceId,
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.gray500, fontSize: 12, fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Column(
          children: [
            Icon(Icons.signal_cellular_alt, size: 20, color: signalColor),
            Text(
              '${rssi}dBm',
              style: GoogleFonts.zenMaruGothic(
                color: AppColors.gray500, fontSize: 10, fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // デバイスカード（接続済み）
  // ============================================================
  Widget _buildConnectedDeviceCard(BluetoothDevice device) {
    final deviceName =
        device.platformName.isNotEmpty ? device.platformName : '不明なデバイス';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0xFFA7F3D0), // 薄い緑色
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 0,
            offset: Offset(3, 4.50),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: ShapeDecoration(
              color: const Color(0xFF10B981), // 濃い緑
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 0,
                  offset: Offset(2, 2.5),
                  spreadRadius: 0,
                )
              ],
            ),
            child: const Icon(
              Icons.bluetooth,
              size: 24,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '接続済み',
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF059669),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  deviceName,
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.20,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}