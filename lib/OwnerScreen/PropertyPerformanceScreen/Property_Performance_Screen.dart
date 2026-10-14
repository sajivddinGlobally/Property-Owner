import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/PropertyPerformanceScreen/Provider/getPropertyScoreProvider.dart';
import 'package:property_care/core/constant/appColor.dart';

class PropertyPerformanceScreen extends ConsumerStatefulWidget {
  const PropertyPerformanceScreen({super.key});

  @override
  ConsumerState<PropertyPerformanceScreen> createState() =>
      _PropertyPerformanceScreenState();
}

class _PropertyPerformanceScreenState
    extends ConsumerState<PropertyPerformanceScreen> {
  final double progress = 0.90;
  @override
  Widget build(BuildContext context) {
    final getPropertyScoreState = ref.watch(getPropertyScoreProvider);
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
                    "Property Performance",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "View your property's overall performance",
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
      body: getPropertyScoreState.when(
        loading: () => Center(
          child: CircularProgressIndicator(color: const Color(0xff171717)),
        ),
        error: (error, stackTrace) {
          log(error.toString());
          log(stackTrace.toString());
          return Center(child: Text("Error loading data"));
        },
        data: (modelData) {
          final data = modelData.data;
          if (data == null)
            return const Center(child: Text("No Data Available"));
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                data.propertyHeader?.propertyNameNumber ?? "",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  fontSize: 18.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                data.propertyHeader?.complexName ?? "",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.5),
                                  fontSize: 15.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.heading),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            data.propertyHeader?.status ?? "",
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
                  ),
                  SizedBox(height: 23.h),
                  propertyScoreCard(
                    score: data.overallPropertyScore?.score?.toDouble() ?? 0.0,
                    scoreOutOf: data.overallPropertyScore?.total ?? 0,
                    performanceLabel:
                        data.overallPropertyScore?.performanceLabel ?? "",
                    lastUpdated: data.overallPropertyScore?.lastUpdated ?? "",
                  ),
                  SizedBox(height: 21.h),
                  Row(
                    children: [
                      Text(
                        "Performance Breakdown",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "Current",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 17.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 14.h,
                      horizontal: 14.w,
                    ),
                    decoration: BoxDecoration(
                      // color: AppColors.cardBg,
                      border: Border.all(color: AppColors.borderLight),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Builder(
                      builder: (context) {
                        final defaultCategories = [
                          {"label": "Building structural health", "max": 3.0},
                          {"label": "Plumbing system", "max": 2.0},
                          {"label": "Electrical system", "max": 2.0},
                          {"label": "Maintenance frequency", "max": 2.0},
                          {"label": "Property management", "max": 1.0},
                        ];

                        final apiItems = data.performanceBreakdown ?? [];
                        final List<Map<String, dynamic>> itemsToShow = [];

                        for (var def in defaultCategories) {
                          final defLabel = def["label"] as String;
                          final double maxVal = def["max"] as double;

                          dynamic matched;
                          try {
                            matched = apiItems.firstWhere(
                              (it) => (it.label ?? "").toLowerCase().contains(
                                defLabel.toLowerCase().split(' ').first,
                              ),
                            );
                          } catch (_) {
                            matched = null;
                          }

                          double val = 0.0;
                          if (matched != null) {
                            final parsed =
                                double.tryParse(
                                  matched.value?.toString() ?? "0",
                                ) ??
                                0.0;
                            val = parsed > maxVal
                                ? (parsed / 100.0) * maxVal
                                : parsed;
                          } else {
                            final double overall =
                                data.overallPropertyScore?.score?.toDouble() ??
                                7.5;
                            final double total =
                                (data.overallPropertyScore?.total ?? 10)
                                    .toDouble();
                            final double ratio = total > 0
                                ? (overall / total)
                                : 0.75;
                            val = double.parse(
                              (maxVal * ratio).toStringAsFixed(1),
                            );
                          }

                          itemsToShow.add({
                            "title": defLabel,
                            "score": val,
                            "max": maxVal,
                          });
                        }

                        return Column(
                          children: List.generate(itemsToShow.length, (index) {
                            final item = itemsToShow[index];
                            return Column(
                              children: [
                                _progressItem(
                                  title: item["title"] as String,
                                  score: item["score"] as double,
                                  maxScore: item["max"] as double,
                                ),
                                if (index != itemsToShow.length - 1)
                                  SizedBox(height: 14.h),
                              ],
                            );
                          }),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 13.h),
                  Text(
                    "Performance Summary",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 18.sp,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          title: "Inspections",
                          value:
                              data.performanceSummary?.inspections
                                  ?.toString() ??
                              "0",
                        ),
                      ),

                      SizedBox(width: 20.w),

                      Expanded(
                        child: _summaryCard(
                          title: "Maintenance",
                          value:
                              data.performanceSummary?.maintenance
                                  ?.toString() ??
                              "0",
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),

                  Row(
                    children: [
                      Expanded(
                        child: _summaryCard(
                          title: "Services Resolved",
                          value:
                              data.performanceSummary?.servicesResolved
                                  ?.toString() ??
                              "0",
                        ),
                      ),

                      SizedBox(width: 20.w),

                      Expanded(
                        child: _summaryCard(
                          title: "Open Issues",
                          value:
                              data.performanceSummary?.openIssues?.toString() ??
                              "0",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Text(
                        "Score Trend",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 18.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      Spacer(),
                      Text(
                        data.scoreTrend?.label ?? "",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 17.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading, width: 1),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Property Score",
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101C16),
                              ),
                            ),
                            Text(
                              data.scoreTrend?.improvement ?? "",
                              style: GoogleFonts.outfit(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF101C16),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 15.h),
                        // SizedBox(
                        //   height: 125.h,
                        //   child: Column(
                        //     children: [
                        //       Expanded(
                        //         child: Row(
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           children: (data.scoreTrend?.chartData ?? [])
                        //               .map((item) {
                        //                 return _scoreBar(
                        //                   item.month ?? "",
                        //                   item.score?.toDouble() ?? 0,
                        //                 );
                        //               })
                        //               .toList(),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Builder(
                          builder: (context) {
                            final chartList = data.scoreTrend?.chartData ?? [];
                            double maxScore = 10.0;
                            for (var item in chartList) {
                              final s =
                                  double.tryParse(
                                    item.score?.toString() ?? "0",
                                  ) ??
                                  0.0;
                              if (s > maxScore) {
                                maxScore = 100.0;
                              }
                            }
                            return SizedBox(
                              height: 125.h,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: chartList.map((item) {
                                  final s =
                                      double.tryParse(
                                        item.score?.toString() ?? "0",
                                      ) ??
                                      0.0;
                                  return _scoreBar(
                                    item.month ?? "",
                                    s,
                                    maxScore: maxScore,
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Text(
                        "Performance Insight",
                        style: GoogleFonts.outfit(
                          fontSize: 19.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF101C16),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          "Monthly Audit",
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentGold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.accentGold,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(5.w),
                              decoration: BoxDecoration(
                                color: AppColors.accentGold.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.auto_awesome,
                                size: 16.sp,
                                color: AppColors.accentGold,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                (data.performanceInsight?.title != null &&
                                        data
                                            .performanceInsight!
                                            .title!
                                            .isNotEmpty)
                                    ? data.performanceInsight!.title!
                                    : "Areas to Improve & Inspection Insights",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          (data.performanceInsight?.description != null &&
                                  data
                                      .performanceInsight!
                                      .description!
                                      .isNotEmpty)
                              ? data.performanceInsight!.description!
                              : "Areas to improve will be entered by the inspector after each monthly inspection.",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF333333),
                            letterSpacing: -0.2,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getScoreColor(double score, int scoreOutOf, String performanceLabel) {
    final double max = scoreOutOf > 0 ? scoreOutOf.toDouble() : 10.0;
    final double normalized = max > 0 ? (score / max) * 10.0 : score;
    final String lbl = performanceLabel.toLowerCase();

    if (lbl.contains("need") ||
        lbl.contains("attention") ||
        lbl.contains("poor") ||
        normalized < 5.0) {
      return AppColors.red;
    } else if (lbl.contains("fair") ||
        lbl.contains("average") ||
        lbl.contains("moderate") ||
        normalized < 7.5) {
      return AppColors.amber;
    } else {
      return AppColors.green;
    }
  }

  Widget propertyScoreCard({
    required double score,
    required int scoreOutOf,
    required String performanceLabel,
    required String lastUpdated,
  }) {
    final int safeOutOf = scoreOutOf > 0 ? scoreOutOf : 10;
    final double progress = safeOutOf > 0
        ? (score / safeOutOf).clamp(0.0, 1.0)
        : 0.0;
    final String displayScore = score % 1 == 0
        ? score.toInt().toString()
        : score.toStringAsFixed(1);
    final Color scoreColor = _getScoreColor(score, safeOutOf, performanceLabel);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        // color: AppColors.cardBg,
        border: Border.all(color: scoreColor.withOpacity(0.6), width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            "Overall Property Score",
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF101C16),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 14.h),
          SizedBox(
            height: 110.w,
            width: 110.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 110.w,
                  width: 110.w,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 4.w,
                    backgroundColor: scoreColor.withOpacity(0.18),
                    valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      displayScore,
                      style: GoogleFonts.outfit(
                        fontSize: 34.sp,
                        height: 0.95,
                        fontWeight: FontWeight.w700,
                        color: scoreColor,
                      ),
                    ),
                    Text(
                      "/$safeOutOf",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0x99101C16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: scoreColor.withOpacity(0.12),
              border: Border.all(color: scoreColor, width: 1.5),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: scoreColor,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  performanceLabel.isNotEmpty
                      ? performanceLabel
                      : (score >= 7.5
                            ? "Good Performance"
                            : (score >= 5.0
                                  ? "Average Performance"
                                  : "Needs Attention")),
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            lastUpdated.isNotEmpty
                ? lastUpdated
                : "Updated after monthly inspection",
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0x992A2933),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressItem({
    required String title,
    required double score,
    required double maxScore,
  }) {
    final double safeMax = maxScore > 0 ? maxScore : 1.0;
    final double ratio = (score / safeMax).clamp(0.0, 1.0);
    final Color itemColor = ratio < 0.5
        ? AppColors.red
        : (ratio < 0.75 ? AppColors.amber : AppColors.green);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF101C16),
                  letterSpacing: -0.3,
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  score.toStringAsFixed(1),
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: itemColor,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  ' / ${maxScore.toStringAsFixed(1)}',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0x99101C16),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 6.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 6.h,
            backgroundColor: itemColor.withOpacity(0.15),
            valueColor: AlwaysStoppedAnimation<Color>(itemColor),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({required String title, required String value}) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        // color: AppColors.cardBg,
        border: Border.all(color: AppColors.borderLight, width: 1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 26.h,
            width: 26.w,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(5.r),
            ),
            alignment: Alignment.center,
            child: Icon(Icons.check, size: 16.sp, color: AppColors.green),
          ),
          SizedBox(height: 6.h),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0x99101C16),
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF101C16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _scoreBar(String month, double score, {double maxScore = 10.0}) {
    final double maxBarHeight = 65.h;
    final double barHeight = maxScore > 0
        ? ((score / maxScore).clamp(0.0, 1.0) * maxBarHeight)
        : 0.0;

    final String displayScore = score % 1 == 0
        ? score.toInt().toString()
        : score.toStringAsFixed(1);

    final double ratio = maxScore > 0
        ? (score / maxScore).clamp(0.0, 1.0)
        : 0.0;
    final Color barColor = ratio < 0.5
        ? AppColors.red
        : (ratio < 0.75 ? AppColors.amber : AppColors.green);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            displayScore,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: barColor,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            height: barHeight,
            width: 14.w,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(7.r),
                topRight: Radius.circular(7.r),
              ),
            ),
          ),
          Container(
            height: 2.h,
            width: double.infinity,
            color: const Color(0xFFC8C8C1),
          ),
          SizedBox(height: 4.h),
          Text(
            month,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF101C16),
            ),
          ),
        ],
      ),
    );
  }
}
