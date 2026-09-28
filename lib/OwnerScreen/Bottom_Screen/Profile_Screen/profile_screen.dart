import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:property_care/OwnerScreen/Audit_Report/AuditReprot_Screen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/NotificationScreen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Profile_Screen/ChagenPasswordScreen.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Profile_Screen/EditProfileScreen.dart';
import 'package:property_care/OwnerScreen/MaintenanceHistory_Screen/MaintenanceHistory_Screen.dart';
import 'package:property_care/OwnerScreen/Tenant_Management_Screen/TenantManagement_Screen.dart';
import 'package:property_care/OwnerScreen/login_screen.dart';
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/OwnerScreen/inspectionReport/inspectionReportScreen.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:svg_flutter/svg.dart';

import 'package:property_care/core/AuthService/AuthServiceProvider.dart';
import 'Provider/getProfileProvider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final getProfileState = ref.watch(getProfileProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.scaffoldBg,
        titleSpacing: 20.w,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MY PROFILE",
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xff292832),
                    letterSpacing: -0.64,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Manage your personal information",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
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
      body: getProfileState.when(
        data: (data) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 22.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.4),
                      border: Border.all(color: Color(0xFF101C16), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blueGrey.shade100,
                          ),
                          child: ClipOval(
                            child: Image.network(
                              data.data?.avatarUrl ?? "",
                              width: 70.r,
                              height: 70.r,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 70.r,
                                  height: 70.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF101C16),
                                      width: 1.w,
                                    ),
                                  ),
                                  child: Icon(Icons.person, size: 30.sp),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          data.data?.name ?? "MD Sajiv",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          data.data?.email ?? "sajiv@gmail.com",
                          style: GoogleFonts.outfit(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 23.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: Color(0xFF000000),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            data.data?.role == "property_owner"
                                ? "Property Owner"
                                : "",
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 27.h),
                  Text(
                    "Personal Information",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF000000),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      children: [
                        _documentRow(
                          title: "Full Name",
                          value: data.data?.name ?? "Md Sajiv",
                        ),
                        _documentRow(
                          title: "Email Address",
                          value: data.data?.email ?? "sajiv@gmail.com",
                        ),
                        _documentRow(
                          title: "Phone Number",
                          value: data.data?.phone ?? "+91 98XXXXXX42",
                        ),
                        _documentRow(
                          title: "Account Type",
                          value: data.data?.role == "property_owner"
                              ? "Property Owner"
                              : "",
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 27.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 13.w,
                      vertical: 15.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Color(0xFF000000),
                                  width: 1.w,
                                ),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/SvgImage/proAparment.svg",
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // "Apartment A-204",
                                  data
                                          .data
                                          ?.activeProperty
                                          ?.propertyNameNumber ??
                                      "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF101C16),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                Text(
                                  // "Green Valley Residency",
                                  data.data?.activeProperty?.complexName ?? "",
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF000000),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Text(
                              data.data?.subscriptionStatus ?? "Active",
                              style: GoogleFonts.outfit(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFFAE8130),
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Property Type",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Property Type",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                // "Apartment",
                                data.data?.activeProperty?.propertyType ?? "",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                // "A-204",
                                data.data?.activeProperty?.propertyNameNumber ??
                                    "",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "FLOOR",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                "Ownership",
                                style: GoogleFonts.outfit(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "2nd Floor",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                data.data?.activeProperty?.ownership ?? "Owner",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Text(
                    "Account Settings",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 11.h),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.h),
                        _accountSettingTab(
                          image: "assets/SvgImage/addicon.svg",
                          name: "Tenant Management",
                          title: "Add or manage your tenant",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => TenantmanagementScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/editicon.svg",
                          name: "Edit Profile",
                          title: "Update your personal information",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Editprofilescreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/lock.svg",
                          name: "Security & Password",
                          title: "Manage password and account security",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => ChagenPasswordScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/inspection.svg",
                          name: "Inspection Reports",
                          title: "Property inspection history",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const InspectionReportScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/audit.svg",
                          name: "Audit Reports",
                          title: "Audit Reports history",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => AuditreprotScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/history.svg",
                          name: "Maintenance History",
                          title: "Audit Reports history",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    MaintenancehistoryScreen(),
                              ),
                            );
                          },
                        ),
                        Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
                        _accountSettingTab(
                          image: "assets/SvgImage/notifi.svg",
                          name: "Notifications",
                          title: "Manage property notification preferences",
                          callback: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Notificationscreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap: () {
                      _showLogoutDialog(context);
                    },
                    child: Container(
                      width: double.infinity,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.logout_rounded,
                              color: Colors.red,
                              size: 22.sp,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              "Logout Account",
                              style: GoogleFonts.outfit(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text("Something went wrong"));
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.background,
              surfaceTintColor: Colors.transparent,
              contentPadding: EdgeInsets.all(24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: Colors.red,
                      size: 36.sp,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Logout",
                    style: GoogleFonts.outfit(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.heading,
                      letterSpacing: -0.54,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Are you sure you want to log out from this account?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      color: Color.fromRGBO(41, 42, 51, 0.6),
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            side: BorderSide(color: AppColors.heading),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: GoogleFonts.outfit(
                              color: AppColors.heading,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () async {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    final service = ref.read(
                                      authServiceProvider,
                                    );
                                    final respos = await service.logout();
                                    if (context.mounted) {
                                      var box = Hive.box("userdata");
                                      await box.delete("token");
                                      showSuccessSnackBar(
                                        respos.message ??
                                            "Successfully logged out",
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      var box = Hive.box("userdata");
                                      await box.delete("token");
                                      showSuccessSnackBar(
                                        "Successfully logged out",
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                        (route) => false,
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: isLoading
                              ? SizedBox(
                                  height: 20.h,
                                  width: 20.w,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Text(
                                  "Logout",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _documentRow({
    required String title,
    required String value,
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
                fontSize: 14.sp,
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

  Widget _accountSettingTab({
    required String image,
    required String name,
    required String title,
    required VoidCallback callback,
  }) {
    return InkWell(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.only(
          left: 13.w,
          right: 13.w,
          top: 10.h,
          bottom: 8.h,
        ),
        child: Row(
          children: [
            Container(
              width: 37.w,
              height: 37.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3.r),
                border: Border.all(color: Color(0xFF000000), width: 1.w),
              ),
              child: Center(child: SvgPicture.asset(image)),
            ),
            SizedBox(width: 11.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF000000),
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(0, 0, 0, 0.7),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF2A2933),
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }
}
