import 'package:doctor_app/Features/Auth/presentation/views/login_view.dart';
import 'package:doctor_app/Features/Auth/presentation/views/sign_up.dart';
import 'package:doctor_app/core/utils/constant.dart';
import 'package:doctor_app/core/utils/navigator/navigator.dart';
import 'package:doctor_app/core/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class WellcomeViewBody extends StatelessWidget {
  const WellcomeViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SizedBox(
              height: 50.h,
            ),
            Image.asset(
              ImagesPath.logo,
              height: MediaQuery.of(context).size.height * 0.25,
              width: 263.w,
            ),
            Text(
              "عيادة دعبول للأشعة",
              style: TextStyle(fontSize: 30.sp),
            ),
            Spacer(),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Color(AppColor.primaryColor))),
                    color: Colors.transparent, // اللون
                    borderRadius:
                        BorderRadius.circular(25.0), // الحواف المستديرة
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Text(
                        "أهلا بك في تطبيق دعبول للأشعة",
                        style: TextStyle(fontSize: 27.sp),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          "تجربة مبتكرة للتشخيص الطبي: اكتشف مع تطبيق دعبول للأشعة الجديد",
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      CustomButton(
                        onTap: () {
                          MovingNavigation.navTo(context,
                              page: const SignUpView());
                        },
                        title: "انشاء حساب",
                        color: AppColor.primaryColor,
                        titleColor: Colors.white,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color(AppColor.primaryColor)),
                            borderRadius: BorderRadius.circular(5.r)),
                        child: CustomButton(
                            titleColor: Colors.white,
                            onTap: () {
                              MovingNavigation.navTo(context,
                                  page: const LoginView());
                            },
                            title: 'تسجيل دخول',
                            color: 0xffFFFF),
                      ),
                      SizedBox(
                        height: 40.h,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
