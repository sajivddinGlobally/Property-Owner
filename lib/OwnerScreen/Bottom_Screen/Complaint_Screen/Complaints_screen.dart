import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Complaint_Screen/ComplaintDetailScreen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Complaint_Screen/CreateComplaintScreen.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:property_care/OwnerScreen/ServiceRequest_Screen/Provider/getServiceProvider.dart';

class ComplaintsScreen extends ConsumerStatefulWidget {
  final bool isShowBackButton;
  const ComplaintsScreen({super.key, this.isShowBackButton = false});

  @override
  ConsumerState<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends ConsumerState<ComplaintsScreen> {
  int selectedFilter = 0;
  int selectedSummary = 0;
  String searchQuery = "";
  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> complaints = [
    {
      "title": "Water Leakage in Bathroom",
      "complaintId": "CMP-2026-00124",
      "status": "OPEN",
      "priority": "High Priority",
      "date": "21 Aug 2026",
      "icon": Icons.water_damage_outlined,
    },
    {
      "title": "Lift Maintenance Issue",
      "complaintId": "CMP-2026-00118",
      "status": "IN PROGRESS",
      "priority": "Medium",
      "date": "18 Aug 2026",
      "icon": Icons.elevator_outlined,
    },
    {
      "title": "Common Area Lighting Issue",
      "complaintId": "CMP-2026-00105",
      "status": "RESOLVED",
      "priority": "Low Priority",
      "date": "10 Aug 2026",
      "icon": Icons.receipt_long_outlined,
    },
  ];

  final List<String> filters = ["All", "Open", "In Progress", "Resolved"];
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
        type: "complaint",
      )),
    );

    final summary = state.valueOrNull?.data?.summaryCounts;
    final total = summary?.totalRequests ?? "0";
    final open = summary?.open ?? "0";
    final resolved = summary?.completed ?? "0";
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
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
                      "COMPLAINTS",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xff292832),
                        letterSpacing: -0.64,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      "PROPERTY COMPLAINTS & QUERIES",
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(index: 0, count: total, title: "Total"),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _summaryCard(index: 1, count: open, title: "Open"),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _summaryCard(
                      index: 2,
                      count: resolved,
                      title: "Resolved",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide(
                      color: Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  hintText: "Search documents...",
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(153, 42, 41, 51),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: Color.fromARGB(153, 42, 41, 51),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
              SizedBox(height: 20.h),
              _buildFilters(),
              SizedBox(height: 20.h),
              state.when(
                data: (complaintData) {
                  if (complaintData.data?.tickets == null ||
                      complaintData.data!.tickets!.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.only(top: 50.h),
                      child: Center(
                        child: Text(
                          "No Complaints found",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff8B8D8B),
                          ),
                        ),
                      ),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "My Complaints",
                            style: GoogleFonts.outfit(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF101C16),
                              letterSpacing: -0.3,
                            ),
                          ),

                          Text(
                            "${complaintData.data!.tickets!.length.toString().padLeft(2, '0')} Records",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF101C16),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 27.h),
                      Padding(
                        padding: EdgeInsets.only(bottom: 60.h),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: complaintData.data!.tickets!.length,
                          itemBuilder: (context, index) {
                            var model = complaintData.data!.tickets![index];
                            return _buildComplaintCard(
                              title: model.category ?? "",
                              complaintId: model.ticketNumber ?? "",
                              status: model.statusPill ?? "",
                              priority: model.priority ?? "",
                              date: model.requestedDate ?? "",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => ComplaintDetailScreen(
                                      complaintId: model.id.toString(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                error: (error, stackTrace) {
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
      floatingActionButton: SizedBox(
        height: 50.h,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => CreateComplaintScreen()),
            );
          },
          backgroundColor: const Color(0xFF101C16),
          foregroundColor: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.r),
          ),
          icon: Icon(Icons.add, size: 20.sp),
          label: Text(
            "New Complaint",
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _summaryCard({
    required int index,
    required String count,
    required String title,
  }) {
    final bool isSelected = selectedSummary == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSummary = index;
          selectedFilter = 0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF6C3) : const Color(0xFFEFEEE6),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Color(0xFF101C16), width: 1.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: GoogleFonts.outfit(
                fontSize: 17.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xFF101C16),
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(178, 42, 41, 51),
              ),
            ),
          ],
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

  Widget _buildComplaintCard({
    required String title,
    required String complaintId,
    required String status,
    required String priority,
    required String date,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: const Color(0xFF101C16), width: 1.w),
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 41.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    border: Border.all(color: Color(0xFF101C16), width: 1.w),
                  ),
                  child: Icon(
                    Icons.water_damage_outlined,
                    size: 17.sp,
                    color: const Color(0xFF3E443D),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF101C16),
                          letterSpacing: -0.3,
                        ),
                      ),

                      Text(
                        "Complaint ID · $complaintId",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(178, 42, 41, 51),
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 5.w),
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    size: 20.sp,
                    color: Color(0xFF292D32),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Divider(
              height: 1,
              thickness: 0.7,
              color: Color.fromARGB(102, 16, 28, 22),
            ),
            SizedBox(height: 15.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 13.w,
                    vertical: 4.5.h,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.r),
                    border: Border.all(
                      color: const Color(0xFF101C16),
                      width: 1.w,
                    ),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF101C16),
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "${priority} Priority",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF101C16),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(width: 5.w),
                Text(
                  date,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF101C16),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
