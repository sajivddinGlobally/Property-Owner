import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Profile_Screen/Provider/getProfileProvider.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

import '../../../core/AuthService/AuthServiceProvider.dart';

class Editprofilescreen extends ConsumerStatefulWidget {
  const Editprofilescreen({super.key});

  @override
  ConsumerState<Editprofilescreen> createState() => _EditprofilescreenState();
}

class _EditprofilescreenState extends ConsumerState<Editprofilescreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final accountTypeController = TextEditingController();
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  File? selectedImage;
  String? existingImageUrl;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint("Image picker error: $e");
    }
  }

  void _showImagePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: const Text("Camera"),
            ),

            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: const Text("Gallery"),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            isDefaultAction: true,
            child: const Text("Cancel"),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProfile();
    });
  }

  void fetchProfile() async {
    final data = await ref.read(getProfileProvider);
    data.whenData((value) {
      nameController.text = value.data?.name ?? "";
      emailController.text = value.data?.email ?? "";
      phoneController.text = value.data?.phone ?? "";
      accountTypeController.text = value.data?.role ?? "";
      setState(() {
        existingImageUrl = value.data?.avatarUrl ?? "";
      });
    });
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
                    "Edit Profile",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Update your personal information",
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
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    SizedBox(height: 33.h),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipOval(
                          child: selectedImage != null
                              ? Image.file(
                                  selectedImage!,
                                  width: 80.r,
                                  height: 80.r,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 80.r,
                                      height: 80.r,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF101C16),
                                          width: 1.w,
                                        ),
                                      ),
                                      child: Icon(Icons.person, size: 30.sp),
                                    );
                                  },
                                )
                              : (existingImageUrl != null &&
                                    existingImageUrl!.isNotEmpty)
                              ? ClipOval(
                                  child: Image.network(
                                    existingImageUrl!,
                                    width: 80.r,
                                    height: 80.r,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 80.r,
                                        height: 80.r,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xFF101C16),
                                            width: 1.w,
                                          ),
                                        ),
                                        child: Icon(Icons.person, size: 30.sp),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  width: 80.r,
                                  height: 80.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xff101C16),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.person,
                                      color: AppColors.heading,
                                      size: 35.sp,
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                          right: -5.w,
                          bottom: -1.h,
                          child: GestureDetector(
                            onTap: _showImagePicker,
                            child: Container(
                              width: 30.r,
                              height: 30.r,
                              decoration: BoxDecoration(
                                color: const Color(0xff101C16),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: 15.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    GestureDetector(
                      onTap: _showImagePicker,
                      child: Text(
                        "Update profile photo",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff101C16),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
              Text(
                "Personal Information",
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF101C16),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 9.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Color(0xFF000000), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextfield(
                      label: "Full Name",
                      hintText: "Enter Full Name",
                      keyboardType: TextInputType.name,
                      controller: nameController,
                    ),
                    SizedBox(height: 14.h),
                    _buildTextfield(
                      label: "Email Address",
                      hintText: "Email Address",
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      isReadOnly: true,
                    ),
                    SizedBox(height: 14.h),
                    _buildTextfield(
                      label: "Phone Number",
                      hintText: "Enter Phone Number",
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      isReadOnly: true,
                    ),
                    SizedBox(height: 14.h),
                    _buildTextfield(
                      label: "Account Type",
                      hintText: "Enter Account Type",
                      keyboardType: TextInputType.streetAddress,
                      controller: accountTypeController,
                      isReadOnly: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              SizedBox(
                width: double.infinity,
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff000000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      final service = ref.read(authServiceProvider);
                      final response = await service.editProfile(
                        phone: phoneController.text.trim(),
                        name: nameController.text.trim(),
                        image: selectedImage != null
                            ? await MultipartFile.fromFile(selectedImage!.path)
                            : null,
                      );
                      if (response.status == true) {
                        showSuccessSnackBar(response.message ?? "Sucess");
                        ref.invalidate(getProfileProvider);
                        Navigator.pop(context);
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
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            color: AppColors.scaffoldBg,
                            strokeWidth: 1.5,
                          ),
                        )
                      : Text(
                          "Save",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: Color(0xffFFFFFF),
                            fontSize: 15.sp,
                            letterSpacing: -0.34,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.scaffoldBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                      side: BorderSide(color: AppColors.heading),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
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
    required TextInputType keyboardType,
    required TextEditingController controller,
    bool? isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF000000),
            letterSpacing: -0.2,
          ),
        ),

        SizedBox(height: 7.h),
        TextFormField(
          cursorHeight: 24.h,
          cursorColor: AppColors.heading,
          controller: controller,
          cursorWidth: 2.w,
          keyboardType: keyboardType,
          textAlignVertical: TextAlignVertical.center,
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
          readOnly: isReadOnly ?? false,
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

            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 8.h,
            ),
          ),
        ),
      ],
    );
  }
}
