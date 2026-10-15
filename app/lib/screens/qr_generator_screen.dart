import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/visitor_model.dart';
import 'dashboard_screen.dart';

class QRGeneratorScreen extends StatelessWidget {
  final VisitorModel visitor;

  QRGeneratorScreen({required this.visitor});

  @override
  Widget build(BuildContext context) {
    // QR data matches what the backend generates: {"visitorId": "..."}
    final String qrData = jsonEncode({'visitorId': visitor.id});

    return Scaffold(
      appBar: AppBar(
          title: Text('Visitor QR Code', style: TextStyle(fontSize: 18.sp))),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Share this QR code with the visitor',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Container(
                width: 250.w,
                height: 250.w,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12, blurRadius: 10, spreadRadius: 2)
                  ],
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 220.w,
                ),
              ),
              SizedBox(height: 24.h),
              Text('Name: ${visitor.name}', style: TextStyle(fontSize: 16.sp)),
              SizedBox(height: 6.h),
              Text('Phone: ${visitor.phone}',
                  style: TextStyle(fontSize: 14.sp)),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashboardScreen()),
                      (route) => false,
                    );
                  },
                  child: Text('Back to Dashboard',
                      style: TextStyle(fontSize: 15.sp)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
