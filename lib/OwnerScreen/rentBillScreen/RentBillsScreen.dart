import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:property_care/core/constant/appColor.dart';

import '../../core/Data/Model/ResponseModel/rentBillsModel.dart';
import '../Tenant_Management_Screen/widget/TenantAvatar.dart';
import 'rentBillsProvider.dart';

/// Rent & Bills (owner sirf dekhta hai): chuni hui property ka rent + saare bills.
/// Bill property ka hai - khaali property / owner khud rehta ho tab bhi bills dikhte hain.
class RentBillsScreen extends ConsumerStatefulWidget {
  const RentBillsScreen({super.key});

  @override
  ConsumerState<RentBillsScreen> createState() => _RentBillsScreenState();
}

class _RentBillsScreenState extends ConsumerState<RentBillsScreen> {
  String _rentFilter = ""; // "" | unpaid | overdue | paid
  String _billFilter = "";
  String _payerFilter = ""; // "" | tenant | owner
  int _rentShown = 6;
  int _billShown = 8;

  static const _gold = Color(0xffAE8130);
  static const _green = Color(0xFF24B06A);
  static const _red = Color(0xFFD41F1F);
  static const _muted = Color.fromRGBO(42, 41, 51, 0.6);

  String _inr(num v) {
    final neg = v < 0;
    final fixed = v.abs().toStringAsFixed(v % 1 == 0 ? 0 : 2);
    final parts = fixed.split('.');
    var whole = parts[0];
    // Indian grouping: 12,34,567
    if (whole.length > 3) {
      final last3 = whole.substring(whole.length - 3);
      var rest = whole.substring(0, whole.length - 3);
      final groups = <String>[];
      while (rest.length > 2) {
        groups.insert(0, rest.substring(rest.length - 2));
        rest = rest.substring(0, rest.length - 2);
      }
      if (rest.isNotEmpty) groups.insert(0, rest);
      whole = "${groups.join(',')},$last3";
    }
    return "${neg ? '-' : ''}₹$whole${parts.length > 1 ? '.${parts[1]}' : ''}";
  }

  TextStyle _t(double size, {FontWeight w = FontWeight.w500, Color? c}) =>
      GoogleFonts.outfit(
        fontSize: size.sp,
        fontWeight: w,
        color: c ?? AppColors.heading,
        letterSpacing: -0.2,
      );

  Color _statusColor(String s) =>
      s == "paid" ? _green : (s == "overdue" ? _red : _gold);

  Widget _statusPill(String status, String label) {
    final c = _statusColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        border: Border.all(color: c.withOpacity(0.45)),
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Text(label, style: _t(13, c: c)),
    );
  }

  BoxDecoration get _card => BoxDecoration(
    color: Colors.white,
    border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.15)),
    borderRadius: BorderRadius.circular(12.r),
  );

  Widget _chips(
    List<List<String>> options,
    String value,
    ValueChanged<String> onTap,
  ) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: options.map((o) {
        final selected = o[0] == value;
        return GestureDetector(
          onTap: () => onTap(o[0]),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.heading : Colors.white,
              border: Border.all(
                color: selected
                    ? AppColors.heading
                    : const Color.fromRGBO(0, 0, 0, 0.2),
              ),
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Text(
              o[1],
              style: _t(13, c: selected ? Colors.white : AppColors.heading),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _totalCard(String label, String value, String sub, Color color) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: _card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _t(13, c: _muted)),
          SizedBox(height: 6.h),
          Text(
            value,
            style: _t(22, w: FontWeight.w600, c: color),
          ),
          SizedBox(height: 4.h),
          Text(sub, style: _t(12, c: _muted)),
        ],
      ),
    );
  }

  Widget _summary(RbTotals t) {
    return Column(
      children: [
        _totalCard(
          "Rent due",
          _inr(t.rentDue),
          t.rentDueMonths > 0
              ? "${t.rentDueMonths} month${t.rentDueMonths == 1 ? '' : 's'} unpaid"
              : "All rent paid",
          t.rentDue > 0 ? _red : _green,
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: _totalCard(
                "Bills · Tenant pays",
                _inr(t.billsDueTenant),
                "By the tenant",
                t.billsDueTenant > 0 ? _gold : AppColors.heading,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _totalCard(
                "Bills · You pay",
                _inr(t.billsDueOwner),
                "Charged to you",
                t.billsDueOwner > 0 ? _red : AppColors.heading,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _info(String k, String v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: _t(12, c: _muted)),
        SizedBox(height: 3.h),
        Text(v, style: _t(15)),
      ],
    );
  }

  Widget _tenantCard(RbTenant? t, RbProperty p) {
    if (t == null) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: _card,
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xffEDEEF0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_off_outlined,
                color: _muted,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("No current tenant", style: _t(16)),
                  SizedBox(height: 3.h),
                  Text(
                    p.occupancy == "owner"
                        ? "You are shown as living here. Bills charged to you are listed below."
                        : "The property is vacant right now. Bills charged to you are listed below.",
                    style: _t(13, c: _muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: _card,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TenantAvatar(name: t.name, imageUrl: t.imageUrl, size: 46.w),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _t(17),
                    ),
                    Text(t.tenantType, style: _t(13, c: _muted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _statusPill(t.rentStatus, "Rent: ${t.rentStatusLabel}"),
                  if (t.isDefaulter) ...[
                    SizedBox(height: 4.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _red,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      child: Text("Defaulter", style: _t(11, c: Colors.white)),
                    ),
                  ],
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: const Divider(
              height: 1,
              color: Color.fromRGBO(0, 0, 0, 0.1),
            ),
          ),
          Row(
            children: [
              Expanded(child: _info("Monthly rent", _inr(t.monthlyRent))),
              Expanded(child: _info("Next due date", t.nextDueDate ?? "-")),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _info(
                  "Lease",
                  "${t.leaseStart ?? '-'} → ${t.leaseEnd ?? '-'}",
                ),
              ),
              Expanded(child: _info("Phone", t.phone ?? "-")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: _t(18)),
        SizedBox(height: 3.h),
        Text(sub, style: _t(13, c: _muted)),
      ],
    );
  }

  Widget _empty(String text) => Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 14.w),
    decoration: _card,
    alignment: Alignment.center,
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: _t(14, c: _muted),
    ),
  );

  Widget _moreButton(int left, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 4.h),
      padding: EdgeInsets.symmetric(vertical: 10.h),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.heading),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text("Show $left more", style: _t(14)),
    ),
  );

  Widget _rentTile(RbRentRow r) {
    final sub = r.status == "paid"
        ? (r.paidOn != null ? "Paid on ${r.paidOn}" : "Paid")
        : (r.daysLate > 0
              ? "Due ${r.dueDate ?? '-'} · ${r.daysLate} days ago"
              : "Due ${r.dueDate ?? '-'}");
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: _card,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r.month, style: _t(15)),
                SizedBox(height: 2.h),
                Text(
                  [if (r.tenantName != null) r.tenantName!, sub].join(" · "),
                  style: _t(12, c: _muted),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_inr(r.amount), style: _t(15, w: FontWeight.w600)),
              SizedBox(height: 4.h),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (r.isDefaulter) ...[
                    Text("Defaulter", style: _t(11, c: _red)),
                    SizedBox(width: 6.w),
                  ],
                  _statusPill(r.status, r.statusLabel),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _billIcon(String type) {
    switch (type) {
      case "electricity":
        return Icons.bolt_outlined;
      case "water":
        return Icons.water_drop_outlined;
      case "gas":
        return Icons.local_fire_department_outlined;
      case "repair":
        return Icons.handyman_outlined;
      case "cleaning":
        return Icons.cleaning_services_outlined;
      case "damage":
        return Icons.report_problem_outlined;
      default:
        return Icons.receipt_long_outlined;
    }
  }

  Widget _billTile(RbBill b) {
    final sub = b.status == "paid"
        ? (b.paidOn != null ? "Paid on ${b.paidOn}" : "Paid")
        : (b.status == "overdue"
              ? "Due ${b.dueDate ?? '-'} · ${b.daysLate} days late"
              : "Due ${b.dueDate ?? '-'}");
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: _card,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(_billIcon(b.type), color: _gold, size: 20.sp),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(b.typeLabel, style: _t(15)),
                if (b.extraTitle != null)
                  Text(
                    b.extraTitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: _t(12, c: _muted),
                  ),
                SizedBox(height: 2.h),
                Text("${b.month} · $sub", style: _t(12, c: _muted)),
                SizedBox(height: 6.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: b.isOwner
                        ? AppColors.heading
                        : const Color(0xffEDEEF0),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Text(
                    b.isOwner
                        ? "You pay"
                        : "Tenant pays${b.tenantName != null ? ' · ${b.tenantName}' : ''}",
                    style: _t(
                      11,
                      c: b.isOwner ? Colors.white : AppColors.heading,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_inr(b.amount), style: _t(15, w: FontWeight.w600)),
              SizedBox(height: 4.h),
              _statusPill(b.status, b.statusLabel),
            ],
          ),
        ],
      ),
    );
  }

  Widget _body(RentBillsData d) {
    final rent = _rentFilter.isEmpty
        ? d.rentHistory
        : d.rentHistory.where((r) => r.status == _rentFilter).toList();
    final bills = d.bills
        .where(
          (b) =>
              (_billFilter.isEmpty || b.status == _billFilter) &&
              (_payerFilter.isEmpty || b.paidBy == _payerFilter),
        )
        .toList();
    int cnt(List list, String s) =>
        list.where((e) => (e as dynamic).status == s).length;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 30.h),
      children: [
        _summary(d.totals),
        SizedBox(height: 14.h),
        _tenantCard(d.tenant, d.property),
        SizedBox(height: 24.h),
        _sectionTitle(
          "Rent",
          "Bill on the 5th, due by the 15th. Unpaid after the 15th = Overdue; 60 days after the bill date = Defaulter.",
        ),
        SizedBox(height: 10.h),
        _chips(
          [
            ["", "All ${d.rentHistory.length}"],
            ["unpaid", "Unpaid ${cnt(d.rentHistory, 'unpaid')}"],
            ["overdue", "Overdue ${cnt(d.rentHistory, 'overdue')}"],
            ["paid", "Paid ${cnt(d.rentHistory, 'paid')}"],
          ],
          _rentFilter,
          (v) => setState(() {
            _rentFilter = v;
            _rentShown = 6;
          }),
        ),
        SizedBox(height: 10.h),
        if (rent.isEmpty)
          _empty(
            d.rentHistory.isEmpty
                ? "No rent yet."
                : "Nothing here for this filter.",
          )
        else ...[
          ...rent.take(_rentShown).map(_rentTile),
          if (rent.length > _rentShown)
            _moreButton(
              rent.length - _rentShown,
              () => setState(() => _rentShown += 10),
            ),
        ],
        SizedBox(height: 24.h),
        _sectionTitle(
          "Bills & Charges",
          "Electricity, water, gas, repairs and other charges. Past the due date = Overdue.",
        ),
        SizedBox(height: 10.h),
        _chips(
          [
            ["", "All ${d.bills.length}"],
            ["unpaid", "Unpaid ${cnt(d.bills, 'unpaid')}"],
            ["overdue", "Overdue ${cnt(d.bills, 'overdue')}"],
            ["paid", "Paid ${cnt(d.bills, 'paid')}"],
          ],
          _billFilter,
          (v) => setState(() {
            _billFilter = v;
            _billShown = 8;
          }),
        ),
        SizedBox(height: 8.h),
        _chips(
          [
            ["", "Who pays: All"],
            ["tenant", "Tenant pays"],
            ["owner", "You pay"],
          ],
          _payerFilter,
          (v) => setState(() {
            _payerFilter = v;
            _billShown = 8;
          }),
        ),
        SizedBox(height: 10.h),
        if (bills.isEmpty)
          _empty(
            d.bills.isEmpty
                ? "No bills for this property yet."
                : "Nothing here for this filter.",
          )
        else ...[
          ...bills.take(_billShown).map(_billTile),
          if (bills.length > _billShown)
            _moreButton(
              bills.length - _billShown,
              () => setState(() => _billShown += 10),
            ),
        ],
        SizedBox(height: 16.h),
        Text(
          "Rent and bills are managed by the Home Care team. Contact them if something looks wrong.",
          style: _t(12, c: _muted),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(rentBillsProvider);
    final subtitle = state.valueOrNull?.property;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        surfaceTintColor: AppColors.scaffoldBg,
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
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Rent & Bills", style: _t(18)),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle == null
                        ? "Rent and bills for your property"
                        : "${subtitle.name}${subtitle.occupancyLabel != null ? ' · ${subtitle.occupancyLabel}' : ''}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: _t(15, c: _muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.heading,
        onRefresh: () async {
          ref.invalidate(rentBillsProvider);
          try {
            await ref.read(rentBillsProvider.future);
          } catch (_) {}
        },
        child: state.when(
          data: _body,
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.heading),
          ),
          error: (e, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(20.w),
            children: [
              SizedBox(height: 80.h),
              Icon(Icons.error_outline, color: _red, size: 40.sp),
              SizedBox(height: 10.h),
              Text(
                e.toString().replaceFirst("Exception: ", ""),
                textAlign: TextAlign.center,
                style: _t(15),
              ),
              SizedBox(height: 14.h),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.heading,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => ref.invalidate(rentBillsProvider),
                  child: Text("Try again", style: _t(14, c: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
