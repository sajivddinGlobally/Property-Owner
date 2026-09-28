import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Complaint_Screen/Complaints_screen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Document_Screen/document_screen.dart';
import 'package:property_care/OwnerScreen/MaintenanceHistory_Screen/MaintenanceHistory_Screen.dart';
import 'package:property_care/OwnerScreen/ServiceRequest_Screen/Service_Request_Screen.dart';
import 'package:property_care/OwnerScreen/inspectionReport/inspectionReportScreen.dart';
import 'package:property_care/core/constant/appColor.dart';

import 'Provider/propertyConsolidatedStatusProvider.dart';

class PropertyStatusScreen extends ConsumerStatefulWidget {
  const PropertyStatusScreen({super.key});

  @override
  ConsumerState<PropertyStatusScreen> createState() =>
      _PropertyStatusScreenState();
}

class _PropertyStatusScreenState extends ConsumerState<PropertyStatusScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(consolidatedStateProvider);
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
                    "Property Status",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "CONSOLIDATED PROPERTY STATUS",
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
      body: state.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: const Color(0xff171717)),
        ),
        error: (error, stackTrace) => Center(child: Text("Error loading data")),
        data: (modelData) {
          final data = modelData.data;
          if (data == null) return Center(child: Text("No Data Available"));
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 13.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Stack(
                            children: [
                              Image.network(
                                data.propertyBanner?.imageUrl ?? "",
                                width: double.infinity,
                                height: 151.h,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: double.infinity,
                                      height: 151.h,
                                      color: Colors.grey,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(Icons.error_outline),
                                      ),
                                    ),
                              ),
                              Positioned(
                                left: 12.w,
                                top: 10.h,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                  ),
                                  height: 30.h,
                                  decoration: BoxDecoration(
                                    color: Color(0xff101C16),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      data.propertyBanner?.propertyName ?? "",
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.propertyBanner?.propertyName ?? "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff101C16),
                                      letterSpacing: -0.54,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    data.propertyBanner?.complexLocation ?? "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(42, 41, 51, 0.6),
                                      letterSpacing: -0.34,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 17.w,
                                vertical: 5.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.heading),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: 7.h,
                                    width: 7.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.heading,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Text(
                                    data.propertyBanner?.statusBubble ?? "",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                      fontSize: 14.sp,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        SizedBox(height: 10.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.heading),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  "${data.propertyBanner?.score ?? 0}",
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.heading,
                                    fontSize: 17.sp,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Property Status",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                      fontSize: 17.sp,
                                      letterSpacing: -0.2,
                                    ),
                                  ),

                                  SizedBox(height: 3.h),

                                  Text(
                                    data.propertyBanner?.statusText ?? "",
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.6,
                                      ),
                                      fontSize: 14.sp,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: ((data.propertyBanner?.score ?? 0) / 100)
                                .toDouble()
                                .clamp(0.0, 1.0),
                            minHeight: 3.h,
                            backgroundColor: const Color(0xff919191),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF101C16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Text(
                        "Current Status",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 17.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  const ServiceRequestScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "View All",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            fontSize: 15.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 21.w,
                    mainAxisSpacing: 17.h,
                    childAspectRatio: 2.h,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _infoCard(
                        icon: Icons.priority_high,
                        value: "${data.currentStatus?.pendingIssues ?? 0}",
                        title: "Pending Issues",
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

                      _infoCard(
                        icon: Icons.arrow_forward,
                        value:
                            "${data.currentStatus?.openServiceRequests ?? 0}",
                        title: "Open Service Requests",
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

                      _infoCard(
                        icon: Icons.access_time,
                        value: data.currentStatus?.recentInspectionDate ?? "",
                        title: "Recent Inspection",
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

                      _infoCard(
                        icon: Icons.check,
                        value: "${data.currentStatus?.completedWork ?? 0}",
                        title: "Completed Work",
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
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Text(
                        "Maintenance Activities",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 17.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  const MaintenancehistoryScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "See All",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            fontSize: 15.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  if (data.maintenanceActivities != null &&
                      data.maintenanceActivities!.isNotEmpty) ...[
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 17.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffFFFDF0),
                        border: Border.all(
                          color: const Color(0xff999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: Column(
                        children: List.generate(
                          data.maintenanceActivities!.length,
                          (index) {
                            final activity = data.maintenanceActivities![index];

                            return Column(
                              children: [
                                _auditItem(
                                  icon: "✓",
                                  title: activity.title ?? "",
                                  description: activity.description ?? "",
                                  timeAgo: activity.timeAgo ?? "",
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

                                if (index !=
                                    data.maintenanceActivities!.length - 1) ...[
                                  SizedBox(height: 12.h),

                                  Container(
                                    width: double.infinity,
                                    height: 1.h,
                                    color: const Color(0xff202820),
                                  ),

                                  SizedBox(height: 12.h),
                                ],
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Text(
                        "Important Property Issues",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 17.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const ComplaintsScreen(
                                isShowBackButton: true,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "View All",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            fontSize: 15.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 17.h),
                  ...List.generate(
                    (data.importantPropertyIssues ?? []).length,
                    (index) {
                      final issue = data.importantPropertyIssues![index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const ComplaintsScreen(
                                isShowBackButton: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 17.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFDF0),
                            border: Border.all(
                              color: const Color(0xff999999),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  issue.imageUrl ?? "",
                                  width: 50.w,
                                  height: 50.h,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                        width: 50.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                          color: Colors.grey.shade100,
                                          border: Border.all(
                                            color: Colors.grey.shade200,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.error_outline,
                                          color: AppColors.heading,
                                          size: 20.sp,
                                        ),
                                      ),
                                ),
                              ),
                              SizedBox(width: 13.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      issue.title ?? "",
                                      style: GoogleFonts.inter(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                        height: 1.h,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      issue.description ?? "",
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(42, 41, 51, 0.5),
                                        letterSpacing: -0.2,
                                        height: 1.2.h,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 13.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.heading),
                                  borderRadius: BorderRadius.circular(50.r),
                                ),
                                child: Text(
                                  issue.statusLabel ?? "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Text(
                        "Latest Reports & Documents",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 17.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const DocumentScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "View All",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            fontSize: 15.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ...List.generate((data.latestReportsDocuments ?? []).length, (
                    index,
                  ) {
                    final doc = data.latestReportsDocuments![index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: _reportCard(
                        title: doc.title ?? "",
                        subtitle: doc.subtitle ?? "",
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  const DocumentScreen(isShowBackButton: true),
                            ),
                          );
                        },
                      ),
                    );
                  }),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String value,
    required String title,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(9.r),
      child: Container(
        padding: EdgeInsets.only(
          left: 16.w,
          top: 9.h,
          right: 10.w,
          bottom: 8.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF171717), width: 1),
          borderRadius: BorderRadius.circular(9.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, size: 15.sp, color: AppColors.heading),
            Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.heading,
              ),
            ),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF777777),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _auditItem({
    required String icon,
    required String title,
    required String description,
    required String timeAgo,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: Color.fromRGBO(16, 28, 22, 0.2),
              borderRadius: BorderRadius.circular(3.r),
            ),
            alignment: Alignment.center,
            child: Text(
              icon,
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.heading,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.heading,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(42, 41, 51, 0.5),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          Text(
            timeAgo,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(42, 41, 51, 0.5),
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reportCard({
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff101C16), width: 1.2),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: Row(
          children: [
            Container(
              width: 42.w,
              height: 42.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xffE1E0D5),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.article_outlined,
                size: 18.sp,
                color: const Color(0xff5C5D58),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color.fromRGBO(42, 41, 51, 0.6),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward,
              size: 18.sp,
              color: const Color(0xff101C16),
            ),
          ],
        ),
      ),
    );
  }
}
