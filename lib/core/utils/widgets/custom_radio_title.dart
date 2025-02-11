import 'package:doctor_app/core/utils/constant.dart';
import 'package:flutter/material.dart';

class CustomRadioTile extends StatelessWidget {
  final String title;
  final String value;
  final String? groupValue;
  final ValueChanged<String?>? onChanged;

  const CustomRadioTile({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile<String>(
      fillColor: const WidgetStatePropertyAll(Color(AppColor.primaryColor)),
      title: Text(title),
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
    );
  }
}
