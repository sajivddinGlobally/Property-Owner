import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/ServiceRequest_Screen/Create_Service_request.dart';
import 'package:property_care/OwnerScreen/ServiceRequest_Screen/Provider/getServiceProvider.dart';
import 'package:property_care/OwnerScreen/ServiceRequest_Screen/Service_Request_details.dart';
import 'package:property_care/core/constant/appColor.dart';

class ServiceRequestScreen extends ConsumerStatefulWidget {
  const ServiceRequestScreen({super.key});

  @override
  ConsumerState<ServiceRequestScreen> createState() =>
      _ServiceRequestScreenState();
}

class _ServiceRequestScreenState extends ConsumerState<ServiceRequestScreen> {
  int selectedFilter = 0;
  int selectedSummary = 0;
  final List<String> filters = ["All", "Open", "In Progress", "Resolved"];
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusFilter = "";
    if (selectedFilter == 1)
      statusFilter = "open";
    else if (selectedFilter == 2)
      statusFilter = "in_progress";
    else if (selectedFilter == 3)
      statusFilter = "resolved";

    final state = ref.watch(
      getServiceRequestProvider((
        statusFilter: statusFilter,
        search: searchQuery,
        type: "service_request",
      )),
    );

    final summary = state.valueOrNull?.data?.summaryCounts;
    final totalRequest = summary?.totalRequests ?? "0";
    final inProgress = summary?.inProgress ?? "0";
    final complete = summary?.completed ?? "0";

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
                    "Service Requests",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "PROPERTY SERVICE MANAGEMENT",
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => CreateServiceRequest(),
                  ),
                );
              },
              child: Container(
                width: 50.w,
                height: 50.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff101C16),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 24.sp),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _requestCountBox(
                      count: totalRequest ?? "0",
                      title: "TOTAL REQUEST",
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: _requestCountBox(
                      count: inProgress ?? "0",
                      title: "IN PROGRESS",
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: _requestCountBox(
                      count: complete ?? "0",
                      title: "COMPLETED",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Container(
                height: 55.h,
                width: double.infinity,
                padding: EdgeInsets.only(left: 16.w, right: 10.w),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFDF2),
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
                            searchQuery = value;
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
              SizedBox(height: 20.h),
              _buildFilters(),
              SizedBox(height: 20.h),
              state.when(
                data: (modelData) {
                  if (modelData.data?.tickets == null ||
                      modelData.data!.tickets!.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Center(
                        child: Text(
                          "No service requests found",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff8B8D8B),
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: modelData.data!.tickets!.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => ServiceRequestDetails(
                                id: modelData.data!.tickets![index].id!
                                    .toString(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 11.w,
                            vertical: 15.h,
                          ),
                          margin: EdgeInsets.only(bottom: 20.h),
                          decoration: BoxDecoration(
                            color: const Color(0xffFFFDF0),
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
                                    width: 36.w,
                                    height: 36.h,
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

                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          // "Bathroom Plumbing Service",
                                          modelData
                                                  .data
                                                  ?.tickets?[index]
                                                  .title ??
                                              "",
                                          // maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.outfit(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xff101C16),
                                            letterSpacing: -0.2,
                                          ),
                                        ),

                                        SizedBox(height: 6.h),

                                        Text(
                                          // "SR-2026-00128",
                                          modelData
                                                  .data
                                                  ?.tickets?[index]
                                                  .ticketNumber ??
                                              "",
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Color.fromRGBO(
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
                                      // "IN PROGRESS",
                                      modelData
                                              .data
                                              ?.tickets![index]
                                              .statusPill ??
                                          "",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xff101C16),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              Text(
                                // "Plumbing inspection and repair required for bathroom water leakage.",
                                modelData
                                        .data
                                        ?.tickets![index]
                                        .shortDescription ??
                                    "",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(16, 28, 22, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              SizedBox(height: 14.h),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: const Color(0xff777970),
                              ),

                              SizedBox(height: 17.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: _infoItem(
                                      title: "Category",
                                      value:
                                          modelData
                                              .data
                                              ?.tickets![index]
                                              .iconType ??
                                          "",
                                    ),
                                  ),

                                  SizedBox(width: 15.w),
                                  Expanded(
                                    child: _infoItem(
                                      title: "Priority",
                                      value:
                                          modelData
                                              .data
                                              ?.tickets![index]
                                              .priority ??
                                          "",
                                    ),
                                  ),
                                  SizedBox(width: 15.w),

                                  Expanded(
                                    child: _infoItem(
                                      title: "Requested",
                                      value:
                                          modelData
                                              .data
                                              ?.tickets![index]
                                              .requestedDate ??
                                          "",
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 14.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      // "Updated 2 hrs ago",
                                      modelData
                                              .data
                                              ?.tickets![index]
                                              .updatedText ??
                                          "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color.fromRGBO(16, 28, 22, 0.6),
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    child: Text(
                                      "View Details →",
                                      style: GoogleFonts.outfit(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.heading,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  log(stackTrace.toString());
                  return Center(child: Text("Error Loading Data"));
                },
                loading: () => SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 1.8,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.heading),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
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
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 13.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff101C16)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(color: const Color(0xff101C16), width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  filters[index],
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xff101C16),
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ),
          );
        }),
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
            color: Color.fromRGBO(16, 28, 22, 0.6),
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

  Widget _requestCountBox({required String count, required String title}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading, width: 1.w),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
              letterSpacing: -0.24,
            ),
          ),

          SizedBox(height: 6.h),

          Text(
            title,
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
    );
  }
}
