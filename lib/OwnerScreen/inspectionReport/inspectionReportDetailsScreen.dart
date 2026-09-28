import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

import 'Provider/getInspectionReportDeailsProvider.dart';

class InspectionReportDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  final String? title;
  final String? date;
  final String? property;
  final String? inspector;
  final String? inspectionDate;
  final String? status;

  const InspectionReportDetailsScreen({
    super.key,
    required this.id,
    this.title,
    this.date,
    this.property,
    this.inspector,
    this.inspectionDate,
    this.status,
  });

  @override
  ConsumerState<InspectionReportDetailsScreen> createState() =>
      _InspectionReportDetailsScreenState();
}

class _InspectionReportDetailsScreenState
    extends ConsumerState<InspectionReportDetailsScreen> {
  bool _isDownloading = false;

  Future<void> _handlePdfAction({
    required String? url,
    required bool openImmediately,
  }) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Inspection report PDF is not available");
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
          : 'inspection_report_${widget.id}.pdf';

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
          showSuccessSnackBar("Opening inspection report...");
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
      showErrorSnackBar("Failed to load inspection report PDF");
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
        elevation: 0,
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
                    "INSPECTION REPORTS",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "INSPECTION REPORT DETAILS",
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
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
                "Failed to load inspection details",
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

          final title = widget.title ?? "Property Inspection Report";
          final headerDate =
              data?.inspectionDate ?? widget.date ?? "15 August 2026";
          final property =
              data?.propertyName ?? widget.property ?? "Apartment A-204";
          final inspector =
              data?.inspector?.name ?? widget.inspector ?? "Rajesh Sharma";
          final inspectionDate =
              data?.inspectionDate ?? widget.inspectionDate ?? "15 Aug 2026";
          final rawStatus = data?.status ?? widget.status ?? "Completed";
          final status = rawStatus.isNotEmpty
              ? "${rawStatus[0].toUpperCase()}${rawStatus.substring(1)}"
              : "Completed";

          final recommendationsText =
              (data?.recommendations != null &&
                  data!.recommendations!.trim().isNotEmpty)
              ? data.recommendations!
              : "Recommended actions and priority items are available based on the inspection findings.";

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
                    SizedBox(height: 12.h),

                    // Overview Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1.1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44.w,
                                height: 44.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                    width: 1.1,
                                  ),
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.article_outlined,
                                    size: 20.sp,
                                    color: const Color(0xff101C16),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff101C16),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    SizedBox(height: 5.h),
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
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 18.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                    width: 1.1,
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

                          SizedBox(height: 12.h),
                          Divider(
                            height: 1,
                            thickness: 0.8,
                            color: const Color(0xffD0D2C8),
                          ),
                          SizedBox(height: 12.h),

                          // Grid details: PROPERTY & INSPECTOR
                          Row(
                            children: [
                              Expanded(
                                child: _infoItem(
                                  title: "PROPERTY",
                                  value: property,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _infoItem(
                                  title: "INSPECTOR",
                                  value: inspector,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12.h),

                          // Grid details: INSPECTION DATE & STATUS
                          Row(
                            children: [
                              Expanded(
                                child: _infoItem(
                                  title: "INSPECTION DATE",
                                  value: inspectionDate,
                                ),
                              ),
                              SizedBox(width: 10.w),
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

                    SizedBox(height: 24.h),

                    // Inspection Findings Header
                    Text(
                      "Inspection Findings",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Findings Box
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff999999),
                          width: 1.1,
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: checklist.isNotEmpty
                          ? ListView.separated(
                              itemCount: checklist.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              separatorBuilder: (context, index) => Column(
                                children: [
                                  SizedBox(height: 12.h),
                                  Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    color: const Color(0xff777970),
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
                                return _findingItem(
                                  iconType: isPass
                                      ? _IconBadgeType.check
                                      : _IconBadgeType.warning,
                                  title: checkItem.itemName ?? "",
                                  subtitle: checkItem.remarks ?? "",
                                );
                              },
                            )
                          : Column(
                              children: [
                                _findingItem(
                                  iconType: _IconBadgeType.check,
                                  title: "General Property Condition",
                                  subtitle:
                                      "Property condition reviewed during the scheduled inspection.",
                                ),
                                SizedBox(height: 12.h),
                                Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: const Color(0xff777970),
                                ),
                                SizedBox(height: 12.h),
                                _findingItem(
                                  iconType: _IconBadgeType.warning,
                                  title: "Maintenance Observation",
                                  subtitle:
                                      "Minor maintenance attention is recommended for the identified area.",
                                ),
                                SizedBox(height: 12.h),
                                Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: const Color(0xff777970),
                                ),
                                SizedBox(height: 12.h),
                                _findingItem(
                                  iconType: _IconBadgeType.check,
                                  title: "Safety Check",
                                  subtitle:
                                      "Safety-related observations recorded in the inspection report.",
                                ),
                              ],
                            ),
                    ),

                    SizedBox(height: 24.h),

                    // Recommendations Header
                    Text(
                      "Recommendations",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Recommendations Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xff101C16),
                          width: 1.1,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recommendationsText,
                            style: GoogleFonts.outfit(
                              fontSize: 12.5.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(16, 28, 22, 0.75),
                              letterSpacing: -0.2,
                              height: 1.35,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18.w,
                                vertical: 7.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff101C16),
                                  width: 1.1,
                                ),
                                borderRadius: BorderRadius.circular(25.r),
                              ),
                              child: Text(
                                "Review Recommended Actions",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff101C16),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Attached Documents / Images Header
                    Text(
                      "Attached Documents / Images",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Document & Images Row
                    Row(
                      children: [
                        // PDF Document Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _handlePdfAction(
                              url: pdfUrl,
                              openImmediately: true,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 18.h,
                                horizontal: 12.w,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff101C16),
                                  width: 1.1,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 28.w,
                                    height: 28.h,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xff101C16),
                                        width: 1.2,
                                      ),
                                      borderRadius: BorderRadius.circular(2.r),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.picture_as_pdf_outlined,
                                        size: 16.sp,
                                        color: const Color(0xff101C16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "Inspection Report",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff101C16),
                                    ),
                                  ),
                                  Text(
                                    "PDF",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff101C16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),

                        // Inspection Images Card
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              if (images.isNotEmpty) {
                                _showImagePreview(images.first);
                              } else {
                                showErrorSnackBar(
                                  "No inspection images available",
                                );
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 18.h,
                                horizontal: 12.w,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xff101C16),
                                  width: 1.1,
                                ),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (images.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(4.r),
                                      child: Image.network(
                                        images.first,
                                        width: 28.w,
                                        height: 28.h,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 28.w,
                                                  height: 28.h,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color(
                                                        0xff101C16,
                                                      ),
                                                      width: 1.2,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          2.r,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Container(
                                                      width: 8.w,
                                                      height: 8.h,
                                                      color: const Color(
                                                        0xff101C16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                      ),
                                    )
                                  else
                                    Container(
                                      width: 28.w,
                                      height: 28.h,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xff101C16),
                                          width: 1.2,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          2.r,
                                        ),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 8.w,
                                          height: 8.h,
                                          color: const Color(0xff101C16),
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    "Inspection Images",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff101C16),
                                    ),
                                  ),
                                  Text(
                                    "Images",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff101C16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),

                    // Bottom Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.scaffoldBg,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0xff101C16),
                                    width: 1.1,
                                  ),
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
                                      width: 18.w,
                                      height: 18.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xff101C16),
                                      ),
                                    )
                                  : Text(
                                      "View Full Report",
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff101C16),
                                        fontSize: 13.5.sp,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: SizedBox(
                            height: 44.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff101C16),
                                elevation: 0,
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
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 13.5.sp,
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
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(16, 28, 22, 0.55),
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff101C16),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _findingItem({
    required _IconBadgeType iconType,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34.w,
          height: 34.h,
          decoration: BoxDecoration(
            color: const Color(0xffD9DCD3),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Center(
            child: iconType == _IconBadgeType.check
                ? Icon(Icons.check, size: 18.sp, color: const Color(0xff101C16))
                : Text(
                    "!",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xff101C16),
                    ),
                  ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff101C16),
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: GoogleFonts.outfit(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromRGBO(16, 28, 22, 0.6),
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

enum _IconBadgeType { check, warning }
