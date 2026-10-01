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
                    top: 50.h,
                    left: 20.w,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 44.w,
                        height: 44.h,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromRGBO(16, 28, 22, 0.3),
                          ),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.arrow_back,
                            color: const Color(0xff101C16),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 61.h,
                    width: 59.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9.r),
                      border: Border.all(
                        color: const Color.fromRGBO(16, 28, 22, 0.5),
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
                    "FORGOT PASSWORD?",
                    style: GoogleFonts.outfit(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "No worries. Enter your registered email address or mobile number and we'll send you a secure reset code.",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff26332D),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    "EMAIL OR MOBILE NUMBER",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 52.h,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: TextField(
                      style: GoogleFonts.outfit(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff101C16),
                        letterSpacing: -0.2,
                      ),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 12.w, right: 8.w),
                          child: Icon(
                            Icons.mail_outline,
                            color: const Color(0xff101C16),
                            size: 24.sp,
                          ),
                        ),
                        prefixIconConstraints: BoxConstraints(
                          minWidth: 48.w,
                          minHeight: 52.h,
                        ),
                        hintText: "Enter Email or mobile number",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: AppColors.heading,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                            width: 1.2,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 14.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 36.h),
                  SizedBox(
                    height: 52.h,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.heading,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
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
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Send Reset OTP",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 16.sp,
                                color: const Color(0xffFFFFFF),
                                letterSpacing: 0.2,
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
