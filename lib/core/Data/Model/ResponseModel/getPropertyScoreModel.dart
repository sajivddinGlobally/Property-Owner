// To parse this JSON data, do
//
//     final getPropertyScoreModel = getPropertyScoreModelFromJson(jsonString);

import 'dart:convert';

GetPropertyScoreModel getPropertyScoreModelFromJson(String str) =>
    GetPropertyScoreModel.fromJson(json.decode(str));

String getPropertyScoreModelToJson(GetPropertyScoreModel data) =>
    json.encode(data.toJson());

class GetPropertyScoreModel {
  bool? status;
  Data? data;

  GetPropertyScoreModel({this.status, this.data});

  factory GetPropertyScoreModel.fromJson(Map<String, dynamic> json) =>
      GetPropertyScoreModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  PropertyHeader? propertyHeader;
  OverallPropertyScore? overallPropertyScore;
  LatestInspection? latestInspection;
  // Home Care: latest audit alag block (property score mein nahi judta)
  ScoreLatestAudit? latestAudit;
  bool hasLatestAuditKey;
  List<PerformanceBreakdown>? performanceBreakdown;
  PerformanceSummary? performanceSummary;
  ScoreTrend? scoreTrend;
  PerformanceInsight? performanceInsight;

  Data({
    this.propertyHeader,
    this.overallPropertyScore,
    this.latestInspection,
    this.latestAudit,
    this.hasLatestAuditKey = false,
    this.performanceBreakdown,
    this.performanceSummary,
    this.scoreTrend,
    this.performanceInsight,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    propertyHeader: json["property_header"] == null
        ? null
        : PropertyHeader.fromJson(json["property_header"]),
    overallPropertyScore: json["overall_property_score"] == null
        ? null
        : OverallPropertyScore.fromJson(json["overall_property_score"]),
    latestInspection: json["latest_inspection"] == null
        ? null
        : LatestInspection.fromJson(json["latest_inspection"]),
    latestAudit: json["latest_audit"] is Map<String, dynamic>
        ? ScoreLatestAudit.fromJson(json["latest_audit"])
        : null,
    hasLatestAuditKey: json.containsKey("latest_audit"),
    performanceBreakdown: json["performance_breakdown"] == null
        ? []
        : List<PerformanceBreakdown>.from(
            json["performance_breakdown"]!.map(
              (x) => PerformanceBreakdown.fromJson(x),
            ),
          ),
    performanceSummary: json["performance_summary"] == null
        ? null
        : PerformanceSummary.fromJson(json["performance_summary"]),
    scoreTrend: json["score_trend"] == null
        ? null
        : ScoreTrend.fromJson(json["score_trend"]),
    performanceInsight: json["performance_insight"] == null
        ? null
        : PerformanceInsight.fromJson(json["performance_insight"]),
  );

  Map<String, dynamic> toJson() => {
    "property_header": propertyHeader?.toJson(),
    "overall_property_score": overallPropertyScore?.toJson(),
    "latest_inspection": latestInspection?.toJson(),
    "latest_audit": latestAudit?.toJson(),
    "performance_breakdown": performanceBreakdown == null
        ? []
        : List<dynamic>.from(performanceBreakdown!.map((x) => x.toJson())),
    "performance_summary": performanceSummary?.toJson(),
    "score_trend": scoreTrend?.toJson(),
    "performance_insight": performanceInsight?.toJson(),
  };
}

class PropertyHeader {
  String? propertyNameNumber;
  String? complexName;
  String? propertyType;
  String? propertyTypeLabel;
  String? status;

  PropertyHeader({
    this.propertyNameNumber,
    this.complexName,
    this.propertyType,
    this.propertyTypeLabel,
    this.status,
  });

  bool get isHomeCare => propertyType == "independent_house";

  factory PropertyHeader.fromJson(Map<String, dynamic> json) => PropertyHeader(
    propertyNameNumber: json["property_name_number"],
    complexName: json["complex_name"],
    propertyType: json["property_type"],
    propertyTypeLabel: json["property_type_label"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "property_name_number": propertyNameNumber,
    "complex_name": complexName,
    "property_type": propertyType,
    "property_type_label": propertyTypeLabel,
    "status": status,
  };
}

class OverallPropertyScore {
  dynamic score;
  String? scoreDisplay;
  String? scoreLabel;
  int? total;
  dynamic score100Scale;
  String? performanceLabel;
  String? status;
  String? tier;
  bool? isPendingInspection;
  dynamic previousScore;
  dynamic changeVsPrevious;
  String? lastUpdated;
  String? formula;

  OverallPropertyScore({
    this.score,
    this.scoreDisplay,
    this.scoreLabel,
    this.total,
    this.score100Scale,
    this.performanceLabel,
    this.status,
    this.tier,
    this.isPendingInspection,
    this.previousScore,
    this.changeVsPrevious,
    this.lastUpdated,
    this.formula,
  });

  double get numericScore => double.tryParse(score?.toString() ?? "0") ?? 0.0;

  double? get numericPreviousScore =>
      previousScore == null ? null : double.tryParse(previousScore.toString());

  double? get numericChangeVsPrevious => changeVsPrevious == null
      ? null
      : double.tryParse(changeVsPrevious.toString());

  factory OverallPropertyScore.fromJson(Map<String, dynamic> json) =>
      OverallPropertyScore(
        score: json["score"],
        scoreDisplay: json["score_display"],
        scoreLabel: json["score_label"],
        total: json["total"] is int
            ? json["total"]
            : int.tryParse(json["total"]?.toString() ?? ""),
        score100Scale: json["score_100_scale"],
        performanceLabel: json["performance_label"],
        status: json["status"],
        tier: json["tier"],
        isPendingInspection: json["is_pending_inspection"],
        previousScore: json["previous_score"],
        changeVsPrevious: json["change_vs_previous"],
        lastUpdated: json["last_updated"],
        formula: json["formula"],
      );

  Map<String, dynamic> toJson() => {
    "score": score,
    "score_display": scoreDisplay,
    "score_label": scoreLabel,
    "total": total,
    "score_100_scale": score100Scale,
    "performance_label": performanceLabel,
    "status": status,
    "tier": tier,
    "is_pending_inspection": isPendingInspection,
    "previous_score": previousScore,
    "change_vs_previous": changeVsPrevious,
    "last_updated": lastUpdated,
    "formula": formula,
  };
}

class LatestInspection {
  int? id;
  String? date;
  String? dateFormatted;
  int? daysAgo;
  dynamic score;
  int? totalCheckpoints;
  int? passed;
  int? needsAttention;
  String? checklistPdfUrl;

  LatestInspection({
    this.id,
    this.date,
    this.dateFormatted,
    this.daysAgo,
    this.score,
    this.totalCheckpoints,
    this.passed,
    this.needsAttention,
    this.checklistPdfUrl,
  });

  factory LatestInspection.fromJson(Map<String, dynamic> json) =>
      LatestInspection(
        id: json["id"] is int
            ? json["id"]
            : int.tryParse(json["id"]?.toString() ?? ""),
        date: json["date"],
        dateFormatted: json["date_formatted"],
        daysAgo: json["days_ago"] is int
            ? json["days_ago"]
            : int.tryParse(json["days_ago"]?.toString() ?? ""),
        score: json["score"],
        totalCheckpoints: json["total_checkpoints"] is int
            ? json["total_checkpoints"]
            : int.tryParse(json["total_checkpoints"]?.toString() ?? ""),
        passed: json["passed"] is int
            ? json["passed"]
            : int.tryParse(json["passed"]?.toString() ?? ""),
        needsAttention: json["needs_attention"] is int
            ? json["needs_attention"]
            : int.tryParse(json["needs_attention"]?.toString() ?? ""),
        checklistPdfUrl: json["checklist_pdf_url"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "date_formatted": dateFormatted,
    "days_ago": daysAgo,
    "score": score,
    "total_checkpoints": totalCheckpoints,
    "passed": passed,
    "needs_attention": needsAttention,
    "checklist_pdf_url": checklistPdfUrl,
  };
}

class ScoreLatestAudit {
  int? id;
  String? auditType;
  String? date;
  String? dateFormatted;
  dynamic score;
  String? scoreLabel;
  String? tier;
  int? totalCheckpoints;
  int? passed;
  int? needsAttention;
  String? checklistPdfUrl;

  ScoreLatestAudit({
    this.id,
    this.auditType,
    this.date,
    this.dateFormatted,
    this.score,
    this.scoreLabel,
    this.tier,
    this.totalCheckpoints,
    this.passed,
    this.needsAttention,
    this.checklistPdfUrl,
  });

  double? get numericScore =>
      score == null ? null : double.tryParse(score.toString());

  static int? _toInt(dynamic v) =>
      v is int ? v : int.tryParse(v?.toString() ?? "");

  factory ScoreLatestAudit.fromJson(Map<String, dynamic> json) =>
      ScoreLatestAudit(
        id: _toInt(json["id"]),
        auditType: json["audit_type"]?.toString(),
        date: json["date"]?.toString(),
        dateFormatted: json["date_formatted"]?.toString(),
        score: json["score"],
        scoreLabel: json["score_label"]?.toString(),
        tier: json["tier"]?.toString(),
        totalCheckpoints: _toInt(json["total_checkpoints"]),
        passed: _toInt(json["passed"]),
        needsAttention: _toInt(json["needs_attention"]),
        checklistPdfUrl: json["checklist_pdf_url"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "audit_type": auditType,
    "date": date,
    "date_formatted": dateFormatted,
    "score": score,
    "score_label": scoreLabel,
    "tier": tier,
    "total_checkpoints": totalCheckpoints,
    "passed": passed,
    "needs_attention": needsAttention,
    "checklist_pdf_url": checklistPdfUrl,
  };
}

class PerformanceBreakdown {
  String? parameter;
  String? label;
  String? weight;
  dynamic weightPct;
  dynamic score;
  dynamic maxScore;
  dynamic value;
  String? displayValue;
  String? suffix;
  int? total;
  int? passed;
  int? needsAttention;

  PerformanceBreakdown({
    this.parameter,
    this.label,
    this.weight,
    this.weightPct,
    this.score,
    this.maxScore,
    this.value,
    this.displayValue,
    this.suffix,
    this.total,
    this.passed,
    this.needsAttention,
  });

  double get numericScore => double.tryParse(score?.toString() ?? "0") ?? 0.0;

  double get numericMaxScore =>
      double.tryParse(maxScore?.toString() ?? "10") ?? 10.0;

  double get numericValue => double.tryParse(value?.toString() ?? "0") ?? 0.0;

  factory PerformanceBreakdown.fromJson(Map<String, dynamic> json) =>
      PerformanceBreakdown(
        parameter: json["parameter"],
        label: json["label"] ?? json["parameter"],
        weight: json["weight"],
        weightPct: json["weight_pct"],
        score: json["score"],
        maxScore: json["max_score"],
        value: json["value"],
        displayValue: json["display_value"],
        suffix: json["suffix"],
        total: json["total"] is int
            ? json["total"]
            : int.tryParse(json["total"]?.toString() ?? ""),
        passed: json["passed"] is int
            ? json["passed"]
            : int.tryParse(json["passed"]?.toString() ?? ""),
        needsAttention: json["needs_attention"] is int
            ? json["needs_attention"]
            : int.tryParse(json["needs_attention"]?.toString() ?? ""),
      );

  Map<String, dynamic> toJson() => {
    "parameter": parameter,
    "label": label,
    "weight": weight,
    "weight_pct": weightPct,
    "score": score,
    "max_score": maxScore,
    "value": value,
    "display_value": displayValue,
    "suffix": suffix,
    "total": total,
    "passed": passed,
    "needs_attention": needsAttention,
  };
}

class PerformanceSummary {
  String? inspections;
  String? audits;
  String? maintenance;
  String? servicesResolved;
  String? openIssues;

  PerformanceSummary({
    this.inspections,
    this.audits,
    this.maintenance,
    this.servicesResolved,
    this.openIssues,
  });

  factory PerformanceSummary.fromJson(Map<String, dynamic> json) =>
      PerformanceSummary(
        inspections: json["inspections"]?.toString(),
        audits: json["audits"]?.toString(),
        maintenance: json["maintenance"]?.toString(),
        servicesResolved: json["services_resolved"]?.toString(),
        openIssues: json["open_issues"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
    "inspections": inspections,
    "audits": audits,
    "maintenance": maintenance,
    "services_resolved": servicesResolved,
    "open_issues": openIssues,
  };
}

class ScoreTrend {
  String? period;
  List<String>? periods;
  String? label;
  String? improvement;
  List<ChartDatum>? chartData;

  ScoreTrend({
    this.period,
    this.periods,
    this.label,
    this.improvement,
    this.chartData,
  });

  factory ScoreTrend.fromJson(Map<String, dynamic> json) => ScoreTrend(
    period: json["period"],
    periods: json["periods"] == null
        ? []
        : List<String>.from(json["periods"]!.map((x) => x.toString())),
    label: json["label"],
    improvement: json["improvement"],
    chartData: json["chart_data"] == null
        ? []
        : List<ChartDatum>.from(
            json["chart_data"]!.map((x) => ChartDatum.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "period": period,
    "periods": periods,
    "label": label,
    "improvement": improvement,
    "chart_data": chartData == null
        ? []
        : List<dynamic>.from(chartData!.map((x) => x.toJson())),
  };
}

class ChartDatum {
  String? month;
  String? label;
  dynamic score;
  bool? hasInspection;
  int? inspections;
  dynamic passedPct;

  ChartDatum({
    this.month,
    this.label,
    this.score,
    this.hasInspection,
    this.inspections,
    this.passedPct,
  });

  double? get numericScore =>
      score == null ? null : double.tryParse(score.toString());

  factory ChartDatum.fromJson(Map<String, dynamic> json) => ChartDatum(
    month: json["month"] ?? json["label"],
    label: json["label"] ?? json["month"],
    score: json["score"],
    hasInspection: json["has_inspection"],
    inspections: json["inspections"] is int
        ? json["inspections"]
        : int.tryParse(json["inspections"]?.toString() ?? ""),
    passedPct: json["passed_pct"],
  );

  Map<String, dynamic> toJson() => {
    "month": month,
    "label": label,
    "score": score,
    "has_inspection": hasInspection,
    "inspections": inspections,
    "passed_pct": passedPct,
  };
}

class PerformanceInsight {
  String? title;
  String? description;

  PerformanceInsight({this.title, this.description});

  factory PerformanceInsight.fromJson(Map<String, dynamic> json) =>
      PerformanceInsight(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {"title": title, "description": description};
}
