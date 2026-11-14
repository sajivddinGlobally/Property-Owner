import 'dart:convert';
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
import 'package:photo_view/photo_view.dart';
import 'package:property_care/OwnerScreen/ServiceRequest_Screen/Provider/getServiceRequestDetailsProvider.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

import '../../core/AuthService/AuthServiceProvider.dart';
import 'Provider/getServiceProvider.dart';

class ServiceRequestDetails extends ConsumerStatefulWidget {
  final String id;
  const ServiceRequestDetails({super.key, required this.id});

  @override
  ConsumerState<ServiceRequestDetails> createState() =>
      _ServiceRequestDetailsState();
}

class _ServiceRequestDetailsState extends ConsumerState<ServiceRequestDetails> {
  String? _loadingAttachmentUrl;

  Future<void> _handlePdfAction({
    required String url,
    required String fileName,
  }) async {
    if (_loadingAttachmentUrl != null) return;

    setState(() {
      _loadingAttachmentUrl = url;
    });

    try {
      String resolvedUrl = url.trim();
      if (!resolvedUrl.startsWith('http://') &&
          !resolvedUrl.startsWith('https://')) {
        final clean = resolvedUrl.startsWith('/')
            ? resolvedUrl.substring(1)
            : resolvedUrl;
        resolvedUrl = 'https://realestate.gwsstaging.com/public/$clean';
      }

      final uri = Uri.tryParse(resolvedUrl);
      String resolvedFileName = fileName.trim();
      if (uri != null && uri.pathSegments.isNotEmpty) {
        final lastSegment = uri.pathSegments.last.replaceAll(
          RegExp(r'[^\\w\\s\\.-]'),
          '_',
        );
        if (lastSegment.toLowerCase().endsWith('.pdf')) {
          resolvedFileName = lastSegment;
        } else if (!resolvedFileName.toLowerCase().endsWith('.pdf')) {
          resolvedFileName = '$lastSegment.pdf';
        }
      }
      if (!resolvedFileName.toLowerCase().endsWith('.pdf')) {
        resolvedFileName = '$resolvedFileName.pdf';
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
        final len = await file.length();
        if (len > 10) {
          final headerBytes = await file.openRead(0, 5).first;
          final header = String.fromCharCodes(headerBytes);
          if (header == '%PDF-') {
            showSuccessSnackBar("Opening document...");
            final openResult = await OpenFilex.open(savePath);
            if (openResult.type != ResultType.done) {
              if (openResult.type == ResultType.noAppToOpen) {
                showErrorSnackBar(
                  "No app found to open PDF files. Please install a PDF viewer.",
                );
              } else {
                showErrorSnackBar("Could not open file: ${openResult.message}");
              }
            }
            return;
          } else {
            await file.delete();
          }
        } else {
          await file.delete();
        }
      }

      showSuccessSnackBar("Downloading document...");

      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final box = Hive.isBoxOpen("userdata")
          ? Hive.box("userdata")
          : await Hive.openBox("userdata");
      final token = box.get("token");

      final options = Options(
        headers: {
          if (token != null && token.toString().isNotEmpty)
            "Authorization": "Bearer $token",
          "Accept": "application/pdf, application/json, */*",
        },
      );

      await dio.download(resolvedUrl, savePath, options: options);

      if (await file.exists()) {
        final len = await file.length();
        if (len > 10) {
          final headerBytes = await file.openRead(0, 5).first;
          final header = String.fromCharCodes(headerBytes);
          if (header != '%PDF-') {
            String errorMsg = "The server did not return a valid PDF";
            try {
              final text = await file.readAsString();
              if (text.contains('"message"')) {
                final decoded = json.decode(text);
                if (decoded is Map && decoded['message'] != null) {
                  errorMsg = decoded['message'].toString();
                }
              }
            } catch (_) {}
            await file.delete();
            showErrorSnackBar("Failed: $errorMsg");
            return;
          }
        }
      }

      showSuccessSnackBar("Document downloaded successfully");

      final openResult = await OpenFilex.open(savePath);
      if (openResult.type != ResultType.done) {
        if (openResult.type == ResultType.noAppToOpen) {
          showErrorSnackBar(
            "No app found to open PDF files. Please install a PDF viewer.",
          );
        } else {
          showErrorSnackBar("Could not open file: ${openResult.message}");
        }
      }
    } catch (e) {
      log("Error loading PDF: $e");
      showErrorSnackBar("Failed to load PDF document");
    } finally {
      if (mounted) {
        setState(() {
          _loadingAttachmentUrl = null;
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
                  onTap: () => Navigator.pop(context),
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

  final activities = [
    {
      "title": "Request Submitted",
      "date": "18 Aug 2026 • 10:24 AM",
      // "description": "Complaint successfully submitted by property owner.",
    },
    {
      "title": "Under Review",
      "date": "10 Aug 2026 • 11:15 AM",
      // "description": "Complaint reviewed by the association team.",
    },
    {
      "title": "Assigned",
      "date": "12 Aug 2026 • 09:30 AM",
      // "description": "Maintenance supervisor assigned for inspection.",
    },
    {
      "title": "In Progress",
      "date": "12 Aug 2026 • 12:45 PM",
      // "description": "Maintenance supervisor assigned for inspection.",
    },
  ];
  bool isClose = false;
  @override
  Widget build(BuildContext context) {
    final serviceDetailState = ref.watch(
      serviceRequestDetailsProvider(widget.id),
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
                    "Service Request Details",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "View request and ticket details",
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
      body: serviceDetailState.when(
        data: (data) {
          final String rawStatus = (data.data?.header?.statusPill ?? "")
              .trim()
              .toLowerCase();
          final bool isResolved =
              rawStatus == "resolved" || rawStatus.contains("resolve");
          final bool isClosed =
              rawStatus == "closed" || rawStatus.contains("close");
          return RefreshIndicator(
            backgroundColor: AppColors.scaffoldBg,
            color: AppColors.heading,
            onRefresh: () async {
              ref.invalidate(serviceRequestDetailsProvider(widget.id));
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(16, 28, 22, 0.1),
                        border: Border.all(color: AppColors.heading),
                        borderRadius: BorderRadius.circular(17.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ticket ID",
                                      style: GoogleFonts.outfit(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                      ),
                                    ),

                                    SizedBox(height: 2.h),

                                    Text(
                                      data.data?.header?.ticketNumber ?? "",
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff101C16),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 17.w,
                                  vertical: 5.h,
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xff101C16),
                                  ),
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 5.w,
                                      height: 5.h,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff101C16),
                                        shape: BoxShape.circle,
                                      ),
                                    ),

                                    SizedBox(width: 9.w),

                                    Text(
                                      data.data?.header?.statusPill ?? "",
                                      style: GoogleFonts.outfit(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff101C16),
                                        letterSpacing: -0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Text(
                            data.data?.header?.title ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            data.data?.header?.subtitle ?? "",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(42, 41, 51, 0.6),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Request Information",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
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
                            title: "Service Category",
                            value:
                                data
                                    .data
                                    ?.requestInformation
                                    ?.serviceCategory ??
                                "",
                          ),
                          _documentRow(
                            title: "Service Type",
                            value:
                                data.data?.requestInformation?.serviceType ??
                                "",
                            valueColor: const Color(0xFFAE8130),
                          ),
                          _documentRow(
                            title: "Priority",
                            value:
                                data.data?.requestInformation?.priority ?? "",
                          ),
                          _documentRow(
                            title: "Preferred Date",
                            value:
                                data.data?.requestInformation?.preferredDate ??
                                "",
                          ),
                          _documentRow(
                            title: "Property",
                            value:
                                data.data?.requestInformation?.property ?? "",
                            showBottomBorder: false,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      "Request Details",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(16, 28, 22, 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: AppColors.heading),
                      ),
                      child: Text(
                        data.data?.requestDetails ?? "",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.sp,
                          color: AppColors.heading,
                        ),
                      ),
                    ),
                    SizedBox(height: 17.h),
                    Row(
                      children: [
                        Text(
                          "Request Status",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "Ticket Timeline",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Status Timeline",
                            style: GoogleFonts.outfit(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 11.h),
                          ...List.generate(
                            data.data?.statusTimeline?.length ?? 0,
                            (index) {
                              final activity =
                                  data.data!.statusTimeline![index];
                              return _TimelineItem(
                                title: activity.label ?? "",
                                date: activity.dateTime ?? "",
                                isLast:
                                    index ==
                                    data.data!.statusTimeline!.length - 1,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    if (data.data?.assignedTo != null) ...[
                      Text(
                        "Assigned To",
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: Color(0xFF101C16),
                            width: 1.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.r),
                              child: Image.network(
                                data.data?.assignedTo?.avatarUrl ?? "",
                                width: 50.w,
                                height: 50.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 50.w,
                                      height: 50.w,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
                                        border: Border.all(
                                          color: Color(0xFF101C16),
                                          width: 1.w,
                                        ),
                                      ),
                                      child: Icon(Icons.person, size: 30.sp),
                                    ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.data?.assignedTo?.name ?? "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF101C16),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                Text(
                                  data.data?.assignedTo?.role ?? "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromRGBO(16, 28, 22, 0.5),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 46.w,
                              height: 46.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.4),
                                border: Border.all(
                                  color: Color(0xFF101C16),
                                  width: 1.w,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.call_outlined,
                                  color: Color(0xFF101C16),
                                  size: 20.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if ((data.data?.attachments ?? []).isNotEmpty) ...[
                      Row(
                        children: [
                          Text(
                            "Attachments",
                            style: GoogleFonts.outfit(
                              fontSize: 19.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "${data.data!.attachments!.length} File${data.data!.attachments!.length > 1 ? 's' : ''}",
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      ...List.generate(data.data!.attachments!.length, (index) {
                        final attachment = data.data!.attachments![index];
                        final isPdf = attachment.isPdf;
                        final isDownloading =
                            _loadingAttachmentUrl == attachment.url;
                        final fileName = attachment.fileName?.isNotEmpty == true
                            ? attachment.fileName!
                            : (isPdf ? "Document.pdf" : "Image.jpg");
                        final subtitle = isPdf
                            ? "PDF${attachment.size?.isNotEmpty == true ? ' • ${attachment.size}' : ''}"
                            : "Image${attachment.size?.isNotEmpty == true ? ' • ${attachment.size}' : ''}";

                        return GestureDetector(
                          onTap: () {
                            if (attachment.url == null ||
                                attachment.url!.isEmpty) {
                              return;
                            }
                            if (isPdf) {
                              _handlePdfAction(
                                url: attachment.url!,
                                fileName: fileName,
                              );
                            } else {
                              _showImagePreview(attachment.url!);
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 16.h),
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: const Color(0xFF101C16),
                                width: 1.w,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Thumbnail / Icon
                                if (isPdf)
                                  Container(
                                    width: 50.w,
                                    height: 50.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: const Color(0xFF101C16),
                                        width: 1.w,
                                      ),
                                    ),
                                    child: Center(
                                      child: isDownloading
                                          ? SizedBox(
                                              width: 20.sp,
                                              height: 20.sp,
                                              child:
                                                  const CircularProgressIndicator(
                                                    strokeWidth: 2,
                                                    color: Color(0xFF101C16),
                                                  ),
                                            )
                                          : Icon(
                                              Icons.picture_as_pdf_outlined,
                                              size: 26.sp,
                                              color: const Color(0xFF101C16),
                                            ),
                                    ),
                                  )
                                else
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.r),
                                    child: Image.network(
                                      attachment.url ?? "",
                                      width: 50.w,
                                      height: 50.w,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => Container(
                                            width: 50.w,
                                            height: 50.w,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: const Color(0xFF101C16),
                                                width: 1.w,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 26.sp,
                                              color: const Color(0xFF101C16),
                                            ),
                                          ),
                                    ),
                                  ),
                                SizedBox(width: 12.w),
                                // Name and Subtitle
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fileName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF101C16),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: const Color.fromRGBO(
                                            16,
                                            28,
                                            22,
                                            0.55,
                                          ),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                // Action button
                                if (attachment.url == null ||
                                    attachment.url!.isEmpty)
                                  Text(
                                    "No File",
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: const Color.fromRGBO(
                                        16,
                                        28,
                                        22,
                                        0.4,
                                      ),
                                    ),
                                  )
                                else if (isDownloading)
                                  SizedBox(
                                    width: 20.sp,
                                    height: 20.sp,
                                    child: const CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF101C16),
                                    ),
                                  )
                                else
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 6.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff101C16),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          isPdf
                                              ? Icons.file_download_outlined
                                              : Icons.visibility_outlined,
                                          size: 15.sp,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          "View",
                                          style: GoogleFonts.outfit(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                    if (!isClosed) ...[
                      SizedBox(height: 12.h),
                      _buildButton(
                        title: "Close Request",
                        isEnabled: isResolved,
                        backgroundColor: isResolved
                            ? const Color(0xFF101C16)
                            : const Color(0xFFE8E8E8),
                        borderColor: isResolved
                            ? const Color(0xFF101C16)
                            : const Color(0xFFD0D0D0),
                        textColor: isResolved
                            ? Colors.white
                            : const Color(0xFF9E9E9E),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text("Close Request"),
                                    content: Text(
                                      "Are you sure you want to close this request?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: isClose
                                            ? null
                                            : () async {
                                                try {
                                                  setState(() {
                                                    isClose = true;
                                                  });
                                                  final service = ref.read(
                                                    authServiceProvider,
                                                  );
                                                  final res = await service
                                                      .closeTicket(
                                                        id: widget.id
                                                            .toString(),
                                                        status: "closed",
                                                      );
                                                  if (res != null) {
                                                    ref.invalidate(
                                                      serviceRequestDetailsProvider(
                                                        widget.id,
                                                      ),
                                                    );
                                                    ref.invalidate(
                                                      getServiceRequestProvider(
                                                        (
                                                          statusFilter: "",
                                                          search: "",
                                                          type:
                                                              "service_request",
                                                        ),
                                                      ),
                                                    );
                                                    setState(() {
                                                      isClose = false;
                                                    });
                                                    if (context.mounted) {
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                } catch (e) {
                                                  setState(() {
                                                    isClose = false;
                                                  });
                                                } finally {
                                                  setState(() {
                                                    isClose = false;
                                                  });
                                                }
                                              },
                                        child: isClose
                                            ? SizedBox(
                                                width: 18.w,
                                                height: 18.w,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: AppColors.heading,
                                                    ),
                                              )
                                            : Text("Ok"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    ],

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          log(error.toString());
          log(stackTrace.toString());
          return Center(child: Text("Error Loading Data"));
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
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(42, 41, 51, 0.6),
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
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.heading,
                letterSpacing: -0.24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required Color backgroundColor,
    required Color borderColor,
    required Color textColor,
    VoidCallback? onTap,
    bool isEnabled = true,
  }) {
    return SizedBox(
      height: 40.h,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isEnabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: textColor,
          side: BorderSide(color: borderColor, width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String date;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.date,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
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
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  child:
                      date.toLowerCase() == "pending" ||
                          date.toLowerCase() == "current status"
                      ? null
                      : Center(
                          child: Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF101C16),
                            ),
                          ),
                        ),
                ),
                // Vertical Line
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1..w,
                      color: const Color(0xFF000000),
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
                      fontSize: 19.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    date,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      height: 1.1,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(42, 41, 51, 0.5),
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
