import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:async';
import '../core/constants/app_colors.dart';
import '../services/ble_config_service.dart';


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

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((scanning) {
      if (mounted) setState(() => _isScanning = scanning);
    });

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (mounted) {
        setState(() {
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
      setState(() => _connectedDevices = FlutterBluePlus.connectedDevices);
    }
  }

  Future<void> _startScan() async {
    _getConnectedDevices();
    try {
      final adapterState = await FlutterBluePlus.adapterState.first;
      if (adapterState != BluetoothAdapterState.on) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bluetoothをオンにしてください'), backgroundColor: Colors.red),
          );
        }
        return;
      }

      setState(() => _scanResults = []);
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('スキャンに失敗しました: ${e.toString()}'), backgroundColor: Colors.red),
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
          const SnackBar(content: Text('Firebase UIDの送信に成功しました！'), backgroundColor: Colors.green),
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
      if (mounted) setState(() => _isConnecting = false);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: -85,
            top: -215,
            width: 360,
            height: 346.5,
            child: SvgPicture.asset(
              'assets/icons/common/items_bg_decoration.svg',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: _buildHeader(),
                ),
                const SizedBox(height: 51),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 120),
                    children: [
                      if (_connectedDevices.isNotEmpty) ...[
                        ..._connectedDevices.map((device) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: GestureDetector(
                                onTap: () => _connectAndSendUid(device),
                                child: _buildConnectedDeviceCard(device),
                              ),
                            )),
                      ],
                      _buildSectionLabel(_isScanning ? 'スキャン中...' : 'ほかのデバイス'),
                      const SizedBox(height: 11),
                      _buildDeviceListCard(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bluetooth',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.black1000,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  height: 1.20,
                ),
              ),
              Text(
                'Bluetoothデバイスの管理',
                style: GoogleFonts.zenMaruGothic(
                  color: AppColors.black1000,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.20,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _isScanning ? null : _startScan,
          child: Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: _isScanning ? const Color(0xFFB9BFC9) : AppColors.primary700,
              shape: BoxShape.circle,
            ),
            child: _isScanning
                ? const Padding(
                    padding: EdgeInsets.all(8),
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.refresh, size: 20, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.zenMaruGothic(
        color: AppColors.gray500,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 1.20,
      ),
    );
  }

  Widget _buildConnectedDeviceCard(BluetoothDevice device) {
    final deviceName = device.platformName.isNotEmpty ? device.platformName : '不明なデバイス';

    return Container(
      width: double.infinity,
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F35291E),
            offset: Offset(1, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Color(0x40000000), blurRadius: 2.5, spreadRadius: 0),
              ],
            ),
            child: const Icon(Icons.bluetooth, size: 24, color: Color(0xFF508DFF)),
          ),
          const SizedBox(width: 29),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '接続済み',
                  style: GoogleFonts.zenMaruGothic(
                    color: const Color(0xFF22C55E),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.20,
                  ),
                ),
                Text(
                  deviceName,
                  style: GoogleFonts.zenMaruGothic(
                    color: Colors.black,
                    fontSize: 20,
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

  Widget _buildDeviceListCard() {
    final otherDevices = _scanResults
        .where((r) => !_connectedDevices.any((c) => c.remoteId == r.device.remoteId))
        .toList();

    if (otherDevices.isEmpty) {
      return Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F35291E),
              offset: Offset(1, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Center(
          child: Text(
            _isScanning ? 'デバイスを検索しています...' : 'デバイスが見つかりませんでした',
            style: GoogleFonts.zenMaruGothic(
              color: AppColors.gray500,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F35291E),
            offset: Offset(1, 2),
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < otherDevices.length; i++) ...[
            if (i > 0) _buildDivider(),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _connectToDevice(otherDevices[i]),
              child: SizedBox(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        otherDevices[i].device.platformName.isNotEmpty
                            ? otherDevices[i].device.platformName
                            : '不明なデバイス',
                        style: GoogleFonts.zenMaruGothic(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          height: 1.20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        height: 1,
        color: const Color(0xFFE5E7EB),
      ),
    );
  }
}
