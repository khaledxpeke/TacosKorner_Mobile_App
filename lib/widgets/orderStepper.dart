import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:takos_korner/utils/colors.dart';

class OrderStepper extends StatelessWidget {
  final int currentIndex;

  const OrderStepper(this.currentIndex);

  @override
  Widget build(BuildContext context) {
    int nbSteps = 5;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double lineWidth = constraints.maxWidth / nbSteps;
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            StepsIndicator(
              selectedStepColorOut: primaryColor,
              selectedStepColorIn: lightColor,
              selectedStepBorderSize: 2.r,
              unselectedStepColorOut: dSilverColor,
              unselectedStepColorIn: dSilverColor,
              selectedStepSize: 16.w,
              doneStepSize: 16.w,
              unselectedStepSize: 16.w,
              selectedStep: currentIndex,
              nbSteps: nbSteps,
              doneLineColor: primaryColor,
              doneStepColor: primaryColor,
              undoneLineColor: dSilverColor,
              doneLineThickness: 4.h,
              undoneLineThickness: 4.h,
              lineLength: lineWidth - 16.w,
              // enableLineAnimation: true,
              // enableStepAnimation: true,
            ),
          ],
        );
      },
    );
  }
}
