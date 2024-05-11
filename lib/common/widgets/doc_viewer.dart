import 'package:flutter/material.dart';

import '../../core/colors.dart';

class DocViewer extends StatefulWidget {
  final String path;
  const DocViewer({super.key, required this.path});

  @override
  State<DocViewer> createState() => _DocViewerState();
}

class _DocViewerState extends State<DocViewer> {
  @override
  void initState() {
    getPdfBytes();
    super.initState();
  }

  void getPdfBytes() async {
    Uri.base.resolve(widget.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const Center(
        child: CircularProgressIndicator(
      color: babbleTitleColor,
    ));
    return Scaffold(
      backgroundColor: bodyBackgroundColor,
      appBar: AppBar(title: const Text('PDF Viewer')),
      body: child,
    );
  }
}
