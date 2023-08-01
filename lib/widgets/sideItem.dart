// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:takos_korner/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SideItem extends StatelessWidget {
  final String? image;
  final String name;
  final VoidCallback onTap;
  final bool selected;
  final int quantity;
  const SideItem(
      this.image, this.name, this.onTap, this.selected, this.quantity);

  @override
  Widget build(BuildContext context) {
    final url = dotenv.env['API_URL'];
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            height: 61.h,
            width: 82.w,
            decoration: BoxDecoration(
              color: selected ? primaryColor : null,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15.r),
                bottomRight: Radius.circular(15.r),
              ),
            ),
            child: Column(children: [
              SizedBox(height: 4.h),
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
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 9.sp,
                    color: selected ? lightColor : textColor),
              ),
              SizedBox(height: 4.h),
            ]),
          ),
          quantity > 1
              ? Positioned(
                  right: 0,
                  child: Container(
                    height: 20.h,
                    width: 20.w,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                        child: Text('X$quantity',
                            style: TextStyle(
                                color: lightColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w900))),
                  ))
              : Container()
        ],
      ),
    );
  }
}
