// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:takos_korner/provider/dessertProvider.dart';
import 'package:takos_korner/provider/categoriesProvider.dart';
import 'package:takos_korner/provider/sauceProvider.dart';
import 'package:takos_korner/screens/splash_screen.dart';
import 'screens/Home_screen.dart';
import 'screens/category_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => Categories()),
      ChangeNotifierProvider(create: (_) => Deserts()),
      ChangeNotifierProvider(create: (_) => Sauces()),
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
            title: 'Tacos Korner',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Inter'
              //   textTheme:
              //       GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
            ),
            home: SplashScreen(),
            routes: {
              CategoryScreen.routeName: (ctx) => CategoryScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
            },
          );
        });
  }
}
