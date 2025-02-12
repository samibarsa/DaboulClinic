// ignore_for_file: deprecated_member_use

import 'package:doctor_app/Features/Auth/domain/Entities/doctor.dart';
import 'package:doctor_app/Features/Home/domain/Entites/order.dart';
import 'package:doctor_app/Features/Home/domain/Entites/patient.dart';
import 'package:doctor_app/Features/Home/presentation/widgets/order_detail_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({
    super.key,
    required this.order,
    required this.doctor,
    required this.patient,
  });

  final Order order;
  final Doctor doctor;
  final Patient patient;

  @override
  // ignore: library_private_types_in_public_api
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late final TextEditingController patientNameController;
  late final TextEditingController outputTypeController;
  late final TextEditingController additionalNotesController;

  late final String doctorName;
  late final int patientAge;
  late final String date;
  late final String time;

  String? selectedImageType;
  String? selectedExaminationOption;
  String? selectedOutputType;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeOrderDetails();
  }

  void _initializeControllers() {
    patientNameController = TextEditingController(text: widget.patient.name);
    outputTypeController = TextEditingController(
      text: widget.order.detail.mode?.modeName ?? "لا يوجد",
    );
    additionalNotesController = TextEditingController(
      text: widget.order.additionalNotes,
    );
  }

  void _initializeOrderDetails() {
    doctorName = widget.doctor.name;
    date = widget.order.date.toString().split(' ')[0];
    time = widget.order.date.toString().split(' ')[1].split('.')[0];
    patientAge = widget.patient.age;
  }

  @override
  void dispose() {
    patientNameController.dispose();
    outputTypeController.dispose();
    additionalNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = OrderDetailTableData(
      patientName: patientNameController.text,
      patientAge: patientAge.toString(),
      doctorName: doctorName,
      selectedImageType: selectedImageType,
      date: date,
      time: DateFormat('hh:mm a').format(widget.order.date),
      additionalNotes: additionalNotesController.text,
      price: widget.order.price,
      order: widget.order,
      patient: widget.patient,
    );
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text(
          'معلومات الطلب',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 34.h),
            Center(
              child: OrderDetailTable(
                data: data,
                onCopyToClipboard: (text) async {
                  await Clipboard.setData(ClipboardData(text: text));
                },
                onLaunchUrl: (url) async {
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
