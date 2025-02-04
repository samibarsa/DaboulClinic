import 'package:doctor_app/Features/AddOrder/presentation/widgets/add_order_view_body.dart';
import 'package:flutter/material.dart';

class AddOrderView extends StatelessWidget {
  const AddOrderView({super.key, required this.patientId, this.anotherImage});
  final int patientId;
  final anotherImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: const Text("اختيار نوع الصورة"),
      ),
      body: AddOrderViewBody(
        patientId: patientId,
      ),
    );
  }
}
