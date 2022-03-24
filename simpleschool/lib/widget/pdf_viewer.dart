import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import 'package:firebase_core_web/firebase_core_web_interop.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import 'package:simpleschool/model/event.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:syncfusion_flutter_pdfviewer_web/pdfviewer_web.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

import 'package:pdfx/pdfx.dart';

class PdfViewerWidget extends StatefulWidget {
  final Event event;
  const PdfViewerWidget({Key? key, required this.event}) : super(key: key);

  @override
  _PdfViewerWidgetState createState() => _PdfViewerWidgetState(event);
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  final Event event;
  String path = '';
  Uint8List? _documentBytes;
  PdfController? pdfController;

  //final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  _PdfViewerWidgetState(this.event);

  @override
  void initState() {
    getPdfBytes();
    super.initState();
  }

  void getPdfBytes() async {
    path = await event.getFileURL(0);
    _documentBytes = await http.readBytes(Uri.parse(path));

    // pdfController =
    //     PdfController(document: PdfDocument.openData(_documentBytes!));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(path);
    //print(_documentBytes);

    final pdfController = PdfController(
      document: PdfDocument.openData(_documentBytes!),
    );

    print(pdfController.document);
    // Pdf view with re-render pdf texture on zoom (not loose quality on zoom)
// Not supported on windows
    var tmp = PdfView(
      controller: pdfController,
    );

    return Container(color: Colors.blue);

    // return Container(
    //     height: MediaQuery.of(context).size.height * 0.7,
    //     width: MediaQuery.of(context).size.width * 0.7,
    //     child: _documentBytes != null
    //         ? PdfView(
    //             controller: pdfController!,
    //             pageLoader: const CircularProgressIndicator(),
    //           )
    //       : Container());
    //_documentBytes != null ? PdfView(controller: pdfController,) : Container());
  }
}
