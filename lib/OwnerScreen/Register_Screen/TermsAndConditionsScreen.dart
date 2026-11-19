import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/core/constant/appColor.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
              "Terms & Conditions",
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
                      "TERMS AND CONDITIONS OF USE",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD4A017),
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      "PROPERTY MANAGEMENT APPLICATION",
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
                title: "1. INTRODUCTION AND ACCEPTANCE",
                body: "1.1. Welcome to STAYO, a digital property management application designed to simplify, streamline and improve the management of independent residential properties and multi-unit residential communities.\n\n"
                    "1.2. STAYO provides a common digital platform for property owners, residents, tenants, apartment associations, residents’ associations, property managers, administrators, security personnel, maintenance teams, contractors, suppliers and other authorised stakeholders.\n\n"
                    "1.3. The application is designed to facilitate property-related administrative, financial, operational and communication activities through a centralised digital system.\n\n"
                    "1.4. These Terms and Conditions govern the access to and use of the STAYO mobile application, website, dashboard, software and associated services.\n\n"
                    "1.5. By downloading, installing, registering, accessing or using the application, you acknowledge that you have read, understood and agreed to comply with these Terms and Conditions, together with the applicable Privacy Policy and other policies published by STAYO.\n\n"
                    "1.6. If you do not agree with these Terms and Conditions, you must discontinue the use of the application.\n\n"
                    "1.7. These Terms and Conditions apply to all categories of users accessing STAYO, irrespective of their assigned role or access level.",
              ),

              // Section 2
              _buildSection(
                title: "2. DEFINITIONS AND INTERPRETATION",
                body: "For the purpose of these Terms and Conditions, the following expressions shall have the meanings assigned to them:\n\n"
                    "2.1. STAYO / Company: Refers to the legal entity owning, developing, operating or providing the STAYO application and associated services.\n\n"
                    "2.2. Application / Platform: Refers to the STAYO mobile application, web application, administrative dashboard, software and associated digital interfaces.\n\n"
                    "2.3. User: Refers to any individual who accesses, registers or uses the application.\n\n"
                    "2.4. Property: Refers to an independent house, villa, apartment, residential building, commercial building or other premises registered on the platform.\n\n"
                    "2.5. Community: Refers to a residential apartment complex, gated community, housing society or group of residential units managed collectively.\n\n"
                    "2.6. Property Owner: Refers to the legal owner or duly authorised representative of a property.\n\n"
                    "2.7. Resident: Refers to an individual residing in a property or residential community.\n\n"
                    "2.8. Tenant: Refers to an individual occupying a property under a rental, lease or other lawful occupancy arrangement.\n\n"
                    "2.9. Association: Refers to a residents’ association, apartment owners’ association, housing society or other authorised body responsible for managing a residential community.\n\n"
                    "2.10. Administrator: Refers to an individual authorised by the property owner, association or management organisation to administer the application and manage property-related information.\n\n"
                    "2.11. Property Manager: Refers to an individual or organisation appointed to coordinate, supervise or undertake property management activities.\n\n"
                    "2.12. Service Provider: Refers to contractors, technicians, suppliers, security agencies, housekeeping personnel, maintenance personnel and other third parties engaged for property-related services.\n\n"
                    "2.13. Visitor: Refers to any guest, delivery executive, vendor, service technician, domestic worker or other individual seeking access to a property or community.\n\n"
                    "2.14. MMC: Refers to Monthly Maintenance Charges or periodic maintenance contributions payable by property owners, residents or other persons liable under the applicable agreement or association rules.\n\n"
                    "2.15. Subscription: Refers to the fee or payment applicable for accessing the STAYO platform or its designated features.\n\n"
                    "2.16. Digital Records: Refers to information, transaction histories, reports, photographs, documents, notifications, entries and other records generated, uploaded or maintained through the application.",
              ),

              // Section 3
              _buildSection(
                title: "3. PURPOSE AND SCOPE OF THE APPLICATION",
                body: "3.1. STAYO is a property management technology platform intended to digitise and streamline the administrative, operational and financial management of independent properties and residential communities.\n\n"
                    "3.2. The application is designed to reduce manual processes, improve transparency, facilitate communication and provide systematic monitoring of property-related activities.\n\n"
                    "3.3. Depending on the subscription plan and configuration, the application may provide the following facilities:\n"
                    "a. Independent property management.\n"
                    "b. Residential community management.\n"
                    "c. Property and resident information management.\n"
                    "d. Visitor registration, approval and entry management.\n"
                    "e. Security and gate-entry management.\n"
                    "f. Delivery and courier management.\n"
                    "g. Monthly maintenance charge generation and collection tracking.\n"
                    "h. Digital accounting and financial reporting.\n"
                    "i. Income and expenditure management.\n"
                    "j. Outstanding dues and defaulter tracking.\n"
                    "k. Complaint and maintenance request management.\n"
                    "l. Emergency and priority-based issue tracking.\n"
                    "m. Contractor and supplier management.\n"
                    "n. Work allocation and completion monitoring.\n"
                    "o. Security, housekeeping and staff management.\n"
                    "p. Attendance and performance monitoring.\n"
                    "q. Asset and inventory management.\n"
                    "r. Purchase requests and stock monitoring.\n"
                    "s. Property inspections and audit reports.\n"
                    "t. Digital notices, announcements and communication.\n"
                    "u. Document storage and management.\n"
                    "v. Other property-related facilities introduced by STAYO.\n\n"
                    "3.4. The availability of individual features may depend on the selected subscription plan, property configuration, user permissions and technical availability.\n\n"
                    "3.5. STAYO reserves the right to modify, improve, introduce or discontinue features as part of its ongoing development, subject to applicable contractual and legal obligations.",
              ),

              // Section 4
              _buildSection(
                title: "4. ELIGIBILITY AND USER REGISTRATION",
                body: "4.1. Individuals must be at least 18 years of age to independently register for an account, except where an account is created or managed by a legally authorised representative in accordance with applicable law.\n\n"
                    "4.2. Users must provide accurate, complete and updated information during registration.\n\n"
                    "4.3. Users shall not provide false names, contact details, property information or other misleading particulars.\n\n"
                    "4.4. STAYO may request additional information or verification documents where necessary for security, account validation or regulatory compliance.\n\n"
                    "4.5. Each user is responsible for maintaining the confidentiality of their login credentials, passwords and other authentication information.\n\n"
                    "4.6. Users must not share their login credentials with unauthorised individuals.\n\n"
                    "4.7. Any activity performed through a user’s account shall be treated as activity associated with that account, subject to investigation where unauthorised access is reported.\n\n"
                    "4.8. Users must immediately report suspected unauthorised access, account compromise or suspicious activities to the administrator or STAYO support team.\n\n"
                    "4.9. STAYO reserves the right to suspend or restrict accounts involving fraudulent registration, identity misrepresentation, misuse or violation of these Terms.",
              ),

              // Section 5
              _buildSection(
                title: "5. PROPERTY AND COMMUNITY REGISTRATION",
                body: "5.1. Independent properties and residential communities may be registered on STAYO by property owners, authorised representatives, associations or appointed property management organisations.\n\n"
                    "5.2. The person registering a property or community shall confirm that they possess the necessary authority to submit the relevant information and activate the application services.\n\n"
                    "5.3. The registering authority shall be responsible for ensuring the accuracy of property details, unit numbers, ownership information, occupancy records and other information uploaded to the platform.\n\n"
                    "5.4. STAYO shall not independently verify the legal ownership, title, tenancy or occupancy rights of every property or individual registered on the application unless a specific verification service is expressly provided.\n\n"
                    "5.5. Any disputes relating to property ownership, tenancy, association membership, management authority or occupancy rights shall be resolved by the concerned parties in accordance with applicable laws.\n\n"
                    "5.6. The property owner or association shall ensure that appropriate permissions and authorisations have been obtained before uploading information belonging to residents, tenants, employees or visitors.\n\n"
                    "5.7. STAYO reserves the right to request supporting documents or suspend a property registration where legitimate concerns regarding authority or authenticity arise.",
              ),

              // Section 6
              _buildSection(
                title: "6. USER ROLES, PERMISSIONS AND ACCESS CONTROL",
                body: "6.1. STAYO may provide different user roles depending on the requirements of each property or community.\n\n"
                    "6.2. Such roles may include: Property Owner, Resident, Tenant, Association President/Chairperson, Secretary, Treasurer, Property Administrator, Property Manager, Security Supervisor/Personnel, Housekeeping Supervisor, Maintenance Personnel, Contractor/Supplier, and other authorised users.\n\n"
                    "6.3. Each user shall receive access to features and information based on the permissions assigned by the authorised administrator.\n\n"
                    "6.4. Users shall not attempt to access information or administrative functions beyond their assigned permissions.\n\n"
                    "6.5. Administrators shall be responsible for assigning appropriate permissions and reviewing access periodically.\n\n"
                    "6.6. When a user ceases to be a resident, employee, office-bearer or authorised representative, the concerned administrator shall take appropriate steps to deactivate or modify that user’s access.\n\n"
                    "6.7. Users shall not misuse their assigned authority to access, modify, disclose or manipulate information belonging to other users.\n\n"
                    "6.8. STAYO may maintain system activity logs for security, accountability and administrative purposes.",
              ),

              // Section 7
              _buildSection(
                title: "7. VISITOR MANAGEMENT AND ENTRY CONTROL",
                body: "7.1. STAYO provides digital visitor management facilities to facilitate the recording, verification, approval and monitoring of visitors entering registered properties and communities.\n\n"
                    "7.2. Residents may receive visitor notifications and approve or reject visitor entry requests through the application, where the facility is enabled.\n\n"
                    "7.3. Security personnel may record visitor information, including name, contact number, vehicle registration details, purpose of visit, entry time and exit time, as required by the property’s security procedures.\n\n"
                    "7.4. Residents shall be responsible for providing accurate visitor-related information and responding to approval requests wherever required.\n\n"
                    "7.5. Security personnel shall follow the entry procedures and instructions established by the property owner or association.\n\n"
                    "7.6. The final decision regarding permitting or denying entry shall remain with the authorised security personnel or property administration, subject to applicable laws and property rules.\n\n"
                    "7.7. STAYO functions as a digital visitor-recording and access-coordination platform. It does not independently verify the identity, intentions, background or conduct of every visitor.\n\n"
                    "7.8. The property owner, association or appointed security agency shall remain responsible for implementing appropriate physical security measures.\n\n"
                    "7.9. Users shall not misuse visitor information, photographs or contact details for personal, commercial or unauthorised purposes.\n\n"
                    "7.10. Visitor records shall be maintained and retained in accordance with the applicable Privacy Policy, lawful purposes and retention requirements.\n\n"
                    "7.11. STAYO shall not be considered a substitute for security personnel, CCTV systems, access-control equipment or emergency response arrangements.\n\n"
                    "7.12. The use of the visitor management facility does not constitute a guarantee against theft, trespassing, unauthorised entry or other security incidents.",
              ),

              // Section 8
              _buildSection(
                title: "8. DELIVERY AND COURIER MANAGEMENT",
                body: "8.1. STAYO may provide a digital delivery management facility to record and monitor parcels, courier items, food deliveries and other deliveries received at registered properties or communities.\n\n"
                    "8.2. Security personnel or authorised staff may record delivery details and notify the concerned resident through the application.\n\n"
                    "8.3. Delivery information may include the recipient’s name, apartment or unit number, delivery company, parcel reference and time of receipt.\n\n"
                    "8.4. Residents shall be responsible for collecting their deliveries within a reasonable period.\n\n"
                    "8.5. Where the property permits security personnel or other staff to temporarily receive deliveries, the applicable property-level procedures shall govern the physical handling and storage of such items.\n\n"
                    "8.6. STAYO does not automatically assume physical custody of any parcel or delivery merely because delivery details are recorded in the application.\n\n"
                    "8.7. The person or agency physically receiving a delivery shall remain responsible for handling it in accordance with their applicable duties and agreements.\n\n"
                    "8.8. STAYO shall not be responsible for the delay, damage, theft, loss or incorrect delivery of parcels arising from the independent acts or omissions of courier companies, residents or physical custodians, except where liability arises under applicable law.\n\n"
                    "8.9. Residents must ensure that delivery instructions and contact information are accurate.\n\n"
                    "8.10. Prohibited, dangerous or unlawful items shall not be accepted or stored contrary to applicable laws or property rules.",
              ),

              // Section 9
              _buildSection(
                title: "9. MONTHLY MAINTENANCE CHARGES AND COLLECTION MANAGEMENT",
                body: "9.1. STAYO may provide digital facilities for generating monthly maintenance demands, recording payments, monitoring outstanding dues and maintaining maintenance collection records.\n\n"
                    "9.2. Maintenance charges shall be determined by the concerned property owner, association or authorised management body in accordance with applicable agreements, resolutions, bye-laws and laws.\n\n"
                    "9.3. STAYO does not independently determine the amount of maintenance payable by individual residents or property owners.\n\n"
                    "9.4. The association or authorised management shall determine the applicable rates, payment frequency, due dates, penalties, interest and other collection conditions.\n\n"
                    "9.5. Residents and property owners shall be responsible for paying the applicable maintenance charges within the prescribed timelines.\n\n"
                    "9.6. Users are advised to review their maintenance statements and raise discrepancies with the concerned administrator without undue delay.\n\n"
                    "9.7. Where payment facilities are enabled, payments must be made through the authorised channels displayed in the application.\n\n"
                    "9.8. Digital receipts and transaction records generated by STAYO shall reflect the information recorded in the system and may be subject to reconciliation and verification.\n\n"
                    "9.9. Any dispute concerning the calculation, allocation or recovery of maintenance charges shall be addressed by the concerned association or authorised management body.\n\n"
                    "9.10. STAYO may provide reports identifying outstanding dues, payment histories and defaulters based on information available in the system.\n\n"
                    "9.11. The association or authorised management shall verify the accuracy of such reports before taking recovery action or communicating outstanding dues.\n\n"
                    "9.12. STAYO shall not independently initiate legal recovery proceedings against residents or property owners merely because maintenance charges remain outstanding.\n\n"
                    "9.13. Any penalties or additional charges must be authorised by the appropriate property management authority and comply with applicable law.\n\n"
                    "9.14. Users shall not manipulate, falsify or alter maintenance payment records.",
              ),

              // Section 10
              _buildSection(
                title: "10. DIGITAL ACCOUNTING AND FINANCIAL MANAGEMENT",
                body: "10.1. STAYO may provide digital accounting facilities for recording property-related income, maintenance collections, expenses, purchases, vendor payments and other financial transactions.\n\n"
                    "10.2. The accounting facility is intended to improve transparency, financial monitoring and record-keeping.\n\n"
                    "10.3. Financial entries may include maintenance collections, sinking fund contributions, common-area expenses, utility expenses, staff payments, contractor bills, repair costs, purchases and other authorised transactions.\n\n"
                    "10.4. Administrators and authorised financial users shall ensure that entries are accurate and supported by relevant invoices, receipts, vouchers or other documents.\n\n"
                    "10.5. The application may generate income statements, expenditure statements, outstanding dues reports, collection reports and other financial summaries.\n\n"
                    "10.6. The association or property management body shall remain responsible for approving expenditure, authorising payments and ensuring financial discipline.\n\n"
                    "10.7. STAYO shall not independently verify the authenticity of every invoice, receipt, financial entry or transaction uploaded by users.\n\n"
                    "10.8. Digital accounting reports generated by the application are management records and shall not automatically constitute audited financial statements or statutory accounts.\n\n"
                    "10.9. Users shall not make unauthorised financial entries, manipulate records or misuse the accounting facilities.\n\n"
                    "10.10. Any suspected financial irregularity, unauthorised transaction or accounting discrepancy shall be reported immediately to the concerned administrator.\n\n"
                    "10.11. The responsibility for the physical custody, banking arrangements and authorised operation of property funds shall remain with the association, property owner or designated financial authority.\n\n"
                    "10.12. STAYO shall not be treated as a bank, deposit-taking institution or financial custodian merely because it provides accounting or payment-recording facilities.\n\n"
                    "10.13. Where payment processing is facilitated through third-party payment gateways, the applicable payment service provider terms shall also apply.",
              ),

              // Section 11
              _buildSection(
                title: "11. COMPLAINT AND MAINTENANCE REQUEST MANAGEMENT",
                body: "11.1. STAYO may provide facilities for residents, owners and authorised users to register complaints and maintenance requests.\n\n"
                    "11.2. Complaints may relate to electrical issues, plumbing, water supply, lifts, common-area cleaning, security, housekeeping, equipment breakdowns, civil maintenance and other property-related concerns.\n\n"
                    "11.3. The application may classify complaints based on emergency, urgency, priority, nature of the issue and operational requirements.\n\n"
                    "11.4. The system may generate unique complaint reference numbers or tracking tokens for monitoring the progress of each issue.\n\n"
                    "11.5. The administrator or property manager may assign complaints to authorised staff, contractors or service providers.\n\n"
                    "11.6. Users shall provide accurate descriptions and relevant photographs or supporting information wherever possible.\n\n"
                    "11.7. The concerned property management team or assigned service provider shall be responsible for inspecting and resolving the physical issue.\n\n"
                    "11.8. STAYO facilitates complaint recording, tracking and coordination but does not independently perform physical repairs unless separately contracted to do so.\n\n"
                    "11.9. Emergency situations involving gas leakage, fire, electrical hazards, structural damage, medical emergencies or threats to life must be immediately reported to appropriate emergency services and responsible property personnel.\n\n"
                    "11.10. Users must not rely exclusively on application notifications for emergency response.\n\n"
                    "11.11. STAYO shall not guarantee resolution within a particular timeframe unless such commitment is expressly agreed under a separate service-level agreement.",
              ),

              // Section 12 to 17
              _buildSection(
                title: "12. STAFF AND SERVICE PROVIDER MANAGEMENT",
                body: "12.1. STAYO may provide facilities for recording and monitoring activities performed by security personnel, housekeeping staff, caretakers, technicians and other service providers.\n\n"
                    "12.2. Such facilities may include attendance records, duty allocation, task assignments, inspection checklists, performance reports and completion records.\n\n"
                    "12.3. Administrators may use the application to monitor service performance and maintain operational records.\n\n"
                    "12.4. The appointment, employment, remuneration, supervision, disciplinary action and termination of personnel shall remain the responsibility of the concerned employer, association or authorised management organisation.\n\n"
                    "12.5. The use of STAYO does not automatically create an employer-employee relationship between STAYO and personnel whose activities are recorded through the application.\n\n"
                    "12.6. Contractors and service providers shall remain responsible for performing their contractual obligations and complying with applicable laws.\n\n"
                    "12.7. Any dispute relating to staff employment, wages, attendance, misconduct or service-provider contracts shall be addressed by the concerned contracting or employing party.",
              ),

              _buildSection(
                title: "13. ASSET AND INVENTORY MANAGEMENT",
                body: "13.1. STAYO may provide facilities for recording, monitoring and maintaining registers of property assets, equipment, consumables, tools, spare parts and other inventory items.\n\n"
                    "13.2. Authorised users may record stock inward, stock outward, purchases, transfers, returns, consumption, adjustments and disposals.\n\n"
                    "13.3. Administrators may generate inventory reports, asset registers, purchase requests and stock alerts.\n\n"
                    "13.4. The property owner or association shall remain responsible for the physical verification, safekeeping, utilisation and maintenance of assets and inventory.\n\n"
                    "13.5. Digital inventory records shall be based on information entered by authorised users and should be periodically verified.\n\n"
                    "13.6. STAYO shall not be responsible for physical loss, theft, shortage or misuse of assets merely because the inventory is recorded in the application.",
              ),

              _buildSection(
                title: "14. NOTICES, ANNOUNCEMENTS AND COMMUNICATION",
                body: "14.1. STAYO may provide digital communication facilities for property-related notices, announcements, maintenance updates, emergency alerts, payment reminders and other relevant information.\n\n"
                    "14.2. Administrators and authorised representatives may publish notices and announcements to designated users.\n\n"
                    "14.3. Users may receive notifications through the application, SMS, email or other supported communication channels.\n\n"
                    "14.4. Users shall ensure that their contact details are accurate and updated.\n\n"
                    "14.5. STAYO shall not guarantee immediate delivery or receipt of notifications due to network interruptions, device settings or third-party communication service failures.\n\n"
                    "14.6. Official notices and decisions issued by an association shall remain subject to applicable association bye-laws, resolutions and governing documents.\n\n"
                    "14.7. Users shall not misuse communication facilities for harassment, defamatory content, spam, threats or unlawful activities.",
              ),

              _buildSection(
                title: "15. PROPERTY OWNER AND ASSOCIATION RESPONSIBILITIES",
                body: "15.1. Property owners and associations shall ensure that STAYO is used only by duly authorised individuals.\n\n"
                    "15.2. They shall ensure that property, resident, financial and operational information uploaded to the application is accurate and lawfully obtained.\n\n"
                    "15.3. They shall obtain the necessary approvals and permissions before activating relevant application features.\n\n"
                    "15.4. They shall establish appropriate procedures for visitor management, delivery handling, financial administration, maintenance operations and emergency response.\n\n"
                    "15.5. They shall ensure that financial transactions are properly authorised and recorded.\n\n"
                    "15.6. They shall periodically review user permissions and deactivate accounts of persons who are no longer authorised.\n\n"
                    "15.7. They shall ensure that the use of the application does not violate the legal rights or privacy of residents, tenants, employees or visitors.\n\n"
                    "15.8. They shall remain responsible for decisions taken by their office-bearers, employees and authorised representatives.\n\n"
                    "15.9. The association or property owner shall be responsible for ensuring that the use of the platform is consistent with applicable laws, association bye-laws and relevant contractual arrangements.",
              ),

              _buildSection(
                title: "16. RESPONSIBILITIES OF RESIDENTS AND TENANTS",
                body: "16.1. Residents and tenants shall provide accurate personal and occupancy information.\n\n"
                    "16.2. They shall use the application responsibly and comply with the applicable property rules.\n\n"
                    "16.3. They shall not share application credentials or confidential property information with unauthorised persons.\n\n"
                    "16.4. They shall respond to visitor approval requests and other property-related notifications where necessary.\n\n"
                    "16.5. They shall make applicable maintenance payments in accordance with the rules and agreements governing their occupancy.\n\n"
                    "16.6. They shall report maintenance issues, security concerns and other property-related problems through the appropriate channels.\n\n"
                    "16.7. They shall not misuse visitor management, delivery management, complaint management or communication facilities.\n\n"
                    "16.8. Residents and tenants shall respect the privacy and rights of other occupants.",
              ),

              _buildSection(
                title: "17. ROLE AND RESPONSIBILITIES OF STAYO",
                body: "17.1. STAYO is primarily a technology platform designed to facilitate digital property management, operational coordination, communication and financial record-keeping.\n\n"
                    "17.2. The Company shall make reasonable efforts to maintain the functionality, availability and security of the application.\n\n"
                    "17.3. The Company may provide technical assistance, software updates, application support and user guidance.\n\n"
                    "17.4. Unless expressly agreed under a separate written property management agreement, STAYO shall not automatically assume responsibility for the physical management or administration of a property merely because the property is registered on the application.\n\n"
                    "17.5. STAYO does not independently determine maintenance charges, association policies, expenditure approvals, resident obligations or property management decisions.\n\n"
                    "17.6. STAYO does not independently assume responsibility for physical security, employment of property staff, performance of contractors, custody of parcels or maintenance of physical assets merely by providing the corresponding digital facilities.\n\n"
                    "17.7. Where STAYO or an affiliated organisation separately undertakes physical property management services, such responsibilities shall be governed by the applicable service agreement.\n\n"
                    "17.8. The Company shall remain responsible for fulfilling its own contractual obligations and liabilities under applicable law.",
              ),

              // Section 18 to 22
              _buildSection(
                title: "18. SUBSCRIPTION, FEES AND PAYMENT TERMS",
                body: "18.1. STAYO may offer free and paid subscription plans depending on the features and services made available.\n\n"
                    "18.2. Subscription charges, renewal conditions, applicable taxes and additional service fees shall be communicated before subscription or renewal.\n\n"
                    "18.3. The subscription may be obtained by an individual property owner, association or authorised property management organisation.\n\n"
                    "18.4. The subscribing party shall be responsible for paying the applicable subscription charges within the prescribed timelines.\n\n"
                    "18.5. Non-payment may result in suspension or restriction of paid features after appropriate notice, subject to the applicable agreement.\n\n"
                    "18.6. Changes to subscription fees shall be communicated in advance.\n\n"
                    "18.7. Subscription fees shall be governed by the applicable subscription and refund policy.\n\n"
                    "18.8. Subscription payments made to STAYO shall be separate from maintenance charges collected by an association unless expressly agreed otherwise.",
              ),

              _buildSection(
                title: "19. DATA ACCURACY AND DIGITAL RECORDS",
                body: "19.1. STAYO provides a digital platform for recording and maintaining property management information.\n\n"
                    "19.2. The accuracy of records depends on the information submitted, entered, verified and updated by authorised users.\n\n"
                    "19.3. Administrators and users shall be responsible for reviewing financial entries, visitor records, delivery information, inventory records and maintenance reports.\n\n"
                    "19.4. The Company shall not be responsible for inaccuracies arising from false, incomplete or incorrect information entered by users.\n\n"
                    "19.5. Users shall not intentionally manipulate, falsify or delete digital records without appropriate authority.\n\n"
                    "19.6. STAYO may maintain system logs, transaction histories and backup records for security, operational and compliance purposes.\n\n"
                    "19.7. The Company shall make reasonable efforts to preserve digital records but cannot guarantee uninterrupted access to historical information in every circumstance.\n\n"
                    "19.8. Where records are used for financial reconciliation, audits or legal proceedings, users and administrators should retain appropriate supporting documents.",
              ),

              _buildSection(
                title: "20. PRIVACY AND PERSONAL DATA PROTECTION",
                body: "20.1. STAYO may collect and process personal information necessary for providing property management services.\n\n"
                    "20.2. Such information may include names, contact details, email addresses, property details, unit numbers, occupancy information, vehicle registration details, visitor information, delivery records, payment references and maintenance complaints.\n\n"
                    "20.3. Personal information shall be processed for legitimate purposes connected with property management, security, accounting, communication, technical support and service delivery.\n\n"
                    "20.4. Users and property administrators shall ensure that they have the necessary authority and lawful basis to submit personal information belonging to residents, tenants, visitors, employees and other individuals.\n\n"
                    "20.5. The Company shall adopt reasonable technical and organisational safeguards to protect personal information against unauthorised access, disclosure, alteration or destruction.\n\n"
                    "20.6. Users shall not download, share, copy or disclose personal information, financial records, visitor photographs or other confidential information without proper authority.\n\n"
                    "20.7. Personal information shall be retained in accordance with applicable legal requirements and the STAYO Privacy Policy.\n\n"
                    "20.8. Users may submit requests concerning access, correction, deletion or other data-related rights through the designated support channels, subject to applicable laws.\n\n"
                    "20.9. The processing of personal data shall be governed by the separate STAYO Privacy Policy and applicable Indian data protection legislation.",
              ),

              _buildSection(
                title: "21. INFORMATION SECURITY AND USER RESPONSIBILITY",
                body: "21.1. Users shall take reasonable precautions to safeguard their accounts and devices.\n\n"
                    "21.2. Users shall not share passwords, verification codes or authentication credentials.\n\n"
                    "21.3. Users shall immediately report suspected security breaches or unauthorised access.\n\n"
                    "21.4. Users shall not attempt to access the underlying database, software infrastructure or confidential information without permission.\n\n"
                    "21.5. STAYO may implement authentication, access controls, monitoring systems and other security measures to protect the application.\n\n"
                    "21.6. No digital system can guarantee absolute protection against every possible cyber threat. The Company shall make reasonable efforts to identify and address security vulnerabilities.",
              ),

              _buildSection(
                title: "22. INTELLECTUAL PROPERTY RIGHTS",
                body: "22.1. All rights relating to the STAYO name, logo, trademarks, software, application design, interface, graphics, content, databases and other proprietary materials shall belong to the Company or its respective licensors.\n\n"
                    "22.2. Users are granted a limited, non-exclusive, non-transferable right to access and use the application for its intended property management purposes.\n\n"
                    "22.3. Users shall not reproduce, copy, modify, distribute, reverse engineer or commercially exploit any part of the application without prior written permission.\n\n"
                    "22.4. Unauthorised use of the Company’s intellectual property may result in appropriate legal action.",
              ),

              // Section 23 to 27
              _buildSection(
                title: "23. PROHIBITED ACTIVITIES",
                body: "Users shall not:\n"
                    "a. Use STAYO for unlawful or fraudulent purposes.\n"
                    "b. Provide false or misleading property or personal information.\n"
                    "c. Access another user’s account without permission.\n"
                    "d. Manipulate maintenance collection or financial records.\n"
                    "e. Falsify visitor entry or exit records.\n"
                    "f. Misuse residents’ personal information or visitor photographs.\n"
                    "g. Disclose confidential financial or administrative information without authority.\n"
                    "h. Introduce malware or harmful software.\n"
                    "i. Attempt to compromise the security or functioning of the application.\n"
                    "j. Use the platform to harass, threaten or defraud other users.\n"
                    "k. Circumvent subscription, payment or access restrictions.\n"
                    "l. Misuse any application feature for personal gain or unauthorised commercial purposes.\n\n"
                    "Any violation may result in suspension of access and appropriate legal action.",
              ),

              _buildSection(
                title: "24. APPLICATION AVAILABILITY AND TECHNICAL INTERRUPTIONS",
                body: "24.1. STAYO shall make reasonable efforts to ensure the application remains accessible and functional.\n\n"
                    "24.2. The application may occasionally be unavailable due to maintenance, upgrades, server interruptions, network failures, cyber incidents or other technical circumstances.\n\n"
                    "24.3. The Company does not guarantee uninterrupted or error-free operation at all times.\n\n"
                    "24.4. The Company reserves the right to perform maintenance, security updates and software improvements.\n\n"
                    "24.5. Users are responsible for maintaining compatible devices, operating systems and internet connectivity.\n\n"
                    "24.6. The Company shall make reasonable efforts to restore interrupted services as soon as practicable.",
              ),

              _buildSection(
                title: "25. THIRD-PARTY SERVICES AND INTEGRATIONS",
                body: "25.1. STAYO may integrate with third-party service providers, including payment gateways, messaging platforms, cloud hosting providers and other technology services.\n\n"
                    "25.2. Such third-party services may be subject to separate terms, conditions and privacy policies.\n\n"
                    "25.3. The Company shall not be responsible for independent failures or interruptions caused by third-party services, except to the extent of its own legal responsibilities.\n\n"
                    "25.4. Users are advised to review the applicable third-party terms wherever necessary.",
              ),

              _buildSection(
                title: "26. LIMITATION OF LIABILITY",
                body: "26.1. STAYO shall make reasonable efforts to provide reliable digital property management services.\n\n"
                    "26.2. The Company shall not be liable for indirect or consequential losses arising from the use of the application, to the extent permitted by applicable law.\n\n"
                    "26.3. The Company shall not be responsible for service interruptions arising from circumstances beyond its reasonable control.\n\n"
                    "26.4. STAYO shall not be responsible for physical incidents, theft, accidents, disputes, financial misconduct or unauthorised activities merely because the relevant property uses the application.\n\n"
                    "26.5. The Company shall not be responsible for independent decisions, actions or omissions of property owners, associations, residents, employees, contractors or other service providers.\n\n"
                    "26.6. Nothing in these Terms shall exclude liability for fraud, wilful misconduct, negligence or any other liability that cannot legally be excluded or restricted.",
              ),

              _buildSection(
                title: "27. INDEMNIFICATION",
                body: "27.1. Users shall be responsible for losses, damages, claims or expenses arising directly from their unlawful actions, fraudulent conduct, intentional misconduct or material violation of these Terms.\n\n"
                    "27.2. Users shall not misuse the application in a manner that infringes the legal rights, privacy or interests of other users or third parties.\n\n"
                    "27.3. Where a user causes loss or damage through unauthorised access, manipulation of records, fraudulent activities or unlawful disclosure of information, the Company may take appropriate legal action in accordance with applicable law.\n\n"
                    "27.4. Any indemnification obligation shall be subject to applicable law and shall not restrict statutory consumer rights.",
              ),

              // Section 28 to 31
              _buildSection(
                title: "28. SUSPENSION AND TERMINATION",
                body: "28.1. STAYO reserves the right to suspend, restrict or terminate user access where there is fraudulent activity, misuse, unauthorised access or violation of these Terms.\n\n"
                    "28.2. The Company may temporarily suspend services for maintenance, security updates or technical reasons.\n\n"
                    "28.3. Property owners and associations may discontinue the use of STAYO in accordance with their applicable subscription or service agreement.\n\n"
                    "28.4. Users may request account deactivation through the available application settings or authorised support channels.\n\n"
                    "28.5. Account termination shall not automatically extinguish outstanding payment obligations, contractual responsibilities or unresolved legal claims.\n\n"
                    "28.6. Information required to be retained under applicable laws may be preserved for the legally prescribed period.",
              ),

              _buildSection(
                title: "29. FORCE MAJEURE",
                body: "29.1. The Company shall not be held responsible for delay or interruption in performing its obligations to the extent caused by circumstances beyond its reasonable control.\n\n"
                    "29.2. Such circumstances may include natural disasters, floods, fire, pandemics, government restrictions, civil disturbances, strikes, power failures, internet outages, cyber incidents or major infrastructure failures.\n\n"
                    "29.3. The Company shall make reasonable efforts to restore affected services and communicate material disruptions wherever practicable.",
              ),

              _buildSection(
                title: "30. AMENDMENTS TO TERMS AND CONDITIONS",
                body: "30.1. STAYO reserves the right to update or modify these Terms and Conditions from time to time.\n\n"
                    "30.2. Updated terms shall be published through the application or official website.\n\n"
                    "30.3. Material changes shall be communicated to registered users through appropriate notification channels wherever reasonably practicable.\n\n"
                    "30.4. Revised terms shall become effective from the stated effective date, subject to applicable law.\n\n"
                    "30.5. Continued use of the application after the revised terms become effective shall be subject to the updated terms to the extent permitted by law.",
              ),

              _buildSection(
                title: "31. GOVERNING LAW AND DISPUTE RESOLUTION",
                body: "31.1. These Terms and Conditions shall be governed by and interpreted in accordance with the laws of India.\n\n"
                    "31.2. Any dispute arising from the use of the STAYO application should initially be brought to the attention of the Company’s customer support or grievance redressal team.\n\n"
                    "31.3. The parties shall make reasonable efforts to resolve disputes amicably.\n\n"
                    "31.4. Where an amicable resolution is not possible, disputes may be referred to the competent courts or authorities in accordance with applicable Indian law.\n\n"
                    "31.5. Nothing in this clause shall restrict the statutory rights of consumers to approach the appropriate consumer dispute redressal commission or other competent authority.",
              ),

              // Section 32 - Contact & Grievance
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
                      "32. GRIEVANCE REDRESSAL AND CUSTOMER SUPPORT",
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF101C16),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "For any questions, complaints, technical difficulties, account-related concerns or issues regarding the use of STAYO, users may contact:\n\n"
                      "STAYO CUSTOMER SUPPORT\n"
                      "Phone: 9567345740\n"
                      "Email: ascentpmscare@gmail.com\n"
                      "Website: www.ascentpms.care\n"
                      "Registered Office: First floor, Krishnapriya, Ganapathy Kovil road, Vazhuthacaud, Trivandrum-14\n"
                      "Grievance Officer: Grievance Officer, Stayo\n\n"
                      "The Company shall endeavour to acknowledge and address complaints within the applicable statutory timelines.",
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color(0xFF374151),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Section 33 to 35
              _buildSection(
                title: "33. SEVERABILITY",
                body: "If any provision of these Terms and Conditions is held to be invalid, unlawful or unenforceable by a competent authority, such provision shall be modified or severed to the extent necessary, without affecting the validity and enforceability of the remaining provisions.",
              ),

              _buildSection(
                title: "34. ENTIRE AGREEMENT",
                body: "These Terms and Conditions, together with the applicable Privacy Policy, subscription terms and other policies published by STAYO, constitute the terms governing the use of the application.\n\n"
                    "Where a separate written agreement exists between STAYO and a property owner, association or management organisation, the specific terms of that agreement shall govern the services expressly covered by it in the event of an inconsistency.",
              ),

              _buildSection(
                title: "35. FINAL ACCEPTANCE AND USER CONSENT",
                body: "By registering, accessing or using the STAYO mobile application, the user confirms and acknowledges that:\n"
                    "1. They have read and understood these Terms and Conditions.\n"
                    "2. They agree to comply with the rules and policies applicable to their use of the application.\n"
                    "3. They shall provide accurate and authorised information.\n"
                    "4. They shall use the application responsibly and lawfully.\n"
                    "5. They understand the respective responsibilities of STAYO, property owners, associations, administrators and other authorised users.\n"
                    "6. They understand that STAYO is a digital property management platform and does not automatically assume responsibility for the physical, financial or administrative management of every property using the application.\n"
                    "7. They consent to the processing of their personal information in accordance with the STAYO Privacy Policy and applicable law.",
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

