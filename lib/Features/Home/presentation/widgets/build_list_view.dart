import 'package:doctor_app/Features/Home/domain/Entites/order.dart';
import 'package:doctor_app/Features/Home/presentation/maneger/cubit/order_cubit/order_state.dart';
import 'package:doctor_app/Features/Home/presentation/view/order_view_detiles.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/list_tile_card.dart';
import 'package:doctor_app/core/utils/navigator/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class BuildListView extends StatelessWidget {
  const BuildListView({
    super.key,
    required this.orders,
    required this.state,
  });

  final List<Order> orders;
  final OrderLoaded state;

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    return Expanded(
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          orders.sort((a, b) => b.date.compareTo(a.date));
          final order = orders[index];
          var timeZoneOffset = const Duration(hours: -3);
          var dateInTimeZone = order.date.add(timeZoneOffset);
          final localDate = dateInTimeZone.toLocal();
          final ago = timeago.format(localDate, locale: 'ar');
          final patientThis =
              state.patient.where((patient) => order.patientId == patient.id);
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: InkWell(
                  onTap: () {
                    MovingNavigation.navTo(context,
                        page: OrderDetails(
                          order: order,
                          doctor: state.doctor,
                          patient: patientThis.first,
                        ));
                  },
                  child: ListTileCard(
                    papatientName: patientThis.first.name,
                    type: order.detail.type.typeName,
                    date: ago,
                  ),
                ),
              ),
              if (index == orders.length - 1) SizedBox(height: 75.h),
            ],
          );
        },
      ),
    );
  }
}
