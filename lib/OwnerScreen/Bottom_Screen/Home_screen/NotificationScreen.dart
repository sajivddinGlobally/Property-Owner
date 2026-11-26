import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/getNotificaionListProvider.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/markReadNotificatonProvider.dart';
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
  final Set<String> _markedIds = {};

  void _markUnreadNotifications(List<String> ids) {
    final unreadToMark = ids.where((id) => !_markedIds.contains(id)).toList();
    if (unreadToMark.isEmpty) return;
    _markedIds.addAll(unreadToMark);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(markMultipleNotificationsReadProvider(unreadToMark).future)
          .then((res) {
            log(
              "Marked notifications as read: $unreadToMark, status: ${res?.status}, message: ${res?.message}",
            );
          })
          .catchError((err) {
            log("Error marking notifications as read: $err");
          });
    });
  }

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
      case 'emergency':
        return Icons.error_outline_rounded;
      case 'user':
        return Icons.person_outline_rounded;
      case 'parcel':
        return Icons.inventory_2_outlined;
      case 'info':
        return Icons.info_outline_rounded;
      default:
        return Icons.notifications_none_outlined;
    }
  }

  /// Har notification ka rang (type / title se): dues & alerts laal / peela,
  /// inspection neela, service hara, document baingani, baaki brand gold
  Color _accentFor(notif_model.Notification item) {
    final icon = (item.iconType ?? '').toLowerCase();
    final type = (item.type ?? '').toLowerCase();
    final text = '${item.title ?? ''} ${item.tag ?? ''}'.toLowerCase();
    if (icon == 'emergency' ||
        text.contains('defaulter') ||
        text.contains('overdue') ||
        text.contains('urgent')) {
      return const Color(0xFFD93025);
    }
    if (icon == 'warning' ||
        type.contains('payment') ||
        type.contains('maintenance') ||
        text.contains('due') ||
        text.contains('rent') ||
        text.contains('bill')) {
      return const Color(0xFFE08A00);
    }
    if (icon == 'alert' ||
        type.contains('complaint') ||
        text.contains('complaint')) {
      return const Color(0xFFE8590C);
    }
    if (type.contains('inspection') ||
        text.contains('inspection') ||
        text.contains('audit')) {
      return const Color(0xFF1C64F2);
    }
    if (type.contains('service') ||
        text.contains('service') ||
        icon == 'check') {
      return const Color(0xFF16A34A);
    }
    if (icon == 'document' || type.contains('document')) {
      return const Color(0xFF7C3AED);
    }
    return AppColors.accentGold;
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
                    header?.title ?? "Notifications",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    header?.subtitle ?? "Stay updated with your property",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
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
                            fontSize: 13.sp,
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

                  final unreadIds = <String>[];
                  if (sections.isNotEmpty) {
                    for (final section in sections) {
                      for (final item in section.items ?? []) {
                        if (item.id != null && item.isRead == false) {
                          unreadIds.add(item.id.toString());
                        }
                      }
                    }
                  } else if (allNotifications.isNotEmpty) {
                    for (final item in allNotifications) {
                      if (item.id != null && item.isRead == false) {
                        unreadIds.add(item.id.toString());
                      }
                    }
                  }

                  if (unreadIds.isNotEmpty) {
                    _markUnreadNotifications(unreadIds);
                  }

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
                                  fontSize: 16.sp,
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
                                    fontSize: 14.sp,
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
                            fontSize: 16.sp,
                            color: const Color.fromRGBO(42, 41, 51, 0.6),
                          ),
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.heading,
                      onRefresh: () async {
                        _markedIds.clear();
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
                          fontSize: 16.sp,
                          color: const Color.fromRGBO(42, 41, 51, 0.6),
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.heading,
                    onRefresh: () async {
                      _markedIds.clear();
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
                            fontSize: 17.sp,
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
                              fontSize: 15.sp,
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
    final accent = _accentFor(item);
    final unread = item.isRead == false;
    return GestureDetector(
      onTap: () {
        if (item.id != null && item.isRead == false) {
          _markUnreadNotifications([item.id.toString()]);
          setState(() {
            item.isRead = true;
          });
        }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 14.h),
        decoration: BoxDecoration(
          color: unread ? accent.withOpacity(0.07) : Colors.white,
          border: Border.all(
            color: unread ? accent.withOpacity(0.55) : const Color(0xFFE3E1D6),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 4.w, color: accent),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42.w,
                          height: 42.w,
                          decoration: BoxDecoration(
                            color: accent.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Center(
                            child: Icon(
                              _getNotificationIcon(item.iconType),
                              color: accent,
                              size: 21.sp,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
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
                                      style: GoogleFonts.outfit(
                                        fontSize: 17.sp,
                                        fontWeight: unread
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                        color: AppColors.heading,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        item.time ?? "",
                                        style: GoogleFonts.outfit(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      if (unread) ...[
                                        SizedBox(height: 6.h),
                                        Container(
                                          width: 9.w,
                                          height: 9.w,
                                          decoration: BoxDecoration(
                                            color: accent,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                item.message ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(0, 0, 0, 0.72),
                                  letterSpacing: -0.2,
                                  height: 1.3,
                                ),
                              ),
                              SizedBox(height: 9.h),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: accent.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                child: Text(
                                  item.tag ?? "General",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: accent,
                                    letterSpacing: -0.1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
