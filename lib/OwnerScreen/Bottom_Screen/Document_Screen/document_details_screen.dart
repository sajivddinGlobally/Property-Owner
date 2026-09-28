import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:property_care/OwnerScreen/AIDocumentAssistant_Screen/AIDocumentAssistant_Screen.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:share_plus/share_plus.dart';

import 'Provider/documentDetailsProvider.dart';

class DocumentDetailsScreen extends ConsumerStatefulWidget {
  final String id;
  const DocumentDetailsScreen({super.key, required this.id});

  @override
  ConsumerState<DocumentDetailsScreen> createState() =>
      _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends ConsumerState<DocumentDetailsScreen> {
  bool _isDownloading = false;

  Future<void> _downloadDocument(
    String? url,
    String? fileName,
    String? fileType,
  ) async {
    if (url == null || url.trim().isEmpty) {
      showErrorSnackBar("Download URL is not available");
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      String resolvedFileName;
      if (fileName != null && fileName.trim().isNotEmpty) {
        final ext = (fileType != null && fileType.trim().isNotEmpty)
            ? (fileType.startsWith('.')
                  ? fileType.toLowerCase()
                  : '.${fileType.toLowerCase()}')
            : '';
        resolvedFileName = fileName.trim().replaceAll(
          RegExp(r'[^\w\s\.-]'),
          '_',
        );
        if (ext.isNotEmpty && !resolvedFileName.toLowerCase().endsWith(ext)) {
          resolvedFileName = '$resolvedFileName$ext';
        }
      } else {
        final uri = Uri.tryParse(url);
        resolvedFileName = uri != null && uri.pathSegments.isNotEmpty
            ? uri.pathSegments.last
            : 'document_${DateTime.now().millisecondsSinceEpoch}';
      }

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
      if (await file.exists()) {
        showSuccessSnackBar("Opening downloaded document...");
        await OpenFilex.open(savePath);
        return;
      }

      final dio = Dio();
      await dio.download(url, savePath);
      log(savePath);

      showSuccessSnackBar(
        "Document downloaded successfully: $resolvedFileName",
      );

      await OpenFilex.open(savePath);
    } catch (e, st) {
      showErrorSnackBar("Failed to download document: $e");
      log(e.toString());
      log(st.toString());
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
    final documentDetailsState = ref.watch(documentDetailsProvider(widget.id));
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.h),
        child: Container(
          color: AppColors.background,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Row(  
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 41.h,
                      width: 41.w,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color.fromRGBO(16, 28, 22, 0.3),
                        ),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: const Color(0xff101C16),
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 9.w),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Document Details",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff292832),
                            letterSpacing: -0.64,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "DOCUMENT PREVIEW",
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
                  // InkWell(
                  //   onTap: () {
                  //     final docTitle = documentDetailsState
                  //             .valueOrNull?.data?.propertyOverview?.documentName ??
                  //         "Document";
                  //     Navigator.push(
                  //       context,
                  //       CupertinoPageRoute(
                  //         builder: (context) => AIDocumentAssistantScreen(
                  //           initialDocumentTitle: docTitle,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 10.w,
                  //       vertical: 6.h,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: const Color(0xff101C16),
                  //       borderRadius: BorderRadius.circular(6.r),
                  //       border: Border.all(
                  //         color: const Color(0xFFB8860B),
                  //         width: 1.w,
                  //       ),
                  //     ),
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Icon(
                  //           Icons.auto_awesome,
                  //           size: 14.sp,
                  //           color: const Color(0xFFE5C058),
                  //         ),
                  //         SizedBox(width: 4.w),
                  //         Text(
                  //           "AI Summary",
                  //           style: GoogleFonts.outfit(
                  //             fontSize: 12.sp,
                  //             fontWeight: FontWeight.w600,
                  //             color: const Color(0xFFFFFCEB),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: documentDetailsState.when(
        data: (data) {
          final previewUrl = data.data?.header?.documentPreviewUrl;
          final propertyOverview = data.data?.propertyOverview;
          final description = data.data?.description;
          final actionUrls = data.data?.actionUrls;
          final isVerified =
              propertyOverview?.documentStatus?.toLowerCase() == "verified";

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25.h),
                  Text(
                    "Document Preview",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 15.h),
                  GestureDetector(
                    onTap: () {
                      if (previewUrl != null && previewUrl.trim().isNotEmpty) {
                        _showImagePreview(previewUrl.trim());
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      decoration: BoxDecoration(
                        color: const Color(0xffD7D4C8),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.heading),
                      ),
                      child: Center(
                        child:
                            (previewUrl != null && previewUrl.trim().isNotEmpty)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: Image.network(
                                  previewUrl.trim(),
                                  width: 269.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                        "assets/image_details.png",
                                        width: 269.w,
                                        fit: BoxFit.cover,
                                      ),
                                ),
                              )
                            : Image.asset(
                                "assets/image_details.png",
                                width: 269.w,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Property Overview",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 17.sp,
                      color: AppColors.heading,
                      letterSpacing: -0.54,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _documentRow(
                          title: "Document Name",
                          value: propertyOverview?.documentName ?? "",
                        ),
                        _documentRow(
                          title: "Category",
                          value: propertyOverview?.category ?? "",
                        ),
                        _documentRow(
                          title: "File Type",
                          value: propertyOverview?.fileType ?? "",
                        ),
                        _documentRow(
                          title: "File Size",
                          value: propertyOverview?.fileSize ?? "",
                        ),
                        _documentRow(
                          title: "Uploaded On",
                          value: propertyOverview?.uploadedOn ?? "",
                        ),
                        _documentRow(
                          title: "Document Status",
                          value: propertyOverview?.documentStatus ?? "",
                          valueColor: isVerified
                              ? const Color(0xFF24B56B)
                              : AppColors.heading,
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Description",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      fontSize: 17.sp,
                      letterSpacing: -0.54,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 10.h,
                      horizontal: 9.w,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.heading),
                    ),
                    child: Text(
                      description?.isNotEmpty == true
                          ? description!
                          : "No description available.",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        color: const Color.fromRGBO(42, 41, 51, 0.6),
                        fontSize: 14.sp,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 41.h,
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final shareUrl =
                                  actionUrls?.shareUrl ??
                                  actionUrls?.downloadUrl;
                              if (shareUrl != null &&
                                  shareUrl.trim().isNotEmpty) {
                                // ignore: deprecated_member_use
                                await Share.share(
                                  shareUrl.trim(),
                                  subject:
                                      propertyOverview?.documentName ??
                                      "Document",
                                );
                              } else {
                                showErrorSnackBar("Share URL is not available");
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.heading,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            icon: Icon(
                              Icons.reply_outlined,
                              size: 19.sp,
                              color: AppColors.heading,
                            ),
                            label: Text(
                              "Share",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.heading,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 24.w),
                      Expanded(
                        child: SizedBox(
                          height: 41.h,
                          child: ElevatedButton.icon(
                            onPressed: _isDownloading
                                ? null
                                : () {
                                    _downloadDocument(
                                      actionUrls?.downloadUrl,
                                      propertyOverview?.documentName,
                                      propertyOverview?.fileType,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.heading,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: AppColors.heading
                                  .withValues(alpha: 0.7),
                              elevation: 0,
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.r),
                              ),
                            ),
                            icon: _isDownloading
                                ? SizedBox(
                                    width: 16.sp,
                                    height: 16.sp,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.download_outlined,
                                    size: 19.sp,
                                    color: Colors.white,
                                  ),
                            label: Text(
                              _isDownloading
                                  ? "Downloading..."
                                  : "Download Document",
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: -0.24,
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
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text("Error Loading Data: $error"));
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _documentRow({
    required String title,
    required String value,
    Color valueColor = const Color(0xFF171A18),
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
                color: valueColor,
                letterSpacing: -0.24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
