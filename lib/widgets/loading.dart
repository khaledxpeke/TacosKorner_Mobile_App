// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 200.h),
        child: Center(
          child:
              LoadingAnimationWidget.inkDrop(color: primaryColor, size: 25.w),
        ),
      ),
    );
  }
}
