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

      final dir = await getApplicationDocumentsDirectory();
      final file =
          File('${dir.path}/downloaded_image${r.nextInt(999999) + 17}.jpg');

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
            'حدث خطأ أثناء تنزيل الصورة.',
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
