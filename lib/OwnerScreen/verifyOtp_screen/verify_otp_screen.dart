import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/my_bottom_screen.dart';
import 'package:property_care/OwnerScreen/verifyOtp_screen/resetPasswordScreen.dart';
import 'package:property_care/core/constant/appColor.dart';

import '../../core/AuthService/AuthServiceProvider.dart';
import '../../core/Utils/showMessage.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String email;
  const VerifyOtpScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  bool isLoading = false;
  bool isResending = false;
  String otp = "";
  Timer? timer;
  int seconds = 30;
  final TextEditingController otpController = TextEditingController();

  String getMaskedContact() {
    final contact = widget.email.trim();
    // Check if the contact is a phone number (contains digits, optionally starting with +)
    final isPhone = RegExp(r'^\+?[0-9]+$').hasMatch(contact);
    if (isPhone && contact.length >= 4) {
      String firstTwo = contact.substring(0, 2);
      String lastTwo = contact.substring(contact.length - 2);
      String mask = List.generate(contact.length - 4, (index) => 'X').join('');
      return "$firstTwo$mask$lastTwo";
    }
    // Return email as is
    return contact;
  }

  void startTimer() {
    timer?.cancel();

    setState(() {
      seconds = 30;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                      "assets/verify_otp.png",
                      width: 146.w,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      "assets/verify_otp.png",
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
                      child: Container(
                        height: 41.h,
                        width: 41.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: Color.fromRGBO(16, 28, 22, 0.3),
                          ),
                        ),
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
            SizedBox(height: 19.h),
            Container(
              height: 100.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: Color.fromRGBO(16, 28, 22, 0.2),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: Image.asset(
                  "assets/Vector.png",
                  height: 44.h,
                  width: 38.w,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "VERIFY YOUR NUMBER",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
                letterSpacing: -0.54,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "We've sent a 6-digit verification code to",
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
                letterSpacing: -0.39,
              ),
            ),
            Text(
              getMaskedContact(),
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
                letterSpacing: -0.39,
              ),
            ),
            SizedBox(height: 36.h),
            Text(
              "Enter OTP",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
                letterSpacing: -0.39,
              ),
            ),
            SizedBox(height: 14.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: Pinput(
                controller: otpController,
                length: 6,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                keyboardType: TextInputType.number,

                onCompleted: (value) {
                  otp = value;
                  print("OTP: $otp");
                },

                defaultPinTheme: PinTheme(
                  width: 48.w,
                  height: 59.h,

                  textStyle: GoogleFonts.inter(
                    color: const Color(0xff1B1E28),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: const Color(0xff4F5752),
                      width: 1.2.w,
                    ),
                  ),
                ),

                focusedPinTheme: PinTheme(
                  width: 48.w,
                  height: 59.h,

                  textStyle: GoogleFonts.inter(
                    color: const Color(0xff1B1E28),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppColors.heading, width: 1.2.w),
                  ),
                ),

                submittedPinTheme: PinTheme(
                  width: 48.w,
                  height: 59.h,

                  textStyle: GoogleFonts.inter(
                    color: const Color(0xff1B1E28),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),

                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppColors.heading, width: 1.2.w),
                  ),
                ),
              ),
            ),

            SizedBox(height: 18.h),
            Text(
              "Resend code in 00:${seconds.toString().padLeft(2, '0')}",
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff101C16),
              ),
            ),

            SizedBox(height: 14.h),
            GestureDetector(
              onTap: seconds == 0 && !isResending
                  ? () async {
                      try {
                        setState(() {
                          isResending = true;
                        });
                        final service = ref.read(authServiceProvider);
                        final response = await service.forgotPassword(
                          email: widget.email,
                        );
                        if (response.status == true) {
                          startTimer();
                          showSuccessSnackBar("Resend OTP Sucessfull");
                        }
                      } catch (e) {
                        log(e.toString());
                      } finally {
                        if (mounted) {
                          setState(() {
                            isResending = false;
                          });
                        }
                      }
                    }
                  : null,
              child: Text(
                isResending
                    ? "Sending OTP..."
                    : "Didn't receive the code? Resend OTP",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: seconds == 0 && !isResending
                      ? const Color(0xff101C16)
                      : const Color(0xff999999),
                ),
              ),
            ),
            SizedBox(height: 41.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: SizedBox(
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
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            final service = ref.read(authServiceProvider);
                            final response = await service.verifyOTP(
                              email: widget.email,
                              otp: otp,
                            );
                            if (response.status == true) {
                              if (context.mounted) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ResetPasswordScreen(
                                      email: widget.email,
                                    ),
                                  ),
                                );
                              }
                            } else {
                              setState(() {
                                otp = "";
                                otpController.clear();
                              });
                            }
                          } catch (e) {
                            log(e.toString());
                            setState(() {
                              otp = "";
                              otpController.clear();
                            });
                          } finally {
                            if (mounted) {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              color: AppColors.heading,
                              strokeWidth: 1.5,
                            ),
                          ),
                        )
                      : Text(
                          "Verify",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                            color: Color(0xffFFFFFF),
                            letterSpacing: -0.24,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
