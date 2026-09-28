import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getServiceRequestDetailsModel.dart';
import 'package:property_care/core/constant/appColor.dart';

class ComplaintTrackingScreen extends StatefulWidget {
  final Data complaintData;
  const ComplaintTrackingScreen({super.key, required this.complaintData});

  @override
  State<ComplaintTrackingScreen> createState() =>
      _ComplaintTrackingScreenState();
}

class _ComplaintTrackingScreenState extends State<ComplaintTrackingScreen> {
  final double progress = 0.62;

  final activities = [
    {
      "title": "Complaint Submitted",
      "date": "21 Aug 2026 · 10:42 AM",
      "description": "Complaint successfully submitted by property owner.",
    },
    {
      "title": "Complaint Reviewed",
      "date": "21 Aug 2026 · 11:05 AM",
      "description": "Complaint reviewed by the association team.",
    },
    {
      "title": "Assigned to Maintenance",
      "date": "21 Aug 2026 · 11:15 AM",
      "description": "Maintenance supervisor assigned for inspection.",
    },
    {
      "title": "Site Inspection Scheduled",
      "date": "21 Aug 2026 · 02:30 PM",
      "description": "Maintenance visit scheduled for apartment A-204.",
    },
    {
      "title": "Issue Resolution",
      "date": "Pedning",
      "description": "Final repair and resolution confirmation is pending.",
    },
    {
      "title": "Complaint Closed",
      "date": "Pedning",
      "description":
          "Complaint will be closed after successful resolution and owner confirmation.",
    },
  ];
  @override
  Widget build(BuildContext context) {
    final complainData = widget.complaintData;

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
              SizedBox(width: 9.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "STATUS TRACKING",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "COMPLAINT RESOLUTION PROGRESS",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
          padding: EdgeInsetsGeometry.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 19.h),
                decoration: BoxDecoration(
                  color: Color.fromARGB(25, 16, 28, 22),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Color(0xFF101C16), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current Status",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(178, 42, 41, 51),
                                  letterSpacing: -0.3,
                                ),
                              ),
                              Text(
                                // "In Progress",
                                complainData?.header?.statusPill ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 13.w,
                            vertical: 4.5.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40.r),
                            border: Border.all(
                              color: const Color(0xFF101C16),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            "${complainData?.header?.completionPercentage}% COMPLETE",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF101C16),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Your complaint has been assigned to the maintenance team and the resolution process is currently underway.",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(178, 42, 41, 51),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: Color(0xFF101C16), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // "Water Leakage in Bathroom",
                          complainData?.header?.title ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF101C16),
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          // "CMP-2026-00124",
                          complainData?.header?.ticketNumber ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF101C16),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.w,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: Color(0xFF101C16),
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Category: ",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(16, 28, 22, 0.5),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        complainData
                                            ?.requestInformation
                                            ?.serviceCategory ??
                                        "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF101C16),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.w,
                          ),
                          margin: EdgeInsets.only(left: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            border: Border.all(
                              color: Color(0xFF101C16),
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Priority: ",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(16, 28, 22, 0.5),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        complainData
                                            ?.requestInformation
                                            ?.priority ??
                                        "",
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF101C16),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Resolution Progress',
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF101C16),
                  letterSpacing: -0.3,
                ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  top: 10.h,
                  bottom: 12.h,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(color: Color(0xFF101C16), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Overall Progress',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF101C16),
                            letterSpacing: -0.3,
                          ),
                        ),
                        Text(
                          '${complainData?.header?.completionPercentage ?? 0}%',
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF101C16),
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value:
                            ((complainData?.header?.completionPercentage ?? 0) /
                                    100)
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
              SizedBox(height: 20.h),
              Text(
                "Status Timeline",
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF101C16),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 11.h),
              ...List.generate(activities.length, (index) {
                final activity = complainData.statusTimeline![index];
                return _TimelineItem(
                  title: activity.label ?? "",
                  date: activity.dateTime ?? "",
                  isLast: index == complainData.statusTimeline!.length - 1,
                );
              }),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: Color(0xFF101C16), width: 1.w),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 30.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.4),
                            border: Border.all(
                              color: Color(0xFF101C16),
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.access_time_sharp,
                              color: Color(0xFF101C16),
                              size: 20.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          "${complainData.requestInformation?.property}",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      // "Maintenance supervisor has scheduled a site visit. The issue will be inspected before the repair work begins.",
                      "${complainData.requestDetails}",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2A2933),
                        letterSpacing: -0.1,
                      ),
                    ),
                  ],
                ),
              ),
              if (complainData?.assignedTo != null) ...[
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Color(0xFF101C16), width: 1.w),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.network(
                          complainData.assignedTo?.avatarUrl ?? "",
                          width: 50.w,
                          height: 50.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 50.w,
                                height: 50.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: Color(0xFF101C16),
                                    width: 1.w,
                                  ),
                                ),
                                child: Icon(Icons.person, size: 30.sp),
                              ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            complainData?.assignedTo?.name ?? "",
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF101C16),
                              letterSpacing: -0.2,
                            ),
                          ),
                          Text(
                            complainData.assignedTo?.role ?? "",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(16, 28, 22, 0.5),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Container(
                        width: 46.w,
                        height: 46.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.4),
                          border: Border.all(
                            color: Color(0xFF101C16),
                            width: 1.w,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.call_outlined,
                            color: Color(0xFF101C16),
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 27.h),
              Row(
                children: [
                  Expanded(
                    child: _buildButton(
                      title: "Back to Complaint",
                      backgroundColor: Colors.transparent,
                      borderColor: const Color(0xFF101C16),
                      textColor: const Color(0xFF101C16),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: _buildButton(
                      title: "Need Help?",
                      backgroundColor: const Color(0xFF101C16),
                      borderColor: const Color(0xFF101C16),
                      textColor: Colors.white,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 40.h,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.date,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 25.w,
            child: Column(
              children: [
                Container(
                  width: 25.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFFEF4),
                    border: Border.all(
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  child:
                      date.toLowerCase() == "pending" ||
                          date.toLowerCase() == "current status"
                      ? null
                      : Center(
                          child: Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF101C16),
                            ),
                          ),
                        ),
                ),
                // Vertical Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1..w,
                      color: const Color(0xFF000000),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 17.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    date,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(42, 41, 51, 0.5),
                      letterSpacing: -0.2,
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
}
