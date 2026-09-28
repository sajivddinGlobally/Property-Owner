import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/login_screen.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import '../../core/AuthService/AuthServiceProvider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  bool isLoading = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
              height: 170.h,
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
                ],
              ),
            ),
            Center(
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset(
                      "assets/logo.jpeg",
                      width: 73.w,
                      height: 73.w,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "RESET PASSWORD",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      fontSize: 18.sp,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Create a new password for your account.",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      fontSize: 16.sp,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "NEW PASSWORD",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      fontSize: 15.sp,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 44.h,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: TextField(
                      controller: newPasswordController,
                      cursorColor: AppColors.heading,
                      cursorHeight: 18.h,
                      cursorWidth: 1.5.w,
                      obscureText: !isNewPasswordVisible,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,

                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Icon(
                            Icons.lock_outline,
                            color: const Color(0xff26332D),
                            size: 18.sp,
                          ),
                        ),

                        prefixIconConstraints: BoxConstraints(
                          minWidth: 38.w, // 10 left + 18 icon + 10 gap
                          minHeight: 44.h,
                        ),

                        hintText: "Enter your new Password",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: BorderSide(color: AppColors.heading),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                          ),
                        ),

                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 40.w,
                            minHeight: 44.h,
                          ),
                          onPressed: () {
                            setState(() {
                              isNewPasswordVisible = !isNewPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isNewPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.heading,
                            size: 16.sp,
                          ),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "CONFIRM NEW PASSWORD",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      fontSize: 15.sp,
                      letterSpacing: -0.39,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    height: 44.h,
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: TextField(
                      controller: confirmPasswordController,
                      cursorColor: AppColors.heading,
                      cursorHeight: 18.h,
                      cursorWidth: 1.5.w,
                      obscureText: !isConfirmPasswordVisible,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        isDense: true,
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Icon(
                            Icons.lock_outline,
                            color: const Color(0xff26332D),
                            size: 18.sp,
                          ),
                        ),

                        prefixIconConstraints: BoxConstraints(
                          minWidth: 38.w, // 10 left + 18 icon + 10 gap
                          minHeight: 44.h,
                        ),

                        hintText: "Confirm your new Password",
                        hintStyle: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: BorderSide(color: AppColors.heading),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(3.r),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(16, 28, 22, 0.6),
                          ),
                        ),

                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: 40.w,
                            minHeight: 44.h,
                          ),
                          onPressed: () {
                            setState(() {
                              isConfirmPasswordVisible =
                                  !isConfirmPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isConfirmPasswordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.heading,
                            size: 16.sp,
                          ),
                        ),

                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 0,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
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
                              final newPassword = newPasswordController.text
                                  .trim();
                              final confirmPassword = confirmPasswordController
                                  .text
                                  .trim();

                              if (newPassword.isEmpty) {
                                return;
                              }
                              if (confirmPassword.isEmpty) {
                                return;
                              }

                              if (newPassword != confirmPassword) {
                                showErrorSnackBar("Passwords do not match");
                                return;
                              }

                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final service = ref.read(authServiceProvider);
                                final response = await service.resetPassword(
                                  newPassword: newPassword,
                                  confirmPassword: confirmPassword,
                                  email: widget.email,
                                );
                                if (response.status == true) {
                                  showSuccessSnackBar(
                                    response.message ??
                                        "Password reset successfully",
                                  );
                                  if (context.mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                      (route) => false,
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
                              "Reset Password",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 15.sp,
                                color: Color(0xffFFFFFF),
                                letterSpacing: -0.24,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 33.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
