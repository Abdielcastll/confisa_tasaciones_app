import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../theme/theme.dart';

class EscanerPage extends StatefulWidget {
  static const routeName = 'escanerPage';
  const EscanerPage({Key? key}) : super(key: key);

  @override
  State<EscanerPage> createState() => _EscanerPageState();
}

class _EscanerPageState extends State<EscanerPage> {
  QRViewController? controller;
  bool pausa = true;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR2');

  // @override
  // void reassemble() {
  //   super.reassemble();
  //   if (Platform.isAndroid) {
  //     controller!.pauseCamera();
  //   }
  //   print('reassemble');
  //   controller!.resumeCamera();
  // }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   print('didChangeDependencies');
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // pausa = false;
  //   // Future.delayed(Duration(milliseconds: 00), () {
  //   // setState(() {
  //   controller!.resumeCamera();
  //   // });
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  _buildQrView(context),
                  Positioned(
                    bottom: 40,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await controller?.toggleFlash();
                              setState(() {});
                            },
                            icon: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (_, AsyncSnapshot<bool?> snapshot) {
                                if (snapshot.data == null) {
                                  return Container();
                                } else {
                                  return snapshot.data!
                                      ? const Icon(
                                          Icons.flash_off_outlined,
                                          color: Colors.white,
                                          size: 30,
                                        )
                                      : const Icon(
                                          Icons.flash_on_sharp,
                                          color: Colors.white,
                                          size: 30,
                                        );
                                }
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = MediaQuery.of(context).size.width * .75;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: AppColors.orange,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) async {
    setState(() {
      this.controller = controller;
    });
    await Future.delayed(const Duration(milliseconds: 250));
    this.controller!.resumeCamera();
    controller.scannedDataStream.listen((scanData) {
      scanData;
      FlutterBeep.beep();
      controller.dispose();
      Navigator.of(context).pop(scanData.code);
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
