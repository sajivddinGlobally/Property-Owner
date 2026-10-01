import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:property_care/OwnerScreen/Audit_Report/AuditReport_Details_Screen.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getInspectionReportModel.dart';
import 'package:property_care/core/constant/appColor.dart';

import '../inspectionReport/Provider/getInspectionReportProvider.dart';

class AuditreprotScreen extends ConsumerStatefulWidget {
  const AuditreprotScreen({super.key});

  @override
  ConsumerState<AuditreprotScreen> createState() => _AuditreprotScreenState();
}

class _AuditreprotScreenState extends ConsumerState<AuditreprotScreen> {
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
      getInspectionReportProvider((filter: selectedFilterValue, type: "audit")),
    );

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
                  width: 44.w,
                  height: 44.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromRGBO(16, 28, 22, 0.3),
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: const Color(0xff101C16),
                    size: 20.sp,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Audit Reports",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "AUDIT REPORT HISTORY",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
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
      body: getInspectionReport.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xff101C16)),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Failed to load audit reports",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
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
                    type: "audit",
                  )),
                ),
                child: Text(
                  "Retry",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16.sp,
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
              firstProperty?.location ?? "Green Valley Residency · Jaipur";
          final filteredReports = allReports;

          return RefreshIndicator(
            color: const Color(0xff101C16),
            onRefresh: () async {
              return ref.refresh(
                getInspectionReportProvider((
                  filter: selectedFilterValue,
                  type: "audit",
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
                    if (filteredReports.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 15.h,
                          horizontal: 13.w,
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
                              child: Center(
                                child: Image.asset(
                                  "assets/auditImg.png",
                                  height: 18.h,
                                  width: 18.w,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    propertyName,
                                    style: GoogleFonts.outfit(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    propertyLocation,
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.5,
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
                    Text(
                      "Audit Reports",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      "View previous audit reports, audit dates, findings and\n recommendations.",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(42, 41, 51, 0.5),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Row(
                      children: [
                        Expanded(
                          child: _reportFilterButton(
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
                          child: _reportFilterButton(
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
                          child: _reportFilterButton(
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
                    if (filteredReports.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.h),
                          child: Text(
                            "No audit reports found",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
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
                          return _auditCard(item);
                        },
                      ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _auditCard(Datum item) {
    final reportDate = item.inspectionDate ?? item.createdAt;
    final displayDate = reportDate != null
        ? DateFormat("dd MMMM yyyy").format(reportDate)
        : "";

    final statusText = item.status != null && item.status!.isNotEmpty
        ? "${item.status![0].toUpperCase()}${item.status!.substring(1)}"
        : "Completed";

    final auditDateText = item.inspectionDate != null
        ? DateFormat("dd MMM yyyy").format(item.inspectionDate!)
        : (item.createdAt != null
              ? DateFormat("dd MMM yyyy").format(item.createdAt!)
              : "N/A");

    final auditTypeText =
        (item.auditType != null && item.auditType.toString().trim().isNotEmpty)
        ? item.auditType.toString()
        : "Property Audit";

    final findingsText =
        (item.findings != null && item.findings!.trim().isNotEmpty)
        ? "Available"
        : "None";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => AuditreportDetailsScreen(
              id: item.id?.toString() ?? "",
              title: "Property Audit Report",
              date: displayDate,
              property: item.property?.propertyNameNumber ?? "Apartment A-204",
              auditType: auditTypeText,
              auditDate: auditDateText,
              status: statusText,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 15.h),
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff101C16), width: 1.2),
          borderRadius: BorderRadius.circular(13.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 49.w,
                  height: 51.h,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff101C16),
                      width: 1.1,
                    ),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.article_outlined,
                      size: 22.sp,
                      color: const Color(0xff101C16),
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Property Audit Report",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff101C16),
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 7.h),
                      Text(
                        displayDate,
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(16, 28, 22, 0.6),
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff101C16)),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    statusText,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101C16),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            const Divider(height: 1, thickness: 1, color: Color(0xff777970)),
            SizedBox(height: 17.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _infoItem(title: "AUDIT TYPE", value: auditTypeText),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: _infoItem(title: "AUDIT DATE", value: auditDateText),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _infoItem(title: "REPORT STATUS", value: statusText),
                ),
                SizedBox(width: 15.w),
                Expanded(
                  child: _infoItem(title: "FINDINGS", value: findingsText),
                ),
              ],
            ),
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Findings & recommendations available",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AuditreportDetailsScreen(
                          id: item.id?.toString() ?? "",
                          title: "Property Audit Report",
                          date: displayDate,
                          property:
                              item.property?.propertyNameNumber ??
                              "Apartment A-204",
                          auditType: auditTypeText,
                          auditDate: auditDateText,
                          status: statusText,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "View Report →",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
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

  Widget _reportFilterButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 8.w),

        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: isSelected
                ? const Color(0xff101C16)
                : const Color(0xff8B8D84),
            width: 1.2,
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
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
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

  Widget _infoItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(16, 28, 22, 0.6),
            letterSpacing: -0.2,
          ),
        ),

        SizedBox(height: 2.h),

        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
