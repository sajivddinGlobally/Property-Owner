import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/login_screen.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';
import '../../core/AuthService/AuthServiceProvider.dart';
import 'provider/availableFlatsProvider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool associationAgreeTerms = false;
  bool ownerAgreeTerms = false;
  bool isOwnerPasswordVisible = false;
  bool isOwnerConfirmPasswordVisible = false;
  bool isLoading = false;
  String? selectedFlatNameNumber;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController associationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController apartmentController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    associationController.dispose();
    locationController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getAvailableFlatState = ref.watch(getAvailableFlatsProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        // "assets/property_img.png",
                        "assets/logo.jpeg",
                        width: 75.w,
                        height: 75.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "Create Account",
                      style: GoogleFonts.uoqMunThenKhung(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF000000),
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      textAlign: TextAlign.center,
                      "REGISTER TO MANAGE YOR PROPERTY",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.w),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Color(0xFF000000), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ACCOUNT INFORMATION",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                        letterSpacing: -0.3,
                      ),
                    ),
                    SizedBox(height: 16.w),
                    fieldLabel("FULL NAME"),
                    customTextField(
                      controller: nameController,
                      hintText: "Enter Your Full Name",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your full name";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 13.w),
                    fieldLabel("EMAIL ADDRESS"),
                    customTextField(
                      controller: emailController,
                      hintText: "Enter Your Email Address",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email address";
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return "Please enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 13.w),
                    fieldLabel("MOBILE NUMBER"),
                    customTextField(
                      controller: mobileController,
                      hintText: "Enter Your Mobile Number ",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your mobile number";
                        }
                        if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                          return "Please enter a valid 10-digit mobile number";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 13.w),
                    fieldLabel("PASSWORD"),
                    customTextField(
                      controller: passwordController,
                      hintText: "Create a strong password",
                      obscureText: !isOwnerPasswordVisible,
                      showVisibilityIcon: true,
                      onVisibilityTap: () {
                        setState(() {
                          isOwnerPasswordVisible = !isOwnerPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 13.h),
                    fieldLabel("CONFIRM PASSWORD"),
                    customTextField(
                      controller: confirmPasswordController,
                      hintText: "Re-enter your password",
                      obscureText: !isOwnerConfirmPasswordVisible,
                      showVisibilityIcon: true,
                      onVisibilityTap: () {
                        setState(() {
                          isOwnerConfirmPasswordVisible =
                              !isOwnerConfirmPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your confirm password";
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "PROPERTY INFORMATION",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                        letterSpacing: -0.3,
                      ),
                    ),

                    SizedBox(height: 10.w),
                    fieldLabel("Apartment / Flat Number"),
                    getAvailableFlatState.when(
                      data: (data) {
                        return DropdownButtonFormField<String>(
                          isExpanded: true,
                          value: selectedFlatNameNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select an apartment / flat";
                            }
                            return null;
                          },
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: const Color(0xFF000000),
                            size: 20.sp,
                          ),
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            color: const Color(0xff101C16),
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: 'Select Flat',
                            hintStyle: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(0, 0, 0, 0.6),
                              letterSpacing: -0.3,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 10.h,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.r),
                              borderSide: BorderSide(
                                color: const Color(0xFF000000),
                                width: 1.w,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.r),
                              borderSide: BorderSide(
                                color: const Color(0xFF000000),
                                width: 1.w,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.r),
                              borderSide: BorderSide(
                                color: const Color(0xFF000000),
                                width: 1.w,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.r),
                              borderSide: BorderSide(
                                color: const Color(0xFF000000),
                                width: 1.w,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.r),
                              borderSide: BorderSide(
                                color: const Color(0xFF000000),
                                width: 1.w,
                              ),
                            ),
                          ),
                          items: data.data?.map((flat) {
                            return DropdownMenuItem<String>(
                              value: flat.propertyNameNumber.toString(),
                              child: Text(
                                "${flat.propertyNameNumber ?? ''} (${flat.complex?.name ?? ''})",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedFlatNameNumber = value;
                            });
                          },
                        );
                      },
                      error: (e, s) {
                        log("error $e");
                        return Center(child: Text("Something went wrong"));
                      },
                      loading: () {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.heading,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 25.w,
                          height: 25.w,
                          color: Colors.white,
                          child: Checkbox(
                            value: ownerAgreeTerms,
                            onChanged: (value) {
                              setState(() {
                                ownerAgreeTerms = value ?? false;
                              });
                            },
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            side: const BorderSide(
                              color: Color(0xFF000000),
                              width: 1,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                color: Color(0Xff000000),
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                              children: [
                                const TextSpan(
                                  text:
                                      "I agree to the Terms & Conditions and Privacy Policy.",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.w),
                    SizedBox(
                      width: double.infinity,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                if (ownerAgreeTerms == false) {
                                  showErrorSnackBar(
                                    "Please agree to the terms and conditions",
                                  );
                                  return;
                                }
                                try {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  final service = ref.read(authServiceProvider);
                                  final response = await service.register(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    phone: mobileController.text.trim(),
                                    password: passwordController.text.trim(),
                                    confirmPassword: confirmPasswordController
                                        .text
                                        .trim(),
                                    propertyNameNumber: selectedFlatNameNumber!,
                                    role: 'property_owner',
                                  );
                                  if (response.status == true) {
                                    showSuccessSnackBar(
                                      response.message ?? "Sucess",
                                    );
                                    if (context.mounted) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => LoginScreen(),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF101C16),
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
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
                                "CREATE ACCOUNT",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0.1,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Already have an account?  ",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                          ),
                        ),
                        TextSpan(
                          text: "Login",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget sectionHeader({required String number, required String title}) {
    return Row(
      children: [
        Container(
          width: 28.w,
          height: 28.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF000000), width: 1.w),
            borderRadius: BorderRadius.circular(3.r),
          ),
          child: Text(
            number,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Color(0xFF000000),
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  Widget fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: Color(0xFF000000),
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget customTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    VoidCallback? onVisibilityTap,
    bool showVisibilityIcon = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.outfit(
        fontSize: 16.sp,
        color: const Color(0xff101C16),
        letterSpacing: -0.2,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(0, 0, 0, 0.6),
          letterSpacing: -0.3,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        suffixIcon: showVisibilityIcon
            ? InkWell(
                onTap: onVisibilityTap,
                child: Icon(
                  obscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18.sp,
                  color: const Color(0xFF000000),
                ),
              )
            : null,
        // ⭐ IMPORTANT
        suffixIconConstraints: BoxConstraints(
          minHeight: 44.h,
          maxHeight: 44.h,
          minWidth: 44.w,
          maxWidth: 44.w,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Color(0xFF000000), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Color(0xFF000000), width: 1.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
      ),
    );
  }
}
