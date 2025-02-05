// ignore_for_file: deprecated_member_use

import 'package:doctor_app/Features/Home/presentation/widgets/build_doctor_info.dart';
import 'package:doctor_app/core/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

buildAppBar(
  BuildContext context,
  void Function()? onPressed,
) {
  return AppBar(
    forceMaterialTransparency: true,
    title: Row(
      children: [
        Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                ImagesPath.filter,
                fit: BoxFit.none,
              ),
              onPressed: onPressed,
            ),
            IconButton(
                onPressed: () {
                  showDeveloperInfoBottomSheet(context);
                },
                icon: Icon(Icons.info)),
          ],
        ),
        Spacer(),
        Directionality(
          textDirection: TextDirection.rtl,
          child: buildDoctorInfo(
            context,
          ),
        ),
      ],
    ),
  );
}

void showDeveloperInfoBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    isScrollControlled: true, // السماح بالتمديد والتحكم بالتمرير
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        expand: false, // السماح بالتمديد الكامل
        builder: (context, scrollController) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: EdgeInsets.all(16.0.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    'معلومات المطورين',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ListTile(
                    leading:
                        Icon(Icons.person, color: Color(AppColor.primaryColor)),
                    title: Text(
                      'محمد سامي برصه',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    subtitle: Text('مطور التطبيق'),
                  ),
                  ListTile(
                    leading:
                        Icon(Icons.person, color: Color(AppColor.primaryColor)),
                    title: Text(
                      'أحمد السكني',
                      style: TextStyle(fontSize: 18.sp),
                    ),
                    subtitle: Text('مطور التطبيق'),
                  ),
                  SizedBox(height: 8.h),
                  ListTile(
                    leading: Icon(FontAwesomeIcons.whatsapp,
                        color: Color(AppColor.primaryColor)),
                    title: GestureDetector(
                      onTap: () async {
                        const whatsappUrl = 'https://wa.me/+963959026001';
                        if (await canLaunch(whatsappUrl)) {
                          await launch(whatsappUrl);
                        } else {
                          throw 'Could not launch $whatsappUrl';
                        }
                      },
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          textAlign: TextAlign.end,
                          '0959 026 001',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Color(AppColor.primaryColor),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    subtitle: Text('للتواصل عبر واتساب'),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                    child: Text(
                      'إن أردت تطوير تطبيق مشابه أو لديك استفسارات، لا تتردد في التواصل معنا عبر الواتساب!',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(AppColor.primaryColor),
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 10.h),
                    ),
                    child: Text(
                      'إغلاق',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
