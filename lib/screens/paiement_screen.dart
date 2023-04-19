import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/utils/colors.dart';

class PaiementScreen extends StatelessWidget {
  const PaiementScreen({super.key});
  static const routeName = "/PaiementScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 153.h,
              width: 172.w,
            ),
            Text(
              'Paiement à la caisse SVP',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: textColor),
            )
          ],
        )),
      ),
    );
  }
}
