import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:property_care/OwnerScreen/inspectionReport/inspectionReportDetailsScreen.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getInspectionReportModel.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:svg_flutter/svg.dart';

import 'Provider/getInspectionReportProvider.dart';

class InspectionReportScreen extends ConsumerStatefulWidget {
  const InspectionReportScreen({super.key});

  @override
  ConsumerState<InspectionReportScreen> createState() =>
      _InspectionReportScreenState();
}

class _InspectionReportScreenState
    extends ConsumerState<InspectionReportScreen> {
  int selectedFilter = 0;
  String get selectedFilterValue {
    switch (selectedFilter) {
      case 1:
        return "recent";
      case 2:
        return "previous";
      case 0:
      default:
        return "all";
    }
  }

  @override
  Widget build(BuildContext context) {
    final getInspectionReport = ref.watch(
      getInspectionReportProvider((
        filter: selectedFilterValue,
        type: "inspection",
      )),
    );

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
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
                    "INSPECTION REPORTS",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "PROPERTY INSPECTION HISTORY",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
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
      body: getInspectionReport.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xff101C16)),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Failed to load inspection reports",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff101C16),
                ),
              ),
              SizedBox(height: 12.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff101C16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () => ref.refresh(
                  getInspectionReportProvider((
                    filter: selectedFilterValue,
                    type: "inspection",
                  )),
                ),
                child: Text(
                  "Retry",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (modelData) {
          final allReports = modelData.data ?? [];
          final firstProperty = allReports.isNotEmpty
              ? allReports.first.property
              : null;
          final propertyName =
              firstProperty?.propertyNameNumber ?? "Apartment A-204";
          final propertyLocation =
              firstProperty?.location ?? "Emirates Hills, Dubai, UAE";
          final filteredReports = allReports;

          return RefreshIndicator(
            color: const Color(0xff101C16),
            onRefresh: () async {
              return ref.refresh(
                getInspectionReportProvider((
                  filter: selectedFilterValue,
                  type: "inspection",
                )).future,
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    if (filteredReports.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 14.w,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.heading,
                            width: 1.1,
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                border: Border.all(
                                  color: AppColors.heading,
                                  width: 1.1,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/SvgImage/proAparment.svg",
                                  height: 20.h,
                                  width: 20.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    propertyName,
                                    style: GoogleFonts.outfit(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    propertyLocation,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.6,
                                      ),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                    SizedBox(height: 20.h),

                    // Section Title & Description
                    Text(
                      "Inspection Reports",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "View previous inspections, inspection dates, inspector information and report findings.",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(42, 41, 51, 0.6),
                        letterSpacing: -0.2,
                        height: 1.35,
                      ),
                    ),

                    SizedBox(height: 18.h),

                    // Filter Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _filterButton(
                            title: "All Reports",
                            isSelected: selectedFilter == 0,
                            onTap: () {
                              setState(() {
                                selectedFilter = 0;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _filterButton(
                            title: "Recent",
                            isSelected: selectedFilter == 1,
                            onTap: () {
                              setState(() {
                                selectedFilter = 1;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: _filterButton(
                            title: "Previous",
                            isSelected: selectedFilter == 2,
                            onTap: () {
                              setState(() {
                                selectedFilter = 2;
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Inspection Report Cards List
                    if (filteredReports.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Text(
                            "No inspection reports found",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(42, 41, 51, 0.6),
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        itemCount: filteredReports.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = filteredReports[index];
                          return _inspectionCard(item);
                        },
                      ),

                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _filterButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected
                ? const Color(0xff101C16)
                : const Color(0xff8B8D84),
            width: isSelected ? 1.3 : 1.1,
          ),
          borderRadius: BorderRadius.circular(25.r),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            maxLines: 1,
            style: GoogleFonts.outfit(
              fontSize: 13.5.sp,
              fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              color: isSelected
                  ? const Color(0xff101C16)
                  : const Color(0xff777970),
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _inspectionCard(Datum item) {
    final displayDate = item.createdAt != null
        ? DateFormat("dd MMMM yyyy").format(item.createdAt!)
        : (item.inspectionDate != null
              ? DateFormat("dd MMMM yyyy").format(item.inspectionDate!)
              : "");

    final statusText = item.status != null && item.status!.isNotEmpty
        ? "${item.status![0].toUpperCase()}${item.status!.substring(1)}"
        : "Completed";

    final inspectorName = item.inspector?.name ?? "N/A";

    final inspectionDateText = item.inspectionDate != null
        ? DateFormat("dd MMM yyyy").format(item.inspectionDate!)
        : "N/A";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => InspectionReportDetailsScreen(
              id: item.id?.toString() ?? "",
              title: "Property Inspection Report",
              date: displayDate,
              property: item.property?.propertyNameNumber ?? "Apartment A-204",
              inspector: inspectorName,
              inspectionDate: inspectionDateText,
              status: statusText,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff101C16), width: 1.1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left icon box
                Container(
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff101C16),
                      width: 1.1,
                    ),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.article_outlined,
                      size: 20.sp,
                      color: const Color(0xff101C16),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Title and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Property Inspection Report",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff101C16),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        displayDate,
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Completed Badge
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff101C16),
                      width: 1.1,
                    ),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    statusText,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 12.h),

            // Divider
            Divider(height: 1, thickness: 0.8, color: const Color(0xffD0D2C8)),

            SizedBox(height: 12.h),

            // Inspector & Inspection Date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "INSPECTOR",
                        style: GoogleFonts.outfit(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.55),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        inspectorName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff101C16),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "INSPECTION DATE",
                        style: GoogleFonts.outfit(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.55),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        inspectionDateText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff101C16),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // Findings & View Report
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Findings & recommendations available",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => InspectionReportDetailsScreen(
                          id: item.id?.toString() ?? "",
                          title: "Property Inspection Report",
                          date: displayDate,
                          property:
                              item.property?.propertyNameNumber ??
                              "Apartment A-204",
                          inspector: inspectorName,
                          inspectionDate: inspectionDateText,
                          status: statusText,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "View Report →",
                    style: GoogleFonts.outfit(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
