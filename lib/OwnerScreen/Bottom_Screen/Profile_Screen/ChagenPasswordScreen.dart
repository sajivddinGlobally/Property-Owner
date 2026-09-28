import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:svg_flutter/svg.dart';

class ChagenPasswordScreen extends ConsumerStatefulWidget {
  const ChagenPasswordScreen({super.key});

  @override
  ConsumerState<ChagenPasswordScreen> createState() =>
      _ChagenPasswordScreenState();
}

class _ChagenPasswordScreenState extends ConsumerState<ChagenPasswordScreen> {
  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;
  final currentPassController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();

  @override
  void dispose() {
    currentPassController.dispose();
    newPassController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 41.w,
                  height: 41.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xff101C16),
                    size: 16.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SECURITY & PASSWORD",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Manage your account security",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(42, 41, 51, 0.6),
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 8.5.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(
                    color: const Color(0xFF000000),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Lock Icon
                    Container(
                      width: 37.w,
                      height: 37.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.r),
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1.w,
                        ),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/SvgImage/lock.svg",
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),

                    SizedBox(width: 11.w),

                    // Text Area
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Security & Password",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF000000),
                              letterSpacing: -0.2,
                            ),
                          ),

                          SizedBox(height: 2.h),

                          Text(
                            "Manage password and account security",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 0.7),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 8.w),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                          color: const Color(0xFF000000),
                          width: 1.w,
                        ),
                      ),
                      child: Text(
                        "Secure",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF000000),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Change Password",
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF101C16),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Color(0xFF000000), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextfield(
                      controller: currentPassController,
                      label: "Current Password",
                      hintText: "Current Password",
                      isPasswordVisible: isCurrentPasswordVisible,
                      onVisibilityChanged: () {
                        setState(() {
                          isCurrentPasswordVisible = !isCurrentPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextfield(
                      controller: newPassController,
                      label: "New Password",
                      hintText: "Enter New Password",
                      isPasswordVisible: isNewPasswordVisible,
                      onVisibilityChanged: () {
                        setState(() {
                          isNewPasswordVisible = !isNewPasswordVisible;
                        });
                      },
                    ),
                    SizedBox(height: 12.h),
                    _buildTextfield(
                      controller: confirmPassController,
                      label: "Confirm New Password",
                      hintText: "Confirm New Password",
                      isPasswordVisible: isConfirmPasswordVisible,
                      onVisibilityChanged: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                  onPressed: () async {
                    if (newPassController.text != confirmPassController.text) {
                      showErrorSnackBar('Passwords do not match');
                      return;
                    }
                    if (newPassController.text.isEmpty ||
                        confirmPassController.text.isEmpty ||
                        currentPassController.text.isEmpty) {
                      showErrorSnackBar('Please fill all the fields');
                      return;
                    }
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final service = ref.read(authServiceProvider);
                      final response = await service.changePassword(
                        currentPassword: currentPassController.text,
                        newPassword: newPassController.text,
                        confirmNewPassword: confirmPassController.text,
                      );
                      if (context.mounted) {
                        showSuccessSnackBar('Password changed successfully');
                        if (response.status == true) {
                          Navigator.pop(context);
                        }
                      }
                    } catch (e) {
                      log(e.toString());
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              color: AppColors.background,
                              strokeWidth: 2.w,
                            ),
                          ),
                        )
                      : Text(
                          "Update Password",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: Color(0xffFFFFFF),
                            fontSize: 15.sp,
                            letterSpacing: -0.34,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextfield({
    required String label,
    required String hintText,
    required bool isPasswordVisible,
    required VoidCallback onVisibilityChanged,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF000000),
            letterSpacing: -0.2,
          ),
        ),

        SizedBox(height: 7.h),

        Container(
          height: 40.h,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: TextField(
            style: GoogleFonts.outfit(fontSize: 17.sp, letterSpacing: -0.2),
            controller: controller,
            cursorColor: AppColors.heading,
            cursorHeight: 18.h,
            cursorWidth: 1.5.w,
            obscureText: !isPasswordVisible,
            textAlignVertical: TextAlignVertical.center,

            decoration: InputDecoration(
              isDense: true,

              hintText: hintText,

              hintStyle: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: const Color.fromRGBO(16, 28, 22, 0.6),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: BorderSide(color: AppColors.heading),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.r),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(16, 28, 22, 0.6),
                ),
              ),

              suffixIcon: IconButton(
                padding: EdgeInsets.zero,

                constraints: BoxConstraints(minWidth: 40.w, minHeight: 44.h),

                onPressed: onVisibilityChanged,

                icon: Icon(
                  isPasswordVisible
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
      ],
    );
  }
}
