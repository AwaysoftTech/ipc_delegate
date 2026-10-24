import 'package:ipc_delegates/core/utils/local_strings.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';
import 'package:ipc_delegates/view/components/app-bar/custom_appbar.dart';
import 'package:ipc_delegates/view/components/custom_loader/custom_loader.dart';
import 'package:ipc_delegates/core/utils/color_resources.dart';
import 'package:ipc_delegates/core/route/route.dart';
import 'package:ipc_delegates/core/utils/dimensions.dart';
import 'package:ipc_delegates/core/utils/images.dart';

import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrScreen extends StatefulWidget
{
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen>
{
  MobileScannerController controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates, // Prevents multiple detections of the same code
    formats: const [BarcodeFormat.qrCode], // Only scan QR codes
  );
  String? scannedCode;

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: LocalStrings.scanQr.tr,
        bgColor: Theme.of(context).appBarTheme.backgroundColor!,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: ColorResources.primaryColor,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorResources.primaryColor.withValues(alpha: 0.5),
                      blurRadius: 10,
                      spreadRadius: 6,
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: MobileScanner(
                    controller: controller,
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      for (final barcode in barcodes)
                      {
                        debugPrint('Barcode found! ${barcode.rawValue}');
                        // Handle the scanned QR code data here
                        // For example, navigate to a new screen or display a dialog
                        if (barcode.rawValue != null) {
                          Navigator.of(context).pop(barcode.rawValue); // Return the scanned value
                        }
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    controller.toggleTorch();
                  },
                  icon: const Icon(Icons.flash_on),
                  label: const Text('Torch'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      scannedCode = null;
                    });
                  },
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space40),
        ],
      ),
    );
  }
}
