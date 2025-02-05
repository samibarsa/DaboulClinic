// ignore_for_file: deprecated_member_use

import 'package:shimmer/shimmer.dart';
import 'package:doctor_app/Features/Auth/data/repo/auth_repository_impl.dart';
import 'package:doctor_app/Features/Auth/domain/usecase/usecacses.dart';
import 'package:doctor_app/Features/Home/presentation/maneger/cubit/order_cubit/order_cubit.dart';
import 'package:doctor_app/Features/Home/presentation/maneger/cubit/order_cubit/order_state.dart';
import 'package:doctor_app/Features/wellcome/presentation/views/wellcome.dart';
import 'package:doctor_app/core/utils/constant.dart';
import 'package:doctor_app/core/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Widget buildDoctorInfo(
  BuildContext context,
) {
  return BlocBuilder<OrderCubit, OrderState>(
    builder: (context, state) {
      if (state is OrderLoading) {
        return Row(
          children: [
            SvgPicture.asset(ImagesPath.doctor),
            SizedBox(width: 8.w),
            Shimmer.fromColors(
              baseColor: Colors.grey[800]!, // لون داكن أساسي
              highlightColor: Colors.grey[600]!, // لون فاتح للوميض
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(-1.0, 1.0, 1.0), // عكس الاتجاه
                child: Container(
                  width: 100.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[850], // لون متناسق مع الوضع الداكن
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ),
          ],
        );
      } else if (state is OrderLoaded) {
        return Row(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.r)),
                  ),
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.all(1),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 79.w),
                            child: CustomButton(
                                title: "تسجيل خروج",
                                color: AppColor.primaryColor,
                                onTap: () async {
                                  await SignOutUseCase(AuthRepositoryImpl(
                                          Supabase.instance.client))
                                      .repository
                                      .signOut();

                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.clear();
                                  Navigator.pushAndRemoveUntil(
                                      // ignore: use_build_context_synchronously
                                      context, MaterialPageRoute(
                                    builder: (context) {
                                      return const WellcomeScrean();
                                    },
                                  ), (_) => false);
                                },
                                titleColor: Colors.white),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    ImagesPath.doctor,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "أهلاً وسهلاً!",
                        style: TextStyle(
                            fontSize: 12.sp, color: const Color(0xff6A6A6A)),
                      ),
                      Text(
                        state.doctor.name, // عرض اسم الطبيب
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return const Text("حدث خطأ في تحميل البيانات");
      }
    },
  );
}
