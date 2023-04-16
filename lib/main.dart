// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/dishCategories.dart';
import 'screens/Home_screen.dart';
import 'screens/category_screen.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Categories()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(396, 642),
        builder: (context, child) {
          return MaterialApp(
            title: 'Takos Korner',
            debugShowCheckedModeBanner: false,
            // theme: ThemeData(
            //   textTheme: GoogleFonts.interTextTheme(),
            // ),
            home: HomeScreen(),
            routes: {
              CategoryScreen.routeName: (ctx) => CategoryScreen(),
            },
          );
        });
  }
}
