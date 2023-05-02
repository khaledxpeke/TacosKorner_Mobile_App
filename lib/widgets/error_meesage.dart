// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, file_names

import 'package:flutter/material.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorMessage extends StatelessWidget {
  String errorMsg;
  ErrorMessage(this.errorMsg);

  @override
  Widget build(BuildContext context) {
    return Text(
          errorMsg,
          style: TextStyle(
              color: redColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500),
        );
  }
}
