import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/getPropertyListProvider.dart';
import 'package:property_care/OwnerScreen/Tenant_Management_Screen/Provider/getTenantDetailsProvider.dart';
import 'package:property_care/OwnerScreen/Tenant_Management_Screen/Provider/getTenantListProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/propertyListModel.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

class AddTenantScreen extends ConsumerStatefulWidget {
  final int? propertyId;
  final String? propertyName;
  final String? complexName;
  final String? tenantId;

  const AddTenantScreen({
    super.key,
    this.propertyId,
    this.propertyName,
    this.complexName,
    this.tenantId,
  });

  @override
  ConsumerState<AddTenantScreen> createState() => _AddTenantScreenState();
}

class _AddTenantScreenState extends ConsumerState<AddTenantScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController tenantStatusController = TextEditingController(
    text: "Active",
  );
  final TextEditingController tenantTypeController = TextEditingController(
    text: "Primary Tenant",
  );
  final TextEditingController monthlyRentController = TextEditingController();
  final TextEditingController securityDepositController =
      TextEditingController();

  DateTime? moveInDate;
  DateTime? moveOutDate;
  File? _selectedImage;
  String? _existingImageUrl;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null || dateStr.trim().isEmpty) return null;
    final trimmed = dateStr.trim();
    for (final format in [
      "dd MMM yyyy",
      "yyyy-MM-dd",
      "dd-MM-yyyy",
      "d MMM yyyy",
      "yyyy/MM/dd",
      "dd/MM/yyyy",
    ]) {
      try {
        return DateFormat(format).parse(trimmed);
      } catch (_) {}
    }
    try {
      return DateTime.parse(trimmed);
    } catch (_) {}
    return null;
  }

  @override
  void initState() {
    super.initState();

    if (widget.tenantId != null) {
      Future.microtask(() {
        _loadTenantDetails();
      });
    }
  }

  Future<void> _loadTenantDetails() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await ref.read(
        getTenantDetailsProvider(widget.tenantId!).future,
      );
      final tenant = response.data?.tenantDetails;

      if (tenant != null && mounted) {
        setState(() {
          nameController.text = tenant.name ?? tenant.tenantName ?? "";
          phoneController.text = tenant.phone ?? "";
          emailController.text = tenant.email ?? "";
          tenantStatusController.text =
              (tenant.tenantStatus != null && tenant.tenantStatus!.isNotEmpty)
              ? tenant.tenantStatus!
              : "Active";
          tenantTypeController.text =
              (tenant.tenantType != null && tenant.tenantType!.isNotEmpty)
              ? tenant.tenantType!
              : "Primary Tenant";
          monthlyRentController.text = tenant.monthlyRent?.toString() ?? "";
          securityDepositController.text =
              tenant.securityDeposit?.toString() ?? "";

          moveInDate = _parseDate(tenant.moveInDate);
          moveOutDate = _parseDate(tenant.moveOutDate);

          if (tenant.imageUrl != null &&
              tenant.imageUrl.toString().trim().isNotEmpty) {
            _existingImageUrl = tenant.imageUrl.toString().trim();
          }
        });
      }
    } catch (e, st) {
      log("Tenant details error: $e");
      log(st.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    tenantStatusController.dispose();
    tenantTypeController.dispose();
    monthlyRentController.dispose();
    securityDepositController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      showErrorSnackBar("Failed to pick image: $e");
    }
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Select Tenant Photo",
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBg,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.heading),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppColors.heading,
                              size: 28.sp,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Camera",
                            style: GoogleFonts.outfit(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBg,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.heading),
                            ),
                            child: Icon(
                              Icons.photo_library,
                              color: AppColors.heading,
                              size: 28.sp,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Gallery",
                            style: GoogleFonts.outfit(fontSize: 14.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> selectMoveInDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: moveInDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        moveInDate = pickedDate;
      });
    }
  }

  Future<void> selectMoveOutDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: moveOutDate ?? moveInDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        moveOutDate = pickedDate;
      });
    }
  }

  String formatDate(DateTime? date) {
    if (date == null) {
      return "dd-mm-yyyy";
    }

    return DateFormat("dd-MM-yyyy").format(date);
  }

  Future<void> _submitTenant({required int propertyId}) async {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final email = emailController.text.trim();
    final tenantStatus = tenantStatusController.text.trim().isNotEmpty
        ? tenantStatusController.text.trim()
        : "Active";
    final tenantType = tenantTypeController.text.trim().isNotEmpty
        ? tenantTypeController.text.trim()
        : "Primary Tenant";
    final monthlyRent = monthlyRentController.text.trim();
    final securityDeposit = securityDepositController.text.trim();

    if (name.isEmpty) {
      showErrorSnackBar("Please enter tenant name");
      return;
    }
    if (phone.isEmpty) {
      showErrorSnackBar("Please enter mobile number");
      return;
    }
    if (moveInDate == null) {
      showErrorSnackBar("Please select move-in date");
      return;
    }
    if (moveOutDate == null) {
      showErrorSnackBar("Please select expected move-out date");
      return;
    }
    if (monthlyRent.isEmpty) {
      showErrorSnackBar("Please enter monthly rent");
      return;
    }
    if (securityDeposit.isEmpty) {
      showErrorSnackBar("Please enter security deposit");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      MultipartFile? imageFile;
      if (_selectedImage != null) {
        imageFile = await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: _selectedImage!.path.split('/').last.split('\\').last,
        );
      }

      final service = ref.read(authServiceProvider);
      if (widget.tenantId != null) {
        await service.addTenant(
          // id: widget.tenantId!,
          propertyId: propertyId,
          name: name,
          phone: phone,
          email: email,
          monthlyRent: monthlyRent,
          securityDeposit: securityDeposit,
          moveInDate: DateFormat("yyyy-MM-dd").format(moveInDate!),
          moveOutDate: DateFormat("yyyy-MM-dd").format(moveOutDate!),
          tenantStatus: tenantStatus,
          tenantType: tenantType,
          image: imageFile,
        );
        showSuccessSnackBar("Tenant updated successfully!");
        ref.invalidate(getTenantDetailsProvider(widget.tenantId!));
        ref.invalidate(getTenantListProvider);
      } else {
        await service.addTenant(
          propertyId: propertyId,
          name: name,
          phone: phone,
          email: email,
          monthlyRent: monthlyRent,
          securityDeposit: securityDeposit,
          moveInDate: DateFormat("yyyy-MM-dd").format(moveInDate!),
          moveOutDate: DateFormat("yyyy-MM-dd").format(moveOutDate!),
          tenantStatus: tenantStatus,
          tenantType: tenantType,
          image: imageFile,
        );
        ref.invalidate(getTenantListProvider);
        showSuccessSnackBar("Tenant added successfully!");
      }
      if (mounted) {
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
  }

  @override
  Widget build(BuildContext context) {
    final propertyListState = ref.watch(getPropertyListProvider);
    final selectedProperty = propertyListState.valueOrNull?.data?.firstWhere(
      (p) => p.isSelected == true,
      orElse: () => propertyListState.valueOrNull?.data?.isNotEmpty == true
          ? propertyListState.valueOrNull!.data!.first
          : Datum(
              id: 20,
              propertyNameNumber: "Apartment A-204",
              complexName: "Green Valley Residency",
            ),
    );

    final resolvedPropertyId = widget.propertyId ?? selectedProperty?.id ?? 20;
    final resolvedPropertyName =
        widget.propertyName ??
        selectedProperty?.propertyNameNumber ??
        "Apartment A-204";
    final resolvedComplexName =
        widget.complexName ??
        selectedProperty?.complexName ??
        "Green Valley Residency";

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
                    "Add Tenant",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Add tenant details for your property",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(42, 41, 51, 0.6),
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
              SizedBox(height: 30.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.heading),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40.h,
                      width: 40.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: AppColors.heading),
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/auditImg.png",
                          height: 18.h,
                          width: 18.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Property",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.5),
                            fontSize: 13.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          resolvedPropertyName,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            fontSize: 17.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Text(
                          resolvedComplexName,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.5),
                            fontSize: 13.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      "Owner",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xffAE8130),
                        fontSize: 15.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),
              Text(
                "Tenant Information",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 17.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: const Color(0xFF000000),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: _showImagePicker,
                            child: _selectedImage != null
                                ? ClipOval(
                                    child: Image.file(
                                      _selectedImage!,
                                      width: 70.r,
                                      height: 70.r,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 70.r,
                                              height: 70.r,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Color(0xFF101C16),
                                                  width: 1.w,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.person,
                                                size: 30.sp,
                                              ),
                                            );
                                          },
                                    ),
                                  )
                                : (_existingImageUrl != null &&
                                      _existingImageUrl!.isNotEmpty)
                                ? ClipOval(
                                    child: Image.network(
                                      _existingImageUrl!,
                                      width: 70.r,
                                      height: 70.r,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return Container(
                                              width: 70.r,
                                              height: 70.r,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFF101C16,
                                                  ),
                                                  width: 1.w,
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.person,
                                                size: 30.sp,
                                              ),
                                            );
                                          },
                                    ),
                                  )
                                : Container(
                                    width: 70.r,
                                    height: 70.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: const Color(0xFF101C16),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Icon(Icons.person, size: 30.sp),
                                  ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: _showImagePicker,
                              child: Container(
                                width: 24.r,
                                height: 24.r,
                                decoration: BoxDecoration(
                                  color: AppColors.heading,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 13.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildTextfield(
                      label: "Tenant Full Name",
                      hintText: "Enter Tenant Name",
                      keyboardType: TextInputType.name,
                      controller: nameController,
                    ),
                    _buildTextfield(
                      label: "Mobile Number",
                      hintText: "Enter Mobile Number",
                      keyboardType: TextInputType.phone,
                      controller: phoneController,
                    ),
                    _buildTextfield(
                      label: "Email Address (Optional)",
                      hintText: "Enter Email Address",
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                    ),
                    _buildTextfield(
                      label: "Tenant Status",
                      hintText: "Active",
                      keyboardType: TextInputType.text,
                      controller: tenantStatusController,
                    ),
                    _buildTextfield(
                      label: "Tenant Type",
                      hintText: "Primary Tenant",
                      keyboardType: TextInputType.text,
                      controller: tenantTypeController,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                "Occupancy Details",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 17.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFCEF),
                  border: Border.all(color: AppColors.heading),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Move-in Date",
                            style: GoogleFonts.inter(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          GestureDetector(
                            onTap: selectMoveInDate,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 8.h,
                              ),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFCEF),
                                border: Border.all(color: AppColors.heading),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                formatDate(moveInDate),
                                style: GoogleFonts.inter(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  color: moveInDate == null
                                      ? const Color(0xff8C8C8C)
                                      : AppColors.heading,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expected Move-out",
                            style: GoogleFonts.inter(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 7.h),
                          GestureDetector(
                            onTap: selectMoveOutDate,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10.w,
                                vertical: 8.h,
                              ),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFCEF),
                                border: Border.all(color: AppColors.heading),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: Text(
                                formatDate(moveOutDate),
                                style: GoogleFonts.inter(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w400,
                                  color: moveOutDate == null
                                      ? const Color(0xff8C8C8C)
                                      : AppColors.heading,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 23.h),
              Text(
                "Rental Details",
                style: GoogleFonts.inter(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: const Color(0xFF000000),
                    width: 1.w,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTextfield(
                        label: "Monthly Rent",
                        hintText: "₹ Enter amount",
                        keyboardType: TextInputType.number,
                        controller: monthlyRentController,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildTextfield(
                        label: "Security Deposit",
                        hintText: "₹ Enter amount",
                        keyboardType: TextInputType.number,
                        controller: securityDepositController,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 26.h),
              SizedBox(
                width: double.infinity,
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    disabledBackgroundColor: AppColors.heading.withValues(
                      alpha: 0.7,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () => _submitTenant(propertyId: resolvedPropertyId),
                  child: isLoading
                      ? SizedBox(
                          width: 18.sp,
                          height: 18.sp,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Save Tenant",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: double.infinity,
                height: 36.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.scaffoldBg,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
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
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF000000),
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 7.h),
        Container(
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: const BoxDecoration(color: Colors.transparent),
          child: TextField(
            style: GoogleFonts.outfit(fontSize: 18.sp, letterSpacing: -0.2),
            controller: controller,
            cursorHeight: 18.h,
            cursorColor: AppColors.heading,
            cursorWidth: 1.5.w,
            keyboardType: keyboardType,
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
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 6.h,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
