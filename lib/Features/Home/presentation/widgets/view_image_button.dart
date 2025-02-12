import 'package:doctor_app/Features/Home/domain/Entites/order.dart';
import 'package:doctor_app/Features/Home/presentation/view/image_viewer.dart';
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

  void _startCountdown() async {
    if (widget.order.imageExtention != 4) {
      final fileExtension = _getFileExtension(widget.order.imageExtention!);
      final publicUrl = Supabase.instance.client.storage
          .from('images')
          .getPublicUrl('${widget.order.orderId}.$fileExtension');

      MovingNavigation.navTo(
        context,
        page: ImageViewerPage(
          imageUrl: publicUrl,
        ),
      );
    } else {
      _showCountdown();
    }
  }

  String _getFileExtension(int extensionCode) {
    switch (extensionCode) {
      case 1:
        return 'jpg';
      case 2:
        return 'png';
      case 3:
        return 'jpeg';
      default:
        return 'png';
    }
  }

  void _showCountdown() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "تم نسخ الرابط إلى الحافظة!",
          textDirection: TextDirection.rtl,
        ),
      ),
    );
    setState(() => _isCounting = true);

    while (_countdown > 0) {
      await Future.delayed(Duration(seconds: 1));
      setState(() => _countdown--);
    }

    final publicUrl = Supabase.instance.client.storage
        .from('images')
        .getPublicUrl('${widget.order.orderId}.dcm');

    widget.onCopyToClipboard(publicUrl);
    widget.onLaunchUrl('https://www.imaios.com/en/imaios-dicom-viewer');

    setState(() {
      _isCounting = false;
      _countdown = 3;
    });
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
          onTap: _isCounting ? null : _startCountdown,
          titleColor: Color(0xffE3F2FD),
        ),
      ],
    );
  }
}
