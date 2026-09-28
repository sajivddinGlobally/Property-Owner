import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/AIDocumentAssistant_Screen/AIDocumentAssistant_Screen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Document_Screen/Provider/getDocumentListProvider.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Document_Screen/document_details_screen.dart';

class DocumentScreen extends ConsumerStatefulWidget {
  final bool isShowBackButton;
  const DocumentScreen({super.key,this.isShowBackButton = false});

  @override
  ConsumerState<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends ConsumerState<DocumentScreen> {
  int selectedFilter = 0;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  final List<String> filters = [
    "All",
    "Property",
    "Inspection",
    "Audit",
    "Certificates",
    "Maintenance",
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final getDocumentState = ref.watch(
      getDocumentListProvider(filters[selectedFilter]),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        titleSpacing: 20.w,
        title: Row(
          children: [
            if (widget.isShowBackButton)
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "PROPERTY DOCUMENTS",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff292832),
                        letterSpacing: -0.64,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "ALL PROPERTY RECORDS IN ONE PLACE",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
          ],
        ),
      ),
      // appBar: PreferredSize(
      //   preferredSize: Size.fromHeight(60.h),
      //   child: Container(
      //     color: AppColors.background,
      //     child: SafeArea(
      //       child: Padding(
      //         padding: EdgeInsets.symmetric(horizontal: 20.w),
      //         child: Row(
      //           children: [
      //             Expanded(
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     "PROPERTY DOCUMENTS",
      //                     maxLines: 1,
      //                     overflow: TextOverflow.ellipsis,
      //                     style: GoogleFonts.outfit(
      //                       fontSize: 17.sp,
      //                       fontWeight: FontWeight.w500,
      //                       color: const Color(0xff292832),
      //                       letterSpacing: -0.64,
      //                     ),
      //                   ),
      //                   SizedBox(height: 2.h),
      //                   Text(
      //                     "ALL PROPERTY RECORDS IN ONE PLACE",
      //                     maxLines: 1,
      //                     overflow: TextOverflow.ellipsis,
      //                     style: GoogleFonts.outfit(
      //                       fontSize: 14.sp,
      //                       fontWeight: FontWeight.w400,
      //                       color: Color.fromRGBO(42, 41, 51, 0.6),
      //                       letterSpacing: -0.24,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //             InkWell(
      //               onTap: () {
      //                 Navigator.push(
      //                   context,
      //                   CupertinoPageRoute(
      //                     builder: (context) =>
      //                         const AIDocumentAssistantScreen(),
      //                   ),
      //                 );
      //               },
      //               child: Container(
      //                 padding: EdgeInsets.symmetric(
      //                   horizontal: 10.w,
      //                   vertical: 6.h,
      //                 ),
      //                 decoration: BoxDecoration(
      //                   color: const Color(0xff101C16),
      //                   borderRadius: BorderRadius.circular(6.r),
      //                   border: Border.all(
      //                     color: const Color(0xFFB8860B),
      //                     width: 1.w,
      //                   ),
      //                 ),
      //                 child: Row(
      //                   mainAxisSize: MainAxisSize.min,
      //                   children: [
      //                     Icon(
      //                       Icons.auto_awesome,
      //                       size: 14.sp,
      //                       color: const Color(0xFFE5C058),
      //                     ),
      //                     SizedBox(width: 4.w),
      //                     Text(
      //                       "AI Assistant",
      //                       style: GoogleFonts.outfit(
      //                         fontSize: 12.sp,
      //                         fontWeight: FontWeight.w600,
      //                         color: const Color(0xFFFFFCEB),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),,
      //     ),
      //   ),
      // ),
      body: getDocumentState.when(
        data: (documentData) {
          final overview = documentData.data?.propertyOverview;
          final storage = documentData.data?.storageUsage;
          final allDocuments = documentData.data?.recentDocuments ?? [];
          final filteredDocs = allDocuments.where((doc) {
            if (searchQuery.isEmpty) return true;
            final q = searchQuery.toLowerCase();
            return (doc.title ?? "").toLowerCase().contains(q) ||
                (doc.categoryPill ?? "").toLowerCase().contains(q);
          }).toList();

          final countParts = (overview?.totalDocumentsCount ?? "").trim().split(
            " ",
          );
          final countNumber =
              countParts.isNotEmpty && countParts.first.isNotEmpty
              ? countParts.first
              : "0";
          final countLabel = countParts.length > 1
              ? countParts.sublist(1).join(" ")
              : "Documents";
          final imageUrl =
              overview?.imageUrl?.trim().replaceAll(" ", "%20") ?? "";

          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 13.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: const Color(0xff101C16),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Stack(
                            children: [
                              imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      width: double.infinity,
                                      height: 151.h,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Image.asset(
                                                "assets/document_img.png",
                                                width: double.infinity,
                                                height: 151.h,
                                                fit: BoxFit.cover,
                                              ),
                                    )
                                  : Image.asset(
                                      "assets/document_img.png",
                                      width: double.infinity,
                                      height: 151.h,
                                      fit: BoxFit.cover,
                                    ),
                              if (overview?.propertyNumber != null &&
                                  overview!.propertyNumber!.trim().isNotEmpty)
                                Positioned(
                                  left: 12.w,
                                  top: 10.h,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 5.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Color(0xff101C16),
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        overview.propertyNumber!,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    overview?.propertyName ?? "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff101C16),
                                      letterSpacing: -0.54,
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    overview?.complexLocation ?? "",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromRGBO(42, 41, 51, 0.6),
                                      letterSpacing: -0.34,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  countNumber,
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff101C16),
                                    letterSpacing: -0.54,
                                  ),
                                ),
                                Text(
                                  countLabel,
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    color: Color(0xff101C16),
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: -0.34,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 23.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Container(
                    height: 55.h,
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 16.w, right: 10.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Color(0xff101C16), width: 1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 25.sp,
                          color: const Color(0xff8B8D8B),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.trim();
                              });
                            },
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: "Search documents...",
                              hintStyle: GoogleFonts.outfit(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xff8B8D8B),
                              ),
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 17.h),
                Padding(
                  padding: EdgeInsets.only(left: 20.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(filters.length, (index) {
                        final bool isSelected = selectedFilter == index;

                        return Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedFilter = index;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                vertical: 5.h,
                                horizontal: 13.w,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xff101C16)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(40.r),
                                border: Border.all(
                                  color: const Color(0xff101C16),
                                  width: 1,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                filters[index],
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xff101C16),
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Text(
                        "Recent Documents",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff101C16),
                          fontSize: 16.sp,
                          letterSpacing: -0.54,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${filteredDocs.length} File${filteredDocs.length != 1 ? 's' : ''}",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: Color(0xff101C16),
                          fontSize: 14.sp,
                          letterSpacing: -0.24,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                if (filteredDocs.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.h),
                    child: Center(
                      child: Text(
                        "No documents found",
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff8B8D8B),
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: ListView.builder(
                      itemCount: filteredDocs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final doc = filteredDocs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => DocumentDetailsScreen(
                                  id: doc.id.toString(),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(
                              vertical: 13.h,
                              horizontal: 12.w,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: const Color.fromRGBO(16, 28, 22, 0.6),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Document Icon
                                Container(
                                  height: 50.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.r),
                                    border: Border.all(
                                      color: const Color(0xff101C16),
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.description,
                                      color: AppColors.heading,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        doc.title ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17.sp,
                                          color: const Color(0xff101C16),
                                          letterSpacing: -0.54,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        doc.fileTypeSize ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14.sp,
                                          color: const Color.fromRGBO(
                                            42,
                                            41,
                                            51,
                                            0.6,
                                          ),
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        doc.categoryPill ?? "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13.sp,
                                          color: const Color(0xff2A2933),
                                          letterSpacing: -0.24,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  height: 36.w,
                                  width: 36.w,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xff101C16),
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: const Color(0xff101C16),
                                      size: 17.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (storage != null) ...[
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffEAE7DA),
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(
                          color: const Color(0xff26332D),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Property Document Storage",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xff101C16),
                                  letterSpacing: -0.34,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                storage.usageText ??
                                    "${storage.usedMb ?? 0} MB / ${storage.totalMb ?? 25} MB",
                                style: GoogleFonts.outfit(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(0, 0, 0, 0.6),
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 18.h),
                          Container(
                            width: double.infinity,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: const Color(0xff999B93),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor:
                                  ((storage.totalMb != null &&
                                              storage.totalMb! > 0)
                                          ? ((storage.usedMb ?? 0) /
                                                storage.totalMb!)
                                          : 0.0)
                                      .clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff17221D),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 35.h),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 80.h),
            child: Text(
              "Error while loading documents",
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff8B8D8B),
              ),
            ),
          ),
        ),
        loading: () => Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 80.h),
            child: CircularProgressIndicator(color: AppColors.heading),
          ),
        ),
      ),
    );
  }
}
