import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:property_care/OwnerScreen/ServiceRequest_Screen/Provider/getServiceProvider.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:dio/dio.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/getPropertyListProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/propertyListModel.dart';

class CreateServiceRequest extends ConsumerStatefulWidget {
  const CreateServiceRequest({super.key});

  @override
  ConsumerState<CreateServiceRequest> createState() =>
      _CreateServiceRequestState();
}

class _CreateServiceRequestState extends ConsumerState<CreateServiceRequest> {
  int selectedPriority = 1;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  bool isLoading = false;

  final List<String> priorities = ["Low", "Medium", "High"];
  int selectedIndex = -1;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final List<String> categories = [
    "Electrical",
    "Plumbing",
    "Civil",
    "Cleaning",
    "Security",
    "Other",
  ];

  final List<Map<String, dynamic>> serviceCategories = [
    {
      "id": "plumbing",
      "label": "plumbing",
      "types": [
        "Tap & Faucet Repair / Leakage",
        "Pipe Leakage / Drainage Blockage",
        "Toilet & Flush Tank Mechanism Issue",
        "Water Heater / Geyser Service",
        "Low Water Pressure / Shower Issue",
        "Sink & Basin Drainage Issue",
        "Water Tank / Motor Issue",
        "Other Plumbing Work",
      ],
    },
    {
      "id": "electrical",
      "label": "electrical",
      "types": [
        "Light Fixture / Bulb Replacement",
        "Switch, Socket & Plug Issue",
        "Circuit Breaker / MCB Tripping",
        "Ceiling Fan / Exhaust Fan Repair",
        "Wiring & Short Circuit Inspection",
        "Doorbell & Intercom Repair",
        "Appliance Power Connection",
        "Other Electrical Work",
      ],
    },
    {
      "id": "housekeeping",
      "label": "housekeeping",
      "types": [
        "Full Deep Apartment Cleaning",
        "Kitchen & Appliance Deep Cleaning",
        "Bathroom Deep Sanitization",
        "Carpet & Sofa Shampooing",
        "Balcony & Window Glass Cleaning",
        "Move-in / Move-out Cleaning",
        "Garbage & Waste Disposal",
        "Other Housekeeping Work",
      ],
    },
    {
      "id": "security",
      "label": "security",
      "types": [
        "Main Door Lock & Key Issue",
        "Access Card & Key Fob Issue",
        "CCTV & Video Doorbell Issue",
        "Intercom & Security Screen Repair",
        "Window Latch & Safety Grill Issue",
        "Unauthorized Access / Noise Complaint",
        "Security Guard Assistance",
        "Other Security Request",
      ],
    },
    {
      "id": "general",
      "label": "general",
      "types": [
        "Handyman General Repairs",
        "AC Filter Cleaning & Servicing",
        "Wall Touch-up & Patch Painting",
        "Door Hinge & Stopper Alignment",
        "Curtain Rod & Wall Mounting",
        "Tile, Grouting & Marble Repair",
        "Pest Control Inspection",
        "Other General Maintenance",
      ],
    },
  ];
  String? selectedCategory;
  String? selectedService;
  final TextEditingController customServiceController = TextEditingController();
  List<String> customServices = [];
  List<String> get availableServices {
    if (selectedCategory == null) {
      return [];
    }
    final category = serviceCategories.firstWhere(
      (item) => item["id"] == selectedCategory,
    );
    final List<String> types = List<String>.from(category["types"]);
    return [...types, ...customServices];
  }

  String formatCategory(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  File? selectedFile;
  String? selectedFileName;
  String? selectedFileType;
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xffA5A69F),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Add Attachment",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff101C16),
                  ),
                ),
                SizedBox(height: 18.h),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 0.8.w,
                      ),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(
                      Icons.image_outlined,
                      color: const Color(0xff101C16),
                      size: 21.sp,
                    ),
                  ),
                  title: Text(
                    "Upload Image",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                    ),
                  ),
                  subtitle: Text(
                    "JPG, JPEG or PNG",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: const Color(0xff777777),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: const Color(0xff101C16),
                  ),
                ),
                SizedBox(height: 5.h),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    _pickDocument();
                  },
                  leading: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 0.8.w,
                      ),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Icon(
                      Icons.description_outlined,
                      color: const Color(0xff101C16),
                      size: 21.sp,
                    ),
                  ),
                  title: Text(
                    "Upload Document",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                    ),
                  ),
                  subtitle: Text(
                    "PDF, DOC or DOCX",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: const Color(0xff777777),
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: const Color(0xff101C16),
                  ),
                ),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        return;
      }
      final File file = File(image.path);
      final int fileSize = await file.length();
      const int maxSize = 10 * 1024 * 1024;
      if (fileSize > maxSize) {
        showErrorSnackBar("Image size must be less than 10 MB.");
        return;
      }
      setState(() {
        selectedFile = file;
        selectedFileName = image.name;
        selectedFileType = "image";
      });
    } catch (e) {
      showErrorSnackBar("Unable to select image.");
    }
  }

  Future<void> _pickDocument() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf", "doc", "docx"],
      );
      if (result == null) {
        return;
      }
      final PlatformFile fileData = result.files.single;
      if (fileData.path == null) {
        showErrorSnackBar("Unable to select document.");
        return;
      }
      final File file = File(fileData.path!);
      final int fileSize = await file.length();
      const int maxSize = 10 * 1024 * 1024;
      if (fileSize > maxSize) {
        showErrorSnackBar("Document size must be less than 10 MB.");
        return;
      }
      setState(() {
        selectedFile = file;
        selectedFileName = fileData.name;
        selectedFileType = "document";
      });
    } catch (e) {
      showErrorSnackBar("Unable to select document.");
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final propertyListState = ref.watch(getPropertyListProvider);

    final activeProperty = propertyListState.valueOrNull?.data?.firstWhere(
      (p) => p.isSelected == true,
      orElse: () =>
          (propertyListState.valueOrNull?.data != null &&
              propertyListState.valueOrNull!.data!.isNotEmpty)
          ? propertyListState.valueOrNull!.data!.first
          : Datum(),
    );

    final propertyId = activeProperty?.id;

    final propertyName =
        (activeProperty?.propertyNameNumber?.isNotEmpty == true)
        ? activeProperty!.propertyNameNumber!
        : "Apartment A-204";

    final complexName = (activeProperty?.complexName?.isNotEmpty == true)
        ? activeProperty!.complexName!
        : "Green Valley Residency";

    final propertyImage = (activeProperty?.imageUrl?.isNotEmpty == true)
        ? activeProperty!.imageUrl!
        : "";

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
                    "Create Service Request",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "REQUEST A PROPERTY SERVICE",
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
              SizedBox(height: 30.h),
              propertyListState.isLoading &&
                      propertyListState.valueOrNull == null
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      height: 80.h,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.heading,
                          strokeWidth: 1.5.w,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: propertyImage.isNotEmpty
                                  ? Image.network(
                                      propertyImage,
                                      height: 40.h,
                                      width: 40.w,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Center(
                                                child: Image.asset(
                                                  "assets/auditImg.png",
                                                  height: 18.h,
                                                  width: 18.w,
                                                ),
                                              ),
                                    )
                                  : Center(
                                      child: Image.asset(
                                        "assets/auditImg.png",
                                        height: 18.h,
                                        width: 18.w,
                                      ),
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
                                  color: Color.fromRGBO(42, 41, 51, 0.5),
                                  fontSize: 13.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                propertyName,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  fontSize: 17.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                complexName,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.5),
                                  fontSize: 13.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              SizedBox(height: 30.h),
              Text(
                "Service Information",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 17.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Service Category *",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 14.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              _buildDropdown(
                value: selectedCategory == null
                    ? null
                    : formatCategory(selectedCategory!),
                hint: "Select Service Category",
                items: serviceCategories
                    .map((item) => formatCategory(item["id"] as String))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value?.toLowerCase();

                    // Category change hone par purani service reset
                    selectedService = null;
                  });
                },
              ),
              SizedBox(height: 16.h),
              Text(
                "Select Service *",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 17.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              _buildDropdown(
                value: selectedService,
                hint: selectedCategory == null
                    ? "Select category first"
                    : "Select Service",
                items: availableServices,
                onChanged: (value) {
                  setState(() {
                    selectedService = value;
                    titleController.text = value ?? "";
                  });
                },
              ),
              SizedBox(height: 10.h),
              // GridView.builder(
              //   shrinkWrap: true,
              //   physics: const NeverScrollableScrollPhysics(),
              //   itemCount: 4,
              //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //     crossAxisCount: 2,
              //     crossAxisSpacing: 22.w,
              //     mainAxisSpacing: 18.h,
              //     childAspectRatio: 2.35,
              //   ),
              //   itemBuilder: (context, index) {
              //     final List<Map<String, dynamic>> services = [
              //       {
              //         "title": "Plumbing",
              //         "subtitle": "Repair/service",
              //         "icon": Icons.plumbing_outlined,
              //         "color": const Color(0xff292832),
              //       },
              //       {
              //         "title": "Electrical",
              //         "subtitle": "Repair / Inspection",
              //         "icon": Icons.bolt_outlined,
              //         "color": const Color(0xff292832),
              //       },
              //       {
              //         "title": "AC Service",
              //         "subtitle": "Maintenance",
              //         "icon": Icons.article_outlined,
              //         "color": const Color(0xff292832),
              //       },
              //       {
              //         "title": "General",
              //         "subtitle": "Property Service",
              //         "icon": Icons.home_outlined,
              //         "color": const Color(0xff292832),
              //       },
              //     ];
              //     final service = services[index];
              //     final bool isSelected = selectedIndex == index;
              //     return GestureDetector(
              //       onTap: () {
              //         setState(() {
              //           selectedIndex = index;
              //         });
              //         print("Selected Service: ${service["title"]}");
              //         // Yahan navigation bhi kar sakte ho
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(
              //         //     builder: (context) => NextScreen(),
              //         //   ),
              //         // );
              //       },
              //       child: Container(
              //         padding: EdgeInsets.symmetric(
              //           horizontal: 11.w,
              //           vertical: 10.h,
              //         ),
              //         decoration: BoxDecoration(
              //           color: isSelected
              //               ? const Color(0xffFFF5D6)
              //               : const Color(0xffFFFCEF),
              //           border: Border.all(
              //             color: isSelected
              //                 ? const Color(0xffC58A20)
              //                 : service["color"],
              //             width: isSelected ? 1.5 : 1.2,
              //           ),
              //           borderRadius: BorderRadius.circular(3.r),
              //         ),
              //         child: Row(
              //           children: [
              //             Container(
              //               width: 45.w,
              //               height: 45.h,
              //               alignment: Alignment.center,
              //               decoration: BoxDecoration(
              //                 color: const Color(0xffFFFCEF),
              //                 border: Border.all(
              //                   color: service["color"],
              //                   width: 1.1,
              //                 ),
              //                 borderRadius: BorderRadius.circular(4.r),
              //               ),
              //               child: Icon(
              //                 service["icon"],
              //                 size: 23.sp,
              //                 color: service["color"],
              //               ),
              //             )
              //             SizedBox(width: 10.w),
              //             Expanded(
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Text(
              //                     service["title"],
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: GoogleFonts.outfit(
              //                       fontSize: 17.sp,
              //                       fontWeight: FontWeight.w500,
              //                       color: service["color"],
              //                       letterSpacing: -0.3,
              //                     ),
              //                   ),
              //                   SizedBox(height: 1.h),
              //                   Text(
              //                     service["subtitle"],
              //                     maxLines: 1,
              //                     overflow: TextOverflow.ellipsis,
              //                     style: GoogleFonts.outfit(
              //                       fontSize: 14.sp,
              //                       fontWeight: FontWeight.w400,
              //                       color:
              //                           service["color"] ==
              //                               const Color(0xffC58A20)
              //                           ? const Color(0xffC58A20)
              //                           : const Color.fromRGBO(42, 41, 51, 0.6),
              //                       letterSpacing: -0.2,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   },
              // ),
              SizedBox(height: 16.h),
              Text(
                "Service Request Title *",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 17.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                height: 55.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFDF2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xff101C16), width: 1),
                ),
                child: Center(
                  child: TextField(
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                    controller: titleController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "e.g. Bathroom tap repair",
                      hintStyle: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff8B8D8B),
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      // Exact vertical center
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                "Service Details *",
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFDF2),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: const Color(0xff101C16), width: 1),
                ),
                child: TextField(
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF101C16),
                    letterSpacing: -0.2,
                  ),
                  controller: descriptionController,
                  minLines: 5,
                  maxLines: 7,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    hintText: "Describe your service request...",
                    hintStyle: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff8B8D8B),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Text(
                "Preferred Schedule",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 17.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            selectedDate = pickedDate;
                          });
                        }
                      },
                      child: Container(
                        height: 41.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFDF2),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedDate == null
                                    ? "dd-mm-yyyy"
                                    : "${selectedDate!.day.toString().padLeft(2, '0')}-"
                                          "${selectedDate!.month.toString().padLeft(2, '0')}-"
                                          "${selectedDate!.year}",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: selectedDate == null
                                      ? const Color(0xff8B8D8B)
                                      : const Color(0xff292832),
                                ),
                              ),
                            ),

                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20.sp,
                              color: const Color(0xff292832),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 20.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (pickedTime != null) {
                          setState(() {
                            selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Container(
                        height: 41.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: const Color(0xffFFFDF2),
                          borderRadius: BorderRadius.circular(6.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedTime == null
                                    ? "10:10AM"
                                    : selectedTime!.format(context),
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: selectedTime == null
                                      ? const Color(0xff8B8D8B)
                                      : const Color(0xff292832),
                                ),
                              ),
                            ),

                            Icon(
                              Icons.calendar_today_outlined,
                              size: 20.sp,
                              color: const Color(0xff292832),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                "Priority",
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  fontSize: 17.sp,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 10.h),
              _buildPriority(),
              SizedBox(height: 30.h),
              Text(
                "Attach Supporting Document / Image",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101C16),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 10.h),
              GestureDetector(
                onTap: () {
                  _showAttachmentOptions();
                },
                child: DottedBorder(
                  color: const Color(0xff101C16),
                  strokeWidth: 1,
                  dashPattern: const [2, 2],
                  radius: Radius.circular(10.r),
                  child: Container(
                    height: 104.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: selectedFile == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 35.w,
                                height: 35.w,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xFF101C16),
                                    width: 1.w,
                                  ),
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                                child: Icon(
                                  Icons.file_upload_outlined,
                                  size: 18.sp,
                                  color: const Color(0xff101C16),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Add Attachment",
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF101C16),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    "JPG, PNG or PDF · Max 10 MB",
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(153, 42, 41, 51),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff101C16),
                                      width: 0.8.w,
                                    ),
                                    borderRadius: BorderRadius.circular(5.r),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4.r),
                                    child:
                                        selectedFileType == "image" &&
                                            selectedFile != null
                                        ? Image.file(
                                            selectedFile!,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.description_outlined,
                                            size: 20.sp,
                                            color: const Color(0xff101C16),
                                          ),
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    selectedFileName ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff101C16),
                                    ),
                                  ),
                                ),

                                SizedBox(width: 8.w),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedFile = null;
                                      selectedFileName = null;
                                      selectedFileType = null;
                                    });
                                  },
                                  child: Icon(
                                    Icons.close,
                                    size: 19.sp,
                                    color: const Color(0xff101C16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              _buildInfoBox(),
              SizedBox(height: 30.h),
              SizedBox(
                width: double.infinity,
                height: 49.h,
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedCategory == null) {
                      showErrorSnackBar("Please select a service category");
                      return;
                    }
                    // if (selectedIndex == -1) {
                    //   showErrorSnackBar("Please select a service type");
                    //   return;
                    // }
                    if (selectedService == null) {
                      showErrorSnackBar("Please select a service");
                      return;
                    }
                    if (titleController.text.trim().isEmpty) {
                      showErrorSnackBar("Please enter a service title");
                      return;
                    }
                    if (descriptionController.text.trim().isEmpty) {
                      showErrorSnackBar("Please enter service details");
                      return;
                    }
                    if (selectedDate == null) {
                      showErrorSnackBar("Please select a preferred date");
                      return;
                    }
                    if (selectedTime == null) {
                      showErrorSnackBar("Please select a preferred time");
                      return;
                    }

                    final servicesList = [
                      "Plumbing",
                      "Electrical",
                      "AC Service",
                      "General",
                    ];

                    String formattedDate =
                        "${selectedDate!.year}-"
                        "${selectedDate!.month.toString().padLeft(2, '0')}-"
                        "${selectedDate!.day.toString().padLeft(2, '0')}";
                    String formattedTime = selectedTime!.format(context);

                    MultipartFile? attachment;
                    if (selectedFile != null) {
                      attachment = await MultipartFile.fromFile(
                        selectedFile!.path,
                        filename: selectedFileName,
                      );
                    }

                    setState(() {
                      isLoading = true;
                    });

                    try {
                      final service = ref.read(authServiceProvider);
                      await service.createService(
                        // serviceCategory: selectedCategory!,
                        // serviceType: servicesList[selectedIndex],
                        serviceCategory: selectedCategory!,
                        serviceType: selectedService!,
                        title: titleController.text.trim(),
                        details: descriptionController.text.trim(),
                        preferredDate: formattedDate,
                        preferredTime: formattedTime,
                        priority: priorities[selectedPriority],
                        attachment: attachment,
                        type: "service_request",
                        propertyId: propertyId,
                      );
                      ref.invalidate(
                        getServiceRequestProvider((
                          statusFilter: "",
                          search: "",
                          type: "service_request",
                        )),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      showErrorSnackBar("Failed to submit request.");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF101C16),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              color: AppColors.scaffoldBg,
                              strokeWidth: 1.5,
                            ),
                          ),
                        )
                      : Text(
                          "Submit",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
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

  Widget _buildInfoBox() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Color.fromARGB(25, 16, 28, 22),
        borderRadius: BorderRadius.circular(5.r),
        border: Border.all(color: const Color(0xFF101C16), width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "•",
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              color: const Color(0xff555555),
            ),
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(
              "After submission, a unique service request ID will be generated. "
              "You can use it to track your service request status and resolution progress.",
              style: GoogleFonts.outfit(
                fontSize: 11.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2A2933),
                letterSpacing: -0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 48.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.r),
        border: Border.all(color: const Color(0xFF101C16), width: 1.w),
      ),
      padding: EdgeInsets.only(left: 15.w, right: 25.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(153, 42, 41, 51),
              letterSpacing: -0.3,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 20.sp,
            color: Color.fromARGB(153, 42, 41, 51),
          ),
          dropdownColor: Colors.white,
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF101C16),
                  letterSpacing: -0.2,
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPriority() {
    return Row(
      children: List.generate(priorities.length, (index) {
        final bool isSelected = selectedPriority == index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index != priorities.length - 1 ? 7.w : 0,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedPriority = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 38.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color.fromARGB(102, 174, 129, 48)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isSelected
                        ? Color(0xFFAE8130)
                        : Color.fromARGB(153, 42, 41, 51),
                    width: 1.w,
                  ),
                ),
                child: Text(
                  priorities[index],
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Color(0xFF2A2933)
                        : Color.fromARGB(153, 42, 41, 51),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
