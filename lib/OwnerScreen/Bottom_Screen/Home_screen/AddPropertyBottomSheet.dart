import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/getPropertyListProvider.dart';
import 'package:property_care/OwnerScreen/Register_Screen/provider/availableFlatsProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

void showAddPropertyBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (bottomSheetContext) {
      return const AddPropertyBottomSheet();
    },
  );
}

class AddPropertyBottomSheet extends ConsumerStatefulWidget {
  const AddPropertyBottomSheet({super.key});

  @override
  ConsumerState<AddPropertyBottomSheet> createState() =>
      _AddPropertyBottomSheetState();
}

class _AddPropertyBottomSheetState
    extends ConsumerState<AddPropertyBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();

  String? _selectedPropertyNameNumber;
  String? _selectComplexId;
  String? _selectedPropertyType;
  String? _selectedCarePackage;
  bool _isLoading = false;

  final List<Map<String, String>> _propertyTypeOptions = [
    {"label": "Apartment", "value": "apartment"},
    {"label": "Independent House", "value": "independent_house"},
    {"label": "Commercial", "value": "commercial"},
  ];

  final List<Map<String, String>> _carePackageOptions = [
    {"label": "Tenant Care", "value": "tenant_care"},
    {"label": "Premium Care", "value": "premium_care"},
    {"label": "Earn & Care", "value": "earn_n_care"},
  ];

  @override
  void dispose() {
    _locationController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _submitPropertyRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final location = _locationController.text.trim();
    final area = _areaController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(authServiceProvider);
      final response = await service.addProperyRequest(
        propertyNameNumber: _selectedPropertyNameNumber!,
        propertyType: _selectedPropertyType ?? "",
        location: location,
        area: area,
        carePackage: _selectedCarePackage ?? "",
        complexes: _selectComplexId ?? "",
      );
      showSuccessSnackBar("Property request submitted successfully!");
      ref.invalidate(getPropertyListProvider);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final getAvailableFlatState = ref.watch(getAvailableFlatsProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 12.h,
        bottom:
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom +
            20.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF8F5ED),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffA5A69F),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ADD NEW PROPERTY",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff171717),
                          letterSpacing: -0.54,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Submit details to add your property to management",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(42, 41, 51, 0.6),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xff101C16).withValues(alpha: 0.08),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                        color: const Color(0xff171717),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFDF2),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFF000000),
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Property Name & Number (Flat dropdown like Register Screen)
                    _fieldLabel("Property Name & Number *"),
                    getAvailableFlatState.when(
                      data: (data) {
                        final flats = data.data ?? [];
                        return DropdownButtonFormField<String>(
                          initialValue: _selectedPropertyNameNumber,
                          isExpanded: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select an apartment / flat";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: const Color(0xFF000000),
                            size: 20.sp,
                          ),
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            color: const Color(0xff101C16),
                          ),
                          decoration: _inputDecoration(
                            hintText: "Select Property / Flat",
                          ),
                          items: flats.map((flat) {
                            return DropdownMenuItem<String>(
                              value: flat.propertyNameNumber.toString(),
                              child: Text(
                                "${flat.propertyNameNumber ?? ''} (${flat.complex?.name ?? ""})",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value == null) return;

                            final selectedFlat = flats.firstWhere(
                              (flat) => flat.propertyNameNumber == value,
                            );
                            setState(() {
                              _selectedPropertyNameNumber =
                                  selectedFlat.propertyNameNumber;
                              _selectComplexId = selectedFlat.complexId
                                  ?.toString();
                            });
                          },
                        );
                      },
                      loading: () => Container(
                        height: 44.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color(0xFF000000),
                            width: 1.w,
                          ),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: const CircularProgressIndicator(
                            color: AppColors.heading,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                      error: (e, s) => Container(
                        height: 44.h,
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red, width: 1.w),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "Failed to load flats",
                          style: GoogleFonts.outfit(
                            color: Colors.red,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 14.h),
                    // // 2. Property Type Dropdown (full width, values: apartment, independent_house, commercial)
                    // _fieldLabel("Property Type *"),
                    // DropdownButtonFormField<String>(
                    //   initialValue: _selectedPropertyType,
                    //   isExpanded: true,
                    //   // validator: (value) {
                    //   //   if (value == null || value.isEmpty) {
                    //   //     return "Please select property type";
                    //   //   }
                    //   //   return null;
                    //   // },
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   icon: Icon(
                    //     Icons.keyboard_arrow_down,
                    //     color: const Color(0xFF000000),
                    //     size: 20.sp,
                    //   ),
                    //   style: GoogleFonts.outfit(
                    //     fontSize: 15.sp,
                    //     color: const Color(0xff101C16),
                    //   ),
                    //   decoration: _inputDecoration(
                    //     hintText: "Select Property Type",
                    //   ),
                    //   items: _propertyTypeOptions.map((item) {
                    //     return DropdownMenuItem<String>(
                    //       value: item["value"],
                    //       child: Text(
                    //         item["label"]!,
                    //         style: GoogleFonts.outfit(
                    //           fontSize: 15.sp,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColors.heading,
                    //           letterSpacing: -0.2,
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedPropertyType = value;
                    //     });
                    //   },
                    // ),
                    // SizedBox(height: 14.h),
                    // // 3. Property Location / Address
                    // _fieldLabel("Property Location / Address *"),
                    // _customTextField(
                    //   controller: _locationController,
                    //   hintText: "e.g. Emirates Hills, Dubai, UAE",
                    //   // validator: (value) {
                    //   //   if (value == null || value.trim().isEmpty) {
                    //   //     return "Please enter property location";
                    //   //   }
                    //   //   return null;
                    //   // },
                    // ),
                    // SizedBox(height: 14.h),
                    // // 4. Property Area
                    // _fieldLabel("Property Area *"),
                    // _customTextField(
                    //   controller: _areaController,
                    //   hintText: "e.g. 2,400 sq. ft.",
                    //   // validator: (value) {
                    //   //   if (value == null || value.trim().isEmpty) {
                    //   //     return "Please enter property area";
                    //   //   }
                    //   //   return null;
                    //   // },
                    // ),
                    // SizedBox(height: 14.h),
                    // // 5. Care Package Dropdown (full width, values: tenant_care, premium_care, earn_n_care)
                    // _fieldLabel("Care Package *"),
                    // DropdownButtonFormField<String>(
                    //   initialValue: _selectedCarePackage,
                    //   isExpanded: true,
                    //   // validator: (value) {
                    //   //   if (value == null || value.isEmpty) {
                    //   //     return "Please select a care package";
                    //   //   }
                    //   //   return null;
                    //   // },
                    //   autovalidateMode: AutovalidateMode.onUserInteraction,
                    //   icon: Icon(
                    //     Icons.keyboard_arrow_down,
                    //     color: const Color(0xFF000000),
                    //     size: 20.sp,
                    //   ),
                    //   style: GoogleFonts.outfit(
                    //     fontSize: 15.sp,
                    //     color: const Color(0xff101C16),
                    //   ),
                    //   decoration: _inputDecoration(
                    //     hintText: "Select Care Package",
                    //   ),
                    //   items: _carePackageOptions.map((item) {
                    //     return DropdownMenuItem<String>(
                    //       value: item["value"],
                    //       child: Text(
                    //         item["label"]!,
                    //         style: GoogleFonts.outfit(
                    //           fontSize: 15.sp,
                    //           fontWeight: FontWeight.w500,
                    //           color: AppColors.heading,
                    //           letterSpacing: -0.2,
                    //         ),
                    //       ),
                    //     );
                    //   }).toList(),
                    //   onChanged: (value) {
                    //     setState(() {
                    //       _selectedCarePackage = value;
                    //     });
                    //   },
                    // ),
                  ],
                ),
              ),
              // SizedBox(height: 16.h),
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              //   decoration: BoxDecoration(
              //     color: const Color(0xff101C16).withValues(alpha: 0.05),
              //     borderRadius: BorderRadius.circular(8.r),
              //     border: Border.all(
              //       color: const Color(0xFF101C16).withValues(alpha: 0.4),
              //       width: 0.8.w,
              //     ),
              //   ),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Icon(
              //         Icons.info_outline,
              //         size: 17.sp,
              //         color: const Color(0xff101C16),
              //       ),
              //       SizedBox(width: 8.w),
              //       Expanded(
              //         child: Text(
              //           "After submission, your property request will be reviewed by the management team. Once verified, it will be added to your properties list.",
              //           style: GoogleFonts.outfit(
              //             fontSize: 12.sp,
              //             fontWeight: FontWeight.w400,
              //             color: const Color(0xFF2A2933),
              //             letterSpacing: -0.2,
              //             height: 1.35,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 22.h),
              SizedBox(
                width: double.infinity,
                height: 46.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    disabledBackgroundColor: AppColors.heading.withValues(
                      alpha: 0.6,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: _isLoading ? null : _submitPropertyRequest,
                  child: _isLoading
                      ? SizedBox(
                          width: 20.w,
                          height: 20.w,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          "Submit Property Request",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: -0.2,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: double.infinity,
                height: 42.h,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.heading, width: 1.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF000000),
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      isDense: true,
      hintText: hintText,
      hintStyle: GoogleFonts.outfit(
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
        color: const Color.fromRGBO(0, 0, 0, 0.6),
        letterSpacing: -0.3,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: BorderSide(color: const Color(0xFF000000), width: 1.w),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: BorderSide(color: const Color(0xFF000000), width: 1.w),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: BorderSide(color: const Color(0xFF000000), width: 1.w),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: BorderSide(color: Colors.red, width: 1.w),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.r),
        borderSide: BorderSide(color: Colors.red, width: 1.w),
      ),
      errorStyle: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.red),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: GoogleFonts.outfit(
        fontSize: 15.sp,
        color: const Color(0xff101C16),
        letterSpacing: -0.2,
      ),
      decoration: _inputDecoration(hintText: hintText),
    );
  }
}
