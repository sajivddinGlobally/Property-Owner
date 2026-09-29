import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/RentPaymentStatusScreen/RentPaymentStatus_Screen.dart';
import 'package:property_care/OwnerScreen/UtilityPaymentStatusScreen/UtilityPayment_Status.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:svg_flutter/svg.dart';

import 'Provider/getTenantDetailsProvider.dart';
import 'Provider/getTenantListProvider.dart';

class TenantDetailsScreen extends ConsumerStatefulWidget {
  final String tenantId;
  const TenantDetailsScreen({super.key, required this.tenantId});

  @override
  ConsumerState<TenantDetailsScreen> createState() =>
      _TenantDetailsScreenState();
}

class _TenantDetailsScreenState extends ConsumerState<TenantDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final tenantDetailState = ref.watch(
      getTenantDetailsProvider(widget.tenantId),
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
                    "TENANT DETAILS",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "View tenant and occupancy information",
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
      body: tenantDetailState.when(
        data: (tenantDetailsData) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF101C16), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            // "assets/tenantImg.png",
                            tenantDetailsData.data?.tenantDetails?.imageUrl ??
                                "",
                            width: 70.r,
                            height: 70.r,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 70.r,
                                height: 70.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.heading,
                                    width: 1.w,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 30.w,
                                    color: AppColors.heading,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          // "Arjun Kapoor",
                          tenantDetailsData.data?.tenantDetails?.name ?? "N/A",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          tenantDetailsData.data?.tenantDetails?.tenantType ??
                              "Primary Tenant",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 21.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: Color(0xFF000000),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            "${tenantDetailsData.data?.tenantDetails?.tenantStatus ?? ""} Tenant",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Tenant Information",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _documentRow(
                          title: "Full Name",
                          value:
                              tenantDetailsData.data?.tenantDetails?.name ??
                              "Arjun Kapoor",
                        ),
                        _documentRow(
                          title: "Tenant Type",
                          value:
                              tenantDetailsData
                                  .data
                                  ?.tenantDetails
                                  ?.tenantType ??
                              "Primary Tenant",
                        ),
                        _documentRow(
                          title: "Move-in Date",
                          value:
                              tenantDetailsData
                                  .data
                                  ?.tenantDetails
                                  ?.moveInDate ??
                              "N/A",
                        ),
                        _documentRow(
                          title: "Occupancy Status",
                          value:
                              tenantDetailsData
                                  .data
                                  ?.tenantDetails
                                  ?.occupancyStatus ??
                              "Currently Occupied",
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Property Details",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Color(0xFF000000),
                                  width: 1.w,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/SvgImage/proAparment.svg",
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tenantDetailsData
                                          .data
                                          ?.propertyDetails
                                          ?.apartmentNo ??
                                      "Apartment A-204",
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF101C16),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                Text(
                                  tenantDetailsData
                                          .data
                                          ?.propertyDetails
                                          ?.complexName ??
                                      "Green Valley Residency",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF000000),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Property Type",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Property Type",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tenantDetailsData
                                        .data
                                        ?.propertyDetails
                                        ?.propertyType ??
                                    "Apartment",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tenantDetailsData
                                        .data
                                        ?.propertyDetails
                                        ?.apartmentNo ??
                                    "A-204",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "FLOOR",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                "Ownership",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tenantDetailsData
                                        .data
                                        ?.propertyDetails
                                        ?.floor ??
                                    "2nd Floor",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tenantDetailsData
                                        .data
                                        ?.propertyDetails
                                        ?.occupancy ??
                                    "Tenant",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.heading),
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.receipt_long_outlined,
                                size: 19.sp,
                                color: AppColors.heading,
                              ),
                            ),

                            SizedBox(width: 10.w),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Utility Payment Status",
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF101C16),
                                    ),
                                  ),
                                  Text(
                                    "Current utility payment overview",
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                final tid =
                                    tenantDetailsData.data?.tenantDetails?.id
                                        ?.toString() ??
                                    widget.tenantId;
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        RentpaymentstatusScreen(id: tid),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 13.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF101C16,
                                  ).withOpacity(0.06),
                                  border: Border.all(color: AppColors.heading),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      tenantDetailsData
                                              .data
                                              ?.tenantDetails
                                              ?.rentPaymentStatus ??
                                          "Paid",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF101C16),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 11.sp,
                                      color: const Color(0xFF101C16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10.h),
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: const Color(0xFF999999),
                        ),
                        SizedBox(height: 8.h),

                        _utilityRow(
                          icon: Icons.bolt,
                          title: "Electricity",
                          status:
                              tenantDetailsData
                                  .data
                                  ?.utilitiesPaymentStatus
                                  ?.electricity
                                  ?.status ??
                              "Paid",
                          amount:
                              "₹${tenantDetailsData.data?.utilitiesPaymentStatus?.electricity?.lastPaidAmount ?? "0"}",
                        ),
                        _utilityRow(
                          icon: Icons.water_drop_outlined,
                          title: "Water",
                          status:
                              tenantDetailsData
                                  .data
                                  ?.utilitiesPaymentStatus
                                  ?.water
                                  ?.status ??
                              "Paid",
                          amount:
                              "₹${tenantDetailsData.data?.utilitiesPaymentStatus?.water?.lastPaidAmount ?? "0"}",
                        ),
                        _utilityRow(
                          icon: Icons.local_fire_department_outlined,
                          title: "Gas",
                          status:
                              tenantDetailsData
                                  .data
                                  ?.utilitiesPaymentStatus
                                  ?.gas
                                  ?.status ??
                              "Unpaid",
                          amount:
                              "₹${tenantDetailsData.data?.utilitiesPaymentStatus?.gas?.lastPaidAmount ?? "0"}",
                        ),

                        SizedBox(height: 7.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Outstanding",
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    color: Color.fromRGBO(42, 41, 51, 0.6),
                                  ),
                                ),
                                Text(
                                  "₹${"${tenantDetailsData.data?.utilitiesPaymentStatus?.totalOutstanding}"}",
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF101C16),
                                  ),
                                ),
                              ],
                            ),

                            InkWell(
                              onTap: () {
                                final tid =
                                    tenantDetailsData.data?.tenantDetails?.id
                                        ?.toString() ??
                                    widget.tenantId;
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        UtilitypaymentStatus(id: tid),
                                  ),
                                );
                              },
                              child: Text(
                                "View Details →",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF101C16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Contact Information",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.heading),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.heading,
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Icon(
                                  Icons.phone_outlined,
                                  color: AppColors.heading,
                                  size: 16.sp,
                                ),
                              ),

                              SizedBox(height: 8.h),

                              Text(
                                "Phone",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                ),
                              ),

                              SizedBox(height: 8.h),
                              Text(
                                "${tenantDetailsData.data?.tenantDetails?.phone}",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 20.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.heading),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.heading),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Icon(
                                  Icons.mail_outline,
                                  color: AppColors.heading,
                                  size: 16.sp,
                                ),
                              ),

                              SizedBox(height: 8.h),

                              Text(
                                "Email",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                tenantDetailsData.data?.tenantDetails?.email ??
                                    "N/A",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Additional Information",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      "Tenant information is maintained for property management and relevant property-related communication.",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
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
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Failed to load tenant details",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.heading,
                    ),
                    onPressed: () => ref.invalidate(getTenantListProvider),
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _documentRow({
    required String title,
    required String value,
    bool showBottomBorder = true,
  }) {
    return SizedBox(
      height: 50.h,
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
                  fontSize: 13.sp,
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
                fontSize: 15.sp,
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

  Widget _utilityRow({
    required IconData icon,
    required String title,
    required String status,
    required String amount,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF999999), width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 20.h,
            width: 20.w,
            color: const Color(0xFFE8D9AD),
            alignment: Alignment.center,
            child: Icon(icon, size: 13.sp, color: const Color(0xFFB58A2A)),
          ),

          SizedBox(width: 7.w),

          Expanded(
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF101C16),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                status,
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101C16),
                ),
              ),
              Text(
                amount,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  color: Color.fromRGBO(42, 41, 51, 0.6),
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
