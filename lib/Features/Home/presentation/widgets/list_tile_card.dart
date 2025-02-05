import 'package:auto_size_text/auto_size_text.dart';
import 'package:doctor_app/Features/Auth/domain/Entities/doctor.dart';
import 'package:doctor_app/Features/Home/domain/Entites/order.dart';
import 'package:doctor_app/Features/Home/domain/Entites/patient.dart';
import 'package:doctor_app/Features/Home/presentation/view/order_view_detiles.dart';
import 'package:doctor_app/core/utils/constant.dart';
import 'package:doctor_app/core/utils/navigator/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ListTileCard extends StatelessWidget {
  const ListTileCard({
    super.key,
    required this.papatientName,
    required this.type,
    required this.date,
    required this.order,
    required this.doctor,
    required this.patient,
  });

  final String date;
  final String papatientName;
  final String type;
  final Doctor doctor;
  final Order order;
  final Patient patient;

  @override
  Widget build(BuildContext context) {
    String imagePath = "";
    switch (type) {
      case "C.B.C.T":
        imagePath = ImagesPath.cbctIcon;
        break;
      case "سيفالوماتريك":
        imagePath = ImagesPath.cefaloIcon;
        break;
      case "بانوراما":
        imagePath = ImagesPath.panoramaIcon;
        break;
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        child: GestureDetector(
          onTap: () {
            MovingNavigation.navTo(context,
                page: OrderDetails(
                  order: order,
                  doctor: doctor,
                  patient: patient,
                ));
          },
          child: SizedBox(
            height: 80.h,
            child: Card(
              color: Colors.black12,
              margin: EdgeInsets.symmetric(horizontal: 16.w),
              elevation: 3.0, // إضافة ظل خفيف للـ Card
              child: ListTile(
                trailing: Padding(
                  padding: EdgeInsets.only(bottom: 15.h),
                  child: SvgPicture.asset(ImagesPath.arrowListTile),
                ),
                leading: Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: SvgPicture.asset(imagePath),
                ),
                title: TitleListTile(
                  patientName: papatientName,
                  type: type,
                  date: date,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TitleListTile extends StatelessWidget {
  const TitleListTile({
    Key? key,
    required this.patientName,
    required this.type,
    required this.date,
  }) : super(key: key);

  final String patientName;
  final String type;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          patientName,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          minFontSize: 8.sp,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        AutoSizeText(
          type,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          minFontSize: 8.sp,
          overflow: TextOverflow.ellipsis,
        ),
        AutoSizeText(
          date,
          style: TextStyle(
            fontSize: 9.sp,
            color: Color(AppColor.primaryColor),
          ),
          maxLines: 1,
          minFontSize: 8.sp,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
