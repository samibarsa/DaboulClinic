import 'dart:io';
import 'package:doctor_app/Features/Home/domain/Entites/order.dart';
import 'package:doctor_app/core/utils/constant.dart';
import 'package:doctor_app/core/utils/function/function.dart';
import 'package:doctor_app/core/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewImageButton extends StatefulWidget {
  final Order order;
  final Function(String) onCopyToClipboard;

  const ViewImageButton({
    Key? key,
    required this.order,
    required this.onCopyToClipboard,
  }) : super(key: key);

  @override
  _ViewImageButtonState createState() => _ViewImageButtonState();
}

class _ViewImageButtonState extends State<ViewImageButton> {
  double _progress = 0.0;
  bool fileDownloded = false;
  String? filePath; // تخزين المسار النهائي للملف

  @override
  void initState() {
    super.initState();
    checkIfFileExists();
  }

  Future<void> checkIfFileExists() async {
    final directory = await getDownloadsDirectory();
    if (directory == null) return;

    var thisImage =
        "${widget.order.orderId}.${getImageExtension(widget.order.imageExtention!)}";
    final file = File("${directory.path}/$thisImage");

    if (file.existsSync()) {
      setState(() {
        fileDownloded = true;
        filePath = file.path;
      });
    }
  }

  Future<Directory?> getDownloadsDirectory() async {
    Directory? directory = await getExternalStorageDirectory();
    if (directory != null) {
      final downloadsPath = "/storage/emulated/0/Download";
      return Directory(downloadsPath);
    }
    return null;
  }

  Future<String?> getSignedUrl(String path) async {
    try {
      final response = await Supabase.instance.client.storage
          .from('images')
          .createSignedUrl(path, 30);
      return response;
    } catch (e) {
      debugPrint('Error creating signed URL: $e');
      return null;
    }
  }

  Future<String?> _downloadAndSaveImage(String url, String fileName) async {
    try {
      // طلب إذن الكتابة على وحدة التخزين
      if (await Permission.storage.request().isDenied) {
        debugPrint("تم رفض الإذن! يرجى تفعيله من الإعدادات.");
        return null;
      }

      final response =
          await http.Client().send(http.Request('GET', Uri.parse(url)));

      if (response.statusCode == 200) {
        final total = response.contentLength ?? 1;
        int received = 0;

        final directory = await getDownloadsDirectory();
        if (directory == null) {
          debugPrint("تعذر الوصول إلى مجلد التنزيلات.");
          return null;
        }

        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        final sink = file.openWrite();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => _buildProgressDialog(),
        );

        await for (var chunk in response.stream) {
          received += chunk.length;
          sink.add(chunk);
          setState(() => _progress = received / total);
        }

        await sink.close();
        Navigator.of(context).pop(); // إغلاق الـ Dialog عند الانتهاء

        setState(() {
          fileDownloded = true;
          this.filePath = filePath;
        });

        return filePath;
      }
    } catch (e) {
      debugPrint('Error downloading image: $e');
    }

    Navigator.of(context).pop(); // إغلاق الـ Dialog عند حدوث خطأ
    return null;
  }

  Widget _buildProgressDialog() {
    return AlertDialog(
      title: Text("تحميل الصورة"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(value: _progress),
          SizedBox(height: 10),
          Text("${(_progress * 100).toStringAsFixed(0)}%"),
        ],
      ),
    );
  }

  void _startDownload() async {
    final filePath =
        '${widget.order.orderId}.${getImageExtension(widget.order.imageExtention!)}';
    final signedUrl = await getSignedUrl(filePath);

    if (signedUrl != null) {
      final localPath = await _downloadAndSaveImage(signedUrl, filePath);
      if (localPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("تم حفظ الصورة في: $localPath")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("فشل في تحميل الصورة.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في توليد رابط الصورة.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!fileDownloded)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(AppColor.primaryColor)),
            ),
            child: CustomButton(
              title: "تحميل الصورة",
              color: 0xff,
              onTap: _startDownload,
              titleColor: Color(0xffE3F2FD),
            ),
          ),
        SizedBox(height: 12.h),
        if (fileDownloded)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color(AppColor.primaryColor),
              border: Border.all(color: Colors.red),
            ),
            child: CustomButton(
              title: "عرض الصورة",
              color: 0xff,
              onTap: () async {
                if (filePath != null) {
                  OpenFile.open(filePath);
                }
              },
              titleColor: Color(0xffE3F2FD),
            ),
          ),
      ],
    );
  }
}
