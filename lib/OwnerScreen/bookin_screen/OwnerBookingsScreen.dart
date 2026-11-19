import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:property_care/OwnerScreen/Bottom_Screen/Home_screen/Provider/selectedPropertyProvider.dart'
    show selectedPropertyIdProvider;
import 'package:property_care/core/AuthService/AuthServiceProvider.dart'
    show dioProvider;
import 'package:property_care/core/Utils/showMessage.dart';
import 'package:property_care/core/constant/appColor.dart';

import '../../core/Data/Model/ResponseModel/OwnerBookingOverview.dart';
import 'provider/ownerBookingOverviewProvider.dart';

/// Earn n Care: Bookings & Rentals (owner sirf dekhta hai; entry / edit Admin karta hai)
class OwnerBookingsScreen extends ConsumerStatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  ConsumerState<OwnerBookingsScreen> createState() =>
      _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends ConsumerState<OwnerBookingsScreen> {
  String? _month; // YYYY-MM, null = is mahina
  String? _selectedDate; // YYYY-MM-DD

  static final NumberFormat _inr = NumberFormat.decimalPattern('en_IN');
  String _money(num v) => "₹ ${_inr.format(v.round())}";

  bool _downloading = false;

  // Custom report (From - To)
  BookingRangeReport? _report;
  String? _reportError;
  bool _reportLoading = false;
  String? _reportDownloading; // "pdf" | "excel" jab download chal raha ho

  // List: ek page par 10
  static const int _perPage = 10;
  int _page = 1;

  static String _iso(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  /// Mahine ka statement PDF download karke kholta hai (signed link, login ki zaroorat nahi)
  Future<void> _downloadStatement(String url, String month) async {
    if (_downloading) return;
    setState(() => _downloading = true);
    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/Booking_Statement_$month.pdf';
      await Dio().download(url, path);

      final file = File(path);
      final head = await file.openRead(0, 5).first;
      if (String.fromCharCodes(head) != '%PDF-') {
        showErrorSnackBar(
          "Could not generate the statement. Please try again.",
        );
        return;
      }
      final result = await OpenFilex.open(path);
      if (result.type == ResultType.noAppToOpen) {
        showErrorSnackBar(
          "No app found to open PDF files. Please install a PDF viewer.",
        );
      } else if (result.type != ResultType.done) {
        showErrorSnackBar("Could not open the statement: ${result.message}");
      }
    } catch (e) {
      showErrorSnackBar("Could not download the statement. Please try again.");
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _shiftMonth(String currentMonth, int delta) {
    final parts = currentMonth.split("-");
    if (parts.length != 2) return;
    final y = int.tryParse(parts[0]) ?? DateTime.now().year;
    final m = int.tryParse(parts[1]) ?? DateTime.now().month;
    final d = DateTime(y, m + delta, 1);
    setState(() {
      _selectedDate = null;
      _page = 1;
      _month = "${d.year}-${d.month.toString().padLeft(2, '0')}";
    });
  }

  /// Mahina + saal chuno (kisi bhi saal par seedha jao)
  Future<void> _pickMonthYear(String currentMonth) async {
    final parts = currentMonth.split("-");
    final now = DateTime.now();
    int year = parts.length == 2
        ? (int.tryParse(parts[0]) ?? now.year)
        : now.year;
    final curMonth = parts.length == 2
        ? (int.tryParse(parts[1]) ?? now.month)
        : now.month;
    final years = <int>[for (int y = now.year - 5; y <= now.year + 2; y++) y];
    if (!years.contains(year)) {
      years.add(year);
      years.sort();
    }
    const names = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];

    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose month",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.heading,
                ),
              ),
              DropdownButton<int>(
                value: year,
                underline: const SizedBox.shrink(),
                items: years
                    .map(
                      (y) => DropdownMenuItem(
                        value: y,
                        child: Text(
                          "$y",
                          style: GoogleFonts.outfit(
                            fontSize: 17.sp,
                            color: AppColors.heading,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setD(() => year = v ?? year),
              ),
            ],
          ),
          content: SizedBox(
            width: 300.w,
            child: Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: List.generate(12, (i) {
                final selected =
                    parts.length == 2 &&
                    year == (int.tryParse(parts[0]) ?? 0) &&
                    curMonth == i + 1;
                return ChoiceChip(
                  label: SizedBox(
                    width: 44.w,
                    child: Center(child: Text(names[i])),
                  ),
                  selected: selected,
                  selectedColor: AppColors.accentGold.withValues(alpha: 0.35),
                  backgroundColor: Colors.white,
                  labelStyle: GoogleFonts.outfit(
                    fontSize: 15.sp,
                    color: AppColors.heading,
                  ),
                  onSelected: (_) => Navigator.pop(
                    ctx,
                    "$year-${(i + 1).toString().padLeft(2, '0')}",
                  ),
                );
              }),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                "Cancel",
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  color: AppColors.heading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedDate = null;
        _page = 1;
        _month = picked;
      });
    }
  }

  /// From - To chuno (calendar se) aur report lao
  Future<void> _chooseRange() async {
    final now = DateTime.now();
    final initial = _report != null
        ? DateTimeRange(
            start:
                DateTime.tryParse(_report!.from) ??
                DateTime(now.year, now.month, 1),
            end:
                DateTime.tryParse(_report!.to) ??
                DateTime(now.year, now.month + 1, 0),
          )
        : DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: DateTime(now.year, now.month + 1, 0),
          );
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5, 1, 1),
      lastDate: DateTime(now.year + 2, 12, 31),
      initialDateRange: initial,
      helpText: "Choose report dates",
      saveText: "Show",
    );
    if (range != null) {
      await _loadReport(_iso(range.start), _iso(range.end));
    }
  }

  Future<void> _loadReport(String from, String to) async {
    setState(() {
      _reportLoading = true;
      _reportError = null;
    });
    try {
      final r = await fetchOwnerBookingReport(
        ref.read(dioProvider),
        ref.read(selectedPropertyIdProvider),
        from,
        to,
      );
      if (!mounted) return;
      setState(() {
        _report = r;
        _selectedDate = null;
        _page = 1;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _report = null;
        _reportError = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      if (mounted) setState(() => _reportLoading = false);
    }
  }

  /// Report PDF / Excel download karke kholo. Server par zip na ho to Excel ki jagah CSV aata hai - wo bhi khul jaata hai.
  Future<void> _downloadReport(String url, String kind) async {
    if (_reportDownloading != null || _report == null) return;
    setState(() => _reportDownloading = kind);
    try {
      final dir = await getTemporaryDirectory();
      final base = "Booking_Report_${_report!.from}_to_${_report!.to}";
      final tmp = '${dir.path}/$base.download';
      await Dio().download(url, tmp);

      final file = File(tmp);
      final head = await file
          .openRead(0, 5)
          .fold<List<int>>(<int>[], (a, b) => a..addAll(b));
      final sig = String.fromCharCodes(head);
      String? ext;
      if (kind == "pdf" && sig.startsWith('%PDF-')) {
        ext = "pdf";
      } else if (kind == "excel" && sig.startsWith('PK')) {
        ext = "xlsx";
      } else if (kind == "excel" &&
          head.isNotEmpty &&
          !sig.trimLeft().startsWith('<')) {
        ext = "csv";
      }
      if (ext == null) {
        showErrorSnackBar(
          "Could not generate the file. Please tap Show again and retry.",
        );
        return;
      }
      final path = '${dir.path}/$base.$ext';
      await file.rename(path);
      final result = await OpenFilex.open(path);
      if (result.type == ResultType.noAppToOpen) {
        showErrorSnackBar(
          ext == "pdf"
              ? "No app found to open PDF files. Please install a PDF viewer."
              : "No app found to open Excel files. Please install Excel or Google Sheets.",
        );
      } else if (result.type != ResultType.done) {
        showErrorSnackBar("Could not open the file: ${result.message}");
      }
    } catch (e) {
      showErrorSnackBar(
        "Could not download the file. Please tap Show again and retry.",
      );
    } finally {
      if (mounted) setState(() => _reportDownloading = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ownerBookingOverviewProvider(_month));

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
              SizedBox(width: 10.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bookings & Rentals",
                    style: GoogleFonts.outfit(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff292832),
                      letterSpacing: -0.64,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Bookings, rentals and payouts",
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
      body: state.when(
        loading: () =>
            Center(child: CircularProgressIndicator(color: AppColors.heading)),
        error: (e, _) => Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  e.toString().replaceFirst("Exception: ", ""),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 17.sp,
                    color: const Color(0xFF777777),
                  ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(ownerBookingOverviewProvider(_month)),
                  child: Text(
                    "Retry",
                    style: GoogleFonts.outfit(
                      fontSize: 17.sp,
                      color: AppColors.heading,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (data) => _buildBody(data),
      ),
    );
  }

  Widget _buildBody(OwnerBookingOverview data) {
    final s = data.summary;
    final r = _report;
    // List: Custom report ho to uski bookings; warna mahine ki (date chuni ho to us din ki)
    final rows = r != null
        ? r.bookings
        : (_selectedDate == null
              ? data.bookings
              : data.bookings
                    .where((b) => b.coversDate(_selectedDate!))
                    .toList());
    final pages = rows.isEmpty ? 1 : ((rows.length + _perPage - 1) ~/ _perPage);
    final page = _page.clamp(1, pages);
    final start = (page - 1) * _perPage;
    final pageRows = rows.skip(start).take(_perPage).toList();

    final title = r != null
        ? "Custom report • ${r.rangeLabel}"
        : (_selectedDate == null
              ? "Bookings • ${s.monthLabel}"
              : "Bookings on $_selectedDate");

    return RefreshIndicator(
      color: AppColors.heading,
      onRefresh: () async {
        ref.invalidate(ownerBookingOverviewProvider(_month));
        await ref.read(ownerBookingOverviewProvider(_month).future);
      },
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 30.h),
        children: [
          _statGrid(s, data.lifetime),
          SizedBox(height: 16.h),
          _calendarCard(s, data.days),
          // Listing ("Listed on") abhi band hai - wapas chalu karne ke liye: _listingsCard(data.listings),
          SizedBox(height: 16.h),
          // Custom report (calendar ke turant baad) - bookings neeche wali list me
          _rangeReportCard(),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.heading,
                  ),
                ),
              ),
              if (r != null || _selectedDate != null)
                GestureDetector(
                  onTap: () => setState(() {
                    _report = null;
                    _selectedDate = null;
                    _page = 1;
                  }),
                  child: Text(
                    r != null ? "Back to ${s.monthLabel}" : "Show all",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      color: AppColors.accentGold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          ),
          if (r != null) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                _fileButton(
                  "PDF",
                  Icons.picture_as_pdf_outlined,
                  r.pdfUrl,
                  "pdf",
                ),
                SizedBox(width: 10.w),
                _fileButton(
                  "Excel",
                  Icons.table_chart_outlined,
                  r.excelUrl,
                  "excel",
                ),
              ],
            ),
          ] else if (data.statementDownloadUrl != null) ...[
            SizedBox(height: 10.h),
            GestureDetector(
              onTap: () =>
                  _downloadStatement(data.statementDownloadUrl!, s.month),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.heading),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_downloading)
                      SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.heading,
                        ),
                      )
                    else
                      Icon(
                        Icons.picture_as_pdf_outlined,
                        size: 18.sp,
                        color: AppColors.heading,
                      ),
                    SizedBox(width: 8.w),
                    Text(
                      "Download ${s.monthLabel} statement (PDF)",
                      style: GoogleFonts.outfit(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.heading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          SizedBox(height: 10.h),
          if (rows.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  r != null
                      ? "No bookings with check-in in this period."
                      : (_selectedDate == null
                            ? "No bookings this month."
                            : "No booking on this date."),
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    color: const Color(0xFF777777),
                  ),
                ),
              ),
            )
          else ...[
            ...pageRows.map(_bookingCard),
            _pager(page, pages, start, rows.length),
          ],
        ],
      ),
    );
  }

  /// "Showing 1–10 of 23"  < 1 2 3 >
  Widget _pager(int page, int pages, int start, int total) {
    Widget btn(Widget child, VoidCallback? onTap, {bool active = false}) =>
        GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minWidth: 34.w),
            height: 34.h,
            margin: EdgeInsets.only(left: 6.w),
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: active ? AppColors.heading : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.15)),
            ),
            child: DefaultTextStyle(
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: active
                    ? Colors.white
                    : (onTap == null
                          ? const Color(0x55101C16)
                          : AppColors.heading),
              ),
              child: child,
            ),
          ),
        );

    // Zyada pages ho to: 1 ... (page-1) page (page+1) ... last
    final nums = <int>[];
    for (int i = 1; i <= pages; i++) {
      if (pages <= 5 || i == 1 || i == pages || (i - page).abs() <= 1)
        nums.add(i);
    }
    final items = <Widget>[];
    for (int k = 0; k < nums.length; k++) {
      if (k > 0 && nums[k] - nums[k - 1] > 1) {
        items.add(
          Padding(
            padding: EdgeInsets.only(left: 6.w),
            child: const Text("…"),
          ),
        );
      }
      final n = nums[k];
      items.add(
        btn(
          Text("$n"),
          n == page ? null : () => setState(() => _page = n),
          active: n == page,
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Showing ${start + 1}–${(start + _perPage).clamp(0, total)} of $total",
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                color: const Color(0xFF777777),
              ),
            ),
          ),
          if (pages > 1) ...[
            btn(
              Icon(
                Icons.chevron_left,
                size: 18.sp,
                color: page == 1 ? const Color(0x55101C16) : AppColors.heading,
              ),
              page == 1 ? null : () => setState(() => _page = page - 1),
            ),
            ...items,
            btn(
              Icon(
                Icons.chevron_right,
                size: 18.sp,
                color: page == pages
                    ? const Color(0x55101C16)
                    : AppColors.heading,
              ),
              page == pages ? null : () => setState(() => _page = page + 1),
            ),
          ],
        ],
      ),
    );
  }

  Widget _quickChip(String label, DateTime from, DateTime to) {
    return ActionChip(
      label: Text(
        label,
        style: GoogleFonts.outfit(fontSize: 14.sp, color: AppColors.heading),
      ),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Color.fromRGBO(0, 0, 0, 0.2)),
      onPressed: _reportLoading
          ? null
          : () => _loadReport(_iso(from), _iso(to)),
    );
  }

  Widget _fileButton(String label, IconData icon, String? url, String kind) {
    final busy = _reportDownloading == kind;
    return Expanded(
      child: GestureDetector(
        onTap: url == null ? null : () => _downloadReport(url, kind),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            border: Border.all(
              color: kind == "excel" ? AppColors.green : AppColors.heading,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (busy)
                SizedBox(
                  width: 16.w,
                  height: 16.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.heading,
                  ),
                )
              else
                Icon(
                  icon,
                  size: 18.sp,
                  color: kind == "excel" ? AppColors.green : AppColors.heading,
                ),
              SizedBox(width: 6.w),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: kind == "excel" ? AppColors.green : AppColors.heading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom report: From - To chuno, data dekho, PDF / Excel download
  Widget _rangeReportCard() {
    final now = DateTime.now();
    final r = _report;
    return _box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Custom report",
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Choose dates to see bookings with check-in in that period. They show in the list below with PDF / Excel download.",
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: const Color(0xFF777777),
            ),
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: _reportLoading ? null : _chooseRange,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.heading,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_reportLoading)
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  else
                    Icon(Icons.date_range, size: 18.sp, color: Colors.white),
                  SizedBox(width: 8.w),
                  Text(
                    r == null
                        ? "Choose From - To dates"
                        : "Change dates (${r.rangeLabel})",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: [
              _quickChip(
                "This month",
                DateTime(now.year, now.month, 1),
                DateTime(now.year, now.month + 1, 0),
              ),
              _quickChip(
                "Last month",
                DateTime(now.year, now.month - 1, 1),
                DateTime(now.year, now.month, 0),
              ),
              _quickChip(
                "This year",
                DateTime(now.year, 1, 1),
                DateTime(now.year, 12, 31),
              ),
            ],
          ),
          if (_reportError != null) ...[
            SizedBox(height: 10.h),
            Text(
              _reportError!,
              style: GoogleFonts.outfit(fontSize: 14.sp, color: AppColors.red),
            ),
          ],
          if (r != null) ...[
            SizedBox(height: 14.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "${r.rangeLabel} (${r.daysInRange} days)",
                    style: GoogleFonts.outfit(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.heading,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() {
                    _report = null;
                    _page = 1;
                  }),
                  child: Text(
                    "Clear",
                    style: GoogleFonts.outfit(
                      fontSize: 15.sp,
                      color: AppColors.accentGold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _statTile(
                    "Bookings",
                    "${r.totalBookings}",
                    r.cancelled > 0
                        ? "${r.cancelled} cancelled"
                        : "Rental ${r.rentalBookings} • JV ${r.jvBookings}",
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _statTile(
                    "Nights booked",
                    "${r.bookedNights} / ${r.daysInRange}",
                    "${r.occupancyPercent}% occupancy",
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _statTile(
                    "Your earning",
                    _money(r.ownerShare),
                    "Booking value ${_money(r.grossAmount)}",
                    valueColor: AppColors.green,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _statTile(
                    "Payout pending",
                    _money(r.pendingAmount),
                    "Paid ${_money(r.paidAmount)}",
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _box({required Widget child, Color? color, Color? border}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardBg,
        border: Border.all(
          color: border ?? const Color.fromRGBO(0, 0, 0, 0.15),
        ),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }

  Widget _statTile(
    String label,
    String value,
    String sub, {
    Color? valueColor,
  }) {
    return _box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              color: const Color(0xFF777777),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.heading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            sub,
            style: GoogleFonts.outfit(
              fontSize: 13.sp,
              color: const Color(0xFF777777),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statGrid(BookingSummary s, BookingLifetime life) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _statTile(
                "Bookings",
                "${s.totalBookings}",
                "Rental ${s.rentalBookings} • JV ${s.jvBookings}",
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _statTile(
                "Nights booked",
                "${s.bookedNights} / ${s.daysInMonth}",
                "${s.occupancyPercent}% occupancy",
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _statTile(
                "Your earning",
                _money(s.ownerShare),
                "Booking value ${_money(s.grossAmount)}",
                valueColor: AppColors.green,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _statTile(
                "Payout pending",
                _money(s.pendingAmount),
                "Paid ${_money(s.paidAmount)}",
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _calendarCard(BookingSummary s, List<BookingDay> days) {
    const dow = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    int lead = 0;
    if (days.isNotEmpty) {
      final first = DateTime.tryParse(days.first.date);
      if (first != null) lead = first.weekday % 7; // Sunday = 0
    }
    final cells = <Widget>[
      ...dow.map(
        (d) => Center(
          child: Text(
            d,
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              color: const Color(0xFF777777),
            ),
          ),
        ),
      ),
      ...List.generate(lead, (_) => const SizedBox.shrink()),
      ...days.map((d) {
        final selected = _selectedDate == d.date;
        return GestureDetector(
          onTap: () => setState(() {
            // Date chuni -> list us din ki bookings (Custom report se bahar)
            _selectedDate = selected ? null : d.date;
            if (_selectedDate != null) _report = null;
            _page = 1;
          }),
          child: Container(
            margin: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: d.isBooked
                  ? AppColors.accentGold.withValues(alpha: 0.55)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: selected
                    ? AppColors.heading
                    : d.isToday
                    ? const Color(0xFF0B8BB0)
                    : const Color.fromRGBO(0, 0, 0, 0.15),
                width: (selected || d.isToday) ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                "${d.day}",
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: d.isBooked ? FontWeight.w700 : FontWeight.w400,
                  color: AppColors.heading,
                ),
              ),
            ),
          ),
        );
      }),
    ];

    return _box(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => _shiftMonth(s.month, -1),
                icon: const Icon(Icons.chevron_left),
              ),
              // Tap karke mahina + saal chuno
              InkWell(
                borderRadius: BorderRadius.circular(8.r),
                onTap: () => _pickMonthYear(s.month),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        s.monthLabel,
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.expand_more,
                        size: 20.sp,
                        color: AppColors.heading,
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _shiftMonth(s.month, 1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: cells,
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.55),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                "Booked",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: const Color(0xFF777777),
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0B8BB0), width: 2),
                  borderRadius: BorderRadius.circular(3.r),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                "Today",
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: const Color(0xFF777777),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _listingsCard(List<BookingListing> listings) {
    return _box(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Listed on",
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.heading,
            ),
          ),
          SizedBox(height: 8.h),
          if (listings.isEmpty)
            Text(
              "Your property is not listed on any platform yet.",
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                color: const Color(0xFF777777),
              ),
            )
          else
            ...listings.map(
              (l) => Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.platformLabel,
                            style: GoogleFonts.outfit(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.heading,
                            ),
                          ),
                          if (l.title != null && l.title!.isNotEmpty)
                            Text(
                              l.title!,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                color: const Color(0xFF777777),
                              ),
                            ),
                        ],
                      ),
                    ),
                    _pill(
                      l.statusLabel,
                      l.status == "active" ? AppColors.green : AppColors.amber,
                    ),
                    if (l.url != null && l.url!.isNotEmpty)
                      IconButton(
                        tooltip: "Copy link",
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: l.url!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Listing link copied"),
                            ),
                          );
                        },
                        icon: Icon(Icons.copy, size: 18.sp),
                      ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _pill(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 13.sp,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _bookingCard(OwnerBooking b) {
    final statusColor = b.status == "ongoing"
        ? AppColors.green
        : b.status == "cancelled"
        ? AppColors.red
        : b.status == "upcoming"
        ? const Color(0xFF0B8BB0)
        : const Color(0xFF777777);
    final payoutColor = b.payoutStatus == "paid"
        ? AppColors.green
        : b.payoutStatus == "cancelled"
        ? const Color(0xFF777777)
        : AppColors.amber;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: _box(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${b.checkInLabel} → ${b.checkOutLabel}",
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.heading,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        "${b.reference} • ${b.nights} night${b.nights == 1 ? '' : 's'} • ${b.sourceLabel} • ${b.bookingTypeLabel}${b.bookingType == 'joint_venture' ? ' (${b.ownerPercent.toStringAsFixed(b.ownerPercent % 1 == 0 ? 0 : 2)}%)' : ''}",
                        style: GoogleFonts.outfit(
                          fontSize: 13.sp,
                          color: const Color(0xFF777777),
                        ),
                      ),
                    ],
                  ),
                ),
                _pill(b.statusLabel, statusColor),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(child: _kv("Booking value", _money(b.grossAmount))),
                Expanded(
                  child: _kv("Fees", _money(b.platformFee + b.managementFee)),
                ),
                Expanded(
                  child: _kv(
                    "Your share",
                    _money(b.ownerShare),
                    color: AppColors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Text(
                  "Payout  ",
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    color: const Color(0xFF777777),
                  ),
                ),
                _pill(b.payoutStatusLabel, payoutColor),
                if (b.payoutDate != null)
                  Padding(
                    padding: EdgeInsets.only(left: 8.w),
                    child: Text(
                      b.payoutDate!,
                      style: GoogleFonts.outfit(
                        fontSize: 13.sp,
                        color: const Color(0xFF777777),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String v, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          k,
          style: GoogleFonts.outfit(
            fontSize: 13.sp,
            color: const Color(0xFF777777),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          v,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.heading,
          ),
        ),
      ],
    );
  }
}
