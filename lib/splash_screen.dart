import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context, ////////// Owner
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SizedBox(height: 119.h),
            Expanded(
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    "assets/logo.jpeg",
                    width: 223.w,
                    height: 223.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // const Spacer(),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  // "assets/splase_img.png",
                  "assets/splash_2.png",
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),

                /// Loading Circle
                Positioned(
                  top: -50.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: SizedBox(
                      width: 50.w,
                      height: 50.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.2.w,
                        backgroundColor: const Color(0xff101C16),
                        color: const Color(0xffFFFFFF),
                      ),
                    ),
                  ),
                ),

                /// Loading Text
                Positioned(
                  top: 20.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "LOADING...",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffFFFFFF),
                        letterSpacing: 1.04,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),

                /// Version
                Positioned(
                  bottom: 30.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Text(
                      "VERSION 1.0.0",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffFFFFFF),
                        letterSpacing: 1.04,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
