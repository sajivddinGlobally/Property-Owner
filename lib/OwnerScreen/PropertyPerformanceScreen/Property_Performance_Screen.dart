import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_care/OwnerScreen/PropertyPerformanceScreen/Provider/getPropertyScoreProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getPropertyScoreModel.dart';
import 'package:property_care/core/Utils/property_type_helper.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

class PropertyPerformanceScreen extends ConsumerStatefulWidget {
  const PropertyPerformanceScreen({super.key});

  @override
  ConsumerState<PropertyPerformanceScreen> createState() =>
      _PropertyPerformanceScreenState();
}

class _PropertyPerformanceScreenState
    extends ConsumerState<PropertyPerformanceScreen> {
  final ScrollController _chartScrollController = ScrollController();
  bool _isOpeningPdf = false;

  @override
  void dispose() {
    _chartScrollController.dispose();
    super.dispose();
  }

  Future<void> _openChecklistPdf(String? url) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Checklist PDF is not available");
      return;
    }

    setState(() {
      _isOpeningPdf = true;
    });

    try {
      final userBox = Hive.isBoxOpen("userdata")
          ? Hive.box("userdata")
          : await Hive.openBox("userdata");
      final token = userBox.get("token", defaultValue: "") as String;

      Directory targetDir;
      if (Platform.isAndroid) {
        final downloadDirs = await getExternalStorageDirectories(
          type: StorageDirectory.downloads,
        );
        if (downloadDirs != null && downloadDirs.isNotEmpty) {
          targetDir = downloadDirs.first;
        } else {
          targetDir =
              await getExternalStorageDirectory() ??
              await getApplicationDocumentsDirectory();
        }
      } else {
        targetDir = await getApplicationDocumentsDirectory();
      }

      if (!await targetDir.exists()) {
        await targetDir.create(recursive: true);
      }

      final fileName = url.split('/').last.split('?').first;
      final resolvedFileName = fileName.endsWith('.pdf')
          ? fileName
          : 'checklist_report.pdf';
      final savePath = '${targetDir.path}/$resolvedFileName';
      final file = File(savePath);

      final dio = Dio();
      final response = await dio.get<List<int>>(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            'Accept': 'application/pdf',
          },
          followRedirects: true,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final bytes = response.data!;
        if (bytes.length > 5) {
          final header = String.fromCharCodes(bytes.take(5));
          if (header != '%PDF-') {
            showErrorSnackBar("Downloaded file is not a valid PDF report");
            return;
          }
        }
        await file.writeAsBytes(bytes, flush: true);
        showSuccessSnackBar("Opening Checklist PDF...");
        final openResult = await OpenFilex.open(savePath);
        if (openResult.type != ResultType.done) {
          showErrorSnackBar("Could not open PDF: ${openResult.message}");
        }
      } else {
        showErrorSnackBar("Failed to download checklist PDF");
      }
    } catch (e) {
      log("Error opening PDF: $e");
      showErrorSnackBar("Error opening PDF: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isOpeningPdf = false;
        });
      }
    }
  }

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
      body: getPropertyScoreState.when(
        skipLoadingOnReload: true,
        loading: () => Center(
          child: CircularProgressIndicator(color: const Color(0xff171717)),
        ),
        error: (error, stackTrace) {
          log(error.toString());
          log(stackTrace.toString());
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Error loading data",
                  style: GoogleFonts.outfit(fontSize: 16.sp),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(getPropertyScoreProvider);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                  ),
                  child: const Text(
                    "Retry",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
        data: (modelData) {
          final data = modelData.data;
          if (data == null) {
            return const Center(child: Text("No Data Available"));
          }

          // Home Care: score sirf latest INSPECTION se; audit alag dikhega
          final bool isHomeCare =
              (data.propertyHeader?.isHomeCare ?? false) ||
              data.hasLatestAuditKey;
          final bool isReloading = getPropertyScoreState.isLoading;
          final List<String> trendPeriods = data.scoreTrend?.periods ?? [];
          // Tap karte hi chip active dikhe, isliye provider wala period
          final String activePeriod = ref.watch(propertyScorePeriodProvider);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_chartScrollController.hasClients) {
              _chartScrollController.animateTo(
                _chartScrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
              );
            }
          });

          return RefreshIndicator(
            color: AppColors.heading,
            onRefresh: () async {
              ref.invalidate(getPropertyScoreProvider);
              await ref.read(getPropertyScoreProvider.future);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Property Header
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
                                  formatPropertyTitle(
                                    "${data.propertyHeader?.propertyNameNumber}",
                                  ),
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.heading,
                                    fontSize: 18.sp,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                if (data.propertyHeader?.complexName != null &&
                                    data
                                        .propertyHeader!
                                        .complexName!
                                        .isNotEmpty &&
                                    data.propertyHeader!.complexName! !=
                                        "N/A") ...[
                                  SizedBox(height: 2.h),
                                  Text(
                                    formatPropertyTitle(
                                      data.propertyHeader?.complexName,
                                    ),
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.5,
                                      ),
                                      fontSize: 15.sp,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          if (data.propertyHeader?.status != null &&
                              data.propertyHeader!.status!.isNotEmpty) ...[
                            SizedBox(width: 8.w),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 23.h),

                    // Overall Property Score Card
                    propertyScoreCard(
                      overallScore: data.overallPropertyScore,
                      isHomeCare: isHomeCare,
                    ),

                    // Latest Audit (Home Care) - property score mein nahi judta
                    if (isHomeCare) ...[
                      SizedBox(height: 20.h),
                      _buildLatestAuditCard(data.latestAudit),
                    ],

                    // // Latest Inspection Section (if present in API)
                    // if (data.latestInspection != null) ...[
                    //   SizedBox(height: 20.h),
                    //   _buildLatestInspectionCard(data.latestInspection!),
                    // ],
                    SizedBox(height: 21.h),
                    // Performance Breakdown Section
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
                        const Spacer(),
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
                        border: Border.all(color: AppColors.borderLight),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child:
                          (data.performanceBreakdown == null ||
                              data.performanceBreakdown!.isEmpty)
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              child: Center(
                                child: Text(
                                  "No breakdown data available",
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    color: const Color(0x99101C16),
                                  ),
                                ),
                              ),
                            )
                          : Column(
                              children: List.generate(
                                data.performanceBreakdown!.length,
                                (index) {
                                  final item =
                                      data.performanceBreakdown![index];
                                  final double score = item.numericScore;
                                  final double maxScore = item.numericMaxScore;

                                  String? weightSubtitle;
                                  if (item.weight != null &&
                                      item.weight!.isNotEmpty) {
                                    if (item.passed != null &&
                                        item.total != null) {
                                      weightSubtitle =
                                          "${item.passed}/${item.total} passed • ${item.weight}";
                                    } else {
                                      weightSubtitle = item.weight;
                                    }
                                  }

                                  return Column(
                                    children: [
                                      _progressItem(
                                        title:
                                            item.label ?? item.parameter ?? "",
                                        score: score,
                                        maxScore: maxScore,
                                        displayValue: item.displayValue,
                                        weightInfo: weightSubtitle,
                                      ),
                                      if (index !=
                                          data.performanceBreakdown!.length - 1)
                                        SizedBox(height: 14.h),
                                    ],
                                  );
                                },
                              ),
                            ),
                    ),
                    SizedBox(height: 20.h),

                    // Performance Summary Section
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
                            icon: Icons.fact_check_outlined,
                            iconColor: AppColors.green,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _summaryCard(
                            title: "Maintenance",
                            value:
                                data.performanceSummary?.maintenance
                                    ?.toString() ??
                                "0",
                            icon: Icons.build_outlined,
                            iconColor: AppColors.green,
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
                            icon: Icons.task_alt_outlined,
                            iconColor: AppColors.green,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _summaryCard(
                            title: "Open Issues",
                            value:
                                data.performanceSummary?.openIssues
                                    ?.toString() ??
                                "0",
                            icon: Icons.pending_actions_outlined,
                            iconColor:
                                ((int.tryParse(
                                          data.performanceSummary?.openIssues ??
                                              "0",
                                        ) ??
                                        0) >
                                    0)
                                ? AppColors.amber
                                : AppColors.green,
                          ),
                        ),
                      ],
                    ),
                    if (isHomeCare &&
                        data.performanceSummary?.audits != null) ...[
                      SizedBox(height: 10.h),
                      Row(
                        children: [
                          Expanded(
                            child: _summaryCard(
                              title: "Audits",
                              value: data.performanceSummary!.audits!,
                              icon: Icons.verified_outlined,
                              iconColor: AppColors.green,
                            ),
                          ),
                          SizedBox(width: 16.w),
                          const Expanded(child: SizedBox()),
                        ],
                      ),
                    ],
                    SizedBox(height: 20.h),

                    // Score Trend Section
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
                        const Spacer(),
                        Text(
                          data.scoreTrend?.label ?? "Last 12 Months",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            fontSize: 17.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    if (trendPeriods.isNotEmpty) ...[
                      SizedBox(height: 12.h),
                      _periodChips(
                        periods: trendPeriods,
                        active: activePeriod,
                        disabled: isReloading,
                      ),
                    ],
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                              Flexible(
                                child: Text(
                                  data.scoreTrend?.improvement ?? "",
                                  textAlign: TextAlign.end,
                                  style: GoogleFonts.outfit(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0x99101C16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18.h),
                          if (isReloading) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4.r),
                              child: LinearProgressIndicator(
                                minHeight: 2.h,
                                color: AppColors.heading,
                                backgroundColor: AppColors.heading.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                          ],
                          Builder(
                            builder: (context) {
                              final chartList =
                                  data.scoreTrend?.chartData ?? [];
                              final bool noInspectionInPeriod =
                                  chartList.isNotEmpty &&
                                  chartList.every(
                                    (c) =>
                                        c.hasInspection == false ||
                                        c.numericScore == null,
                                  );
                              if (isHomeCare && noInspectionInPeriod) {
                                return SizedBox(
                                  height: 100.h,
                                  child: Center(
                                    child: Text(
                                      "No inspection in this period",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        color: const Color(0x99101C16),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              if (chartList.isEmpty) {
                                return SizedBox(
                                  height: 100.h,
                                  child: Center(
                                    child: Text(
                                      "No trend data available",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        color: const Color(0x99101C16),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              double maxScore = 10.0;
                              for (var item in chartList) {
                                final s = item.numericScore ?? 0.0;
                                if (s > maxScore) {
                                  maxScore = 100.0;
                                }
                              }

                              return SingleChildScrollView(
                                controller: _chartScrollController,
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: chartList.map((item) {
                                    return SizedBox(
                                      width: 48.w,
                                      child: _scoreBar(
                                        item.month ?? item.label ?? "",
                                        item.numericScore,
                                        hasInspection:
                                            item.hasInspection ??
                                            (item.score != null),
                                        maxScore: maxScore,
                                      ),
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

                    // Performance Insight Section
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
                            color: AppColors.accentGold.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            isHomeCare ? "Latest Inspection" : "Monthly Audit",
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
                                  color: AppColors.accentGold.withValues(
                                    alpha: 0.15,
                                  ),
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
                    SizedBox(height: 35.h),
                  ],
                ),
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
    OverallPropertyScore? overallScore,
    bool isHomeCare = false,
  }) {
    // Home Care: inspection nahi hua = Pending Inspection (complex flow same)
    final bool isPendingInspection =
        isHomeCare && overallScore?.isPendingInspection == true;
    final double score = overallScore?.numericScore ?? 0.0;
    final int safeOutOf =
        (overallScore?.total != null && overallScore!.total! > 0)
        ? overallScore.total!
        : 10;
    final double progress = isPendingInspection
        ? 0.0
        : (score / safeOutOf).clamp(0.0, 1.0);

    final String displayScore = isPendingInspection
        ? "--"
        : (overallScore?.scoreDisplay != null &&
              overallScore!.scoreDisplay!.isNotEmpty)
        ? overallScore.scoreDisplay!
        : (score % 1 == 0
              ? score.toInt().toString()
              : score.toStringAsFixed(1));

    final String performanceLabel = isPendingInspection
        ? "Pending Inspection"
        : (overallScore?.performanceLabel != null &&
              overallScore!.performanceLabel!.isNotEmpty)
        ? overallScore.performanceLabel!
        : (overallScore?.tier ??
              (overallScore?.status ??
                  (score >= 7.5
                      ? "Good Performance"
                      : (score >= 5.0
                            ? "Average Performance"
                            : "Needs Attention"))));

    final Color scoreColor = isPendingInspection
        ? const Color(0xFF8A8A8A)
        : _getScoreColor(score, safeOutOf, performanceLabel);
    final change = overallScore?.numericChangeVsPrevious;
    final isPositive = change != null && change >= 0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        border: Border.all(
          color: scoreColor.withValues(alpha: 0.6),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: scoreColor.withValues(alpha: 0.08),
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
                    backgroundColor: scoreColor.withValues(alpha: 0.18),
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
              color: scoreColor.withValues(alpha: 0.12),
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
                  performanceLabel,
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: scoreColor,
                  ),
                ),
              ],
            ),
          ),

          // // Previous Score comparison if available
          // if (change != null) ...[
          //   SizedBox(height: 8.h),
          //   Container(
          //     padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
          //     decoration: BoxDecoration(
          //       color: (isPositive ? AppColors.green : AppColors.red)
          //           .withValues(alpha: 0.12),
          //       borderRadius: BorderRadius.circular(12.r),
          //     ),
          //     child: Text(
          //       "${isPositive ? '↑ +' : '↓ '}${change.abs().toStringAsFixed(1)} vs previous (${overallScore?.previousScore ?? ''})",
          //       style: GoogleFonts.outfit(
          //         fontSize: 13.sp,
          //         fontWeight: FontWeight.w600,
          //         color: isPositive ? AppColors.green : AppColors.red,
          //       ),
          //     ),
          //   ),
          // ],
          SizedBox(height: 10.h),
          Text(
            (overallScore?.lastUpdated != null &&
                    overallScore!.lastUpdated!.isNotEmpty)
                ? overallScore.lastUpdated!
                : "Updated after monthly inspection",
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0x992A2933),
            ),
          ),
          if (isHomeCare) ...[
            SizedBox(height: 4.h),
            Text(
              isPendingInspection
                  ? "Score will appear after the first inspection"
                  : "Based on latest inspection only. Audit is shown separately.",
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0x802A2933),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _periodChips({
    required List<String> periods,
    required String active,
    bool disabled = false,
  }) {
    const labels = {
      "day": "Day",
      "week": "Week",
      "month": "Month",
      "year": "Year",
    };
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.heading.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        children: periods.map((p) {
          final bool isActive = p == active;
          return Expanded(
            child: GestureDetector(
              onTap: (disabled || isActive)
                  ? null
                  : () {
                      ref.read(propertyScorePeriodProvider.notifier).state = p;
                    },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.heading : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[p] ?? p,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.heading,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _tierColor(String? tier) {
    if (tier == "Excellent") return AppColors.green;
    if (tier == "Good") return AppColors.amber;
    if (tier != null && tier.isNotEmpty) return AppColors.red;
    return const Color(0xFF8A8A8A);
  }

  Widget _buildLatestAuditCard(ScoreLatestAudit? audit) {
    final double? auditScore = audit?.numericScore;
    final String scoreText = audit == null
        ? "--"
        : ((audit.scoreLabel != null && audit.scoreLabel!.isNotEmpty)
              ? audit.scoreLabel!
              : (auditScore != null
                    ? "${auditScore % 1 == 0 ? auditScore.toInt() : auditScore.toStringAsFixed(1)} / 10"
                    : "--"));
    final Color tierColor = _tierColor(audit?.tier);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading, width: 1.2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.heading.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.verified_outlined,
                  color: AppColors.heading,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Latest Audit",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101C16),
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      audit == null
                          ? "No audit done yet"
                          : [
                              if (audit.auditType != null &&
                                  audit.auditType!.isNotEmpty)
                                audit.auditType!,
                              audit.dateFormatted ?? audit.date ?? "",
                            ].where((e) => e.isNotEmpty).join(" • "),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0x99101C16),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (audit != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: tierColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: tierColor),
                  ),
                  child: Text(
                    scoreText,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: tierColor,
                    ),
                  ),
                ),
            ],
          ),
          if (audit != null) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _statPill(
                    label: "Passed",
                    value:
                        "${audit.passed ?? 0}/${audit.totalCheckpoints ?? 0}",
                    color: AppColors.green,
                    icon: Icons.check_circle_outline,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _statPill(
                    label: "Needs Attention",
                    value: "${audit.needsAttention ?? 0}",
                    color: (audit.needsAttention ?? 0) > 0
                        ? AppColors.red
                        : AppColors.green,
                    icon: (audit.needsAttention ?? 0) > 0
                        ? Icons.error_outline
                        : Icons.check_circle_outline,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              "Audit score is shown separately and is not included in the property score.",
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0x802A2933),
              ),
            ),
            if (audit.checklistPdfUrl != null &&
                audit.checklistPdfUrl!.isNotEmpty) ...[
              SizedBox(height: 12.h),
              InkWell(
                onTap: _isOpeningPdf
                    ? null
                    : () => _openChecklistPdf(audit.checklistPdfUrl),
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 10.h,
                    horizontal: 12.w,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFCEF),
                    border: Border.all(color: AppColors.heading, width: 1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isOpeningPdf)
                        SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.w,
                            color: AppColors.heading,
                          ),
                        )
                      else
                        Icon(
                          Icons.picture_as_pdf_outlined,
                          color: AppColors.heading,
                          size: 18.sp,
                        ),
                      SizedBox(width: 8.w),
                      Text(
                        _isOpeningPdf
                            ? "Opening Audit PDF..."
                            : "View Audit Checklist PDF",
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildLatestInspectionCard(LatestInspection inspection) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading, width: 1.2),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.heading.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  Icons.fact_check_outlined,
                  color: AppColors.heading,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Latest Inspection",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF101C16),
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      inspection.dateFormatted ?? inspection.date ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0x99101C16),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (inspection.score != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6.r),
                    border: Border.all(color: AppColors.green),
                  ),
                  child: Text(
                    "${inspection.score}/10",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _statPill(
                  label: "Passed",
                  value:
                      "${inspection.passed ?? 0}/${inspection.totalCheckpoints ?? 0}",
                  color: AppColors.green,
                  icon: Icons.check_circle_outline,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _statPill(
                  label: "Needs Attention",
                  value: "${inspection.needsAttention ?? 0}",
                  color: (inspection.needsAttention ?? 0) > 0
                      ? AppColors.red
                      : AppColors.green,
                  icon: (inspection.needsAttention ?? 0) > 0
                      ? Icons.error_outline
                      : Icons.check_circle_outline,
                ),
              ),
            ],
          ),
          if (inspection.checklistPdfUrl != null &&
              inspection.checklistPdfUrl!.isNotEmpty) ...[
            SizedBox(height: 12.h),
            InkWell(
              onTap: _isOpeningPdf
                  ? null
                  : () => _openChecklistPdf(inspection.checklistPdfUrl),
              borderRadius: BorderRadius.circular(8.r),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFCEF),
                  border: Border.all(color: AppColors.heading, width: 1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isOpeningPdf)
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.w,
                          color: AppColors.heading,
                        ),
                      )
                    else
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        color: AppColors.heading,
                        size: 18.sp,
                      ),
                    SizedBox(width: 8.w),
                    Text(
                      _isOpeningPdf
                          ? "Opening Checklist PDF..."
                          : "View Checklist Report PDF",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statPill({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16.sp, color: color),
          SizedBox(width: 6.w),
          Text(
            "$label: ",
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF101C16),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: color,
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
    String? displayValue,
    String? weightInfo,
  }) {
    final double safeMax = maxScore > 0 ? maxScore : 10.0;
    final double ratio = (score / safeMax).clamp(0.0, 1.0);
    final Color itemColor = ratio < 0.5
        ? AppColors.red
        : (ratio < 0.75 ? AppColors.amber : AppColors.green);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                    title,
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF101C16),
                      letterSpacing: -0.3,
                    ),
                  ),
                  // if (weightInfo != null && weightInfo.isNotEmpty) ...[
                  //   SizedBox(height: 2.h),
                  //   Text(
                  //     weightInfo,
                  //     style: GoogleFonts.outfit(
                  //       fontSize: 13.sp,
                  //       fontWeight: FontWeight.w400,
                  //       color: const Color(0x99101C16),
                  //       letterSpacing: -0.2,
                  //     ),
                  //   ),
                  // ],
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayValue ??
                      (score % 1 == 0
                          ? score.toInt().toString()
                          : score.toStringAsFixed(1)),
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: itemColor,
                    letterSpacing: -0.3,
                  ),
                ),
                if (displayValue == null)
                  Text(
                    ' / ${maxScore % 1 == 0 ? maxScore.toInt() : maxScore.toStringAsFixed(1)}',
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
            backgroundColor: itemColor.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(itemColor),
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required String title,
    required String value,
    IconData icon = Icons.check,
    Color? iconColor,
  }) {
    final effectiveColor = iconColor ?? AppColors.green;
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
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
              color: effectiveColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(5.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 16.sp, color: effectiveColor),
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

  Widget _scoreBar(
    String month,
    double? score, {
    bool hasInspection = true,
    double maxScore = 10.0,
  }) {
    final double maxBarHeight = 65.h;
    final bool hasValidScore = hasInspection && score != null && score > 0;
    final double barHeight = hasValidScore && maxScore > 0
        ? ((score / maxScore).clamp(0.0, 1.0) * maxBarHeight)
        : 4.h;

    final String displayScore = hasValidScore
        ? (score % 1 == 0 ? score.toInt().toString() : score.toStringAsFixed(1))
        : "-";

    final double ratio = hasValidScore && maxScore > 0
        ? (score / maxScore).clamp(0.0, 1.0)
        : 0.0;
    final Color barColor = !hasValidScore
        ? const Color(0xFFD6D6D6)
        : (ratio < 0.5
              ? AppColors.red
              : (ratio < 0.75 ? AppColors.amber : AppColors.green));

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          displayScore,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: hasValidScore ? barColor : const Color(0x66101C16),
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: hasValidScore ? FontWeight.w600 : FontWeight.w400,
            color: hasValidScore
                ? const Color(0xFF101C16)
                : const Color(0x88101C16),
          ),
        ),
      ],
    );
  }
}
