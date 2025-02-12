// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:doctor_app/Features/Home/presentation/widgets/inactive_account_dialog.dart';

import 'package:doctor_app/Features/Home/domain/Entites/order.dart';
import 'package:doctor_app/Features/Home/domain/Entites/patient.dart';
import 'package:doctor_app/Features/Home/presentation/maneger/cubit/order_cubit/order_cubit.dart';
import 'package:doctor_app/Features/Home/presentation/maneger/cubit/order_cubit/order_state.dart';
import 'package:doctor_app/Features/Home/presentation/view/monthly_order_view.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/build_app_bar.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/build_list_view.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/custom_shimmer.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/filter_dialog.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/home_view_error.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/search_bar.dart';
import 'package:doctor_app/core/utils/constant.dart';
import 'package:doctor_app/core/utils/navigator/navigator.dart';
import 'package:doctor_app/core/utils/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  TextEditingController searchController = TextEditingController();
  List<Order> filteredOrders = [];

  bool isPanorama = true;
  bool isCephalometric = true;
  bool isCBCT = true;

  @override
  void initState() {
    super.initState();
    _filterOrders();
    searchController.addListener(_filterOrders);
  }

  @override
  void dispose() {
    searchController.removeListener(_filterOrders);
    searchController.dispose();
    super.dispose();
  }

  void _initializeFilteredOrders(OrderLoaded state) {
    final today = DateTime.now();
    final ordersToday = state.orders.where((order) {
      return order.date.year == today.year &&
          order.date.month == today.month &&
          order.date.day == today.day;
    }).toList();
    filteredOrders = ordersToday;
  }

  void _filterOrders() {
    final query = searchController.text.toLowerCase();
    final state = context.read<OrderCubit>().state;
    if (state is OrderLoaded) {
      final today = DateTime.now();
      final ordersToday = state.orders.where((order) {
        return order.date.year == today.year &&
            order.date.month == today.month &&
            order.date.day == today.day;
      }).toList();

      setState(() {
        filteredOrders = ordersToday.where((order) {
          final patient = state.patient.firstWhere(
            (patient) => patient.id == order.patientId,
            orElse: () => Patient(
              name: '',
              id: 0,
              age: 0,
            ),
          );
          final patientName = patient.name.toLowerCase();
          final orderType = order.detail.type.typeName.toLowerCase();

          bool matchesType = false;
          if (isPanorama && orderType.contains('بانوراما')) matchesType = true;
          if (isCephalometric && orderType.contains('سيفالوماتريك')) {
            matchesType = true;
          }
          if (isCBCT && orderType.contains('c.b.c.t')) matchesType = true;

          return patientName.contains(query) && matchesType;
        }).toList();
      });
    }
  }

  void _updateFilter(bool panorama, bool cephalometric, bool cbct) {
    setState(() {
      isPanorama = panorama;
      isCephalometric = cephalometric;
      isCBCT = cbct;
    });
    _filterOrders();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => FilterDialog(
        isPanorama: isPanorama,
        isCephalometric: isCephalometric,
        isCBCT: isCBCT,
        onFilterChanged: _updateFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize10 = screenWidth * 0.030;
    double fontSize12 = screenWidth * 0.045;
    return Scaffold(
      appBar: buildAppBar(context, _showFilterDialog),
      body: RefreshIndicator(
        onRefresh: _handleRefresh, // Handle the refresh operation here
        child: BlocListener<OrderCubit, OrderState>(
          listener: (context, state) {
            if (state is OrderLoaded) {
              _initializeFilteredOrders(state);
            }
          },
          child: BlocBuilder<OrderCubit, OrderState>(
            builder: (context, state) {
              if (state is OrderLoading) {
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      SizedBox(height: 0.h),
                      const Expanded(child: CustomShimmer()),
                    ],
                  ),
                );
              }

              if (state is OrderLoaded) {
                if (state.doctor.isActive) {
                  return Column(
                    children: [
                      SizedBox(height: 10.h),
                      _buildHeader(),
                      SizedBox(height: 10.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          children: [
                            TextButton(
                              onPressed: () {
                                MovingNavigation.navTo(
                                  context,
                                  page: MonthlyOrdersPage(
                                    allOrders: state.orders,
                                    state: state,
                                  ),
                                );
                              },
                              child: Text(
                                "< عرض الطلبات الشهرية",
                                style:
                                    _textStyle().copyWith(fontSize: fontSize10),
                              ),
                            ),
                            Spacer(),
                            Text(
                              "طلبات اليوم",
                              style: TextStyle(
                                fontSize: fontSize12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Expanded(
                        child: filteredOrders.isNotEmpty
                            ? BuildListView(
                                orders: filteredOrders, state: state)
                            : _buildEmptyState(),
                      ),
                    ],
                  );
                } else {
                  // Handle inactive doctor account
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          InactiveAccountDialog(email: state.doctor.email),
                    ).then((_) {
                      // Exit the app when the dialog is closed
                      exit(0);
                    });
                  });
                }
              }

              if (state is OrderError) {
                return HomeViewError(state: state);
              }

              // Default state
              return const Center(child: Text('لم يتم العثور على طلبات.'));
            },
          ),
        ),
      ),
    );
  }

// Refresh function that triggers fetching orders
  Future<void> _handleRefresh() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    await context
        .read<OrderCubit>()
        .fetchOrders(startDate: startOfMonth, endDate: endOfMonth);
    await context.read<OrderCubit>().fetchDoctorDataUseCase();
  }

  Widget _buildHeader() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: CustomSearchBar(searchController: searchController),
    );
  }

  // ignore: unused_element
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text("لا يوجد بيانات حاليا"),
              ),
              SizedBox(height: 40.h),
              CustomButton(
                title: "إعادة تحميل",
                color: AppColor.primaryColor,
                onTap: () async {
                  final now = DateTime.now();
                  final startOfMonth = DateTime(now.year, now.month, 1);
                  final endOfMonth = DateTime(now.year, now.month + 1, 0);
                  context.read<OrderCubit>().fetchOrders(
                      startDate: startOfMonth, endDate: endOfMonth);
                },
                titleColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle _textStyle() {
  return TextStyle(
    decoration: TextDecoration.underline,
    decorationColor: const Color(AppColor.primaryColor),
    fontSize: 11.sp,
    color: const Color(AppColor.primaryColor),
  );
}
