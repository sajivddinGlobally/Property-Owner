import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/getPropertyListProvider.dart';
import 'package:property_care/OwnerScreen/Tenant_Management_Screen/Add_Tenant_Screen.dart';
import 'package:property_care/OwnerScreen/Tenant_Management_Screen/Tenant_Details_Screen.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getTenantListModel.dart';
import 'package:property_care/core/Data/Model/ResponseModel/propertyListModel.dart';
import 'package:property_care/core/constant/appColor.dart';

import 'Provider/getTenantListProvider.dart';

class TenantmanagementScreen extends ConsumerStatefulWidget {
  const TenantmanagementScreen({super.key});

  @override
  ConsumerState<TenantmanagementScreen> createState() =>
      _TenantmanagementScreenState();
}

class _TenantmanagementScreenState
    extends ConsumerState<TenantmanagementScreen> {
  @override
  Widget build(BuildContext context) {
    final getTenantListState = ref.watch(getTenantListProvider);
    final propertyListState = ref.watch(getPropertyListProvider);

    final activeProperty = propertyListState.valueOrNull?.data?.firstWhere(
      (p) => p.isSelected == true || p.status?.toLowerCase() == "active",
      orElse: () => propertyListState.valueOrNull?.data?.isNotEmpty == true
          ? propertyListState.valueOrNull!.data!.first
          : Datum(
              id: 18,
              propertyNameNumber: "Villa A-104",
              complexName: "Grand Horizon Towers & Villas",
            ),
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
                    "Tenant Management",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Manage tenants for your property",
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
      body: getTenantListState.when(
        data: (tenantData) {
          final tenants = tenantData.data?.tenants ?? [];
          final totalActive = tenantData.data?.totalActive ?? tenants.length;
          final firstTenant = tenants.isNotEmpty ? tenants.first : null;

          final propName =
              activeProperty?.propertyNameNumber ??
              firstTenant?.propertyNameNumber ??
              "Villa A-104";
          final compName =
              activeProperty?.complexName ??
              firstTenant?.complexName ??
              "Grand Horizon Towers & Villas";

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 18.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: AppColors.heading),
                          ),
                          child: Center(
                            child: Image.asset(
                              "assets/auditImg.png",
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Property",
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.5),
                                  fontSize: 13.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                propName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  fontSize: 17.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              Text(
                                compName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(42, 41, 51, 0.5),
                                  fontSize: 13.sp,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          "Owner",
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            color: const Color(0xffAE8130),
                            fontSize: 16.sp,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Row(
                    children: [
                      Text(
                        "Current Tenant",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 17.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "$totalActive Active",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                          fontSize: 17.sp,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  if (tenants.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.heading,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 40.sp,
                            color: AppColors.heading,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "No Tenants Added Yet",
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.heading,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Tap below to add a new tenant for this property.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.outfit(
                              fontSize: 13.sp,
                              color: const Color.fromRGBO(42, 41, 51, 0.6),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: tenants.length,
                      itemBuilder: (context, index) {
                        final tenant = tenants[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTenantCard(tenant, propName),
                              SizedBox(height: 10.h),
                              Container(
                                margin: EdgeInsets.only(top: 10.h),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15.w,
                                  vertical: 11.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.heading),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Current Rent Status",
                                          style: GoogleFonts.outfit(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.heading,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          firstTenant?.rentPaymentStatus ??
                                              "Paid",
                                          style: GoogleFonts.outfit(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                (firstTenant?.rentPaymentStatus
                                                        ?.toLowerCase() ==
                                                    "paid")
                                                ? const Color(0xFF24B56B)
                                                : AppColors.heading,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16.h),
                                    Row(
                                      children: [
                                        Text(
                                          "Monthly Rent",
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
                                              42,
                                              41,
                                              51,
                                              0.6,
                                            ),
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          "Last Payment",
                                          style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromRGBO(
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
                                    SizedBox(height: 5.h),
                                    Row(
                                      children: [
                                        Text(
                                          firstTenant?.monthlyRent != null
                                              ? "₹${firstTenant!.monthlyRent}"
                                              : "₹0",
                                          style: GoogleFonts.outfit(
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.heading,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          firstTenant?.lastPaymentDate ??
                                              "Not Available",
                                          style: GoogleFonts.outfit(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.heading,
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 15.h),
                  SizedBox(
                    width: double.infinity,
                    height: 36.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.heading,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => AddTenantScreen(
                              propertyId: activeProperty?.id,
                              propertyName: propName,
                              complexName: compName,
                            ),
                          ),
                        );
                        ref.invalidate(getTenantListProvider);
                      },
                      child: Text(
                        "+ Add New Tenant",
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
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
          log(error.toString());
          log(stackTrace.toString());
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Failed to load tenant details",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.heading,
                    ),
                    onPressed: () => ref.invalidate(getTenantListProvider),
                    child: const Text(
                      "Retry",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
      ),
    );
  }

  Widget _buildTenantCard(Tenant tenant, String defaultPropName) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading, width: 1.2),
        borderRadius: BorderRadius.circular(13.r),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      (tenant.imageUrl != null &&
                          tenant.imageUrl!.trim().isNotEmpty)
                      ? Image.network(
                          tenant.imageUrl!.trim(),
                          width: 51.w,
                          height: 51.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 51.w,
                                height: 51.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.heading,
                                    width: 1.w,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 20.w,
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
                              width: 1.w,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 20.w,
                              color: AppColors.heading,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 13.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tenant.name ?? "Tenant",
                      style: GoogleFonts.outfit(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      "Tenant • ${tenant.propertyNameNumber ?? defaultPropName}",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 22.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.heading, width: 1),
                  borderRadius: BorderRadius.circular(50.r),
                ),
                child: Text(
                  tenant.status ?? "Active",
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
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
                  title: "Mobile Number",
                  value: tenant.phone?.isNotEmpty == true
                      ? tenant.phone!
                      : "N/A",
                ),
              ),
              Expanded(
                child: _detailItem(
                  title: "Move-in Date",
                  value: tenant.moveInDate?.isNotEmpty == true
                      ? tenant.moveInDate!
                      : "N/A",
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
                  title: "Monthly Rent",
                  value: tenant.monthlyRent != null
                      ? "₹${tenant.monthlyRent}"
                      : "₹0",
                ),
              ),
              Expanded(
                child: _detailItem(
                  title: "Move-out Date",
                  value: tenant.moveOutDate?.isNotEmpty == true
                      ? tenant.moveOutDate!
                      : "Not Set",
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) =>
                            TenantDetailsScreen(tenantId: tenant.id.toString()),
                      ),
                    );
                  },
                  child: Container(
                    height: 35.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.heading,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                    child: Text(
                      "View Tenant Details",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) =>
                          AddTenantScreen(tenantId: tenant.id.toString()),
                    ),
                  );
                },
                child: Container(
                  width: 36.w,
                  height: 34.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFCEF),
                    border: Border.all(color: AppColors.heading, width: 1.2),
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  child: Icon(
                    Icons.edit_outlined,
                    size: 16.sp,
                    color: AppColors.heading,
                  ),
                ),
              ),
            ],
          ),
        ],
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
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: const Color.fromRGBO(42, 41, 51, 0.6),
            letterSpacing: -0.2,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.heading,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
