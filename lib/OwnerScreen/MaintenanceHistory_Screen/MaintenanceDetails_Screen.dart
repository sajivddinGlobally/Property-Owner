import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_care/OwnerScreen/MaintenanceHistory_Screen/Provider/getmaintenanceHistoryDetailsProvider.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

class MaintenancedetailsScreen extends ConsumerStatefulWidget {
  final String id;
  const MaintenancedetailsScreen({super.key, required this.id});

  @override
  ConsumerState<MaintenancedetailsScreen> createState() =>
      _MaintenancedetailsScreenState();
}

class _MaintenancedetailsScreenState
    extends ConsumerState<MaintenancedetailsScreen> {
  String? _downloadingDocUrl;

  Future<void> _viewDocument({
    required String? url,
    required String? fileName,
    required String? fileType,
  }) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Document URL not available");
      return;
    }

    setState(() {
      _downloadingDocUrl = url;
    });

    try {
      String resolvedFileName = "";
      if (fileName != null && fileName.trim().isNotEmpty) {
        resolvedFileName = fileName.trim();
      } else {
        final uri = Uri.tryParse(url);
        resolvedFileName = uri != null && uri.pathSegments.isNotEmpty
            ? uri.pathSegments.last
            : 'document_${DateTime.now().millisecondsSinceEpoch}.pdf';
      }

      resolvedFileName = resolvedFileName.replaceAll(
        RegExp(r'[^\w\s\.-]'),
        '_',
      );

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
        showSuccessSnackBar("Opening document...");
        await OpenFilex.open(savePath);
        return;
      }

      showSuccessSnackBar("Downloading document...");
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      await dio.download(url, savePath);

      showSuccessSnackBar("Document downloaded successfully");
      await OpenFilex.open(savePath);
    } catch (e, str) {
      log("Download error: $e");
      log(str.toString());

      // Partial / corrupt file delete karein agar download fail hua
      try {
        final uri = Uri.tryParse(url);
        final fileNameFallback = uri != null && uri.pathSegments.isNotEmpty
            ? uri.pathSegments.last
            : 'doc';
        final resolvedName = (fileName != null && fileName.trim().isNotEmpty)
            ? fileName.trim().replaceAll(RegExp(r'[^\w\s\.-]'), '_')
            : fileNameFallback;
        final dir = await getApplicationDocumentsDirectory();
        final failedFile = File('${dir.path}/$resolvedName');
        if (await failedFile.exists()) {
          await failedFile.delete();
        }
      } catch (_) {}

      if (e is DioException && e.response?.statusCode == 404) {
        showErrorSnackBar("Document file not found on server (404)");
      } else if (e is DioException &&
          (e.type == DioExceptionType.connectionTimeout ||
              e.type == DioExceptionType.receiveTimeout)) {
        showErrorSnackBar("Download connection timed out. Please try again.");
      } else {
        showErrorSnackBar("Failed to download document");
      }
    } finally {
      if (mounted) {
        setState(() {
          _downloadingDocUrl = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final getMaintenanceDetailState = ref.watch(
      getMaintenanceHistoryDetailsProvider(widget.id),
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
                    "Maintenance Details",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "View complete maintenance information",
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
      body: getMaintenanceDetailState.when(
        data: (data) {
          final details = data.data;
          final header = details?.header;
          final info = details?.information;
          final work = details?.workDetails;
          final timeline = details?.timeline ?? [];
          final team = details?.assignedTeam;
          final docs = details?.relatedDocuments ?? [];
          final notes = details?.notes;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Box
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xffFFFCEF),
                                border: Border.all(
                                  color: AppColors.heading,
                                  width: 1.2,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.bolt,
                                size: 20.sp,
                                color: AppColors.heading,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    header?.title ?? "Maintenance",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff292832),
                                      letterSpacing: -0.64,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    header?.workType ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.6,
                                      ),
                                      letterSpacing: -0.24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.heading),
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: Center(
                                child: Text(
                                  header?.status ?? "Completed",
                                  style: GoogleFonts.outfit(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff292832),
                                    letterSpacing: -0.64,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Divider(thickness: 1, color: AppColors.heading),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Text(
                              "Maintenance ID",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                letterSpacing: -0.24,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              header?.maintenanceCode ?? "N/A",
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColors.heading,
                                letterSpacing: -0.24,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),
                  Text(
                    "Maintenance Information",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.24,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Information Box
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _documentRow(
                          title: "Property",
                          value: info?.property ?? "N/A",
                          color: AppColors.heading,
                        ),
                        if (info?.complex != null && info!.complex!.isNotEmpty)
                          _documentRow(
                            title: "Complex",
                            value: info.complex!,
                            color: AppColors.heading,
                          ),
                        _documentRow(
                          title: "Category",
                          value: info?.category ?? "N/A",
                          color: const Color(0xffAE8130),
                        ),
                        _documentRow(
                          title: "Work Type",
                          value: info?.workType ?? "N/A",
                          color: AppColors.heading,
                        ),
                        _documentRow(
                          title: "Request Date",
                          value: info?.requestDate ?? "N/A",
                          color: AppColors.heading,
                        ),
                        _documentRow(
                          title: "Completed Date",
                          value: info?.completedDate ?? "N/A",
                          color: AppColors.heading,
                        ),
                        _documentRow(
                          title: "Current Status",
                          value: info?.currentStatus ?? "N/A",
                          color:
                              (info?.currentStatus?.toLowerCase() ==
                                  "completed")
                              ? const Color(0xff24B06A)
                              : const Color(0xffAE8130),
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),
                  Text(
                    "Work Details",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.24,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(16, 28, 22, 0.1),
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                    child: Text(
                      (work?.description != null &&
                              work!.description!.isNotEmpty)
                          ? work.description!
                          : "No work details available.",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                  Text(
                    "Maintenance Timeline",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.24,
                    ),
                  ),
                  SizedBox(height: 11.h),

                  // Timeline Box
                  Container(
                    padding: EdgeInsets.only(
                      left: 17.w,
                      right: 17.w,
                      top: 17.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: (timeline.isNotEmpty)
                        ? Column(
                            children: [
                              ...List.generate(timeline.length, (index) {
                                final activity = timeline[index];
                                final isCompleted =
                                    activity.status?.toLowerCase() ==
                                        "completed" ||
                                    (activity.timestamp != null &&
                                        activity.timestamp!.isNotEmpty &&
                                        activity.timestamp!.toLowerCase() !=
                                            "pending");
                                return _TimelineItem(
                                  title: activity.title ?? "",
                                  date: activity.timestamp ?? "",
                                  isCompleted: isCompleted,
                                  isLast: index == timeline.length - 1,
                                );
                              }),
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 14.h,
                              horizontal: 10.w,
                            ),
                            child: Text(
                              "No timeline updates available.",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: const Color.fromRGBO(42, 41, 51, 0.6),
                              ),
                            ),
                          ),
                  ),

                  SizedBox(height: 30.h),
                  Text(
                    "Assigned Team",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.24,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Assigned Team Box
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(),
                    ),
                    child: Row(
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
                                (team?.avatar != null &&
                                    team!.avatar!.isNotEmpty)
                                ? Image.network(
                                    team.avatar!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 51.w,
                                              height: 51.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: AppColors.heading,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  size: 20.sp,
                                                  color: AppColors.heading,
                                                ),
                                              ),
                                            ),
                                  )
                                : Container(
                                    width: 51.w,
                                    height: 51.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.heading,
                                      ),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.person,
                                        size: 20.sp,
                                        color: AppColors.heading,
                                      ),
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
                                team?.name ?? "Not Assigned",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff292832),
                                  letterSpacing: -0.64,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Text(
                                team?.role ?? "Maintenance Team",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          team?.status ?? "Assigned",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            letterSpacing: -0.24,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),
                  Text(
                    "Related Documents",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.24,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Related Documents
                  if (docs.isNotEmpty)
                    ...List.generate(docs.length, (index) {
                      final doc = docs[index];
                      return Container(
                        margin: EdgeInsets.only(
                          bottom: index == docs.length - 1 ? 0 : 12.h,
                        ),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 51.w,
                              height: 51.w,
                              decoration: const BoxDecoration(
                                color: Color(0xffF1F1EC),
                              ),
                              child: Image.asset(
                                "assets/pdf.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.fileName ?? doc.title ?? "Document.pdf",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff292832),
                                      letterSpacing: -0.64,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    "${doc.title ?? "Document"} • ${doc.fileSize ?? ""}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color.fromRGBO(
                                        42,
                                        41,
                                        51,
                                        0.6,
                                      ),
                                      letterSpacing: -0.24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            GestureDetector(
                              onTap: _downloadingDocUrl == doc.downloadUrl
                                  ? null
                                  : () => _viewDocument(
                                      url: doc.downloadUrl,
                                      fileName: doc.fileName,
                                      fileType: doc.fileType,
                                    ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                child: _downloadingDocUrl == doc.downloadUrl
                                    ? SizedBox(
                                        width: 16.w,
                                        height: 16.w,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.heading,
                                        ),
                                      )
                                    : Text(
                                        "View",
                                        style: GoogleFonts.outfit(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.heading,
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      );
                    })
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: AppColors.heading.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "No related documents found",
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: const Color.fromRGBO(42, 41, 51, 0.6),
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 20.h),
                  Text(
                    "Notes",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.24,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: AppColors.heading, width: 1.5),
                      ),
                    ),
                    child: Text(
                      (notes != null && notes.isNotEmpty)
                          ? notes
                          : "No notes available.",
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
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 40.sp, color: Colors.red),
                SizedBox(height: 10.h),
                Text(
                  "Something went wrong",
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.heading,
                    letterSpacing: -0.24,
                  ),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(
                      getMaintenanceHistoryDetailsProvider(widget.id),
                    );
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
          return SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.heading),
            ),
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
                fontSize: 13.sp,
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
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isCompleted;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.date,
    this.isCompleted = true,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final bool showFilledDot =
        isCompleted &&
        date.toLowerCase() != "pending" &&
        date.toLowerCase() != "current status";

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
                      color: showFilledDot
                          ? const Color(0xFF101C16)
                          : const Color(0xFFC8C8C1),
                      width: 1.w,
                    ),
                  ),
                  child: showFilledDot
                      ? Center(
                          child: Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF101C16),
                            ),
                          ),
                        )
                      : null,
                ),
                // Vertical Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1.w,
                      color: showFilledDot
                          ? const Color(0xFF000000)
                          : const Color(0xFFC8C8C1),
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
                      fontSize: 17.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                      color: showFilledDot
                          ? const Color(0xFF101C16)
                          : const Color.fromRGBO(42, 41, 51, 0.4),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    date,
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: showFilledDot
                          ? const Color.fromRGBO(42, 41, 51, 0.5)
                          : const Color.fromRGBO(42, 41, 51, 0.3),
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
