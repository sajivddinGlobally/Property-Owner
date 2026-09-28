import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/MaintenancePaymentStatusScreen/Provider/maintenancePaymentStatusProvider.dart';
import 'package:property_care/core/constant/appColor.dart';

class MaintenancePaymentStatus extends ConsumerStatefulWidget {
  const MaintenancePaymentStatus({super.key});

  @override
  ConsumerState<MaintenancePaymentStatus> createState() =>
      _MaintenancePaymentStatusState();
}

class _MaintenancePaymentStatusState
    extends ConsumerState<MaintenancePaymentStatus> {
  @override
  Widget build(BuildContext context) {
    final maintenancePaymentStatusState = ref.watch(
      maintenancePaymentStatusProvider,
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
                    "Maintenance Payment Status",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Track maintenance charge status",
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
      body: maintenancePaymentStatusState.when(
        data: (data) {
          final resData = data.data;
          final property = resData?.property;
          final currentStatus = resData?.currentStatus;
          final monthlyRecords = resData?.monthlyRecords ?? [];
          final reminder = resData?.reminder;

          final bool isUnpaid =
              property?.badgeStatus?.toLowerCase() == "unpaid" ||
              currentStatus?.paymentStatus?.toLowerCase() == "pending" ||
              currentStatus?.paymentStatus?.toLowerCase() == "unpaid";

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    property?.name ?? "N/A",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF101C16),
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    property?.complexName ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.6,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 19.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isUnpaid
                                      ? Colors.red
                                      : const Color(0xff24B06A),
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Text(
                                property?.badgeStatus ?? "Unpaid",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isUnpaid
                                      ? Colors.red
                                      : const Color(0xff24B06A),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 14.h),
                        Text(
                          "Outstanding Amount",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff2A2933),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          property?.formattedOutstanding ??
                              (property?.outstandingAmount != null
                                  ? "₹ ${property!.outstandingAmount}"
                                  : "₹ 0"),
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF101C16),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Current Status",
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
                          title: "Monthly Charge",
                          value:
                              currentStatus?.formattedMonthlyCharge ??
                              (currentStatus?.monthlyCharge != null
                                  ? "₹ ${currentStatus!.monthlyCharge}"
                                  : "N/A"),
                          color: AppColors.heading,
                        ),
                        _documentRow(
                          title: "Due Date",
                          value: currentStatus?.dueDate ?? "N/A",
                          color: AppColors.heading,
                        ),
                        _documentRow(
                          title: "Payment Status",
                          value: currentStatus?.paymentStatus ?? "N/A",
                          color:
                              currentStatus?.paymentStatus?.toLowerCase() ==
                                  "paid"
                              ? const Color(0xff24B06A)
                              : const Color(0xffFBE414),
                        ),
                        _documentRow(
                          title: "Defaulter Status",
                          value:
                              currentStatus?.defaulterStatus ??
                              (currentStatus?.isDefaulter == true
                                  ? "Yes"
                                  : "No"),
                          color:
                              (currentStatus?.isDefaulter == true ||
                                  currentStatus?.defaulterStatus
                                          ?.toLowerCase() ==
                                      "yes")
                              ? Colors.red
                              : const Color(0xff24B06A),
                        ),
                        _documentRow(
                          title: "Last Updated",
                          value: currentStatus?.lastUpdated ?? "N/A",
                          color: AppColors.heading,
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Monthly Records",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  if (monthlyRecords.isNotEmpty)
                    ...List.generate(monthlyRecords.length, (index) {
                      final item = monthlyRecords[index];
                      final month =
                          (item is Map ? item['month'] ?? item['title'] : null)
                              ?.toString() ??
                          "Record ${index + 1}";
                      final subTitle =
                          (item is Map
                                  ? item['sub_title'] ?? item['due_date']
                                  : null)
                              ?.toString() ??
                          "";
                      final status =
                          (item is Map ? item['status'] : null)?.toString() ??
                          "Unpaid";
                      final amount =
                          (item is Map
                                  ? item['formatted_amount'] ?? item['amount']
                                  : null)
                              ?.toString() ??
                          "0";
                      final isPaid = status.toLowerCase() == "paid";
                      final rightTitle =
                          (item is Map ? item['right_title'] : null)
                              ?.toString();
                      final rightValue =
                          (item is Map ? item['right_value'] : null)
                              ?.toString();

                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: paymentHistoryCard(
                          month: month,
                          subTitle: subTitle,
                          status: status,
                          amount: amount,
                          rightTitle: rightTitle,
                          rightValue: rightValue,
                          isPaid: isPaid,
                        ),
                      );
                    })
                  else
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.heading.withValues(alpha: 0.3),
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Center(
                        child: Text(
                          "No monthly records available",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: const Color.fromRGBO(42, 41, 51, 0.6),
                          ),
                        ),
                      ),
                    ),
                  if (reminder?.show == true) ...[
                    SizedBox(height: 20.h),
                    Text(
                      "Reminder",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF101C16),
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading, width: 1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder?.title ?? "Maintenance Payment Reminder",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF101C16),
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            reminder?.message ?? "",
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF101C16),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 40.sp, color: Colors.red),
                SizedBox(height: 10.h),
                Text(
                  "Failed to load payment status",
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.heading,
                  ),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(maintenancePaymentStatusProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                  ),
                  child: Text(
                    "Retry",
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                ),
              ],
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
                  fontSize: 13.sp,
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

  Widget paymentHistoryCard({
    required String month,
    required String subTitle,
    required String status,
    required String amount,
    String? rightTitle,
    String? rightValue,
    bool isPaid = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Row(
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

                    SizedBox(height: 2.h),

                    Text(
                      subTitle,
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(42, 41, 51, 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 4.h),
                decoration: BoxDecoration(
                  border: Border.all(color: isPaid ? Colors.green : Colors.red),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: isPaid ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 36.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Amount",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(42, 41, 51, 0.6),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      "₹ $amount",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF101C16),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (rightTitle != null && rightValue != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      rightTitle,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(42, 41, 51, 0.6),
                        letterSpacing: -0.2,
                      ),
                    ),

                    SizedBox(height: 3.h),

                    Text(
                      rightValue,
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
        ],
      ),
    );
  }
}
