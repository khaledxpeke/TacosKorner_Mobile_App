// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:takos_korner/utils/colors.dart';

class CategoryItem extends StatelessWidget {
  final String? image;
  final String name;
  final double? price;
  final String? currency;
  final VoidCallback onTap;
  final bool selected;
  const CategoryItem(
    this.image,
    this.name,
    this.price,
    this.currency,
    this.onTap,
    this.selected,
  );

  @override
  Widget build(BuildContext context) {
    final url = dotenv.env['API_URL'];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 97.h,
        width: 82.w,
        decoration: BoxDecoration(
          color: selected ? primaryColor : lSilverColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(children: [
          SizedBox(height: 10.h),
          Expanded(
            child: image == ""
                ? Container()
                : image!.startsWith("uploads")
                    ? Image.network(
                        "$url/$image",
                        fit: BoxFit.cover,
                      )
                    : Image.network(
                        image!,
                        fit: BoxFit.cover,
                      ),
          ),
          SizedBox(height: 12.h),
          Text(
            name,
            style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 9.sp,
                color: selected ? lightColor : textColor),
          ),
          price != null
              ? Padding(
                  padding: EdgeInsets.only(top: 3.h),
                  child: Text(
                    "$price $currency",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 9.sp,
                        color: selected ? lightColor : primaryColor),
                  ),
                )
              : Container(),
          SizedBox(height: 9.h),
        ]),
      ),
    );
  }
}
