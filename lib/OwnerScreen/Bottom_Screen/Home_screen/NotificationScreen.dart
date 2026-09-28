import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/getNotificaionListProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getNotificaionListModel.dart'
    as notif_model;
import 'package:property_care/core/constant/appColor.dart';

class Notificationscreen extends ConsumerStatefulWidget {
  const Notificationscreen({super.key});

  @override
  ConsumerState<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends ConsumerState<Notificationscreen> {
  int selectedFilter = 0;

  final List<String> defaultFilters = [
    "All",
    "Maintenance",
    "Inspections",
    "Complaints",
    "Services",
  ];

  IconData _getNotificationIcon(String? iconType) {
    switch (iconType?.toLowerCase()) {
      case 'warning':
        return Icons.warning_amber_rounded;
      case 'check':
        return Icons.check;
      case 'alert':
        return Icons.notifications_active_outlined;
      case 'document':
        return Icons.description_outlined;
      case 'inspection':
        return Icons.fact_check_outlined;
      case 'service':
        return Icons.build_outlined;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final getNotificaionState = ref.watch(
      getNotificaionListProvider(defaultFilters[selectedFilter]),
    );

    final apiData = getNotificaionState.valueOrNull?.data;
    final header = apiData?.header;
    final filters = (apiData?.filters != null && apiData!.filters!.isNotEmpty)
        ? apiData.filters!
        : defaultFilters;

    final selectedFilterText = selectedFilter < filters.length
        ? filters[selectedFilter]
        : "All";

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
                    header?.title ?? "Notifications",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    header?.subtitle ?? "Stay updated with your property",
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            SizedBox(height: 16.h),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(filters.length, (index) {
                  final bool isSelected = selectedFilter == index;

                  return Padding(
                    padding: EdgeInsets.only(right: 10.w),
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
                            fontSize: 11.sp,
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
            SizedBox(height: 20.h),
            Expanded(
              child: getNotificaionState.when(
                data: (data) {
                  final resData = data.data;
                  final sections = resData?.sections ?? [];
                  final allNotifications = resData?.notifications ?? [];

                  bool matchesFilter(notif_model.Notification item) {
                    if (selectedFilterText.toLowerCase() == "all") return true;
                    final tag = item.tag?.toLowerCase() ?? "";
                    final type = item.type?.toLowerCase() ?? "";
                    final filter = selectedFilterText.toLowerCase();
                    return tag.contains(filter) ||
                        filter.contains(tag) ||
                        type.contains(filter) ||
                        filter.contains(type);
                  }

                  if (sections.isNotEmpty) {
                    final validSections = <Widget>[];

                    for (final section in sections) {
                      final filteredItems = (section.items ?? [])
                          .where(matchesFilter)
                          .toList();

                      if (filteredItems.isEmpty) continue;

                      validSections.add(
                        Padding(
                          padding: EdgeInsets.only(bottom: 14.h),
                          child: Row(
                            children: [
                              Text(
                                section.title ?? "Recent",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const Spacer(),
                              if (section.badge != null &&
                                  section.badge!.isNotEmpty)
                                Text(
                                  section.badge!,
                                  style: GoogleFonts.outfit(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.heading,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );

                      for (final item in filteredItems) {
                        validSections.add(_buildNotificationCard(item));
                      }

                      validSections.add(SizedBox(height: 10.h));
                    }

                    if (validSections.isEmpty) {
                      return Center(
                        child: Text(
                          "No notifications found",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            color: const Color.fromRGBO(42, 41, 51, 0.6),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.heading,
                      onRefresh: () async {
                        ref.invalidate(getNotificaionListProvider);
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: validSections,
                      ),
                    );
                  }

                  final filteredList = allNotifications
                      .where(matchesFilter)
                      .toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        "No notifications found",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          color: const Color.fromRGBO(42, 41, 51, 0.6),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.heading,
                    onRefresh: () async {
                      ref.invalidate(getNotificaionListProvider);
                    },
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(filteredList[index]);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 40.sp,
                          color: Colors.red,
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Failed to load notifications",
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.heading,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        ElevatedButton(
                          onPressed: () {
                            ref.invalidate(getNotificaionListProvider);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.heading,
                          ),
                          child: Text(
                            "Retry",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () {
                  return Center(
                    child: CircularProgressIndicator(color: AppColors.heading),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(notif_model.Notification item) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 12.h),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color(0xff101010), width: 1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff101010), width: 1.1),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Center(
              child: Icon(
                _getNotificationIcon(item.iconType),
                color: AppColors.heading,
                size: 18.sp,
              ),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      item.time ?? "",
                      style: GoogleFonts.outfit(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                Text(
                  item.message ?? "",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color.fromRGBO(0, 0, 0, 0.7),
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xff101010)),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Text(
                    item.tag ?? "General",
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff101010),
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/getNotificaionListProvider.dart';
// import 'package:property_care/core/constant/appColor.dart';

// class Notificationscreen extends ConsumerStatefulWidget {
//   const Notificationscreen({super.key});

//   @override
//   ConsumerState<Notificationscreen> createState() => _NotificationscreenState();
// }

// class _NotificationscreenState extends ConsumerState<Notificationscreen> {
//   int selectedFilter = 0;

//   final List<String> filters = [
//     "All",
//     "Maintenance",
//     "Inspections",
//     "Complaints",
//     "Services",
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final getNotificaionState = ref.watch(getNotificaionListProvider);
//     return Scaffold(
//       backgroundColor: AppColors.scaffoldBg,
//       appBar: AppBar(
//         backgroundColor: AppColors.scaffoldBg,
//         automaticallyImplyLeading: false,
//         titleSpacing: 20.w,
//         title: Align(
//           alignment: Alignment.centerLeft,
//           child: Row(
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   width: 41.w,
//                   height: 41.h,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: const Color.fromRGBO(16, 28, 22, 0.3),
//                     ),
//                     borderRadius: BorderRadius.circular(4.r),
//                   ),
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: const Color(0xff101C16),
//                     size: 16.sp,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Notifications",
//                     style: GoogleFonts.outfit(
//                       fontSize: 17.sp,
//                       fontWeight: FontWeight.w500,
//                       color: const Color(0xff292832),
//                       letterSpacing: -0.64,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     "Stay updated with your propertys",
//                     style: GoogleFonts.outfit(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w400,
//                       color: Color.fromRGBO(42, 41, 51, 0.6),
//                       letterSpacing: -0.24,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 20.w),
//         child: Column(
//           children: [
//             SizedBox(height: 16.h),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: List.generate(filters.length, (index) {
//                   final bool isSelected = selectedFilter == index;

//                   return Padding(
//                     padding: EdgeInsets.only(right: 10.w),
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           selectedFilter = index;
//                         });
//                       },
//                       child: AnimatedContainer(
//                         duration: const Duration(milliseconds: 200),
//                         // height: 27.h,
//                         padding: EdgeInsets.symmetric(
//                           vertical: 5.h,
//                           horizontal: 13.w,
//                         ),
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? const Color(0xff101C16)
//                               : Colors.transparent,
//                           borderRadius: BorderRadius.circular(40.r),
//                           border: Border.all(
//                             color: const Color(0xff101C16),
//                             width: 1,
//                           ),
//                         ),
//                         alignment: Alignment.center,
//                         child: Text(
//                           filters[index],
//                           style: GoogleFonts.outfit(
//                             fontSize: 11.sp,
//                             fontWeight: FontWeight.w500,
//                             color: isSelected
//                                 ? Colors.white
//                                 : const Color(0xff101C16),
//                             letterSpacing: -0.3,
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ),
//             ),
//             SizedBox(height: 20.h),
//             Row(
//               children: [
//                 Text(
//                   "Today",
//                   style: GoogleFonts.outfit(
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.heading,
//                     letterSpacing: -0.2,
//                   ),
//                 ),
//                 Spacer(),
//                 Text(
//                   "3 New",
//                   style: GoogleFonts.outfit(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w500,
//                     color: AppColors.heading,
//                     letterSpacing: -0.2,
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 18.h),
//             ListView.builder(
//               itemCount: 3,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 return Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 13.w,
//                     vertical: 12.h,
//                   ),
//                   margin: EdgeInsets.only(bottom: 16.h),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: const Color(0xff101010)),
//                     borderRadius: BorderRadius.circular(8.r),
//                   ),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         width: 42.w,
//                         height: 42.h,
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: const Color(0xff101010),
//                             width: 1.1,
//                           ),
//                           borderRadius: BorderRadius.circular(4.r),
//                         ),
//                         child: Center(
//                           child: Icon(
//                             Icons.check,
//                             color: AppColors.heading,
//                             size: 16.sp,
//                           ),
//                         ),
//                       ),

//                       SizedBox(width: 20.w),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     "Maintenance Payment Reminder",
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 17.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.heading,
//                                       letterSpacing: -0.3,
//                                     ),
//                                   ),
//                                 ),

//                                 SizedBox(width: 8.w),

//                                 Text(
//                                   "09:45 AM",
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 11.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: AppColors.heading,
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             SizedBox(height: 5.h),
//                             Text(
//                               "Your monthly maintenance charge is pending. Please contact the administration for payment details.",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: GoogleFonts.outfit(
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.w400,
//                                 color: const Color.fromRGBO(0, 0, 0, 0.7),
//                                 letterSpacing: -0.2,
//                               ),
//                             ),

//                             SizedBox(height: 5.h),

//                             Container(
//                               height: 23.h,
//                               width: 106.w,
//                               decoration: BoxDecoration(
//                                 border: Border.all(
//                                   color: const Color(0xff101010),
//                                 ),
//                                 borderRadius: BorderRadius.circular(25.r),
//                               ),
//                               alignment: Alignment.center,
//                               child: Text(
//                                 "Maintenance",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 12.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: const Color(0xff101010),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
