// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:property_care/OwnerScreen/RentPaymentStatusScreen/RentPaymentStatus_Screen.dart';
// import 'package:property_care/OwnerScreen/UtilityPaymentStatusScreen/UtilityPayment_Status.dart';
// import 'package:property_care/core/constant/appColor.dart';
// import 'package:property_care/core/Utils/property_type_helper.dart';
// import 'package:svg_flutter/svg.dart';
// import 'Provider/getTenantDetailsProvider.dart';
// import 'Provider/getTenantListProvider.dart';
// import 'widget/TenantAvatar.dart';

// class TenantDetailsScreen extends ConsumerStatefulWidget {
//   final String tenantId;
//   const TenantDetailsScreen({super.key, required this.tenantId});

//   @override
//   ConsumerState<TenantDetailsScreen> createState() =>
//       _TenantDetailsScreenState();
// }

// class _TenantDetailsScreenState extends ConsumerState<TenantDetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final tenantDetailState = ref.watch(
//       getTenantDetailsProvider(widget.tenantId),
//     );
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
//                   width: 44.w,
//                   height: 44.h,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: const Color.fromRGBO(16, 28, 22, 0.3),
//                     ),
//                     borderRadius: BorderRadius.circular(6.r),
//                   ),
//                   child: Icon(
//                     Icons.arrow_back,
//                     color: const Color(0xff101C16),
//                     size: 20.sp,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 10.w),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "TENANT DETAILS",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.heading,
//                       letterSpacing: -0.3,
//                     ),
//                   ),
//                   SizedBox(height: 2.h),
//                   Text(
//                     "View tenant and occupancy information",
//                     style: GoogleFonts.outfit(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w400,
//                       color: const Color.fromRGBO(42, 41, 51, 0.7),
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       body: tenantDetailState.when(
//         data: (tenantDetailsData) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(vertical: 20.h),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: Color(0xFF101C16), width: 1.w),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         TenantAvatar(
//                           name:
//                               tenantDetailsData.data?.tenantDetails?.name ??
//                               tenantDetailsData.data?.tenantDetails?.tenantName,
//                           imageUrl:
//                               tenantDetailsData.data?.tenantDetails?.imageUrl,
//                           size: 70.r,
//                         ),
//                         SizedBox(height: 6.h),
//                         Text(
//                           // "Arjun Kapoor",
//                           tenantDetailsData.data?.tenantDetails?.name ?? "N/A",
//                           style: GoogleFonts.outfit(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w700,
//                             color: Color(0xFF000000),
//                             letterSpacing: -0.3,
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                         Text(
//                           tenantDetailsData.data?.tenantDetails?.tenantType ??
//                               "Primary Tenant",
//                           style: GoogleFonts.outfit(
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xFF000000),
//                             letterSpacing: -0.3,
//                           ),
//                         ),
//                         SizedBox(height: 10.h),
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                             horizontal: 21.w,
//                             vertical: 4.h,
//                           ),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(50.r),
//                             border: Border.all(
//                               color: Color(0xFF000000),
//                               width: 1.w,
//                             ),
//                           ),
//                           child: Text(
//                             "${tenantDetailsData.data?.tenantDetails?.tenantStatus ?? ""} Tenant",
//                             style: GoogleFonts.outfit(
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w500,
//                               color: Color(0xFF000000),
//                               letterSpacing: -0.3,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Tenant Information",
//                     style: GoogleFonts.outfit(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 18.sp,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.heading),
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Column(
//                       children: [
//                         _documentRow(
//                           title: "Full Name",
//                           value:
//                               tenantDetailsData.data?.tenantDetails?.name ??
//                               "Arjun Kapoor",
//                         ),
//                         _documentRow(
//                           title: "Tenant Type",
//                           value:
//                               tenantDetailsData
//                                   .data
//                                   ?.tenantDetails
//                                   ?.tenantType ??
//                               "Primary Tenant",
//                         ),
//                         _documentRow(
//                           title: "Move-in Date",
//                           value:
//                               tenantDetailsData
//                                   .data
//                                   ?.tenantDetails
//                                   ?.moveInDate ??
//                               "N/A",
//                         ),
//                         _documentRow(
//                           title: "Occupancy Status",
//                           value:
//                               tenantDetailsData
//                                   .data
//                                   ?.tenantDetails
//                                   ?.occupancyStatus ??
//                               "Currently Occupied",
//                           showBottomBorder: false,
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Property Details",
//                     style: GoogleFonts.outfit(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 18.sp,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 13.w,
//                       vertical: 15.h,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.heading),
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 40.w,
//                               height: 40.h,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8.r),
//                                 border: Border.all(
//                                   color: Color(0xFF000000),
//                                   width: 1.w,
//                                 ),
//                               ),
//                               child: Center(
//                                 child: SvgPicture.asset(
//                                   "assets/SvgImage/proAparment.svg",
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10.w),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   tenantDetailsData
//                                           .data
//                                           ?.propertyDetails
//                                           ?.apartmentNo ??
//                                       "Community Care A-204",
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 18.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFF101C16),
//                                     letterSpacing: -0.2,
//                                   ),
//                                 ),
//                                 Text(
//                                   tenantDetailsData
//                                           .data
//                                           ?.propertyDetails
//                                           ?.complexName ??
//                                       "Green Valley Residency",
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: Color(0xFF000000),
//                                     letterSpacing: -0.2,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8.h),
//                         Divider(color: Color.fromRGBO(42, 41, 51, 0.6)),
//                         SizedBox(height: 6.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 "Property Type",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color.fromRGBO(42, 41, 51, 0.6),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 "Property Type",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color.fromRGBO(42, 41, 51, 0.6),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 _formatPropertyType(
//                                   tenantDetailsData
//                                       .data
//                                       ?.propertyDetails
//                                       ?.propertyType,
//                                 ),
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xFF101C16),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 tenantDetailsData
//                                         .data
//                                         ?.propertyDetails
//                                         ?.apartmentNo ??
//                                     "A-204",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xFF101C16),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 8.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 "FLOOR",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color.fromRGBO(42, 41, 51, 0.6),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),

//                             Expanded(
//                               child: Text(
//                                 "Ownership",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color.fromRGBO(42, 41, 51, 0.6),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4.h),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 tenantDetailsData
//                                         .data
//                                         ?.propertyDetails
//                                         ?.floor ??
//                                     "2nd Floor",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xFF101C16),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: Text(
//                                 tenantDetailsData
//                                         .data
//                                         ?.propertyDetails
//                                         ?.occupancy ??
//                                     "Tenant",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: Color(0xFF101C16),
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Container(
//                     width: double.infinity,
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 16.w,
//                       vertical: 10.h,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.heading, width: 1),
//                       borderRadius: BorderRadius.circular(9.r),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               height: 40.h,
//                               width: 40.w,
//                               decoration: BoxDecoration(
//                                 border: Border.all(color: AppColors.heading),
//                                 borderRadius: BorderRadius.circular(5.r),
//                               ),
//                               alignment: Alignment.center,
//                               child: Icon(
//                                 Icons.receipt_long_outlined,
//                                 size: 19.sp,
//                                 color: AppColors.heading,
//                               ),
//                             ),

//                             SizedBox(width: 10.w),

//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     "Utility Payment Status",
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 18.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: const Color(0xFF101C16),
//                                     ),
//                                   ),
//                                   Text(
//                                     "Current utility payment overview",
//                                     style: GoogleFonts.outfit(
//                                       fontSize: 17.sp,
//                                       fontWeight: FontWeight.w500,
//                                       color: AppColors.heading,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             InkWell(
//                               onTap: () {
//                                 final tid =
//                                     tenantDetailsData.data?.tenantDetails?.id
//                                         ?.toString() ??
//                                     widget.tenantId;
//                                 Navigator.push(
//                                   context,
//                                   CupertinoPageRoute(
//                                     builder: (context) =>
//                                         RentpaymentstatusScreen(id: tid),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 padding: EdgeInsets.symmetric(
//                                   horizontal: 13.w,
//                                   vertical: 4.h,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: const Color(
//                                     0xFF101C16,
//                                   ).withOpacity(0.06),
//                                   border: Border.all(color: AppColors.heading),
//                                   borderRadius: BorderRadius.circular(20.r),
//                                 ),
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     Text(
//                                       tenantDetailsData
//                                               .data
//                                               ?.tenantDetails
//                                               ?.rentPaymentStatus ??
//                                           "Paid",
//                                       style: GoogleFonts.outfit(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w500,
//                                         color: const Color(0xFF101C16),
//                                       ),
//                                     ),
//                                     SizedBox(width: 4.w),
//                                     Icon(
//                                       Icons.arrow_forward_ios,
//                                       size: 11.sp,
//                                       color: const Color(0xFF101C16),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),

//                         SizedBox(height: 10.h),
//                         Divider(
//                           height: 1,
//                           thickness: 1,
//                           color: const Color(0xFF999999),
//                         ),
//                         SizedBox(height: 8.h),

//                         _utilityRow(
//                           icon: Icons.bolt,
//                           title: "Electricity",
//                           status:
//                               tenantDetailsData
//                                   .data
//                                   ?.utilitiesPaymentStatus
//                                   ?.electricity
//                                   ?.status ??
//                               "Paid",
//                           amount:
//                               "₹${tenantDetailsData.data?.utilitiesPaymentStatus?.electricity?.lastPaidAmount ?? "0"}",
//                         ),
//                         _utilityRow(
//                           icon: Icons.water_drop_outlined,
//                           title: "Water",
//                           status:
//                               tenantDetailsData
//                                   .data
//                                   ?.utilitiesPaymentStatus
//                                   ?.water
//                                   ?.status ??
//                               "Paid",
//                           amount:
//                               "₹${tenantDetailsData.data?.utilitiesPaymentStatus?.water?.lastPaidAmount ?? "0"}",
//                         ),
//                         _utilityRow(
//                           icon: Icons.local_fire_department_outlined,
//                           title: "Gas",
//                           status:
//                               tenantDetailsData
//                                   .data
//                                   ?.utilitiesPaymentStatus
//                                   ?.gas
//                                   ?.status ??
//                               "Unpaid",
//                           amount:
//                               "₹${tenantDetailsData.data?.utilitiesPaymentStatus?.gas?.lastPaidAmount ?? "0"}",
//                         ),

//                         SizedBox(height: 7.h),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Total Outstanding",
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 17.sp,
//                                     color: Color.fromRGBO(42, 41, 51, 0.6),
//                                   ),
//                                 ),
//                                 Text(
//                                   "₹${"${tenantDetailsData.data?.utilitiesPaymentStatus?.totalOutstanding}"}",
//                                   style: GoogleFonts.outfit(
//                                     fontSize: 17.sp,
//                                     fontWeight: FontWeight.w500,
//                                     color: const Color(0xFF101C16),
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             InkWell(
//                               onTap: () {
//                                 final tid =
//                                     tenantDetailsData.data?.tenantDetails?.id
//                                         ?.toString() ??
//                                     widget.tenantId;
//                                 Navigator.push(
//                                   context,
//                                   CupertinoPageRoute(
//                                     builder: (context) =>
//                                         UtilitypaymentStatus(id: tid),
//                                   ),
//                                 );
//                               },
//                               child: Text(
//                                 "View Details →",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 17.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: const Color(0xFF101C16),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Contact Information",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xFF101C16),
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Container(
//                           padding: EdgeInsets.all(16.w),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: AppColors.heading),
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: 32.w,
//                                 height: 32.h,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(
//                                     color: AppColors.heading,
//                                     width: 1.2,
//                                   ),
//                                   borderRadius: BorderRadius.circular(4.r),
//                                 ),
//                                 child: Icon(
//                                   Icons.phone_outlined,
//                                   color: AppColors.heading,
//                                   size: 16.sp,
//                                 ),
//                               ),

//                               SizedBox(height: 8.h),

//                               Text(
//                                 "Phone",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 17.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.heading,
//                                 ),
//                               ),

//                               SizedBox(height: 8.h),
//                               Text(
//                                 "${tenantDetailsData.data?.tenantDetails?.phone}",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.heading,
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),

//                       SizedBox(width: 20.w),
//                       Expanded(
//                         child: Container(
//                           padding: EdgeInsets.all(16.w),
//                           decoration: BoxDecoration(
//                             border: Border.all(color: AppColors.heading),
//                             borderRadius: BorderRadius.circular(12.r),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 width: 32.w,
//                                 height: 32.h,
//                                 decoration: BoxDecoration(
//                                   border: Border.all(color: AppColors.heading),
//                                   borderRadius: BorderRadius.circular(4.r),
//                                 ),
//                                 child: Icon(
//                                   Icons.mail_outline,
//                                   color: AppColors.heading,
//                                   size: 16.sp,
//                                 ),
//                               ),

//                               SizedBox(height: 8.h),

//                               Text(
//                                 "Email",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 17.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.heading,
//                                 ),
//                               ),
//                               SizedBox(height: 8.h),
//                               Text(
//                                 tenantDetailsData.data?.tenantDetails?.email ??
//                                     "N/A",
//                                 style: GoogleFonts.outfit(
//                                   fontSize: 18.sp,
//                                   fontWeight: FontWeight.w500,
//                                   color: AppColors.heading,
//                                   letterSpacing: -0.2,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16.h),
//                   Text(
//                     "Additional Information",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       fontWeight: FontWeight.w500,
//                       color: AppColors.heading,
//                       letterSpacing: -0.2,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   Container(
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: AppColors.heading),
//                       borderRadius: BorderRadius.circular(10.r),
//                     ),
//                     child: Text(
//                       "Tenant information is maintained for property management and relevant property-related communication.",
//                       style: GoogleFonts.outfit(
//                         fontSize: 15.sp,
//                         fontWeight: FontWeight.w500,
//                         color: AppColors.heading,
//                         letterSpacing: -0.2,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30.h),
//                 ],
//               ),
//             ),
//           );
//         },
//         error: (error, stackTrace) {
//           log(error.toString());
//           log(stackTrace.toString());

//           return Center(
//             child: Padding(
//               padding: EdgeInsets.all(20.w),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Failed to load tenant details/n ${error.toString()}",
//                     style: GoogleFonts.outfit(
//                       fontSize: 18.sp,
//                       color: AppColors.heading,
//                     ),
//                   ),
//                   SizedBox(height: 10.h),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.heading,
//                     ),
//                     onPressed: () => ref.invalidate(getTenantListProvider),
//                     child: const Text(
//                       "Retry",
//                       style: TextStyle(color: Colors.white),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//         loading: () =>
//             Center(child: CircularProgressIndicator(color: AppColors.heading)),
//       ),
//     );
//   }

//   Widget _documentRow({
//     required String title,
//     required String value,
//     bool showBottomBorder = true,
//   }) {
//     return SizedBox(
//       height: 50.h,
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 15.w),
//               decoration: BoxDecoration(
//                 border: showBottomBorder
//                     ? const Border(
//                         bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
//                       )
//                     : null,
//               ),
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 title,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: GoogleFonts.outfit(
//                   fontSize: 15.sp,
//                   fontWeight: FontWeight.w500,
//                   color: Color.fromRGBO(42, 41, 51, 0.6),
//                   letterSpacing: -0.24,
//                 ),
//               ),
//             ),
//           ),
//           Container(
//             height: double.infinity,
//             padding: EdgeInsets.symmetric(horizontal: 16.w),
//             decoration: BoxDecoration(
//               border: showBottomBorder
//                   ? const Border(
//                       bottom: BorderSide(color: Color(0xFFC8C8C1), width: 1),
//                     )
//                   : null,
//             ),
//             alignment: Alignment.centerRight,
//             child: Text(
//               value,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.right,
//               style: GoogleFonts.outfit(
//                 fontSize: 17.sp,
//                 fontWeight: FontWeight.w700,
//                 color: AppColors.heading,
//                 letterSpacing: -0.24,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _utilityRow({
//     required IconData icon,
//     required String title,
//     required String status,
//     required String amount,
//   }) {
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 5.h),
//       decoration: const BoxDecoration(
//         border: Border(
//           bottom: BorderSide(color: Color(0xFF999999), width: 0.8),
//         ),
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 20.h,
//             width: 20.w,
//             color: const Color(0xFFE8D9AD),
//             alignment: Alignment.center,
//             child: Icon(icon, size: 13.sp, color: const Color(0xFFB58A2A)),
//           ),

//           SizedBox(width: 7.w),

//           Expanded(
//             child: Text(
//               title,
//               style: GoogleFonts.outfit(
//                 fontSize: 18.sp,
//                 fontWeight: FontWeight.w500,
//                 color: const Color(0xFF101C16),
//               ),
//             ),
//           ),

//           Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Text(
//                 status,
//                 style: GoogleFonts.outfit(
//                   fontSize: 18.sp,
//                   fontWeight: FontWeight.w500,
//                   color: const Color(0xFF101C16),
//                 ),
//               ),
//               Text(
//                 amount,
//                 style: GoogleFonts.outfit(
//                   fontSize: 17.sp,
//                   color: Color.fromRGBO(42, 41, 51, 0.6),
//                   fontWeight: FontWeight.w500,
//                   letterSpacing: -0.2,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   String _formatPropertyType(String? type) {
//     if (type == null || type.trim().isEmpty) return "Apartment";
//     final lower = type.trim().toLowerCase();
//     if (lower == "apartment") {
//       return "Apartment";
//     }
//     if (lower == "community_care") {
//       return "Community Care";
//     }
//     if (lower == "independent_house") {
//       return "Independent House";
//     }
//     if (lower == "home_care") {
//       return "Home Care";
//     }
//     return type
//         .replaceAll('_', ' ')
//         .split(' ')
//         .map(
//           (w) => w.isNotEmpty
//               ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
//               : '',
//         )
//         .join(' ');
//   }
// }

import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/core/constant/appColor.dart';
import 'package:property_care/core/Utils/property_type_helper.dart';
import 'package:svg_flutter/svg.dart';
import '../rentBillScreen/RentBillsScreen.dart';
import 'Provider/getTenantDetailsProvider.dart';
import 'package:property_care/core/Data/Model/ResponseModel/getTenantDetailsModel.dart';
import 'widget/TenantAvatar.dart';

class TenantDetailsScreen extends ConsumerStatefulWidget {
  final String tenantId;
  const TenantDetailsScreen({super.key, required this.tenantId});

  @override
  ConsumerState<TenantDetailsScreen> createState() =>
      _TenantDetailsScreenState();
}

class _TenantDetailsScreenState extends ConsumerState<TenantDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final tenantDetailState = ref.watch(
      getTenantDetailsProvider(widget.tenantId),
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
                    "TENANT DETAILS",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.heading,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "View tenant and occupancy information",
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromRGBO(42, 41, 51, 0.7),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: tenantDetailState.when(
        data: (tenantDetailsData) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Color(0xFF101C16), width: 1.w),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TenantAvatar(
                          name:
                              tenantDetailsData.data?.tenantDetails?.name ??
                              tenantDetailsData.data?.tenantDetails?.tenantName,
                          imageUrl:
                              tenantDetailsData.data?.tenantDetails?.imageUrl,
                          size: 70.r,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          // "Arjun Kapoor",
                          tenantDetailsData.data?.tenantDetails?.name ?? "N/A",
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF000000),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          tenantDetailsData.data?.tenantDetails?.tenantType ??
                              "Primary Tenant",
                          style: GoogleFonts.outfit(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                            letterSpacing: -0.3,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 21.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: Color(0xFF000000),
                              width: 1.w,
                            ),
                          ),
                          child: Text(
                            _statusPillText(
                              tenantDetailsData.data?.tenantDetails,
                            ),
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF000000),
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Tenant Information",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                      color: AppColors.heading,
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
                          value:
                              tenantDetailsData.data?.tenantDetails?.name ??
                              "-",
                        ),
                        _documentRow(
                          title: "Tenant Type",
                          value:
                              tenantDetailsData
                                  .data
                                  ?.tenantDetails
                                  ?.tenantType ??
                              "Primary Tenant",
                        ),
                        _documentRow(
                          title: "Move-in Date",
                          value:
                              tenantDetailsData
                                  .data
                                  ?.tenantDetails
                                  ?.moveInDate ??
                              "N/A",
                        ),
                        _documentRow(
                          title: "Occupancy Status",
                          value:
                              tenantDetailsData
                                  .data
                                  ?.tenantDetails
                                  ?.occupancyStatus ??
                              "-",
                          showBottomBorder: false,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Property Details",
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      color: AppColors.heading,
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
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
                                  tenantDetailsData
                                          .data
                                          ?.propertyDetails
                                          ?.apartmentNo ??
                                      "-",
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF101C16),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                Text(
                                  _complexOrType(
                                    tenantDetailsData.data?.propertyDetails,
                                  ),
                                  style: GoogleFonts.outfit(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF000000),
                                    letterSpacing: -0.2,
                                  ),
                                ),
                              ],
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
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "Apartment No.",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
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
                                _formatPropertyType(
                                  tenantDetailsData
                                      .data
                                      ?.propertyDetails
                                      ?.propertyType,
                                ),
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tenantDetailsData
                                        .data
                                        ?.propertyDetails
                                        ?.apartmentNo ??
                                    "-",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
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
                                "Floor",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromRGBO(42, 41, 51, 0.6),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),

                            Expanded(
                              child: Text(
                                "Occupancy",
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
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
                                tenantDetailsData
                                        .data
                                        ?.propertyDetails
                                        ?.floor ??
                                    "-",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF101C16),
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tenantDetailsData
                                        .data
                                        ?.propertyDetails
                                        ?.occupancy ??
                                    "-",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
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
                  SizedBox(height: 16.h),
                  // Tenant ke apne utility bills (bill nahi -> "Not Billed", koi nakli Paid nahi)
                  _utilityCard(context, tenantDetailsData),
                  SizedBox(height: 16.h),
                  Text(
                    "Contact Information",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF101C16),
                      letterSpacing: -0.2,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.heading),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.heading,
                                    width: 1.2,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Icon(
                                  Icons.phone_outlined,
                                  color: AppColors.heading,
                                  size: 16.sp,
                                ),
                              ),

                              SizedBox(height: 8.h),

                              Text(
                                "Phone",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                ),
                              ),

                              SizedBox(height: 8.h),
                              Text(
                                tenantDetailsData.data?.tenantDetails?.phone ??
                                    "-",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 20.w),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.heading),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  border: Border.all(color: AppColors.heading),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Icon(
                                  Icons.mail_outline,
                                  color: AppColors.heading,
                                  size: 16.sp,
                                ),
                              ),

                              SizedBox(height: 8.h),

                              Text(
                                "Email",
                                style: GoogleFonts.outfit(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                tenantDetailsData.data?.tenantDetails?.email ??
                                    "N/A",
                                style: GoogleFonts.outfit(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.heading,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Additional Information",
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
                      border: Border.all(color: AppColors.heading),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      "Tenant information is maintained for property management and relevant property-related communication.",
                      style: GoogleFonts.outfit(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                        letterSpacing: -0.2,
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
                    "Failed to load tenant details.\nPlease try again.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      color: AppColors.heading,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.heading,
                    ),
                    onPressed: () => ref.invalidate(
                      getTenantDetailsProvider(widget.tenantId),
                    ),
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

  /* ------------------------------------------------------------------
   * Tenant status / utility helpers (koi dummy fallback nahi)
   * ------------------------------------------------------------------ */

  bool _tenantActive(TenantDetails? t) {
    if (t == null) return true;
    if (t.isActive != null) return t.isActive!;
    final s = (t.tenantStatus ?? "Active").trim().toLowerCase();
    return s.isEmpty || s == "active";
  }

  /// Upar ka pill: abhi rehta hai -> "Active Tenant", gaya -> "Moved out on 18 Nov 2026"
  String _statusPillText(TenantDetails? t) {
    if (t == null) return "-";
    if (_tenantActive(t)) return "Active Tenant";
    final out = (t.moveOutDate ?? "").trim();
    if (out.isNotEmpty && out.toLowerCase() != "not set") {
      return "Moved out on $out";
    }
    return "Moved Out";
  }

  /// Complex ka naam (Community Care); Home Care mein complex nahi -> property type
  String _complexOrType(PropertyDetails? d) {
    final c = (d?.complexName ?? "").trim();
    if (c.isNotEmpty && c.toUpperCase() != "N/A") return c;
    return _formatPropertyType(d?.propertyType);
  }

  /// Backend label -> paid / unpaid / overdue / none
  String _utilState(Electricity? u) {
    final s = (u?.status ?? "").toLowerCase().replaceAll(RegExp(r'[\s_]+'), "");
    if (u == null || s.isEmpty || s == "notbilled" || s == "-") return "none";
    if (s == "paid") return "paid";
    if (s == "overdue") return "overdue";
    return "unpaid";
  }

  String _inr(num? v) {
    final n = (v ?? 0);
    final whole = n == n.roundToDouble();
    final str = whole ? n.round().toString() : n.toStringAsFixed(2);
    final parts = str.split('.');
    String intPart = parts[0];
    final neg = intPart.startsWith('-');
    if (neg) intPart = intPart.substring(1);
    // Indian grouping: 12,34,567
    String out;
    if (intPart.length <= 3) {
      out = intPart;
    } else {
      final last3 = intPart.substring(intPart.length - 3);
      String rest = intPart.substring(0, intPart.length - 3);
      final groups = <String>[];
      while (rest.length > 2) {
        groups.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) groups.insert(0, rest);
      out = "${groups.join(',')},$last3";
    }
    return "₹${neg ? '-' : ''}$out${parts.length > 1 ? '.${parts[1]}' : ''}";
  }

  Widget _pill(String state, {bool big = false, String? text}) {
    late Color bg;
    late Color fg;
    late String label;
    switch (state) {
      case "paid":
        bg = const Color(0xFF24B06A).withOpacity(0.15);
        fg = const Color(0xFF24B06A);
        label = "Paid";
        break;
      case "overdue":
        bg = const Color(0xFFD41F1F).withOpacity(0.10);
        fg = const Color(0xFFD41F1F);
        label = "Overdue";
        break;
      case "unpaid":
        bg = const Color(0xFFAE8130).withOpacity(0.20);
        fg = const Color(0xFFAE8130);
        label = "Unpaid";
        break;
      default:
        bg = Colors.black.withOpacity(0.05);
        fg = Colors.black.withOpacity(0.5);
        label = "Not Billed";
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: big ? 12.w : 9.w,
        vertical: big ? 4.h : 2.h,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        text ?? label,
        style: GoogleFonts.outfit(
          fontSize: big ? 13.sp : 12.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }

  void _openRentBills(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const RentBillsScreen()),
    );
  }

  /// Utility card: bijli / paani / gas ka latest bill. Bill nahi -> "Not Billed".
  /// Moved out tenant -> "Bills During Stay". Property ke saare bills Rent & Bills mein.
  Widget _utilityCard(BuildContext context, GetTenantDetailsModel model) {
    final u = model.data?.utilitiesPaymentStatus;
    final active = _tenantActive(model.data?.tenantDetails);
    final outstanding = (u?.totalOutstanding ?? 0);
    final rows = <List<dynamic>>[
      [Icons.bolt, "Electricity", u?.electricity],
      [Icons.water_drop_outlined, "Water", u?.water],
      [Icons.local_fire_department_outlined, "Gas", u?.gas],
    ];
    final states = rows.map((r) => _utilState(r[2] as Electricity?)).toList();
    final anyBilled =
        states.any((s) => s != "none") ||
        _utilState(u?.internet) != "none" ||
        outstanding > 0;
    final anyOverdue = states.contains("overdue");

    // Bakaya mein repair / damage jaise charges bhi ho sakte hain jo list mein nahi
    num listedDue = 0;
    for (final e in [u?.electricity, u?.water, u?.gas, u?.internet]) {
      final st = _utilState(e);
      if (st == "unpaid" || st == "overdue")
        listedDue += (e?.lastPaidAmount ?? 0);
    }
    final hasOtherCharges = outstanding - listedDue > 0.5;

    Widget badge;
    if (u == null || !anyBilled) {
      badge = _pill("none", big: true, text: "No Bills");
    } else if (outstanding > 0) {
      badge = _pill(anyOverdue ? "overdue" : "unpaid", big: true);
    } else {
      badge = _pill("paid", big: true, text: "All Paid");
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading, width: 1),
        borderRadius: BorderRadius.circular(9.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40.h,
                width: 40.w,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.heading),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.receipt_long_outlined,
                  size: 19.sp,
                  color: AppColors.heading,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      active ? "Utility Bills" : "Bills During Stay",
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF101C16),
                      ),
                    ),
                    Text(
                      active
                          ? "Latest bill of each utility"
                          : "Bills from when this tenant lived here",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromRGBO(42, 41, 51, 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              badge,
            ],
          ),
          SizedBox(height: 10.h),
          const Divider(height: 1, thickness: 1, color: Color(0xFF999999)),
          SizedBox(height: 4.h),
          for (var i = 0; i < rows.length; i++)
            _utilityRow(
              icon: rows[i][0] as IconData,
              title: rows[i][1] as String,
              item: rows[i][2] as Electricity?,
              state: states[i],
            ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      active ? "Unpaid by Tenant" : "Left Unpaid",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        color: const Color.fromRGBO(42, 41, 51, 0.6),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      u == null
                          ? "-"
                          : (outstanding > 0
                                ? _inr(outstanding)
                                : "Nothing due"),
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: outstanding > 0
                            ? const Color(0xFFD41F1F)
                            : const Color(0xFF24B06A),
                      ),
                    ),
                    if (hasOtherCharges)
                      Text(
                        "Includes other charges (repair, damage etc.)",
                        style: GoogleFonts.outfit(
                          fontSize: 12.sp,
                          color: const Color.fromRGBO(42, 41, 51, 0.6),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: () => _openRentBills(context),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Text(
                    active ? "All Bills →" : "Property Bills →",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFAE8130),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _utilityRow({
    required IconData icon,
    required String title,
    required Electricity? item,
    required String state,
  }) {
    final billed = state != "none";
    final month = (item?.month ?? "").trim();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0DA), width: 0.8),
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 22.h,
            width: 22.w,
            decoration: BoxDecoration(
              color: const Color(0xFFE8D9AD),
              borderRadius: BorderRadius.circular(4.r),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 13.sp, color: const Color(0xFFB58A2A)),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF101C16),
                  ),
                ),
                if (billed && month.isNotEmpty)
                  Text(
                    month,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      color: const Color.fromRGBO(42, 41, 51, 0.6),
                    ),
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _pill(state),
              if (billed) ...[
                SizedBox(height: 3.h),
                Text(
                  _inr(item?.lastPaidAmount),
                  style: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2A2933),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  String _formatPropertyType(String? type) {
    if (type == null || type.trim().isEmpty) return "Apartment";
    final lower = type.trim().toLowerCase();
    if (lower == "apartment") {
      return "Apartment";
    }
    if (lower == "community_care") {
      return "Community Care";
    }
    if (lower == "independent_house") {
      return "Independent House";
    }
    if (lower == "home_care") {
      return "Home Care";
    }
    return type
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (w) => w.isNotEmpty
              ? '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}'
              : '',
        )
        .join(' ');
  }
}
