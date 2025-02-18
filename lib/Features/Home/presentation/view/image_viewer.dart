import 'dart:math';

import 'package:doctor_app/Features/Home/presentation/widgets/image_viewr_body.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ImageViewerPage extends StatefulWidget {
  final String imageUrl;

  const ImageViewerPage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImageViewerPageState createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  bool _isDownloading = false;
  double _progress = 0.0;
  Future<void> _downloadImage() async {
    try {
      setState(() {
        _isDownloading = true;
      });

      Dio dio = Dio();
      Random r = Random();

      // الحصول على مسار التخزين الخارجي
      final Directory? externalStorageDir = await getExternalStorageDirectory();

      if (externalStorageDir == null) {
        throw Exception('تعذر الوصول إلى التخزين الخارجي');
      }

      // إنشاء مسار مجلد التنزيلات العام
      final String downloadsPath = '/storage/emulated/0/Download';

      // التأكد من وجود المجلد
      final Directory downloadsDir = Directory(downloadsPath);
      if (!downloadsDir.existsSync()) {
        downloadsDir.createSync(recursive: true);
      }

      // إنشاء الملف في مجلد التنزيلات العام
      final file =
          File('$downloadsPath/downloaded_image${r.nextInt(999999) + 17}.jpg');

      // تنزيل الصورة
      await dio.download(
        widget.imageUrl,
        file.path,
        onReceiveProgress: (received, total) {
          setState(() {
            _progress = (received / total);
          });
        },
      );

      setState(() {
        _isDownloading = false;
        _progress = 0.0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم تنزيل الصورة بنجاح!',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    } catch (error) {
      setState(() {
        _isDownloading = false;
        _progress = 0.0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تنزيل الصورة: $error',
            textDirection: TextDirection.rtl,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'عرض الصورة',
          textDirection: TextDirection.rtl,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: _isDownloading ? null : _downloadImage,
          ),
        ],
      ),
      body: ImageViewrBody(
          widget: widget, isDownloading: _isDownloading, progress: _progress),
    );
  }
}
