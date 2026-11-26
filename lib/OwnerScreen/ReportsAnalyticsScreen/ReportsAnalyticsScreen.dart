import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart'
    show selectedPropertyIdProvider;
import 'package:property_care/core/AuthService/AuthServiceProvider.dart'
    show dioProvider;
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

const String _reportsApi =
    "https://admin.ascentpms.care/api/v1/owner/reports-analytics";

/// Ek property ka Reports & Analytics (backend signed link deta hai, 60 min valid)
class OwnerReportItem {
  final int propertyId;
  final String propertyName;
  final String location;
  final String carePackage;
  final bool isSelected;
  final String? pdfUrl;
  final String? downloadUrl;
  final String fileName;

  OwnerReportItem({
    required this.propertyId,
    required this.propertyName,
    required this.location,
    required this.carePackage,
    required this.isSelected,
    required this.pdfUrl,
    required this.downloadUrl,
    required this.fileName,
  });

  factory OwnerReportItem.fromJson(Map<String, dynamic> j) => OwnerReportItem(
    propertyId: int.tryParse("${j["property_id"]}") ?? 0,
    propertyName: (j["property_name"] ?? "Property").toString(),
    location: (j["location"] ?? "").toString(),
    carePackage: (j["care_package"] ?? "").toString(),
    isSelected: j["is_selected"] == true,
    pdfUrl: j["pdf_url"]?.toString(),
    downloadUrl: j["download_url"]?.toString(),
    fileName: (j["file_name"] ?? "Reports_Analytics.pdf").toString(),
  );
}

class OwnerReportsData {
  final String description;
  final List<OwnerReportItem> reports;

  OwnerReportsData({required this.description, required this.reports});
}

final ownerReportsAnalyticsProvider =
    FutureProvider.autoDispose<OwnerReportsData>((ref) async {
      final propertyId = ref.watch(selectedPropertyIdProvider);
      final dio = ref.read(dioProvider);
      try {
        final response = await dio.get(
          _reportsApi,
          queryParameters: {if (propertyId != null) "property_id": propertyId},
        );
        final body = response.data;
        if (body is Map && body["status"] == true) {
          final data = body["data"] is Map
              ? Map<String, dynamic>.from(body["data"])
              : <String, dynamic>{};
          final list = (data["reports"] is List ? data["reports"] as List : [])
              .whereType<Map>()
              .map(
                (e) => OwnerReportItem.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList();
          // Chuni hui property sabse upar
          list.sort((a, b) => (b.isSelected ? 1 : 0) - (a.isSelected ? 1 : 0));
          return OwnerReportsData(
            description: (data["description"] ?? "").toString(),
            reports: list,
          );
        }
        throw Exception(
          body is Map && body["message"] != null
              ? body["message"].toString()
              : "Could not load reports.",
        );
      } on DioException catch (e) {
        final data = e.response?.data;
        throw Exception(
          data is Map && data["message"] != null
              ? data["message"].toString()
              : "Could not load reports.",
        );
      }
    });

class ReportsAnalyticsScreen extends ConsumerStatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  ConsumerState<ReportsAnalyticsScreen> createState() =>
      _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState
    extends ConsumerState<ReportsAnalyticsScreen> {
  int? _opening; // property id jiska report khul raha hai

  /// Report download karke kholo. Server PDF na de sake to printable page (HTML) khulta hai.
  Future<void> _openReport(OwnerReportItem item) async {
    final url = item.downloadUrl ?? item.pdfUrl;
    if (url == null || url.isEmpty || _opening != null) return;
    setState(() => _opening = item.propertyId);
    try {
      final dir = await getTemporaryDirectory();
      final base = item.fileName.toLowerCase().endsWith('.pdf')
          ? item.fileName.substring(0, item.fileName.length - 4)
          : item.fileName;
      var path = '${dir.path}/$base.pdf';
      await Dio().download(url, path);

      final file = File(path);
      final head = await file.openRead(0, 5).first;
      if (String.fromCharCodes(head) != '%PDF-') {
        // PDF nahi aaya (printable page) -> .html naam se kholo
        final htmlPath = '${dir.path}/$base.html';
        await file.rename(htmlPath);
        path = htmlPath;
      }

      final result = await OpenFilex.open(path);
      if (result.type == ResultType.noAppToOpen) {
        showErrorSnackBar(
          "No app found to open this report. Please install a PDF viewer.",
        );
      } else if (result.type != ResultType.done) {
        showErrorSnackBar("Could not open the report: ${result.message}");
      }
    } catch (e) {
      showErrorSnackBar("Could not download the report. Please try again.");
    } finally {
      if (mounted) setState(() => _opening = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownerReportsAnalyticsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 20.sp),
          color: AppColors.heading,
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "REPORTS & ANALYTICS",
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.heading,
              ),
            ),
            Text(
              "Health score, complaints and dues",
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(ownerReportsAnalyticsProvider),
        child: state.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => ListView(
            padding: EdgeInsets.all(20.w),
            children: [
              SizedBox(height: 80.h),
              Icon(Icons.error_outline, size: 48.sp, color: AppColors.red),
              SizedBox(height: 12.h),
              Text(
                e.toString().replaceFirst("Exception: ", ""),
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  color: AppColors.heading,
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: OutlinedButton(
                  onPressed: () =>
                      ref.invalidate(ownerReportsAnalyticsProvider),
                  child: const Text("Retry"),
                ),
              ),
            ],
          ),
          data: (data) {
            if (data.reports.isEmpty) {
              return ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  SizedBox(height: 80.h),
                  Icon(
                    Icons.insert_chart_outlined_rounded,
                    size: 52.sp,
                    color: AppColors.borderLight,
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    "No Home Care property found for your account yet.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      color: AppColors.heading,
                    ),
                  ),
                ],
              );
            }
            return ListView(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 30.h),
              children: [
                if (data.description.isNotEmpty) ...[
                  Text(
                    data.description,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
                ...data.reports.map(_reportCard),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _reportCard(OwnerReportItem item) {
    final busy = _opening == item.propertyId;
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: item.isSelected ? AppColors.heading : AppColors.borderLight,
          width: item.isSelected ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.insert_chart_outlined_rounded,
                  color: AppColors.accentGold,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.propertyName,
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      [
                        item.location,
                        item.carePackage,
                      ].where((e) => e.isNotEmpty).join("  •  "),
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.isSelected)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.green.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "Selected",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.green,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton.icon(
              onPressed: busy ? null : () => _openReport(item),
              icon: busy
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 20.sp,
                      color: Colors.white,
                    ),
              label: Text(
                busy ? "Preparing report..." : "View / Download Report (PDF)",
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.heading,
                disabledBackgroundColor: AppColors.heading.withOpacity(0.6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
