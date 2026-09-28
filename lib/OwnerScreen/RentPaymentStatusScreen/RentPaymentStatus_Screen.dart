import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/RentPaymentStatusScreen/provider/getUtilityStatusProvider.dart';
import 'package:property_care/core/constant/appColor.dart';

class RentpaymentstatusScreen extends ConsumerStatefulWidget {
  final String id;
  const RentpaymentstatusScreen({super.key, required this.id});

  @override
  ConsumerState<RentpaymentstatusScreen> createState() =>
      _RentpaymentstatusScreenState();
}

class _RentpaymentstatusScreenState
    extends ConsumerState<RentpaymentstatusScreen> {
  @override
  Widget build(BuildContext context) {
    final getUtilityPaymentState = ref.watch(
      getUtilityStatusProvider(widget.id),
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
                    getUtilityPaymentState.value?.data?.header?.screenTitle ??
                        "RENT PAYMENT STATUS",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    getUtilityPaymentState.value?.data?.header?.subtitle ??
                        "Track utility charge information",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
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
      body: getUtilityPaymentState.when(
        data: (data) {
          final propertyDetails = data.data?.propertyDetails;
          final summary = data.data?.summary;
          final currentUtilityList = data.data?.currentUtilityStatus ?? [];
          final historyList = data.data?.utilityPaymentHistory ?? [];
          final reminder = data.data?.reminder;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                propertyDetails?.propertyName ?? "N/A",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  fontSize: 17.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              if (propertyDetails?.complexName != null &&
                                  propertyDetails!.complexName!.isNotEmpty)
                                Text(
                                  propertyDetails.complexName!,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: const Color.fromRGBO(
                                      42,
                                      41,
                                      51,
                                      0.5,
                                    ),
                                    fontSize: 13.sp,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 25.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.heading),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            propertyDetails?.status ?? "Active",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              fontSize: 17.sp,
                              letterSpacing: -0.2,
                            ),
                          ),
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
                          "Total Outstanding Utility Charges",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          summary?.totalOutstanding != null
                              ? "₹${summary!.totalOutstanding}"
                              : "₹0",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          summary?.description ??
                              "Current unpaid utility charges",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                        SizedBox(height: 18.h),
                        Row(
                          children: [
                            Expanded(
                              child: _utilityInfoBox(
                                title: "Current Month",
                                value: summary?.currentMonth ?? "N/A",
                              ),
                            ),
                            SizedBox(width: 18.w),
                            Expanded(
                              child: _utilityInfoBox(
                                title: "Pending Bills",
                                value: summary?.pendingBillsCount != null
                                    ? "${summary!.pendingBillsCount}"
                                    : "0",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Current Utility Status",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      fontSize: 17.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  if (currentUtilityList.isEmpty)
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
                        "No current utility charges",
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF777777),
                        ),
                      ),
                    )
                  else
                    ...currentUtilityList.map((utility) {
                      final badgeText =
                          utility.badge ?? utility.status ?? "Pending";
                      final isPaid =
                          badgeText.toLowerCase() == "paid" ||
                          utility.status?.toLowerCase() == "paid";

                      return Padding(
                        padding: EdgeInsets.only(bottom: 14.h),
                        child: _utilityCard(
                          utilityType: utility.utilityType,
                          title:
                              utility.utilityType ?? utility.title ?? "Utility",
                          subtitle: utility.title ?? "",
                          amount: utility.amount != null
                              ? "₹${utility.amount}"
                              : "₹0",
                          date: utility.dueDate ?? "N/A",
                          status: utility.status ?? "Pending",
                          badge: badgeText,
                          paid: isPaid,
                        ),
                      );
                    }),
                  SizedBox(height: 10.h),
                  Text(
                    "Utility Payment History",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
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
                          final badge =
                              history.badge ?? history.status ?? "Pending";
                          final badgeLower = badge.toLowerCase();
                          final isPaid = badgeLower == "paid";
                          final isPartiallyPaid = badgeLower.contains(
                            "partially",
                          );
                          final isOverdue =
                              badgeLower == "overdue" || badgeLower == "unpaid";

                          Color hStatusColor = const Color(0xFFB77B00);
                          if (isPaid) {
                            hStatusColor = const Color(0xFF24B56B);
                          } else if (isOverdue) {
                            hStatusColor = const Color(0xFFD41F1F);
                          } else if (isPartiallyPaid) {
                            hStatusColor = const Color(0xFFB77B00);
                          }

                          final subtitle =
                              history.label ??
                              (isPaid ? "Total Charges" : "Outstanding");
                          final amountDisplay = history.amount != null
                              ? "₹${history.amount}"
                              : "";

                          return _rentHistoryItem(
                            month: history.month ?? "",
                            subtitle: subtitle,
                            status: badge,
                            amount: amountDisplay,
                            statusColor: hStatusColor,
                            showDivider: index < historyList.length - 1,
                          );
                        }).toList(),
                      ),
                    ),
                  if (reminder != null && reminder.show == true) ...[
                    SizedBox(height: 20.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF9E6),
                        border: Border.all(color: const Color(0xFFE0C475)),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: const Color(0xFFB77B00),
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (reminder.title != null &&
                                    reminder.title!.isNotEmpty)
                                  Text(
                                    reminder.title!,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF101C16),
                                    ),
                                  ),
                                if (reminder.title != null &&
                                    reminder.title!.isNotEmpty)
                                  SizedBox(height: 4.h),
                                if (reminder.message != null &&
                                    reminder.message!.isNotEmpty)
                                  Text(
                                    reminder.message!,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF555555),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  Widget _utilityInfoBox({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF101C16),
            ),
          ),
          SizedBox(height: 4.h),
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

  Widget _utilityCard({
    required String title,
    required String subtitle,
    required String amount,
    required String date,
    required String status,
    required String badge,
    required bool paid,
    String? utilityType,
  }) {
    IconData getUtilityIcon(String? type) {
      final t = type?.toLowerCase() ?? "";
      if (t.contains("water")) return Icons.water_drop_outlined;
      if (t.contains("gas")) return Icons.local_fire_department_outlined;
      return Icons.bolt;
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(12.r),
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
                  borderRadius: BorderRadius.circular(3.r),
                ),
                child: Icon(
                  getUtilityIcon(utilityType),
                  size: 16.sp,
                  color: AppColors.heading,
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
                        fontSize: 17.sp,
                        color: const Color(0xFF101C16),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: paid ? AppColors.heading : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  badge,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    color: paid ? AppColors.heading : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.heading, height: 1),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _info("AMOUNT", amount),
              _info("DUE DATE", date),
              _info("STATUS", status),
            ],
          ),
        ],
      ),
    );
  }

  Widget _info(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(fontSize: 12.sp, color: Colors.grey),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            color: const Color(0xFF101C16),
          ),
        ),
      ],
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
                        fontSize: 13.sp,
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
          Divider(thickness: 0.8, color: const Color(0xFF999999)),
      ],
    );
  }
}
