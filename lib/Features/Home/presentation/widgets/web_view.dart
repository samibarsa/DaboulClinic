import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class DicomViewerScreen extends StatefulWidget {
  @override
  State<DicomViewerScreen> createState() => _DicomViewerScreenState();
}

class _DicomViewerScreenState extends State<DicomViewerScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    // إعداد منصة WebView حسب النظام
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams();
    } else {
      params = AndroidWebViewControllerCreationParams();
    }

    // إنشاء عنصر التحكم في WebView
    controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse('https://www.imaios.com/en/imaios-dicom-viewer'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('DICOM Viewer')),
      body: WebViewWidget(controller: controller),
    );
  }
}
