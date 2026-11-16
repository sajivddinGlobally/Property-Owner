import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Property_Screen/Provider/propertyDetailsProvider.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Property_Screen/property_status_screen.dart';
import 'package:property_care/OwnerScreen/MaintenancePaymentStatusScreen/Maintenance_Payment_Status.dart';
import 'package:property_care/OwnerScreen/PropertyPerformanceScreen/Property_Performance_Screen.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:property_care/core/Utils/property_type_helper.dart'
    show isHomeCareProperty;

class PropertyScreen extends ConsumerStatefulWidget {
  const PropertyScreen({super.key});

  @override
  ConsumerState<PropertyScreen> createState() => _PropertyScreenState();
}

class _PropertyScreenState extends ConsumerState<PropertyScreen> {
  @override
  Widget build(BuildContext context) {
    final propertyDetailState = ref.watch(propertyDetailsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          color: AppColors.background,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PROPERTY DETAILS",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),

                  SizedBox(height: 2.h),

                  Text(
                    "Complete information about your property",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(42, 41, 51, 0.6),
                      letterSpacing: -0.24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: propertyDetailState.when(
        data: (propertyDetails) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          // "assets/property_img (2).png",
                          propertyDetails.data?.imageUrl ?? "",
                          width: double.infinity,
                          height: 183.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: 183.h,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade800,
                                borderRadius: BorderRadius.circular(10.r),
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
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 20.w,
                                  color: Colors.white54,
                                ),
                              ),
                            );
                          },
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
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                      if ((propertyDetails.data?.carePackageLabel != null &&
                              propertyDetails
                                  .data!
                                  .carePackageLabel!
                                  .isNotEmpty) ||
                          (propertyDetails.data?.carePackage != null &&
                              propertyDetails.data!.carePackage!.isNotEmpty))
                        Positioned(
                          right: 14.w,
                          top: 14.h,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 5.h,
                            ),
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
                                  propertyDetails.data?.carePackageLabel ??
                                      propertyDetails.data?.carePackage ??
                                      "",
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
                        ),

                      // Positioned(
                      //   left: 16.w,
                      //   bottom: 17.h,
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         "My Property",
                      //         style: GoogleFonts.outfit(
                      //           fontWeight: FontWeight.w500,
                      //           color: Color(0xffFFFFFF),
                      //           fontSize: 15.sp,
                      //           letterSpacing: -0.24,
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.h),
                      //       Text(
                      //         // "Apartment A-204",
                      //         "${_formatPropertyType(propertyDetails.data?.propertyType)} - ${propertyDetails.data?.propertyNameNumber ?? "N/A"}",
                      //         style: GoogleFonts.outfit(
                      //           fontWeight: FontWeight.w500,
                      //           color: Color(0xffFFFFFF),
                      //           fontSize: 18.sp,
                      //           letterSpacing: -0.54,
                      //         ),
                      //       ),
                      //       SizedBox(height: 6.h),
                      //       Text(
                      //         (propertyDetails.data?.complex?.name != null &&
                      //                 propertyDetails
                      //                     .data!
                      //                     .complex!
                      //                     .name!
                      //                     .isNotEmpty)
                      //             ? "${propertyDetails.data?.complex?.name} · ${propertyDetails.data?.location ?? 'N/A'}"
                      //             : (propertyDetails.data?.location ?? "N/A"),
                      //         style: GoogleFonts.outfit(
                      //           fontWeight: FontWeight.w500,
                      //           color: Color.fromRGBO(255, 255, 255, 0.6),
                      //           fontSize: 16.sp,
                      //           letterSpacing: -0.34,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      Positioned(
                        left: 16.w,
                        right: 16.w,
                        bottom: 17.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "My Property",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 15.sp,
                                letterSpacing: -0.24,
                              ),
                            ),
                            SizedBox(height: 6.h),

                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "${_formatPropertyType(propertyDetails.data?.propertyType)} - "
                                "${propertyDetails.data?.propertyNameNumber ?? "N/A"}",
                                softWrap: true,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  letterSpacing: -0.54,
                                ),
                              ),
                            ),

                            SizedBox(height: 6.h),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                (() {
                                  // Complex ka naam (owner side mein sirf naam) + location, jo ho
                                  final text =
                                      [
                                            propertyDetails
                                                .data
                                                ?.displayComplexName,
                                            propertyDetails.data?.location,
                                          ]
                                          .where(
                                            (s) =>
                                                s != null &&
                                                s.trim().isNotEmpty,
                                          )
                                          .join(" · ");
                                  return text.isNotEmpty ? text : "N/A";
                                })(),
                                softWrap: true,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(
                                    255,
                                    255,
                                    255,
                                    0.6,
                                  ),
                                  fontSize: 16.sp,
                                  letterSpacing: -0.34,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Text(
                        "Property Overview",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 18.sp,
                          letterSpacing: -0.34,
                        ),
                      ),
                      // Spacer(),
                      // Text(
                      //   "View All",
                      //   style: GoogleFonts.outfit(
                      //     fontWeight: FontWeight.w500,
                      //     color: AppColors.heading,
                      //     fontSize: 16.sp,
                      //     letterSpacing: -0.34,
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _documentRow(
                          title: "Property Name",
                          value:
                              propertyDetails.data?.propertyNameNumber ?? "N/A",
                        ),
                        _documentRow(
                          title: "Property Type",
                          value: _formatPropertyType(
                            propertyDetails.data?.propertyType,
                          ),
                        ),
                        _documentRow(
                          title: "Area",
                          value: propertyDetails.data?.area ?? "N/A",
                        ),
                        _documentRow(
                          title: "Location",
                          value: propertyDetails.data?.location ?? "N/A",
                        ),
                        _documentRow(
                          title: "Property Status",
                          value: propertyDetails.data?.status ?? "N/A",
                        ),
                        if ((propertyDetails.data?.carePackageLabel != null &&
                                propertyDetails
                                    .data!
                                    .carePackageLabel!
                                    .isNotEmpty) ||
                            (propertyDetails.data?.carePackage != null &&
                                propertyDetails.data!.carePackage!.isNotEmpty))
                          _documentRow(
                            title: "Care Package",
                            value:
                                propertyDetails.data?.carePackageLabel ??
                                propertyDetails.data?.carePackage ??
                                "N/A",
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Property Information",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      fontSize: 18.sp,
                      letterSpacing: -0.34,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.w,
                    mainAxisSpacing: 16.h,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 1.6,
                    children: [
                      _infoCard(
                        icon: Icons.home_outlined,
                        title:
                            propertyDetails.data?.displayComplexName ?? "N/A",
                        subtitle: "Associated Complex",
                      ),

                      _infoCard(
                        icon: Icons.circle,
                        title: _getCaretakerName(
                          propertyDetails.data?.caretaker,
                        ),
                        subtitle: "Assigned Caretaker",
                        iconSize: 19,
                      ),

                      _infoCard(
                        icon: Icons.access_time_outlined,
                        title:
                            propertyDetails
                                    .data
                                    ?.widgets
                                    ?.latestInspection
                                    ?.date !=
                                null
                            ? DateFormat("dd MMM").format(
                                propertyDetails
                                    .data!
                                    .widgets!
                                    .latestInspection!
                                    .date!,
                              )
                            : "0",
                        subtitle: "Last Inspection",
                      ),
                      _infoCard(
                        icon: Icons.crop_square,
                        title:
                            "${propertyDetails.data?.widgets?.documentsCount ?? "0"}",
                        subtitle: "Documents",
                        iconSize: 20,
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => PropertyStatusScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 35.h,
                            width: 37.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFF30342E),
                              ),
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Center(
                              child: Container(
                                height: 17.h,
                                width: 17.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.heading),
                                ),
                                child: Center(
                                  child: Container(
                                    height: 12.h,
                                    width: 12.w,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Property Status",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.heading,
                                    letterSpacing: -0.34,
                                  ),
                                ),

                                SizedBox(height: 7.h),
                                Text(
                                  "View overall property condition",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 14.5.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(41, 42, 51, 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(width: 15.w),
                          Container(
                            height: 34.h,
                            width: 32.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.heading),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.chevron_right,
                                size: 16.sp,
                                color: AppColors.heading,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => PropertyPerformanceScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.heading),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 45.h,
                            width: 45.w,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.heading,
                                width: 1.5,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                // propertyDetails.data?.overallScore ?? "86",
                                propertyDetails.data?.overallScore
                                        ?.toStringAsFixed(1) ??
                                    // Home Care: inspection nahi hua = Pending
                                    (isHomeCareProperty(
                                          propertyDetails.data?.propertyType,
                                          complex:
                                              propertyDetails.data?.complex,
                                          isIndependent: propertyDetails
                                              .data
                                              ?.isIndependent,
                                        )
                                        ? "--"
                                        : "0"),
                                // double.tryParse(
                                //       propertyDetails.data?.overallScore ?? "0",
                                //     )?.toStringAsFixed(1) ??
                                //     "0.0",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  fontSize: 17.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Property Score",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.heading,
                                    fontSize: 17.sp,
                                    letterSpacing: -0.34,
                                  ),
                                ),

                                SizedBox(height: 2.h),

                                Text(
                                  isHomeCareProperty(
                                        propertyDetails.data?.propertyType,
                                        complex: propertyDetails.data?.complex,
                                        isIndependent:
                                            propertyDetails.data?.isIndependent,
                                      )
                                      ? (propertyDetails.data?.overallScore ==
                                                null
                                            ? "Pending Inspection. Score will appear after the first inspection."
                                            : "Based on the latest inspection checklist. Audit is shown separately.")
                                      : "Overall property performance based on maintenance, cleanliness, security and inspections.",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.6,
                                    ),
                                    fontSize: 16.sp,
                                    letterSpacing: -0.34,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.w,
                      vertical: 9.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromRGBO(42, 41, 51, 0.2),
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Current Care Package",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(42, 41, 51, 0.5),
                                fontSize: 16.sp,
                                letterSpacing: -0.34,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              propertyDetails.data?.carePackageLabel ?? "N/A",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                fontSize: 18.sp,
                                letterSpacing: -0.34,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.w,
                            vertical: 7.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.heading),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: Text(
                              propertyDetails.data?.status ?? "ACTIVE",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                fontSize: 16.sp,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              const MaintenancePaymentStatus(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 38.w,
                            width: 38.w,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.heading),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(
                              Icons.credit_card_outlined,
                              size: 20.sp,
                              color: AppColors.heading,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ascent Service Charge",
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  "Service charge to be paid to Ascent",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF777777),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            size: 22.sp,
                            color: AppColors.heading,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
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

  Widget _documentRow({
    required String title,
    required String value,
    // Color valueColor = const Color(0xFF171A18),
    bool showBottomBorder = true,
  }) {
    return SizedBox(
      height: 40.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              decoration: BoxDecoration(
                border: showBottomBorder
                    ? const Border(
                        bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
                      )
                    : null,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(42, 41, 51, 0.6),
                  letterSpacing: -0.24,
                ),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              border: showBottomBorder
                  ? const Border(
                      bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
                    )
                  : null,
            ),
            alignment: Alignment.centerRight,
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
                letterSpacing: -0.24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    double iconSize = 20,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: (iconSize - 2).sp, color: AppColors.heading),

          SizedBox(height: 6.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
              letterSpacing: -0.54,
            ),
          ),

          SizedBox(height: 4.h),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(41, 42, 51, 0.6),
              letterSpacing: -0.34,
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
      case "home_care":
        return "Home Care";
      case "apartment":
        return "Apartment";
      case "community_care":
        return "Community Care";
      case "villa_compound":
        return "Villa";
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

  String _getCaretakerName(dynamic caretaker) {
    if (caretaker == null) return "N/A";
    if (caretaker is String) {
      return caretaker.trim().isEmpty ? "N/A" : caretaker;
    }
    if (caretaker is Map) {
      final name = caretaker['name'] ?? caretaker['full_name'];
      return (name != null && name.toString().trim().isNotEmpty)
          ? name.toString()
          : "N/A";
    }
    try {
      final name = (caretaker as dynamic).name;
      if (name != null && name.toString().trim().isNotEmpty) {
        return name.toString();
      }
    } catch (_) {}
    return "N/A";
  }
}
