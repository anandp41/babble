import 'dart:io';
import 'package:babble/core/colors.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DocViewer extends StatefulWidget {
  final String path;
  const DocViewer({super.key, required this.path});

  @override
  State<DocViewer> createState() => _DocViewerState();
}

class _DocViewerState extends State<DocViewer> {
  Uint8List? _documentBytes;

  @override
  void initState() {
    getPdfBytes();
    super.initState();
  }

  void getPdfBytes() async {
    HttpClient client = HttpClient();
    final Uri url = Uri.base.resolve(widget.path);
    final HttpClientRequest request = await client.getUrl(url);
    final HttpClientResponse response = await request.close();
    _documentBytes = await consolidateHttpClientResponseBytes(response);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(
        child: CircularProgressIndicator(
      color: babbleTitleColor,
    ));
    if (_documentBytes != null) {
      child = SfPdfViewer.memory(
        _documentBytes!,
      );
    }
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: child,
    );
  }
}
