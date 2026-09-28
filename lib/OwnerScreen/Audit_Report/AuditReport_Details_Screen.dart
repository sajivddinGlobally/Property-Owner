import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

import '../inspectionReport/Provider/getInspectionReportDeailsProvider.dart';

class AuditreportDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  final String? title;
  final String? date;
  final String? property;
  final String? auditType;
  final String? auditDate;
  final String? status;

  const AuditreportDetailsScreen({
    super.key,
    required this.id,
    this.title,
    this.date,
    this.property,
    this.auditType,
    this.auditDate,
    this.status,
  });

  @override
  ConsumerState<AuditreportDetailsScreen> createState() =>
      _AuditreportDetailsScreenState();
}

class _AuditreportDetailsScreenState
    extends ConsumerState<AuditreportDetailsScreen> {
  bool _isDownloading = false;

  Future<void> _handlePdfAction({
    required String? url,
    required bool openImmediately,
  }) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Audit report PDF is not available");
      return;
    }

    if (_isDownloading) return;

    setState(() {
      _isDownloading = true;
    });

    try {
      final uri = Uri.tryParse(url);
      final resolvedFileName = uri != null && uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last.replaceAll(RegExp(r'[^\w\s\.-]'), '_')
          : 'audit_report_${widget.id}.pdf';

      Directory? targetDir;
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

      final savePath = '${targetDir.path}/$resolvedFileName';
      final file = File(savePath);

      if (await file.exists() && await file.length() > 0) {
        if (openImmediately) {
          showSuccessSnackBar("Opening audit report...");
          await OpenFilex.open(savePath);
        } else {
          showSuccessSnackBar("Report downloaded to ${targetDir.path}");
        }
        return;
      }

      showSuccessSnackBar(
        openImmediately ? "Opening document..." : "Downloading report...",
      );

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      await dio.download(url, savePath);

      showSuccessSnackBar(
        openImmediately
            ? "Report opened successfully"
            : "Report downloaded successfully",
      );

      if (openImmediately) {
        await OpenFilex.open(savePath);
      }
    } catch (e) {
      showErrorSnackBar("Failed to load audit report PDF");
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  void _showImagePreview(String imageUrl) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                ),
              ),
              Positioned(
                top: 40.h,
                right: 20.w,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white, size: 24.sp),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final getInspectionReportDetailsData = ref.watch(
      getInspectionReportDetailsProvider(widget.id),
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
                    "Audit Report Details",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "COMPLETE AUDIT REPORT",
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
      body: getInspectionReportDetailsData.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xff101C16)),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Failed to load audit details",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
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
                onPressed: () =>
                    ref.refresh(getInspectionReportDetailsProvider(widget.id)),
                child: Text(
                  "Retry",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (modelData) {
          final data = modelData.data;

          final title = widget.title ?? "Property Audit Report";

          final rawDate = data?.inspectionDate ?? widget.date;
          String headerDate = "12 August 2026";
          String auditDate = "12 Aug 2026";
          if (rawDate != null && rawDate.isNotEmpty) {
            final parsed = DateTime.tryParse(rawDate);
            if (parsed != null) {
              headerDate = DateFormat("dd MMMM yyyy").format(parsed);
              auditDate = DateFormat("dd MMM yyyy").format(parsed);
            } else {
              headerDate = rawDate;
              auditDate = rawDate;
            }
          }

          final property =
              data?.propertyName ?? widget.property ?? "Apartment A-204";
          final auditType =
              (data?.auditType != null &&
                  data!.auditType.toString().trim().isNotEmpty)
              ? data.auditType.toString()
              : (widget.auditType ?? "Property Audit");
          final rawStatus = data?.status ?? widget.status ?? "Completed";
          final status = rawStatus.isNotEmpty
              ? "${rawStatus[0].toUpperCase()}${rawStatus.substring(1)}"
              : "Completed";

          final overviewText =
              (data?.findings != null && data!.findings!.trim().isNotEmpty)
              ? data.findings!
              : "This audit report provides the recorded audit findings, observations and recommendations for the property.";

          final recommendationsText =
              (data?.recommendations != null &&
                  data!.recommendations!.trim().isNotEmpty)
              ? data.recommendations!
              : "Recommended actions based on the audit findings are available for review.";

          final checklist = data?.digitalChecklist ?? [];
          final pdfUrl = data?.attachments?.pdf;
          final images = data?.attachments?.images ?? [];

          return RefreshIndicator(
            color: const Color(0xff101C16),
            onRefresh: () async {
              ref.invalidate(getInspectionReportDetailsProvider(widget.id));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 11.w,
                        vertical: 15.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1.2,
                        ),
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
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff101C16),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    SizedBox(height: 7.h),
                                    Text(
                                      headerDate,
                                      style: GoogleFonts.outfit(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromRGBO(
                                          16,
                                          28,
                                          22,
                                          0.6,
                                        ),
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
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                  ),
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  status,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff101C16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xff777970),
                          ),
                          SizedBox(height: 17.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _infoItem(
                                  title: "PROPERTY",
                                  value: property,
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: _infoItem(
                                  title: "AUDIT TYPE",
                                  value: auditType,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _infoItem(
                                  title: "AUDIT DATE",
                                  value: auditDate,
                                ),
                              ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: _infoItem(
                                  title: "STATUS",
                                  value: status,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Audit Overview",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        fontSize: 18.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(42, 41, 51, 0.6),
                        ),
                        borderRadius: BorderRadius.circular(5.r),
                      ),
                      child: Text(
                        overviewText,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: const Color.fromRGBO(42, 41, 51, 0.6),
                          fontSize: 14.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "Audit Findings",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        fontSize: 17.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 17.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff999999),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(18.r),
                      ),
                      child: checklist.isNotEmpty
                          ? ListView.separated(
                              itemCount: checklist.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => Column(
                                children: [
                                  SizedBox(height: 12.h),
                                  Container(
                                    width: double.infinity,
                                    height: 1.h,
                                    color: const Color(0xff202820),
                                  ),
                                  SizedBox(height: 12.h),
                                ],
                              ),
                              itemBuilder: (context, index) {
                                final checkItem = checklist[index];
                                final isPass =
                                    checkItem.status?.toLowerCase().contains(
                                      "pass",
                                    ) ??
                                    true;
                                return _auditItem(
                                  icon: isPass ? "✓" : "!",
                                  title: checkItem.itemName ?? "Audit Item",
                                  description:
                                      checkItem.remarks ??
                                      "Observations recorded in the audit.",
                                );
                              },
                            )
                          : Column(
                              children: [
                                _auditItem(
                                  icon: "✓",
                                  title: "Property Condition",
                                  description:
                                      "Overall property condition was reviewed during the scheduled audit.",
                                ),
                                SizedBox(height: 12.h),
                                Container(
                                  width: double.infinity,
                                  height: 1.h,
                                  color: const Color(0xff202820),
                                ),
                                SizedBox(height: 12.h),
                                _auditItem(
                                  icon: "!",
                                  title: "Maintenance Observation",
                                  description:
                                      "Maintenance observations identified during the audit are\nrecorded in the report.",
                                ),
                                SizedBox(height: 12.h),
                                Container(
                                  width: double.infinity,
                                  height: 1.h,
                                  color: const Color(0xff202820),
                                ),
                                SizedBox(height: 12.h),
                                _auditItem(
                                  icon: "✓",
                                  title: "Compliance Check",
                                  description:
                                      "Relevant property audit checks and observations have been recorded.",
                                ),
                              ],
                            ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "Recommendations",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        fontSize: 17.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 18.h,
                        horizontal: 15.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.heading),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recommendationsText,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              fontSize: 13.sp,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 5.h,
                              horizontal: 21.w,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.heading),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Text(
                              "Review Recommended Actions",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                fontSize: 13.sp,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "Attached Documents",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        fontSize: 17.sp,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        // PDF Box
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _handlePdfAction(
                              url: pdfUrl,
                              openImmediately: true,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.heading,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 32.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.heading,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.description_outlined,
                                      size: 16,
                                      color: Color(0xff17231F),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "Audit Report",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                  Text(
                                    "PDF",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                      letterSpacing: -0.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        // Audit Images Box
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (images.isNotEmpty) {
                                _showImagePreview(images.first);
                              } else {
                                showErrorSnackBar("No audit images available");
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.heading,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 32.w,
                                    height: 32.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.heading,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Center(
                                      child: images.isNotEmpty
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(2.r),
                                              child: Image.network(
                                                images.first,
                                                width: 18.w,
                                                height: 18.h,
                                                fit: BoxFit.cover,
                                                errorBuilder: (c, e, s) =>
                                                    Container(
                                                      height: 6.h,
                                                      width: 6.w,
                                                      color: AppColors.heading,
                                                    ),
                                              ),
                                            )
                                          : Container(
                                              height: 6.h,
                                              width: 6.w,
                                              decoration: BoxDecoration(
                                                color: AppColors.heading,
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    "Audit Images",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
                                    ),
                                  ),
                                  Text(
                                    "Images",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.inter(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.heading,
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
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 41.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.scaffoldBg,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(color: AppColors.heading),
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: _isDownloading
                                  ? null
                                  : () => _handlePdfAction(
                                      url: pdfUrl,
                                      openImmediately: true,
                                    ),
                              child: _isDownloading
                                  ? SizedBox(
                                      width: 16.w,
                                      height: 16.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xff101C16),
                                      ),
                                    )
                                  : Text(
                                      "View Full Report",
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.heading,
                                        fontSize: 13.sp,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: SizedBox(
                            width: double.infinity,
                            height: 41.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.heading,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                              onPressed: _isDownloading
                                  ? null
                                  : () => _handlePdfAction(
                                      url: pdfUrl,
                                      openImmediately: false,
                                    ),
                              child: Text(
                                "Download Report",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ),
          );
        },
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
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(16, 28, 22, 0.6),
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _auditItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.w,
          height: 36.h,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(16, 28, 22, 0.2),
            borderRadius: BorderRadius.circular(3.r),
          ),
          alignment: Alignment.center,
          child: Text(
            icon,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromRGBO(42, 41, 51, 0.5),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
