import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logger/logger.dart';

import 'package:printing/printing.dart';
import 'package:tasaciones_app/core/models/reporte_response.dart';

class AppPdfViewer extends StatefulWidget {
  final Reporte? reporte;
  const AppPdfViewer(this.reporte, {Key? key}) : super(key: key);

  @override
  State<AppPdfViewer> createState() => _AppPdfViewerState();
}

class _AppPdfViewerState extends State<AppPdfViewer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Reporte')),
      body: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: (format) {
                return Future.value(
                    base64Decode(widget.reporte?.byteArrayImg ?? ''));
              },
              useActions: true,
              loadingWidget: const CircularProgressIndicator(),
              pdfFileName: widget.reporte?.reporteNombre ?? '',
              canDebug: false,
              padding: const EdgeInsets.only(top: 20),
              onError: (_, error) {
                final logger = Logger();
                logger.e(error);
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/img/advertencia.svg',
                      height: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Error',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                );
              },
              // shouldRepaint: true,

              // allowPrinting: true,
              allowSharing: false,
              canChangePageFormat: false,
              // actions: [
              //   IconButton(
              //       onPressed: () {}, icon: Icon(Icons.file_download_outlined))
              // ],
            ),
          ),
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(top: 10),
      //   child: FloatingActionButton.small(
      //     heroTag: '1',
      //     onPressed: () {
      //       // printer();
      //     },
      //     child: const Icon(Icons.print, color: Colors.white),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }
}
