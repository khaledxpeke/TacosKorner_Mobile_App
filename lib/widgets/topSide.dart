// ignore_for_file: use_key_in_widget_constructors, must_be_immutable, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:takos_korner/widgets/orderStepper.dart';

class TopSide extends StatelessWidget {
  String name;
  int stepperIndex;
  String message;
  TopSide(this.name, this.stepperIndex, this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(
              fontSize: 20.sp, fontWeight: FontWeight.w800, color: textColor),
        ),
        SizedBox(height: 2.h),
        OrderStepper(stepperIndex),
        message != "" ? SizedBox(height: 8.h) : Container(),
        message != ""
            ? Text(
                message,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w800,
                    color: textColor),
              )
            : Container(),
        SizedBox(height: 13.h),
      ],
    );
  }
}
