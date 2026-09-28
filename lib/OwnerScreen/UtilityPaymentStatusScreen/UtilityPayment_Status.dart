import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/RentPaymentStatusScreen/RentPaymentStatus_Screen.dart';
import 'package:property_care/core/constant/appColor.dart';

import 'provider/getTenantPaymentProvider.dart';

class UtilitypaymentStatus extends ConsumerStatefulWidget {
  final String id;
  const UtilitypaymentStatus({super.key, required this.id});

  @override
  ConsumerState<UtilitypaymentStatus> createState() =>
      _UtilitypaymentStatusState();
}

class _UtilitypaymentStatusState extends ConsumerState<UtilitypaymentStatus> {
  @override
  Widget build(BuildContext context) {
    final tenantsData = ref.watch(getTenantPaymentProvider(widget.id));
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
                    "UTILITY PAYMENT STATUS",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Track utility charge information",
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
      body: tenantsData.when(
        data: (data) {
          final tenant = data.data;
          final currentRent = tenant?.currentRentStatus;
          final historyList = tenant?.rentPaymentHistory ?? [];

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 51.w,
                              height: 51.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffF1F1EC),
                              ),
                              child: ClipOval(
                                child:
                                    (tenant?.tenantImageUrl != null &&
                                        tenant!.tenantImageUrl
                                            .toString()
                                            .trim()
                                            .isNotEmpty)
                                    ? Image.network(
                                        tenant.tenantImageUrl.toString().trim(),
                                        width: 51.w,
                                        height: 51.w,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 51.w,
                                                  height: 51.w,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Color(0xffF1F1EC),
                                                  ),
                                                  child: Icon(
                                                    Icons.person,
                                                    color: Colors.grey[400],
                                                    size: 30.sp,
                                                  ),
                                                ),
                                      )
                                    : Container(
                                        width: 51.w,
                                        height: 51.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffF1F1EC),
                                        ),
                                        child: Icon(
                                          Icons.person,
                                          color: Colors.grey[400],
                                          size: 30.sp,
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
                                    tenant?.tenantName ?? "N/A",
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    tenant?.tenantType ?? "Primary Tenant",
                                    style: GoogleFonts.outfit(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(0, 0, 0, 0.6),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 2.h,
                                horizontal: 22.w,
                              ),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.heading),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Text(
                                tenant?.tenantStatus ?? "Active",
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
                        SizedBox(height: 10.h),
                        Container(
                          width: double.infinity,
                          height: 1.h,
                          color: const Color(0xff999999),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Text(
                              "Property",
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              tenant?.propertyName ?? "N/A",
                              style: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Outstanding Rent",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF777777),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          tenant?.currentOutstanding != null
                              ? "₹${tenant!.currentOutstanding}"
                              : "₹0",
                          style: GoogleFonts.outfit(
                            fontSize: 19.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "Utility amount currently pending",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromRGBO(42, 41, 51, 0.6),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: _rentInfoBox(
                                title: "Monthly Rent",
                                value: tenant?.monthlyRent != null
                                    ? "₹${tenant!.monthlyRent}"
                                    : "₹0",
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: _rentInfoBox(
                                title: "Due Date",
                                value: tenant?.dueDate ?? "N/A",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Current Utility Status",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF101C16),
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
                          title: "Month",
                          value: currentRent?.month ?? "N/A",
                          color: AppColors.heading,
                        ),
                        _documentRow(
                          title: "Amount",
                          value: currentRent?.rentAmount != null
                              ? "₹${currentRent!.rentAmount}"
                              : "₹0",
                          color: AppColors.heading,
                        ),
                        _documentRow(
                          title: "Due Date",
                          value: currentRent?.dueDate ?? "N/A",
                          color: AppColors.heading,
                        ),
                        _documentRow(
                          title: "Payment Status",
                          value: currentRent?.paymentStatus ?? "Unpaid",
                          color:
                              (currentRent?.paymentStatus?.toLowerCase() ==
                                  "paid")
                              ? const Color(0xFF24B56B)
                              : (currentRent?.paymentStatus?.toLowerCase() ==
                                    "pending")
                              ? const Color(0xFFB77B00)
                              : const Color(0xffD41F1F),
                        ),
                        _documentRow(
                          title: "Last Updated",
                          value: currentRent?.lastPayment ?? "N/A",
                          color: AppColors.heading,
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rent Payment History",
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF101C16),
                          letterSpacing: -0.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RentpaymentstatusScreen(
                                id: widget.id.isNotEmpty ? widget.id : "",
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "View Details →",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  if (historyList.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 20.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading, width: 1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "No payment history available",
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF777777),
                        ),
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading, width: 1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Column(
                        children: historyList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final history = entry.value;
                          final hStatus = history.status?.toLowerCase() ?? "";
                          final isPaid = hStatus == "paid";
                          final isOverdue = hStatus == "overdue";

                          Color hStatusColor = const Color(0xFFB77B00);
                          if (isPaid) {
                            hStatusColor = const Color(0xFF24B56B);
                          } else if (isOverdue) {
                            hStatusColor = const Color(0xFFD41F1F);
                          }

                          final subtitle = isPaid ? "Paid On" : "Rent";
                          final amountDisplay = isPaid
                              ? (history.paidOn != null &&
                                        history.paidOn.toString().isNotEmpty
                                    ? history.paidOn.toString()
                                    : (history.rentAmount != null
                                          ? "₹${history.rentAmount}"
                                          : ""))
                              : (history.rentAmount != null
                                    ? "₹${history.rentAmount}"
                                    : "");

                          return _rentHistoryItem(
                            month: history.month ?? "",
                            subtitle: subtitle,
                            status: history.status ?? "Pending",
                            amount: amountDisplay,
                            statusColor: hStatusColor,
                            showDivider: index < historyList.length - 1,
                          );
                        }).toList(),
                      ),
                    ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text(
              "Error Loading Data",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                color: AppColors.heading,
              ),
            ),
          );
        },
        loading: () {
          return Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          );
        },
      ),
    );
  }

  Widget _rentInfoBox({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF101C16),
              letterSpacing: -0.2,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF101C16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentRow({
    required String title,
    required String value,
    required Color color,
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
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(42, 41, 51, 0.6),
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
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: color,
                letterSpacing: -0.24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rentHistoryItem({
    required String month,
    required String subtitle,
    required String status,
    required String amount,
    required Color statusColor,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      month,
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF101C16),
                        letterSpacing: -0.2,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF777777),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: statusColor, width: 1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: statusColor,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  Text(
                    amount,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
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

        if (showDivider)
          Divider(height: 1, thickness: 0.8, color: const Color(0xFF999999)),
      ],
    );
  }
}
