import 'package:doctor_app/Features/Home/domain/Entites/order.dart';
import 'package:doctor_app/Features/Home/presentation/view/image_viewer.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/web_view.dart';
import 'package:doctor_app/core/utils/navigator/navigator.dart';
import 'package:doctor_app/core/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewImageButton extends StatefulWidget {
  final Order order;
  final Function(String) onCopyToClipboard;
  final Function(String) onLaunchUrl;

  const ViewImageButton({
    Key? key,
    required this.order,
    required this.onCopyToClipboard,
    required this.onLaunchUrl,
  }) : super(key: key);

  @override
  _ViewImageButtonState createState() => _ViewImageButtonState();
}

class _ViewImageButtonState extends State<ViewImageButton> {
  int _countdown = 3;
  bool _isCounting = false;

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

  void _startCountdown() async {
    if (widget.order.imageExtention == 4) {
      _showCountdown();
    } else {
      final fileExtension = _getFileExtension(widget.order.imageExtention!);
      final filePath = '${widget.order.orderId}.$fileExtension';
      final signedUrl = await getSignedUrl(filePath);

      if (signedUrl != null) {
        MovingNavigation.navTo(
          context,
          page: ImageViewerPage(imageUrl: signedUrl),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في إنشاء رابط موقّع')),
        );
      }
    }
  }

  void _showCountdown() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم نسخ الرابط إلى الحافظة!")),
    );

    setState(() => _isCounting = true);

    while (_countdown > 0) {
      await Future.delayed(Duration(seconds: 1));
      setState(() => _countdown--);
    }

    final signedUrl = await getSignedUrl('${widget.order.orderId}.dcm');
    if (signedUrl != null) {
      widget.onCopyToClipboard(signedUrl);
      widget.onLaunchUrl('https://www.imaios.com/en/imaios-dicom-viewer');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("فشل في توليد رابط الصورة.")),
      );
    }

    setState(() {
      _isCounting = false;
      _countdown = 3;
    });
  }

  String _getFileExtension(int extensionCode) {
    return {1: 'jpg', 2: 'png', 3: 'jpeg'}[extensionCode] ?? 'png';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isCounting && widget.order.imageExtention == 4)
          Text(
            'سيتم الانتقال خلال: $_countdown ثوانٍ',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        CustomButton(
          title: "عرض الصورة",
          color: 0xff,
          onTap: () {
            MovingNavigation.navTo(context, page: DicomViewerScreen());
          },
          titleColor: Color(0xffE3F2FD),
        ),
      ],
    );
  }
}
