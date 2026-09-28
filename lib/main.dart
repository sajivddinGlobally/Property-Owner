import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/my_bottom_screen.dart';
import 'package:property_care/splash_screen.dart';
import 'core/Utils/key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("userdata");
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var box = Hive.box("userdata");
    var token = box.get("token");
    log("Bearer Token :- ${token ?? "No Token Found"}");
    return ScreenUtilInit(
      designSize: Size(440, 855),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return AnnotatedRegion(
          value: const SystemUiOverlayStyle(
            // statusBarColor: Color(0xFFF3F3F3),
            // statusBarIconBrightness: Brightness.dark,
            // statusBarBrightness: Brightness.light,
          ),
          child: SafeArea(
            top: false,
            child: MaterialApp(
              navigatorKey: navigatorKey,
              scaffoldMessengerKey: snackBarKey,
              debugShowCheckedModeBanner: false,
              title: 'Property Care',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              ),
              home: token == null ? SplashScreen() : MyBottomScreen(),
            ),
          ),
        );
      },
    );
  }
}
