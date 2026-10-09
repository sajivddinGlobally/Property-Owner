import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/getPropertyListProvider.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/ownerDashboardProvider.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/my_bottom_screen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Property_Screen/Provider/propertyDetailsProvider.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/Utils/preety.dio.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

import 'Provider/getAssignedProvider.dart';

class AddPropertyFormScreen extends ConsumerStatefulWidget {
  const AddPropertyFormScreen({super.key});

  @override
  ConsumerState<AddPropertyFormScreen> createState() =>
      _AddPropertyFormScreenState();
}

class _AddPropertyFormScreenState extends ConsumerState<AddPropertyFormScreen> {
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _flatNumberController = TextEditingController();
  final TextEditingController _complexIdController = TextEditingController();
  final TextEditingController _customComplexController =
      TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _floorsController = TextEditingController();
  String? _selectedCategory = "residential";
  String? _selectedPropertyType;
  String? _selectedCarePackage;
  final TextEditingController _monthlyMaintenanceFeeController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  String? _occupancyStatus;
  String? complexId;
  bool _isCustomComplex = false;
  bool _isLoading = false;

  final List<Map<String, String>> _categoryOptions = [
    {"label": "Residential", "value": "residential"},
    {"label": "Commercial", "value": "commercial"},
  ];

  final List<Map<String, String>> _residentialTypeOptions = [
    {"label": "Independent House", "value": "independent_house"},
    {"label": "Apartment Complex", "value": "apartment"},
    {"label": "Villa Compound", "value": "villa_compound"},
  ];

  final List<Map<String, String>> _commercialTypeOptions = [
    {"label": "Commercial Space / Building", "value": "commercial"},
  ];

  final List<Map<String, String>> _carePackageOptions = [
    {"label": "Tenant Care", "value": "tenant_care"},
    {"label": "Earn n' Care", "value": "earn_n_care"},
    {"label": "Premium Care", "value": "premium_care"},
  ];

  final List<Map<String, String>> _occupancyOptions = [
    {"label": "Self Occupied", "value": "self_occupied"},
    {"label": "Tenant Occupied / Rented", "value": "tenant_occupied"},
    {"label": "Vacant", "value": "vacant"},
  ];

  @override
  void dispose() {
    _flatNumberController.dispose();
    _complexIdController.dispose();
    _customComplexController.dispose();
    _bedroomsController.dispose();
    _floorsController.dispose();
    _monthlyMaintenanceFeeController.dispose();
    _locationController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      log("Image picker error: $e");
    }
  }

  void _showImagePickerModal() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(
            "Select Property Image",
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.heading,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
              child: Text(
                "Camera",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                ),
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
              child: Text(
                "Gallery",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            isDefaultAction: true,
            child: Text(
              "Cancel",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitProperty() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final service = ref.read(authServiceProvider);
      final bool isCommercial =
          (_selectedCategory == "commercial" ||
          _selectedPropertyType == "commercial");
      final bool isIndependent =
          (_selectedPropertyType == "independent_house" || isCommercial);
      final bool hasMmc =
          isCommercial || (_selectedPropertyType != "independent_house");

      String? finalComplexId = complexId;
      if (_isCustomComplex && _customComplexController.text.trim().isNotEmpty) {
        finalComplexId = _customComplexController.text.trim();
      }
      if (finalComplexId != null && finalComplexId.trim().isEmpty) {
        finalComplexId = null;
      }

      final res = await service.createProperty(
        image: _selectedImage,
        flatNumber: _flatNumberController.text.trim(),
        complexId: finalComplexId,
        propertyType: _selectedPropertyType ?? "",
        carePackage: _selectedCarePackage ?? "",
        hasMmc: hasMmc,
        monthlyMaintenanceFee:
            hasMmc && _monthlyMaintenanceFeeController.text.trim().isNotEmpty
            ? _monthlyMaintenanceFeeController.text.trim()
            : "0",
        location: _locationController.text.trim(),
        area: _areaController.text.trim(),
        isIndependent: isIndependent,
        floors: _floorsController.text.trim().isNotEmpty
            ? _floorsController.text.trim()
            : null,
        bedrooms: _bedroomsController.text.trim().isNotEmpty
            ? _bedroomsController.text.trim()
            : null,
        occupancyStatus: _occupancyStatus,
      );
      if (res.status == true) {
        var box = Hive.box("userdata");
        await box.put(
          "property_name_number",
          res.data?.propertyNameNumber.toString(),
        );
        showSuccessSnackBar("Property added successfully!");
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => MyBottomScreen()),
          (route) => false,
        );
      } else {
        showErrorSnackBar(res.message.toString());
      }
    } catch (e) {
      log("Submit Property Error: $e");
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
    final getUnassignedData = ref.watch(getUnassignedPropertyProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top graphics matching Register/Login screen
              SizedBox(
                width: double.infinity,
                height: 150.h,
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

              // Logo & Title
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "assets/new_logo.jpeg",
                        width: 90.w,
                        height: 90.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "ADD PROPERTY",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        fontSize: 22.sp,
                        letterSpacing: -0.39,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Enter your property details below to get started",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff26332D),
                        fontSize: 15.sp,
                        letterSpacing: -0.39,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              getUnassignedData.when(
                data: (data) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 16.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffFFFDF2),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: const Color(0xFF000000),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "PROPERTY INFORMATION",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000000),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        fieldLabel("Property Image (Optional)"),
                        _buildImagePickerField(),
                        SizedBox(height: 14.h),

                        // 1. Property Category (Residential / Commercial)
                        fieldLabel("Property Category *"),
                        _buildDropdownField(
                          value: _selectedCategory,
                          hintText: "Select Category",
                          items: _categoryOptions,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedCategory = val;
                                _selectedPropertyType = null;
                                complexId = null;
                                _isCustomComplex = false;
                                _customComplexController.clear();
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select property category";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),
                        // 2. Property Type (Independent House, Apartment, Villa, etc.)
                        fieldLabel("Property Type *"),
                        _buildDropdownField(
                          value: _selectedPropertyType,
                          hintText: "Select Property Type",
                          items: _selectedCategory == "commercial"
                              ? _commercialTypeOptions
                              : _residentialTypeOptions,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedPropertyType = val;
                                if (_selectedPropertyType != "apartment" &&
                                    _selectedPropertyType != "villa_compound") {
                                  complexId = null;
                                  _isCustomComplex = false;
                                  _customComplexController.clear();
                                }
                                if (_selectedPropertyType ==
                                    "independent_house") {
                                  _monthlyMaintenanceFeeController.clear();
                                }
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a property type";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        // 3. House / Building Number
                        fieldLabel("House/ Building number *"),
                        customTextField(
                          controller: _flatNumberController,
                          hintText:
                              "Enter House/ Building Number (e.g. Flat D-704, Villa 12)",
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter house/ building number";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        // 4. Complex Name (Activated only for Apartment complex or Villa compound)
                        if (_selectedPropertyType == "apartment" ||
                            _selectedPropertyType == "villa_compound") ...[
                          fieldLabel("Complex Name *"),
                          DropdownButtonFormField<String>(
                            padding: EdgeInsets.zero,
                            isExpanded: true,
                            value: complexId,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select a complex name";
                              }
                              return null;
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_down,
                              color: const Color(0xFF000000),
                              size: 20.sp,
                            ),
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff101C16),
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Select Complex Name',
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 15.sp,
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
                                  color: Colors.red,
                                  width: 1.w,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4.r),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.w,
                                ),
                              ),
                            ),
                            items: [
                              ...?data.data?.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item.id.toString(),
                                  child: Text(
                                    item.address != null &&
                                            item.address!.isNotEmpty
                                        ? "${item.name ?? ''} (${item.address})"
                                        : "${item.name ?? ''}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                );
                              }),
                              // TODO: Uncomment once backend supports dynamic/custom complex creation
                              // DropdownMenuItem<String>(
                              //   value: "other",
                              //   child: Text(
                              //     "+ Other (Enter custom complex name)",
                              //     style: GoogleFonts.outfit(
                              //       fontSize: 16.sp,
                              //       fontWeight: FontWeight.w600,
                              //       color: const Color(0xff101C16),
                              //     ),
                              //   ),
                              // ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                // TODO: Uncomment once backend supports custom complex
                                // if (value == "other") {
                                //   _isCustomComplex = true;
                                //   complexId = null;
                                // } else {
                                //   _isCustomComplex = false;
                                //   complexId = value;
                                //   _customComplexController.clear();
                                // }
                                complexId = value;
                              });
                            },
                          ),
                          // TODO: Uncomment once backend supports custom complex
                          // if (_isCustomComplex) ...[
                          //   SizedBox(height: 10.h),
                          //   customTextField(
                          //     controller: _customComplexController,
                          //     hintText: "Enter your complex name",
                          //     validator: (value) {
                          //       if (_isCustomComplex &&
                          //           (value == null || value.trim().isEmpty)) {
                          //         return "Please enter your complex name";
                          //       }
                          //       return null;
                          //     },
                          //   ),
                          // ],
                          SizedBox(height: 14.h),
                        ],

                        // 5. Care Package
                        fieldLabel("Care Package *"),
                        _buildDropdownField(
                          value: _selectedCarePackage,
                          hintText: "Select Care Package",
                          items: _carePackageOptions,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedCarePackage = val;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a care package";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 14.h),

                        // 6. Monthly Maintenance Fee (Only for Apartment, Villa, or Commercial)
                        if (_selectedPropertyType != null &&
                            _selectedPropertyType != "independent_house") ...[
                          fieldLabel("Monthly Maintenance Fee (Optional)"),
                          customTextField(
                            controller: _monthlyMaintenanceFeeController,
                            hintText: "Enter Monthly Maintenance Fee",
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 14.h),
                        ],

                        // 7. Location
                        fieldLabel("Location (Optional)"),
                        customTextField(
                          controller: _locationController,
                          hintText:
                              "Enter Location (e.g. Tower D, Green Valley)",
                        ),
                        SizedBox(height: 14.h),

                        // 8. Area
                        fieldLabel("Area (Optional)"),
                        customTextField(
                          controller: _areaController,
                          hintText: "Enter Area (e.g. 1,500 sq ft)",
                        ),
                        SizedBox(height: 14.h),

                        // 9. No. of Bedrooms
                        fieldLabel("No. of Bedrooms (Optional)"),
                        customTextField(
                          controller: _bedroomsController,
                          hintText: "Enter number of bedrooms (e.g. 2, 3 BHK)",
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 14.h),

                        // 10. No. of Floors
                        fieldLabel("No. of Floors (Optional)"),
                        customTextField(
                          controller: _floorsController,
                          hintText: "Enter number of floors (e.g. 1, 2, G+1)",
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 14.h),

                        // 11. Occupancy Status
                        fieldLabel("Occupancy Status (Optional)"),
                        _buildDropdownField(
                          value: _occupancyStatus,
                          hintText: "Select Occupancy Status",
                          items: _occupancyOptions,
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _occupancyStatus = val;
                              });
                            }
                          },
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          height: 52.h,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF101C16),
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            onPressed: _isLoading ? null : _submitProperty,
                            child: _isLoading
                                ? Center(
                                    child: SizedBox(
                                      width: 20.w,
                                      height: 20.h,
                                      child: const CircularProgressIndicator(
                                        color: Color(0xffFFFFFF),
                                        strokeWidth: 1.5,
                                      ),
                                    ),
                                  )
                                : Text(
                                    "Add Property",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp,
                                      color: const Color(0xffFFFFFF),
                                      letterSpacing: 0.2,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                error: (e, s) {
                  log("error $e");
                  return Center(child: Text("Something went wrong"));
                },
                loading: () {
                  return SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.heading,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerField() {
    if (_selectedImage != null) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFF000000), width: 1.w),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(5.r)),
              child: Image.file(
                _selectedImage!,
                height: 160.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _showImagePickerModal,
                    child: Text(
                      "Change Image",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    child: Text(
                      "Remove",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: _showImagePickerModal,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: const Color(0xFF000000), width: 1.w),
          color: const Color(0xffFFFDF2),
        ),
        child: Column(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 32.sp,
              color: const Color(0xFF101C16),
            ),
            SizedBox(height: 6.h),
            Text(
              "Upload Property Image",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF000000),
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Supports JPG, PNG (Tap to select)",
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color.fromRGBO(0, 0, 0, 0.6),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    String? value,
    required String hintText,
    required List<Map<String, String>> items,
    required ValueChanged<String?> onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return DropdownButtonFormField<String>(
      validator: validator,
      isExpanded: true,
      value: value,
      hint: Text(
        hintText,
        style: GoogleFonts.outfit(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(0, 0, 0, 0.6),
          letterSpacing: -0.3,
        ),
      ),
      icon: Icon(
        Icons.keyboard_arrow_down,
        color: const Color(0xFF000000),
        size: 20.sp,
      ),
      dropdownColor: const Color(0xffFFFDF2),
      style: GoogleFonts.outfit(
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xff101C16),
        letterSpacing: -0.2,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(0, 0, 0, 0.6),
          letterSpacing: -0.3,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: const Color(0xFF000000), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: const Color(0xFF000000), width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item["value"],
          child: Text(
            item["label"]!,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
              letterSpacing: -0.2,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Widget fieldLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF000000),
          letterSpacing: -0.3,
        ),
      ),
    );
  }

  Widget customTextField({
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
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
        color: const Color(0xff101C16),
        letterSpacing: -0.2,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: const Color.fromRGBO(0, 0, 0, 0.6),
          letterSpacing: -0.3,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: const Color(0xFF000000), width: 1.w),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: const Color(0xFF000000), width: 1.5.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6.r),
          borderSide: BorderSide(color: Colors.red, width: 1.w),
        ),
      ),
    );
  }
}
