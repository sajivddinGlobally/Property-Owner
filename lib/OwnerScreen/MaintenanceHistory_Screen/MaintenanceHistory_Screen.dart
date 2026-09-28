import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/MaintenanceHistory_Screen/MaintenanceDetails_Screen.dart';
import 'package:property_care/core/constant/appColor.dart';

import 'Provider/getMaintenanceHistoryProvider.dart';

class MaintenancehistoryScreen extends ConsumerStatefulWidget {
  const MaintenancehistoryScreen({super.key});

  @override
  ConsumerState<MaintenancehistoryScreen> createState() =>
      _MaintenancehistoryScreenState();
}

class _MaintenancehistoryScreenState
    extends ConsumerState<MaintenancehistoryScreen> {
  int selectedFilterIndex = 0;
  final List<String> filterOptions = [
    "All",
    "Electrical",
    "HVAC",
    "Plumbing",
    "Cleaning",
    "Completed",
  ];

  @override
  Widget build(BuildContext context) {
    final maintenanceHistoryAsync = ref.watch(
      getMaintenanceHistoryProvider(filterOptions[selectedFilterIndex]),
    );

    final summary = maintenanceHistoryAsync.valueOrNull?.data?.property;
    final totalRecords = summary?.totalRecords ?? 0;
    final completedRecords = summary?.completedRecords ?? 0;
    final status = summary?.status ?? "Loading...";
    final name = summary?.name ?? "Loading...";
    final complexName = summary?.complexName ?? "Loading...";

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
                    "Maintenance History",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "View previous and current maintenance activities",
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 35.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: AppColors.heading),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.outfit(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff292832),
                                letterSpacing: -0.64,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              // "Green Valley Residency",
                              complexName,
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(42, 41, 51, 0.6),
                                letterSpacing: -0.24,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.heading),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Center(
                            child: Text(
                              // "Active",
                              status,
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
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.heading),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Total Records",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(42, 41, 51, 0.6),
                                    letterSpacing: -0.24,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  totalRecords.toString(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.heading,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 13.w),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 12.h,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.heading),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Complete Records",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: Color.fromRGBO(42, 41, 51, 0.6),
                                    letterSpacing: -0.24,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  completedRecords.toString(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.heading,
                                    letterSpacing: -0.24,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Text(
                    "Maintenance Records",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                      letterSpacing: -0.24,
                    ),
                  ),
                  Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (String value) {
                      setState(() {
                        selectedFilterIndex = filterOptions.indexOf(value);
                      });
                    },
                    color: AppColors.scaffoldBg,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      side: BorderSide(color: AppColors.heading, width: 1),
                    ),
                    itemBuilder: (BuildContext context) {
                      return filterOptions.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(
                            choice,
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color:
                                  choice == filterOptions[selectedFilterIndex]
                                  ? AppColors.heading
                                  : const Color.fromRGBO(42, 41, 51, 0.7),
                            ),
                          ),
                        );
                      }).toList();
                    },
                    child: Text(
                      "Filter ▾",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 14.h),
              _buildFilters(),
              SizedBox(height: 16.h),
              maintenanceHistoryAsync.when(
                data: (data) {
                  final records = data.data?.records ?? [];
                  if (records.isEmpty) {
                    return Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(vertical: 24.h),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 36.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.heading.withValues(alpha: 0.3),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xffFFFCEF),
                              border: Border.all(
                                color: AppColors.heading,
                                width: 1.2,
                              ),
                            ),
                            child: Icon(
                              Icons.build_outlined,
                              size: 24.sp,
                              color: AppColors.heading,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Text(
                            "No Maintenance Records Found",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "There are no maintenance records available for '${filterOptions[selectedFilterIndex]}'.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color.fromRGBO(42, 41, 51, 0.6),
                              letterSpacing: -0.2,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.h),
                        width: double.infinity,
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.heading,
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(13.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 40.w,
                                  height: 40.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.heading,
                                      width: 1.2,
                                    ),
                                    borderRadius: BorderRadius.circular(7.r),
                                  ),
                                  child: Icon(
                                    Icons.bolt,
                                    size: 20.sp,
                                    color: AppColors.heading,
                                  ),
                                ),
                                SizedBox(width: 13.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        records[index].title ?? "",
                                        style: GoogleFonts.outfit(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.heading,
                                          letterSpacing: -0.2,
                                        ),
                                      ),

                                      SizedBox(height: 5.h),

                                      Text(
                                        records[index].headerSubtitle ?? "",
                                        style: GoogleFonts.outfit(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromRGBO(
                                            42,
                                            41,
                                            51,
                                            0.6,
                                          ),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 6.h,
                                    horizontal: 18.w,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.heading,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                  child: Text(
                                    records![index].status ?? "",
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

                            SizedBox(height: 10.h),
                            Container(
                              width: double.infinity,
                              height: 1.h,
                              color: const Color(0xff999999),
                            ),

                            SizedBox(height: 12.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _detailItem(
                                    title: "Category",
                                    value: records![index].category ?? "",
                                  ),
                                ),

                                Expanded(
                                  child: _detailItem(
                                    title: "Performed By",
                                    value: records![index].performedBy ?? "",
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 19.h),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _detailItem(
                                    title: "Work Type",
                                    value: records![index].workType ?? "",
                                  ),
                                ),

                                Expanded(
                                  child: _detailItem(
                                    title: "Completed On",
                                    value: records![index].completedOn ?? "",
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 16.h),

                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        MaintenancedetailsScreen(
                                          id: records[index].id.toString(),
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 38.h,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.heading,
                                  borderRadius: BorderRadius.circular(7.r),
                                ),
                                child: Text(
                                  "View Maintenance Details →",
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                error: (error, stackTrace) {
                  return Center(child: Text("Error Loading Data"));
                },
                loading: () => SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
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

  Widget _detailItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(42, 41, 51, 0.6),
            letterSpacing: -0.2,
          ),
        ),

        SizedBox(height: 6.h),

        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 17.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filterOptions.length, (index) {
          final bool isSelected = selectedFilterIndex == index;
          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedFilterIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.heading : Colors.transparent,
                  borderRadius: BorderRadius.circular(40.r),
                  border: Border.all(color: AppColors.heading, width: 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  filterOptions[index],
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.heading,
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
}
