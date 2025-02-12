import 'package:doctor_app/Features/Home/domain/Entites/order.dart';
import 'package:doctor_app/Features/Home/domain/Entites/patient.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/table_item.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/view_image_button.dart';
import 'package:doctor_app/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailTable extends StatelessWidget {
  final OrderDetailTableData data;
  final Function(String) onCopyToClipboard;
  final Function(String) onLaunchUrl;

  const OrderDetailTable({
    Key? key,
    required this.data,
    required this.onCopyToClipboard,
    required this.onLaunchUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTableItems(),
              SizedBox(height: 40.h),
              if (data.order.isImaged &&
                  data.order.imageExtention != 0 &&
                  data.order.detail.type.typeName != "C.B.C.T")
                ViewImageButton(
                  order: data.order,
                  onCopyToClipboard: onCopyToClipboard,
                  onLaunchUrl: onLaunchUrl,
                ),
              if (data.order.imageExtention == 0)
                Text("تم تسليم المريض الصورة"),
              SizedBox(height: 40.h),
              ShowOrderState(order: data.order),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableItems() {
    final items = <Widget>[];

    void addTableItem(String title, String value,
        {double topRadius = 0, double bottomRadius = 0}) {
      items.add(
        TableItem(
          title: title,
          value: value,
          topradius: topRadius,
          buttomradius: bottomRadius,
        ),
      );
    }

    if (data.patientName != "لا يوجد") {
      addTableItem('اسم المريض', data.patientName, topRadius: 12.r);
    }
    if (data.patientAge != "لا يوجد") {
      addTableItem('العمر', data.patientAge);
    }
    if (data.patient.phoneNumber != null &&
        data.patient.phoneNumber != "لا يوجد") {
      addTableItem('رقم هاتف المريض', data.patient.phoneNumber!);
    }
    if (data.doctorName != "لا يوجد") {
      addTableItem('اسم الطبيب', data.doctorName);
    }
    if (data.order.detail.type.typeName != "لا يوجد") {
      addTableItem('نوع الصورة', data.order.detail.type.typeName);
    }
    if (data.order.detail.option.optionName != "لا يوجد") {
      addTableItem('الجزء المراد تصويره', data.order.detail.option.optionName);
    }
    if (data.order.detail.type.typeName != "C.B.C.T") {
      addTableItem('شكل الصورة', data.order.output.outputType);
    }
    if (data.order.detail.option.optionName == "ساحة 5*5 مميزة للبية") {
      addTableItem('رقم السن', data.order.toothNumber.toString());
    }
    if (data.selectedImageType != 'بانوراما' &&
        data.order.detail.mode?.modeName != null &&
        data.order.detail.mode!.modeName != "لا يوجد") {
      addTableItem('وضعية الصورة', data.order.detail.mode!.modeName);
    }
    if (data.date != "لا يوجد") {
      addTableItem('التاريخ', data.date);
    }
    if (data.time != "لا يوجد") {
      addTableItem('التوقيت', data.time);
    }
    if (data.price != 0) {
      addTableItem('الفاتورة', "${data.price} ل.س");
    }
    if (data.additionalNotes != "لا يوجد") {
      addTableItem('ملاحظات', data.additionalNotes, bottomRadius: 12.r);
    }

    items.add(SizedBox(height: 40.h));

    return Column(children: items);
  }
}

class ShowOrderState extends StatelessWidget {
  final Order order;

  const ShowOrderState({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = order.isImaged;
    final backgroundColor =
        isCompleted ? Color(0xffE3F2FD) : Colors.amber.shade100;
    final icon = isCompleted ? Icons.check_circle : Icons.access_time_filled;
    final iconColor = isCompleted ? Color(AppColor.primaryColor) : Colors.amber;
    final text = isCompleted
        ? 'تم إتمام عملية التصوير بنجاح.'
        : 'بانتظار وصول المريض لاستكمال إجراءات الطلب.';
    final textColor =
        isCompleted ? Color(AppColor.primaryColor) : Colors.amber.shade800;

    return Center(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.1,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 24.w),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailTableData {
  final String patientName;
  final String patientAge;
  final String doctorName;
  final String? selectedImageType;
  final Patient patient;
  final String date;
  final String time;
  final String additionalNotes;
  final int price;
  final Order order;

  OrderDetailTableData({
    required this.patient,
    required this.patientName,
    required this.patientAge,
    required this.doctorName,
    required this.selectedImageType,
    required this.date,
    required this.time,
    required this.additionalNotes,
    required this.price,
    required this.order,
  });
}
