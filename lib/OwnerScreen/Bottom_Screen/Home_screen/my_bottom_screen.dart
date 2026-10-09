import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:property_care/OwnerScreen/AIPropertyAssistant_Screen/AIProperty_Assistant_Screen.dart';
import 'package:property_care/OwnerScreen/Audit_Report/AuditReprot_Screen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Complaint_Screen/Complaints_screen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Document_Screen/document_screen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/NotificationScreen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/ownerDashboardProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/ownerDashboardModel.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Profile_Screen/profile_screen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Property_Screen/property_screen.dart';
import 'package:property_care/OwnerScreen/MaintenanceHistory_Screen/MaintenanceHistory_Screen.dart';
import 'package:property_care/OwnerScreen/MaintenancePaymentStatusScreen/Maintenance_Payment_Status.dart';
import 'package:property_care/OwnerScreen/ServiceRequest_Screen/Service_Request_Screen.dart';
import 'package:property_care/OwnerScreen/inspectionReport/inspectionReportScreen.dart';
import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:svg_flutter/svg_flutter.dart';

import 'AddPropertyBottomSheet.dart';
import 'Provider/getPropertyListProvider.dart';
import 'Provider/selectedPropertyProvider.dart';

class MyBottomScreen extends StatefulWidget {
  const MyBottomScreen({super.key});

  @override
  State<MyBottomScreen> createState() => _MyBottomScreenState();
}

class _MyBottomScreenState extends State<MyBottomScreen> {
  int selectIndex = 0;

  List<Widget> get screen => [
    HomeScreen(
      onProfileTap: () {
        setState(() {
          selectIndex = 4;
        });
      },
      onDocumentTap: () {
        setState(() {
          selectIndex = 3;
        });
      },
    ),
    PropertyScreen(),
    ComplaintsScreen(),
    DocumentScreen(),
    ProfileScreen(),
  ];
  DateTime? lastBackPressed;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectIndex != 0) {
          setState(() {
            selectIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: screen[selectIndex],
        bottomNavigationBar: SafeArea(
          top: false,
          child: Container(
            width: double.infinity,
            height: 70.h,
            decoration: BoxDecoration(
              color: Color(0xFFFFFCEB),
              border: Border(
                top: BorderSide(color: const Color(0xFF17221D), width: 1.w),
              ),
            ),
            child: Row(
              children: [
                _bottomItem(
                  index: 0,
                  image: "assets/SvgImage/bottom.svg",
                  title: "Home",
                ),
                _bottomItem(
                  index: 1,
                  image: "assets/SvgImage/bottom2.svg",
                  title: "Property",
                ),
                _bottomItem(
                  index: 2,
                  image: "assets/SvgImage/bottom3.svg",
                  title: "Complaints",
                ),
                SizedBox(width: 7.w),
                _bottomItem(
                  index: 3,
                  image: "assets/SvgImage/bottom4.svg",
                  title: "Documents",
                ),
                _bottomItem(
                  index: 4,
                  image: "assets/SvgImage/bottom5.svg",
                  title: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomItem({
    required int index,
    required String image,
    required String title,
  }) {
    final bool isSelected = selectIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            selectIndex = index;
          });
        },
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: SvgPicture.asset(
                  image,
                  color: isSelected
                      ? const Color(0xff101C16)
                      : const Color(0xffA0A5A2),
                  width: 30.w,
                  height: 30.h,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? Color(0xFF17221D)
                      : const Color(0xffA0A5A2),
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onDocumentTap;
  const HomeScreen({
    super.key,
    required this.onProfileTap,
    required this.onDocumentTap,
  });

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void showPropertyPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.25),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Consumer(
              builder: (context, modalRef, child) {
                final getPropertyListState = modalRef.watch(
                  getPropertyListProvider,
                );
                final currentSelectedPropertyId = modalRef.watch(
                  selectedPropertyIdProvider,
                );

                return Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.80,
                  ),
                  padding: EdgeInsets.only(
                    left: 14.w,
                    right: 14.w,
                    top: 14.h,
                    bottom: MediaQuery.of(context).padding.bottom + 14.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffF8F5ED),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                  ),
                  child: getPropertyListState.when(
                    data: (propertyData) {
                      final properties = propertyData.data ?? [];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25.h),
                          Row(
                            children: [
                              Text(
                                "MY PROPERTIES",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff171717),
                                  letterSpacing: -0.54,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "${properties.length} Properties",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          if (properties.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(bottom: 16.h),
                              child: Text(
                                "No properties found.",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  color: const Color(0xff171717),
                                ),
                              ),
                            )
                          else
                            Flexible(
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: properties.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 16.h),
                                itemBuilder: (context, index) {
                                  final property = properties[index];
                                  final hasBackendSelected = properties.any(
                                    (p) => p.isSelected == true,
                                  );
                                  final isSelected =
                                      currentSelectedPropertyId != null
                                      ? property.id == currentSelectedPropertyId
                                      : (hasBackendSelected
                                            ? property.isSelected == true
                                            : index == 0);
                                  return propertyItem(
                                    property.imageUrl ?? "",
                                    "${_formatPropertyType(property.propertyType)} ${property.propertyNameNumber ?? ''}"
                                        .trim(),
                                    (property.complexName != null &&
                                            property.complexName!.isNotEmpty)
                                        ? "${property.complexName} - ${property.location ?? ''}"
                                        : (property.location ?? ""),
                                    isSelected,
                                    onTap: () async {
                                      final propertyId = property.id;
                                      if (propertyId == null) return;

                                      // 1. Pehle selectedPropertyId state update karein
                                      ref
                                              .read(
                                                selectedPropertyIdProvider
                                                    .notifier,
                                              )
                                              .state =
                                          propertyId;

                                      // 2. Bottom sheet close karein
                                      if (bottomSheetContext.mounted) {
                                        Navigator.pop(bottomSheetContext);
                                      }

                                      log(
                                        "${property.propertyNameNumber} Selected (ID: $propertyId)",
                                      );

                                      // 3. POST API hit karein aur dashboard/list refresh karein
                                      try {
                                        final service = ref.read(
                                          authServiceProvider,
                                        );
                                        await service.selectProperty(
                                          propertyId: propertyId,
                                        );

                                        ref.invalidate(getPropertyListProvider);
                                        ref.invalidate(ownerDashboardProvider);
                                      } catch (e) {
                                        log("Error in selectProperty API: $e");
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(bottomSheetContext);
                              showAddPropertyBottomSheet(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 34.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff777777),
                                ),
                              ),
                              child: Text(
                                "+  Add New Property",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  color: const Color(0xff171717),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                        ],
                      );
                    },
                    loading: () => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 40.h),
                        Center(
                          child: CircularProgressIndicator(
                            color: const Color(0xff171717),
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                    error: (error, stackTrace) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 40.h),
                        Center(
                          child: Text(
                            "Failed to load properties",
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(height: 40.h),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String formatAuditDate(String? date) {
    if (date == null || date.isEmpty) {
      return "N/A";
    }

    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat("dd MMMM yyyy").format(parsedDate);
    } catch (e) {
      return "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    final getOnwerDashboardState = ref.watch(ownerDashboardProvider);
    var box = Hive.box("userdata");
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          color: AppColors.scaffoldBg,
          padding: EdgeInsets.only(
            left: 18.w,
            right: 18.w,
            top: 28.h,
            // bottom: 12.h,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Good Morning",
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.39,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      "HELLO, ${box.get("name")?.toUpperCase()} 👋",
                      style: GoogleFonts.manrope(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.64,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Notificationscreen(),
                    ),
                  );
                },
                child: Container(
                  height: 36.h,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: const Color(0xffB8BCB8),
                      width: 1.w,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.notifications_none_outlined,
                      size: 24.sp,
                      color: const Color(0xff101C16),
                    ),
                  ),
                ),
              ),

              SizedBox(width: 8.w),
              InkWell(
                onTap: widget.onProfileTap,
                child: Container(
                  height: 36.h,
                  width: 36.w,
                  decoration: BoxDecoration(
                    color: AppColors.scaffoldBg,
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(
                      color: const Color(0xffB8BCB8),
                      width: 1.w,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_outline,
                      size: 25.sp,
                      color: Color(0xff101C16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: getOnwerDashboardState.when(
        data: (ownerDashboard) {
          final bool isPending =
              ownerDashboard.data?.activeDashboard == false ||
              ownerDashboard.data?.isApproved == false;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(ownerDashboardProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.r),
                          bottomRight: Radius.circular(30.r),
                        ),
                        child:
                            (ownerDashboard.data?.property?.imageUrl != null &&
                                ownerDashboard
                                    .data!
                                    .property!
                                    .imageUrl!
                                    .isNotEmpty)
                            ? Image.network(
                                ownerDashboard.data!.property!.imageUrl!,
                                width: double.infinity,
                                height: 305.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    "assets/home_img.png",
                                    width: double.infinity,
                                    height: 305.h,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                "assets/home_img.png",
                                width: double.infinity,
                                height: 305.h,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xff101C16).withOpacity(0.0),
                                Color(0xff101C16).withOpacity(0.4),
                                Color(0xff101C16).withOpacity(0.9),
                                Color(0xff101C16),
                              ],
                              stops: const [0.0, 0.4, 0.75, 1.0],
                            ),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.r),
                              bottomRight: Radius.circular(30.r),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: GestureDetector(
                          onTap: () {
                            print("hello");

                            showPropertyPopup();
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              top: 14.h,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 7.h,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xff171717),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  "assets/Vector (1).png",
                                  height: 16.h,
                                  width: 15.w,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  // "Apartment A-204",
                                  "${_formatPropertyType(ownerDashboard.data?.property?.type)} ${ownerDashboard.data?.property?.nameNumber ?? ''}"
                                      .trim(),
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    letterSpacing: -0.54,
                                  ),
                                ),

                                const Spacer(),

                                Container(
                                  height: 30.h,
                                  width: 30.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: const Color(0xff171717),
                                    size: 16.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20.w,
                        right: 20.w,
                        top: 88.h,
                        child: Row(
                          children: [
                            Container(
                              height: 31.h,
                              width: 106.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r),
                                border: Border.all(color: Colors.white),
                              ),
                              child: Center(
                                child: Text(
                                  "MY PROPERTY",
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    letterSpacing: -0.34,
                                  ),
                                ),
                              ),
                            ),
                            if (ownerDashboard
                                        .data
                                        ?.property
                                        ?.carePackage
                                        ?.label !=
                                    null &&
                                ownerDashboard
                                    .data!
                                    .property!
                                    .carePackage!
                                    .label!
                                    .isNotEmpty) ...[
                              const Spacer(),
                              Container(
                                height: 31.h,
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xff101C16),
                                  borderRadius: BorderRadius.circular(50.r),
                                  border: Border.all(
                                    color: const Color(0xFFB8860B),
                                    width: 1.2,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.workspace_premium_outlined,
                                      size: 14.sp,
                                      color: const Color(0xFFE5C058),
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      ownerDashboard
                                          .data!
                                          .property!
                                          .carePackage!
                                          .label!,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFFFFCEB),
                                        fontSize: 14.sp,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Positioned.fill(
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       gradient: LinearGradient(
                      //         begin: Alignment.topCenter,
                      //         end: Alignment.bottomCenter,
                      //         colors: [
                      //           Color(0xff101C16).withOpacity(0.0),
                      //           Color(0xff101C16).withOpacity(0.0),
                      //           Color(0xff101C16),
                      //         ],
                      //       ),
                      //       borderRadius: BorderRadius.only(
                      //         bottomLeft: Radius.circular(30.r),
                      //         bottomRight: Radius.circular(30.r),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        left: 20.w,
                        right: 20.w,
                        bottom: 24.h,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "MY PROPERTY",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      letterSpacing: -0.34,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    // "Apartment A-204",
                                    "${_formatPropertyType(ownerDashboard.data?.property?.type)} ${ownerDashboard.data?.property?.nameNumber ?? ''}"
                                        .trim(),
                                    // "${ownerDashboard.data?.property?.type} ${ownerDashboard.data?.property?.nameNumber}",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 19.sp,
                                      color: Colors.white,
                                      letterSpacing: -0.7,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    (ownerDashboard
                                                    .data
                                                    ?.property
                                                    ?.complex
                                                    ?.name !=
                                                null &&
                                            ownerDashboard
                                                .data!
                                                .property!
                                                .complex!
                                                .name!
                                                .isNotEmpty)
                                        ? "${ownerDashboard.data?.property?.complex?.name} · ${ownerDashboard.data?.property?.location ?? ''}"
                                        : (ownerDashboard
                                                  .data
                                                  ?.property
                                                  ?.location ??
                                              "N/A"),
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15.sp,
                                      color: Colors.white.withOpacity(0.65),
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 20.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(20, 30, 25, 0.65),
                                borderRadius: BorderRadius.circular(50.r),
                                border: Border.all(
                                  color: isPending
                                      ? const Color(0xFFFBBF24)
                                      : Colors.white,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8.w,
                                      height: 8.h,
                                      decoration: BoxDecoration(
                                        color: isPending
                                            ? const Color(0xFFFBBF24)
                                            : Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      // "Good",
                                      ownerDashboard
                                              .data
                                              ?.property
                                              ?.statusLabel ??
                                          (isPending
                                              ? "Pending Approval"
                                              : "Active"),
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.sp,
                                        color: Colors.white,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // "Premium Care",
                                  ownerDashboard
                                          .data
                                          ?.property
                                          ?.carePackage
                                          ?.label ??
                                      "",
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18.sp,
                                    color: Color(0xff2A2933),
                                    letterSpacing: -0.54,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isPending ? 14.w : 24.5.w,
                                vertical: 6.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: isPending
                                    ? const Color(0xffE8E6DE)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(50.r),
                                border: Border.all(
                                  color: const Color(0xff17221D),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  (ownerDashboard.data?.property?.statusLabel ??
                                          (isPending
                                              ? "Pending Approval"
                                              : "Active"))
                                      .toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isPending ? 13.sp : 16.sp,
                                    color: const Color(0xff17221D),
                                    letterSpacing: -0.39,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Divider(color: Color(0xFF101C16)),
                        SizedBox(height: 16.h),
                        if (isPending) ...[
                          _buildPendingVerificationSection(ownerDashboard.data),
                        ] else ...[
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      AipropertyAssistantScreen(
                                    propertyId: ownerDashboard.data?.property?.id,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color.fromRGBO(184, 134, 11, 0.9),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(0xff000000),
                                      ),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Container(
                                      width: 39.w,
                                      height: 39.h,
                                      decoration: BoxDecoration(
                                        color: const Color(0xff000000),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.auto_awesome,
                                          color: Colors.white,
                                          size: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Property Assistant",
                                              style: GoogleFonts.outfit(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff101010),
                                                letterSpacing: -0.54,
                                              ),
                                            ),

                                            SizedBox(width: 6.w),

                                            Container(
                                              height: 14.h,
                                              width: 15.w,
                                              decoration: BoxDecoration(
                                                color: const Color(0xffAE8130),
                                                borderRadius:
                                                    BorderRadius.circular(3.r),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "AI",
                                                  style: GoogleFonts.outfit(
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(
                                                      0xff000000,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 2.h),

                                        Text(
                                          "Ask me anything about your property",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff000000),
                                            letterSpacing: -0.24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  SizedBox(width: 8.w),

                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffC18D0B),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: Colors.black,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => ServiceRequestScreen(),
                                ),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: const Color(0xff4F5752),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 42.w,
                                        height: 42.h,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffF8F5ED),
                                          borderRadius: BorderRadius.circular(
                                            7.r,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xff4F5752),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.build_outlined,
                                          size: 20.sp,
                                          color: const Color(0xff303832),
                                        ),
                                      ),

                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Service Requests",
                                              style: GoogleFonts.outfit(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff000000),
                                                letterSpacing: -0.4,
                                              ),
                                            ),

                                            SizedBox(height: 2.h),

                                            Text(
                                              "Raise & track property services",
                                              style: GoogleFonts.outfit(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(
                                                  0,
                                                  0,
                                                  0,
                                                  0.6,
                                                ),
                                                letterSpacing: -0.24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 38.w,
                                        height: 38.h,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color(0xff101C16),
                                            width: 1,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.arrow_forward,
                                          size: 18.sp,
                                          color: const Color(0xff101C16),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8.h),

                                  Container(
                                    height: 1,
                                    width: double.infinity,
                                    color: const Color(0xff101C16),
                                  ),

                                  SizedBox(height: 10.h),

                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Active Requests",
                                            style: GoogleFonts.outfit(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(
                                                0,
                                                0,
                                                0,
                                                0.6,
                                              ),
                                            ),
                                          ),

                                          SizedBox(height: 2.h),

                                          Text(
                                            "${ownerDashboard.data?.widgets?.serviceRequests?.active ?? "0"}",
                                            style: GoogleFonts.outfit(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff101C16),
                                            ),
                                          ),
                                        ],
                                      ),

                                      SizedBox(width: 18.w),

                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xffE8E6DE),
                                          borderRadius: BorderRadius.circular(
                                            20.r,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xff101C16),
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 4.w,
                                              height: 4.h,
                                              decoration: const BoxDecoration(
                                                color: Color(0xff000000),
                                                shape: BoxShape.circle,
                                              ),
                                            ),

                                            SizedBox(width: 6.w),

                                            Text(
                                              "In Progress",
                                              style: GoogleFonts.outfit(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff101C16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "View All →",
                                        style: GoogleFonts.outfit(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff101C16),
                                          letterSpacing: -0.34,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 18.h),
                          Row(
                            children: [
                              Text(
                                "Property Overview",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff2A2933),
                                  fontSize: 18.sp,
                                  letterSpacing: -0.54,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "View All",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff2A2933),
                                  fontSize: 16.sp,
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 17.h),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.asset(
                                  "assets/vector_img.png",
                                  width: double.infinity,
                                  height: 190.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          const Color(0xff101C16),
                                          const Color(
                                            0xff101C16,
                                          ).withOpacity(0.65),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Content
                              Positioned(
                                left: 19.w,
                                top: 30.h,
                                child: Text(
                                  "PROPERTY AT A GLANCE",
                                  style: GoogleFonts.outfit(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: -0.34,
                                  ),
                                ),
                              ),

                              Positioned(
                                left: 19.w,
                                top: 63.h,
                                child: Row(
                                  children: [
                                    _infoItem(
                                      "${ownerDashboard.data?.widgets?.pendingIssues ?? "0"}",
                                      "Pending\nIssues",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const ServiceRequestScreen(),
                                          ),
                                        );
                                      },
                                    ),

                                    _verticalDivider(),

                                    _infoItem(
                                      "${ownerDashboard.data?.widgets?.openMaintenance ?? "0"}",
                                      "Open\nMaintenance",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const MaintenancehistoryScreen(),
                                          ),
                                        );
                                      },
                                    ),

                                    _verticalDivider(),

                                    _infoItem(
                                      ownerDashboard
                                                  .data
                                                  ?.widgets
                                                  ?.latestInspection
                                                  ?.date !=
                                              null
                                          ? DateFormat("dd MMM").format(
                                              ownerDashboard
                                                  .data!
                                                  .widgets!
                                                  .latestInspection!
                                                  .date!,
                                            )
                                          : "0",
                                      "Last\nInspection",
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                const InspectionReportScreen(),
                                          ),
                                        );
                                      },
                                    ),

                                    _verticalDivider(),

                                    _infoItem(
                                      "${ownerDashboard.data?.widgets?.documentsCount ?? "0"}",
                                      "Documents",
                                      onTap: widget.onDocumentTap,
                                      // () {
                                      //   Navigator.push(
                                      //     context,
                                      //     CupertinoPageRoute(
                                      //       builder: (context) =>
                                      //           const DocumentScreen(),
                                      //     ),
                                      //   );
                                      // },
                                    ),
                                    _verticalDivider(),
                                  ],
                                ),
                              ),

                              Positioned(
                                left: 19.w,
                                bottom: 25.h,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 18.w,
                                      height: 18.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xffD8B400),
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 9.w,
                                          height: 9.w,
                                          decoration: const BoxDecoration(
                                            color: Color(0xffD8B400),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 6.w),
                                    Text(
                                      "Everything is being monitored",
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.asset(
                                  "assets/home2_img.png",
                                  width: double.infinity,
                                  height: 235.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.r),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          const Color(
                                            0xff000000,
                                          ).withOpacity(0.95),
                                          const Color(
                                            0xff000000,
                                          ).withOpacity(0.70),
                                          const Color(
                                            0xff000000,
                                          ).withOpacity(0.20),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.45, 0.72, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15.w,
                                top: 20.h,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20.w,
                                      height: 20.w,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xffD4B800),
                                          width: 1.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          2.r,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.description_outlined,
                                        color: const Color(0xffD4B800),
                                        size: 12.sp,
                                      ),
                                    ),

                                    SizedBox(width: 7.w),

                                    Text(
                                      "PROPERTY REPORT",
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        letterSpacing: -0.24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 15.w,
                                top: 48.h,
                                child: Text(
                                  "Property Audit Report",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15.w,
                                top: 75.h,
                                child: Text(
                                  "Latest Property Audit",
                                  style: GoogleFonts.outfit(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(255, 255, 255, 0.6),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 15.w,
                                top: 100.h,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xffD4B800),
                                          width: 1.17.w,
                                        ),
                                      ),
                                      child: Text(
                                        ownerDashboard
                                                .data
                                                ?.property
                                                ?.overallScore
                                                ?.toStringAsFixed(1) ??
                                            "0",
                                        style: GoogleFonts.outfit(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffD4B800),
                                          letterSpacing: -0.3,
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 10.w),

                                    Text(
                                      "OVERALL\nSCORE",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                left: 15.w,
                                right: 15.w,
                                bottom: 53.h,
                                child: Container(
                                  height: 1,
                                  color: Color.fromRGBO(255, 255, 255, 0.5),
                                ),
                              ),
                              Positioned(
                                left: 15.w,
                                bottom: 30.h,
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Audit Date: ",
                                        style: GoogleFonts.outfit(
                                          fontSize: 16.sp,
                                          color: Colors.white.withOpacity(0.65),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      TextSpan(
                                        // text: "15 August 2026",
                                        text:
                                            ownerDashboard
                                                    .data
                                                    ?.widgets
                                                    ?.latestAudit
                                                    ?.createdAt !=
                                                null
                                            ? DateFormat("dd MMMM yyyy").format(
                                                ownerDashboard
                                                    .data!
                                                    .widgets!
                                                    .latestAudit!
                                                    .createdAt!,
                                              )
                                            : "N/A",
                                        style: GoogleFonts.outfit(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 15.w,
                                bottom: 30.h,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            AuditreprotScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "View Report →",
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xffD4B800),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) =>
                                      MaintenancePaymentStatus(),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.heading,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 34.h,
                                        width: 34.w,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.heading,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            5.r,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.credit_card_outlined,
                                          size: 20.sp,
                                          color: AppColors.heading,
                                        ),
                                      ),

                                      SizedBox(width: 10.w),

                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              // "Maintenance Payment",
                                              "Ascent Service Charge",
                                              style: GoogleFonts.outfit(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF101C16),
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                            Text(
                                              // "Monthly maintenance status",
                                              "Service charge to be paid to Ascent",
                                              style: GoogleFonts.outfit(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF777777),
                                                letterSpacing: -0.2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10.w,
                                          vertical: 3.h,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.heading,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            50.r,
                                          ),
                                        ),
                                        child: Text(
                                          ownerDashboard
                                                  .data
                                                  ?.widgets
                                                  ?.maintenancePayment
                                                  ?.status ??
                                              "",
                                          style: GoogleFonts.outfit(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF101C16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 14.h),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _paymentAmountBox(
                                          name: 'Outstanding',
                                          value:
                                              ownerDashboard
                                                  .data
                                                  ?.widgets
                                                  ?.maintenancePayment
                                                  ?.outstanding
                                                  .toString() ??
                                              "0",
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: _paymentAmountBox(
                                          name: 'Upcoming',
                                          value:
                                              ownerDashboard
                                                  .data
                                                  ?.widgets
                                                  ?.maintenancePayment
                                                  ?.upcoming
                                                  .toString() ??
                                              "0",
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: _paymentAmountBox(
                                          name: 'Overdue',
                                          value:
                                              ownerDashboard
                                                  .data
                                                  ?.widgets
                                                  ?.maintenancePayment
                                                  ?.overdue
                                                  .toString() ??
                                              "0",
                                        ),
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: _paymentAmountBox(
                                          name: 'Remaining',
                                          value:
                                              ownerDashboard
                                                  .data
                                                  ?.widgets
                                                  ?.maintenancePayment
                                                  ?.remaining
                                                  .toString() ??
                                              "0",
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 10.h),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        // "Maintenance charges",
                                        "Service charges",
                                        style: GoogleFonts.outfit(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF777777),
                                        ),
                                      ),
                                      Text(
                                        "View All →",
                                        style: GoogleFonts.outfit(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF101C16),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30.h),
                         
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          log(error.toString());
          log(stackTrace.toString());
          return Center(child: Text("Something went wrong"));
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _buildPendingVerificationSection(Data? data) {
    final notice = data?.notice;
    final property = data?.property;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Notice Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xff4F5752), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF8F5ED),
                      borderRadius: BorderRadius.circular(7.r),
                      border: Border.all(
                        color: const Color(0xff4F5752),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.hourglass_top_rounded,
                      size: 20.sp,
                      color: const Color(0xff303832),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notice?.title ?? "Verification in Progress",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000),
                            letterSpacing: -0.4,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Admin approval underway",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffE8E6DE),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      notice?.badge ?? "Pending Approval",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff101C16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xff101C16),
              ),
              SizedBox(height: 10.h),
              Text(
                notice?.description ??
                    "Your property has been submitted and is currently pending verification and approval by the Administrator. Your active dashboard, services, and reports will be enabled upon approval.",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                  height: 1.4,
                  letterSpacing: -0.24,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // 2. Verification Steps Roadmap Card
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xff4F5752), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF8F5ED),
                      borderRadius: BorderRadius.circular(7.r),
                      border: Border.all(
                        color: const Color(0xff4F5752),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.timeline,
                      size: 20.sp,
                      color: const Color(0xff303832),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Approval Timeline",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000),
                            letterSpacing: -0.4,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Track verification stages",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xff101C16),
              ),
              SizedBox(height: 14.h),

              // Step 1: Submitted
              _buildTimelineStep(
                title: "Property Submitted",
                subtitle:
                    "${_formatPropertyType(property?.type)} • ${property?.nameNumber ?? ''}",
                icon: Icons.check,
                isCompleted: true,
                isInProgress: false,
                isLast: false,
              ),

              // Step 2: Verification In Progress
              _buildTimelineStep(
                title: "Admin Review & Verification",
                subtitle: "Administrator is verifying details & specifications",
                icon: Icons.sync,
                isCompleted: false,
                isInProgress: true,
                isLast: false,
              ),

              // Step 3: Activation
              _buildTimelineStep(
                title: "Dashboard Activation",
                subtitle:
                    "Services, maintenance & reports unlock upon approval",
                icon: Icons.lock_outline,
                isCompleted: false,
                isInProgress: false,
                isLast: true,
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // 3. Submitted Property Summary
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xff4F5752), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42.w,
                    height: 42.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffF8F5ED),
                      borderRadius: BorderRadius.circular(7.r),
                      border: Border.all(
                        color: const Color(0xff4F5752),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.home_work_outlined,
                      size: 20.sp,
                      color: const Color(0xff303832),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Submitted Property Details",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff000000),
                            letterSpacing: -0.4,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Owner registered specifications",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Container(
                height: 1,
                width: double.infinity,
                color: const Color(0xff101C16),
              ),
              SizedBox(height: 10.h),
              _buildSummaryRow(
                "House / Building No.",
                property?.nameNumber ?? "N/A",
              ),
              _buildSummaryRow(
                "Property Category",
                _formatPropertyType(property?.type),
              ),
              if (property?.location != null && property!.location!.isNotEmpty)
                _buildSummaryRow("Location", property.location!),
              if (property?.area != null && property!.area!.isNotEmpty)
                _buildSummaryRow("Area", property.area!),
              if (property?.carePackage?.label != null &&
                  property!.carePackage!.label!.isNotEmpty)
                _buildSummaryRow("Care Package", property.carePackage!.label!),
              _buildSummaryRow(
                "Approval Status",
                property?.statusLabel ?? "Pending Approval",
                isStatus: true,
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // 4. Helpful Refresh Notice
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xff4F5752), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: const Color(0xffF8F5ED),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: const Color(0xff4F5752), width: 1),
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 18.sp,
                  color: const Color(0xff303832),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  "Verification usually takes 24-48 business hours. Pull down to refresh your status once notified.",
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    height: 1.35,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 30.h),
      ],
    );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCompleted,
    required bool isInProgress,
    required bool isLast,
  }) {
    Color iconBg;
    Color iconColor;
    Color borderColor;

    if (isCompleted) {
      iconBg = const Color(0xff101C16);
      iconColor = const Color(0xffF8F5ED);
      borderColor = const Color(0xff101C16);
    } else if (isInProgress) {
      iconBg = const Color(0xffE8E6DE);
      iconColor = const Color(0xff101C16);
      borderColor = const Color(0xff101C16);
    } else {
      iconBg = Colors.transparent;
      iconColor = const Color(0xff777777);
      borderColor = const Color(0xffB8BCB8);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32.w,
              height: 32.h,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 1.2),
              ),
              child: Center(
                child: Icon(icon, size: 16.sp, color: iconColor),
              ),
            ),
            if (!isLast)
              Container(
                width: 1.5,
                height: 36.h,
                color: isCompleted
                    ? const Color(0xff101C16)
                    : const Color(0xffB8BCB8),
              ),
          ],
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 4.h, bottom: isLast ? 0 : 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff101C16),
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (isInProgress) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffE8E6DE),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: const Color(0xff101C16),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          "In Progress",
                          style: GoogleFonts.outfit(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff101C16),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF777777),
              letterSpacing: -0.2,
            ),
          ),
          if (isStatus)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xffE8E6DE),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xff101C16), width: 1),
              ),
              child: Text(
                value,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff101C16),
                ),
              ),
            )
          else
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF101C16),
                letterSpacing: -0.2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _infoItem(String value, String title, {VoidCallback? onTap}) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 19.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
            letterSpacing: -0.3,
            height: 1.1,
          ),
        ),
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: content,
      );
    }
    return content;
  }

  Widget _verticalDivider() {
    return Container(
      width: 1.w,
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 14.w),
      color: Colors.white,
    );
  }

  Widget _maintenanceItem({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required bool isCompleted,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? const Color(0xff101C16)
                      : AppColors.scaffoldBg,
                  border: isCompleted
                      ? null
                      : Border.all(color: const Color(0xff101C16), width: 1.5),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: isCompleted ? 23.sp : 18.sp,
                    color: isCompleted ? Colors.white : const Color(0xff101C16),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.2.w,
                    color: const Color(0xff303832),
                  ),
                ),
            ],
          ),

          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 0.h, bottom: 28.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff24242A),
                            letterSpacing: -0.55,
                          ),
                        ),

                        SizedBox(height: 4.h),

                        Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff8B8B8B),
                            letterSpacing: -0.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    time,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff24242A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget propertyItem(
    String image,
    String title,
    String subtitle,
    bool selected, {
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected
              ? Color.fromRGBO(23, 23, 23, 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(
            color: selected ? const Color(0xff101010) : const Color(0xff777777),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: Image.network(
                // "assets/home_img.png",
                image,
                width: 79.w,
                height: 64.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 79.w,
                    height: 64.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xff777777)),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.error_outline,
                        color: const Color(0xff777777),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff2A2933),
                      letterSpacing: -0.54,
                    ),
                  ),

                  SizedBox(height: 5.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      color: Color.fromRGBO(42, 41, 51, 0.7),
                      letterSpacing: -0.2,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: selected ? const Color(0xff101010) : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xff101010)),
              ),
              child: selected
                  ? Icon(Icons.check, color: Colors.white, size: 14.sp)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentAmountBox({required String name, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF777777), width: 1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            name,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF101C16),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF101C16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPropertyType(String? type) {
    if (type == null || type.trim().isEmpty) return "N/A";
    switch (type.trim().toLowerCase()) {
      case "independent_house":
        return "Independent House";
      case "apartment":
        return "Apartment";
      case "villa_compound":
        return "Villa Compound";
      case "commercial":
        return "Commercial";
      case "commercial_complex":
        return "Commercial Complex";
      default:
        return type
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (w) => w.isNotEmpty
                  ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
                  : '',
            )
            .join(' ');
    }
  }
}
