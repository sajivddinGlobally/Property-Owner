import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/core/constant/appColor.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 20.w,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
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
            SizedBox(width: 14.w),
            Text(
              "Privacy Policy",
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff292832),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "STAYO",
                      style: GoogleFonts.outfit(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF101C16),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "PRIVACY POLICY",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD4A017),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "Protection, Collection, Storage and Use of Personal Information",
                      style: GoogleFonts.outfit(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF6B7280),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                    SizedBox(height: 10.h),
                    _buildMetaRow("Application Name:", "STAYO"),
                    _buildMetaRow("Owner / Operator:", "Ascent PMS Care / STAYO"),
                    _buildMetaRow("Website:", "www.ascentpms.care"),
                    _buildMetaRow("Effective Date:", "19 November 2026"),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Section 1
              _buildSection(
                title: "1. INTRODUCTION",
                body: "STAYO is a digital property management application designed to facilitate the systematic and transparent management of independent residential properties and multi-unit residential communities.\n\n"
                    "The application provides digital facilities for property owners, residents, tenants, associations, property managers, security personnel, administrators, contractors and other authorised users.\n\n"
                    "STAYO recognises the importance of protecting the privacy and personal information of individuals using the application.\n\n"
                    "This Privacy Policy explains how STAYO collects, receives, processes, stores, uses, shares and protects personal information through its mobile application, website and associated services.\n\n"
                    "This policy applies to all individuals accessing or using STAYO, including property owners, residents, tenants, visitors, employees, security personnel, contractors and other authorised users.\n\n"
                    "By accessing or using the application, users acknowledge that they have been provided access to this Privacy Policy. Where consent is required under applicable law, STAYO shall obtain such consent through the appropriate mechanism.\n\n"
                    "Users are advised to read this policy carefully before registering or using the application.",
              ),

              // Section 2
              _buildSection(
                title: "2. SCOPE OF THIS PRIVACY POLICY",
                body: "This Privacy Policy applies to personal information collected or processed through:\n"
                    "• STAYO mobile application.\n"
                    "• STAYO website and web dashboard.\n"
                    "• Property and community registration modules.\n"
                    "• Resident and tenant management modules.\n"
                    "• Visitor management facilities.\n"
                    "• Delivery and courier management facilities.\n"
                    "• Maintenance collection and accounting modules.\n"
                    "• Complaint and maintenance request modules.\n"
                    "• Staff and service provider management modules.\n"
                    "• Asset and inventory management modules.\n"
                    "• Customer support and communication channels.\n"
                    "• Other services and features made available through STAYO.\n\n"
                    "This policy also explains the responsibilities of property owners, associations and administrators who upload, manage or access personal information through the platform.",
              ),

              // Section 3
              _buildSection(
                title: "3. INFORMATION WE COLLECT",
                body: "Depending on the features used and the permissions granted, STAYO may collect or process the following categories of information:\n\n"
                    "3.1 Personal Identification Information:\n"
                    "• Full name, mobile number, email address, residential address, property or apartment number, profile photograph (where provided), and user identification details.\n\n"
                    "3.2 Property and Occupancy Information:\n"
                    "• Property name and address, apartment/villa/unit number, property ownership details, resident and tenant information, occupancy details, emergency contacts, and family/occupant info.\n\n"
                    "3.3 Visitor Management Information:\n"
                    "• Visitor’s name, contact number, photograph (where required & lawful), vehicle registration number, purpose of visit, person visited, entry/exit timestamp, approval/rejection records.\n\n"
                    "3.4 Delivery and Courier Information:\n"
                    "• Recipient’s name, apartment number, delivery company, parcel reference, delivery time, collection status.\n\n"
                    "3.5 Financial and Payment Information:\n"
                    "• Monthly maintenance charges, payment amounts, dates, transaction references, dues, receipts, invoices, vendor payments. Payment credentials (card details, CVV, passwords) are handled directly by authorised third-party payment gateways; STAYO does not store sensitive card or bank credentials.\n\n"
                    "3.6 Maintenance and Complaint Information:\n"
                    "• Description, property details, photos, category, priority, assigned service provider, and status.\n\n"
                    "3.7 Staff and Service Provider Information:\n"
                    "• Name, contact info, role, attendance records, duty allocation, performance records.\n\n"
                    "3.8 Device and Technical Information:\n"
                    "• Device model, OS, app version, IP address, device identifiers, login timestamps, error logs, and security logs.",
              ),

              // Section 4
              _buildSection(
                title: "4. PURPOSE OF COLLECTING INFORMATION",
                body: "STAYO collects and processes personal information only for legitimate purposes connected with the operation and delivery of its property management services:\n\n"
                    "4.1. Creating and managing user accounts.\n"
                    "4.2. Registering independent properties and residential communities.\n"
                    "4.3. Maintaining resident, tenant and property records.\n"
                    "4.4. Facilitating visitor registration, approval and entry monitoring.\n"
                    "4.5. Recording and communicating delivery information.\n"
                    "4.6. Generating and maintaining monthly maintenance demands.\n"
                    "4.7. Recording payments and maintaining financial transaction histories.\n"
                    "4.8. Generating accounting statements and collection reports.\n"
                    "4.9. Identifying outstanding maintenance dues for authorised administrators.\n"
                    "4.10. Registering, assigning and tracking maintenance complaints.\n"
                    "4.11. Coordinating contractors, suppliers and service providers.\n"
                    "4.12. Monitoring staff attendance and assigned duties.\n"
                    "4.13. Maintaining asset and inventory records.\n"
                    "4.14. Sending notices, announcements, payment reminders and service notifications.\n"
                    "4.15. Providing technical support and responding to customer queries.\n"
                    "4.16. Detecting unauthorised access, fraudulent activities and security threats.\n"
                    "4.17. Complying with applicable legal and regulatory obligations.\n"
                    "4.18. Improving the functionality, reliability and security of the application.",
              ),

              // Section 5
              _buildSection(
                title: "5. ACCESS TO DEVICE PERMISSIONS",
                body: "STAYO may request access to certain device features depending on functionality:\n\n"
                    "5.1 Camera Permission: To capture visitor photographs, maintenance issue photos, property inspections, inventory conditions, or supporting documents.\n\n"
                    "5.2 Gallery and Photo Access: To upload profile photos, property photos, complaint photos, and inspection documents.\n\n"
                    "5.3 Location Permission: Where necessary for location-dependent features (e.g., recording authorised staff attendance). Location is not collected continuously.\n\n"
                    "5.4 Notification Permission: To send visitor alerts, delivery notifications, maintenance updates, payment reminders, community announcements, and emergency alerts.\n\n"
                    "5.5 Storage and File Access: To upload or download invoices, reports, documents, and receipts.\n\n"
                    "Users may deny optional permissions, though certain features may not function without them.",
              ),

              // Section 6
              _buildSection(
                title: "6. VISITOR INFORMATION AND THIRD-PARTY PERSONAL DATA",
                body: "6.1. STAYO may process information relating to visitors entering registered properties.\n"
                    "6.2. Such information may be entered by residents, security personnel, administrators or visitors.\n"
                    "6.3. Property owners, associations and administrators are responsible for ensuring visitor information is collected in compliance with applicable laws.\n"
                    "6.4. Visitors should be informed about information collection through appropriate notices.\n"
                    "6.5. Visitor details and photos shall be accessed only by authorised individuals for legitimate security purposes.\n"
                    "6.6. Visitor info shall not be used for unrelated commercial purposes.\n"
                    "6.7. Digital visitor records are retained per property requirements and privacy policy.\n"
                    "6.8. Physical security remains the responsibility of property administration and security personnel.",
              ),

              // Section 7
              _buildSection(
                title: "7. SHARING OF PERSONAL INFORMATION",
                body: "STAYO does not sell personal information to third parties for commercial use. Information may be shared with authorised parties only as necessary:\n\n"
                    "7.1. Property Owners and Administrators: For legitimate property and resident management.\n"
                    "7.2. Security Personnel: Visitor-related information for gate security coordination.\n"
                    "7.3. Payment Gateway Providers: For processing payments securely.\n"
                    "7.4. Contractors and Service Providers: Relevant maintenance complaint details to perform repairs.\n"
                    "7.5. Technology and Hosting Providers: For secure cloud hosting, database management, and technical support under strict confidentiality.\n"
                    "7.6. Legal and Regulatory Authorities: Disclosed only when legally required by a court order or competent authority.\n"
                    "7.7. Business Transfers: In the event of a merger, acquisition, or restructuring, subject to applicable safeguards.",
              ),

              // Section 8 to 11
              _buildSection(
                title: "8. ACCESS CONTROL AND CONFIDENTIALITY",
                body: "8.1. STAYO provides role-based access permissions so users access only information relevant to their roles.\n"
                    "8.2. Residents cannot access confidential financial or personal information of other residents.\n"
                    "8.3. Security personnel access only necessary visitor information.\n"
                    "8.4. Financial info is restricted to authorised committee members or owners.\n"
                    "8.5. Administrators are responsible for granting and revoking permissions.\n"
                    "8.6. Users must not disclose confidential information without proper authority.\n"
                    "8.7. Access logs are maintained to identify unauthorised activities.\n"
                    "8.8. Misuse may result in immediate account suspension and legal action.",
              ),

              _buildSection(
                title: "9. DATA STORAGE AND SECURITY",
                body: "9.1. STAYO takes reasonable technical and organisational measures to protect personal information.\n"
                    "9.2. Security measures include: authentication and access controls, role-based permissions, encrypted data transmission (HTTPS/TLS), secure cloud infrastructure, logs, and backups.\n"
                    "9.3. Access is restricted to authorised personnel on a need-to-know basis.\n"
                    "9.4. STAYO regularly monitors and addresses security vulnerabilities.\n"
                    "9.5. While rigorous security is maintained, no digital system can guarantee absolute invulnerability.\n"
                    "9.6. In case of a data breach, STAYO will investigate, contain, and notify affected users and authorities as required by law.",
              ),

              _buildSection(
                title: "10. DATA RETENTION AND DELETION",
                body: "10.1. Personal information is retained only as long as necessary for property management purposes or legal compliance.\n"
                    "10.2. Account information is retained during active registration and for required audit periods.\n"
                    "10.3. Visitor records are retained according to property-level schedules.\n"
                    "10.4. Financial records are retained as required by financial, tax, and corporate laws.\n"
                    "10.5. Maintenance records are retained for historical audit and dispute resolution.\n"
                    "10.6. Users may request account and data deletion through app settings or support channels.\n"
                    "10.7. Identity verification may be required prior to deletion.\n"
                    "10.8. Legally mandated records may be retained post-closure as allowed by law.\n"
                    "10.9. Unneeded data is securely destroyed or anonymised.",
              ),

              _buildSection(
                title: "11. USER RIGHTS AND CONTROL OVER PERSONAL INFORMATION",
                body: "Subject to applicable Indian data protection law, users have the right to:\n"
                    "11.1. Inquire about the processing of their personal data.\n"
                    "11.2. Request correction of inaccurate information.\n"
                    "11.3. Request completion or updating of records.\n"
                    "11.4. Request erasure of personal information where permissible.\n"
                    "11.5. Withdraw consent where processing was consent-based.\n"
                    "11.6. Register grievances concerning personal data processing.\n"
                    "11.7. Nominate another person to exercise data rights as allowed by law.\n"
                    "11.8. Exercise rights by contacting the Grievance Officer.\n"
                    "11.9. Reasonable verification may be required before fulfilling requests.\n"
                    "11.10. Some requests may be limited by legal retention requirements.",
              ),

              // Section 12 to 17
              _buildSection(
                title: "12. CHILDREN’S PERSONAL INFORMATION",
                body: "12.1. STAYO is intended for adult property owners, tenants, and administrators.\n"
                    "12.2. The application does not independently register children under 18.\n"
                    "12.3. Any necessary family/child info must be submitted by an authorised parent or guardian.\n"
                    "12.4. Children's data is handled with parental consent per applicable legal standards.\n"
                    "12.5. Users must not upload children's information without proper authority.",
              ),

              _buildSection(
                title: "13. THIRD-PARTY SERVICES AND EXTERNAL PLATFORMS",
                body: "13.1. STAYO integrates with third-party payment gateways, cloud hosting, and messaging providers.\n"
                    "13.2. These providers operate under their own privacy policies and security agreements.\n"
                    "13.3. STAYO chooses reputable providers with robust data security standards.\n"
                    "13.4. STAYO is not responsible for independent practices of external third-party sites.\n"
                    "13.5. Users should review relevant third-party privacy statements.",
              ),

              _buildSection(
                title: "14. COMMUNICATIONS AND NOTIFICATIONS",
                body: "14.1. Contact info is used to deliver vital service communications.\n"
                    "14.2. Messages include: registration notices, security alerts, visitor arrivals, deliveries, maintenance updates, receipts, and payment reminders.\n"
                    "14.3. Essential operational notices cannot be disabled without affecting app service.\n"
                    "14.4. Promotional communications, if any, require separate consent.\n"
                    "14.5. Users may opt out of optional promotional messages anytime.",
              ),

              _buildSection(
                title: "15. FINANCIAL AND ACCOUNTING INFORMATION",
                body: "15.1. Used solely for recording maintenance collections, expenses, and dues.\n"
                    "15.2. Accessible only to authorised administrators and property managers.\n"
                    "15.3. Residents can view only their own payment records and authorized society accounts.\n"
                    "15.4. Property associations are responsible for accuracy and approvals.\n"
                    "15.5. Resident financial details are never used for unrelated purposes.\n"
                    "15.6. Users must not share confidential financial records.\n"
                    "15.7. Payment processing follows PCI-DSS and gateway security standards.",
              ),

              _buildSection(
                title: "16. PROPERTY OWNER AND ASSOCIATION RESPONSIBILITIES",
                body: "16.1. Must ensure personal data uploaded is lawfully obtained.\n"
                    "16.2. Must obtain required notices or consents under applicable law.\n"
                    "16.3. Must ensure only authorised personnel have access.\n"
                    "16.4. Must not misuse resident or visitor information.\n"
                    "16.5. Must maintain reasonable data review procedures.\n"
                    "16.6. Must report suspected data misuse immediately to STAYO.\n"
                    "16.7. Must comply with Indian data protection legislation (DPDPA).\n"
                    "16.8. Society-level data controllership is independent of STAYO's platform role.",
              ),

              _buildSection(
                title: "17. LOCATION INFORMATION",
                body: "17.1. Requested only for specific features requiring geographic verification.\n"
                    "17.2. Used for staff attendance or location-based services.\n"
                    "17.3. Never used for continuous or unrestricted background tracking.\n"
                    "17.4. Users can toggle location permissions in device settings.\n"
                    "17.5. Disabling location may impact location-dependent features.\n"
                    "17.6. Processed strictly within communicated boundaries.",
              ),

              // Section 18 to 21
              _buildSection(
                title: "18. COOKIES AND APPLICATION ANALYTICS",
                body: "18.1. Web dashboards and portals may use session cookies for security and functionality.\n"
                    "18.2. Technologies collect basic usage, session, and performance stats.\n"
                    "18.3. Analytics assist in improving app speed, stability, and UX.\n"
                    "18.4. Consent is obtained where legally required.\n"
                    "18.5. Users can adjust cookie settings via their web browsers.",
              ),

              _buildSection(
                title: "19. INTERNATIONAL DATA PROCESSING",
                body: "19.1. Cloud servers may process or back up data across certified cloud regions.\n"
                    "19.2. Cross-border handling adheres strictly to Indian data protection laws and statutory restrictions.\n"
                    "19.3. Contractual security safeguards are maintained with all cloud service providers.",
              ),

              _buildSection(
                title: "20. DATA BREACH AND SECURITY INCIDENTS",
                body: "20.1. STAYO maintains incident response protocols.\n"
                    "20.2. In case of an incident, rapid investigation and containment will be initiated.\n"
                    "20.3. Affected users and statutory bodies will be informed per legal requirements.\n"
                    "20.4. Users must promptly notify support of any account anomalies.\n"
                    "20.5. Cooperation with security investigations is required.",
              ),

              _buildSection(
                title: "21. CHANGES TO THIS PRIVACY POLICY",
                body: "21.1. STAYO reserves the right to update this policy.\n"
                    "21.2. New versions will be published in the application and on the website.\n"
                    "21.3. Material changes will be communicated via in-app alerts or email.\n"
                    "21.4. Fresh consent will be obtained where mandated by law.\n"
                    "21.5. Users are encouraged to review this policy periodically.",
              ),

              // Section 22 - Contact & Grievance
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 16.h),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFD4A017).withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "22. GRIEVANCE REDRESSAL AND DATA PROTECTION CONTACT",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101C16),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "For questions, concerns, or requests relating to personal information, users may contact:\n\n"
                      "STAYO – PRIVACY AND GRIEVANCE SUPPORT\n"
                      "Company Name: Ascent PMS Care\n"
                      "Grievance Officer: Grievance Officer, Stayo\n"
                      "Email: ascentpmscare@gmail.com\n"
                      "Phone: 9567345740\n"
                      "Website: www.ascentpms.care\n"
                      "Registered Office: First floor, Krishnapriya, Ganapathy Kovil road, Vazhuthacaud, Trivandrum-14\n\n"
                      "STAYO shall endeavour to acknowledge and resolve grievances within statutory timelines.",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color(0xFF374151),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Section 23 - Consent
              _buildSection(
                title: "23. CONSENT AND ACKNOWLEDGEMENT",
                body: "By registering or using the STAYO application, users confirm that:\n"
                    "1. Their information may be collected for property management and application-related purposes.\n"
                    "2. Relevant information may be shared with authorised property administrators and service providers where necessary.\n"
                    "3. Visitor, delivery and maintenance information may be processed to facilitate property operations.\n"
                    "4. Financial information may be processed to maintain maintenance collection and accounting records.\n"
                    "5. Their applicable privacy rights may be exercised through the designated grievance channels.\n"
                    "6. Their information shall be handled in accordance with this Privacy Policy and applicable Indian data protection laws.",
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.w,
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4B5563),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String body}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF101C16),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: const Color(0xFF374151),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

