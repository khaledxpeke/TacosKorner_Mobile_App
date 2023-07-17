// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
        padding: EdgeInsets.symmetric(horizontal: 2.w),
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
                    ? CachedNetworkImage(
                        imageUrl: "$url/$image",
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) {
                          return Image.asset(
                            "assets/images/logo.png",
                            fit: BoxFit.cover,
                          );
                        },
                        placeholder: (context, url) {
                          return Center(
                              child: LoadingAnimationWidget.inkDrop(
                                  color: primaryColor, size: 25.w));
                        },
                      )
                    : Image.network(
                        image!,
                        fit: BoxFit.cover,
                      ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 2.h, left: 3, right: 3),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 9.sp,
                    color: selected ? lightColor : textColor),
              )),
          price != null
              ? Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    "$price $currency",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 9.sp,
                        color: selected ? lightColor : primaryColor),
                  ),
                )
              : Container(),
          SizedBox(height: 8.h),
        ]),
      ),
    );
  }
}
