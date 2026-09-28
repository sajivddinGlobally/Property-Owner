import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:property_care/OwnerScreen/verifyOtp_screen/verify_otp_screen.dart';

import '../../core/AuthService/AuthServiceProvider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: 180.h,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/circuler_img.png",
                      width: 146.w,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/circuler_img.png",
                      width: 177.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Positioned(
                    top: 57.h,
                    left: 20.w,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: 30.w,
                        height: 30.h,
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: const Color(0xff101C16),
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 28.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 61.h,
                    width: 59.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                        color: Color.fromRGBO(16, 28, 22, 0.5),
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        "assets/forgot.png",
                        width: 27.w,
                        height: 29.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "FORGOT PASSWORD?",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.54,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  Text(
                    "No worries. Enter your registered email address or mobile number \nand we'll send you a secure reset code.",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 43.h),
                  Text(
                    "Email or Mobile Number",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 44.h,
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: TextField(
                      controller: emailController,
                      cursorColor: AppColors.heading,
                      cursorHeight: 18.h,
                      cursorWidth: 1.5.w,
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,

                        prefixIcon: Icon(
                          Icons.auto_awesome,
                          size: 20.sp,
                          color: Colors.black,
                        ),

                        hintText: "Enter Email or mobile number",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Color.fromRGBO(16, 28, 22, 0.6),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: BorderSide(color: AppColors.heading),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 43.h),
                  SizedBox(
                    height: 41.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.heading,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (emailController.text.trim().isEmpty) {
                                return;
                              }
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final service = ref.read(authServiceProvider);
                                final response = await service.forgotPassword(
                                  email: emailController.text.trim(),
                                );
                                if (response.status == true) {
                                  showSuccessSnackBar(
                                    response.message ?? "Success",
                                  );
                                  if (context.mounted) {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => VerifyOtpScreen(
                                          email: emailController.text.trim(),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              } catch (e) {
                                log(e.toString());
                              } finally {
                                if (mounted) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                      child: isLoading
                          ? SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator(
                                color: AppColors.heading,
                                strokeWidth: 1.5,
                              ),
                            )
                          : Text(
                              "Send Reset OTP",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                                color: Color(0xffFFFFFF),
                                letterSpacing: -0.24,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
