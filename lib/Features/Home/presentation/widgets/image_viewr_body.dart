import 'package:doctor_app/Features/Home/presentation/view/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageViewrBody extends StatelessWidget {
  const ImageViewrBody({
    super.key,
    required this.widget,
    required bool isDownloading,
    required double progress,
  })  : _isDownloading = isDownloading,
        _progress = progress;

  final ImageViewerPage widget;
  final bool _isDownloading;
  final double _progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: Image.network(widget.imageUrl),
          ),
        ),
        if (_isDownloading)
          Positioned(
            bottom: 20.h,
            left: MediaQuery.of(context).size.width / 2 - 50.w,
            child: Column(
              children: [
                CircularProgressIndicator(value: _progress),
                SizedBox(height: 8.h),
                Text(
                  'جاري التنزيل...',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
