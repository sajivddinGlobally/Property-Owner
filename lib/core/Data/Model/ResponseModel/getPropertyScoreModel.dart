// To parse this JSON data, do
//
//     final getPropertyScoreModel = getPropertyScoreModelFromJson(jsonString);

import 'dart:convert';

GetPropertyScoreModel getPropertyScoreModelFromJson(String str) => GetPropertyScoreModel.fromJson(json.decode(str));

String getPropertyScoreModelToJson(GetPropertyScoreModel data) => json.encode(data.toJson());

class GetPropertyScoreModel {
    bool? status;
    Data? data;

    GetPropertyScoreModel({
        this.status,
        this.data,
    });

    factory GetPropertyScoreModel.fromJson(Map<String, dynamic> json) => GetPropertyScoreModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    PropertyHeader? propertyHeader;
    OverallPropertyScore? overallPropertyScore;
    List<PerformanceBreakdown>? performanceBreakdown;
    PerformanceSummary? performanceSummary;
    ScoreTrend? scoreTrend;
    PerformanceInsight? performanceInsight;

    Data({
        this.propertyHeader,
        this.overallPropertyScore,
        this.performanceBreakdown,
        this.performanceSummary,
        this.scoreTrend,
        this.performanceInsight,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        propertyHeader: json["property_header"] == null ? null : PropertyHeader.fromJson(json["property_header"]),
        overallPropertyScore: json["overall_property_score"] == null ? null : OverallPropertyScore.fromJson(json["overall_property_score"]),
        performanceBreakdown: json["performance_breakdown"] == null ? [] : List<PerformanceBreakdown>.from(json["performance_breakdown"]!.map((x) => PerformanceBreakdown.fromJson(x))),
        performanceSummary: json["performance_summary"] == null ? null : PerformanceSummary.fromJson(json["performance_summary"]),
        scoreTrend: json["score_trend"] == null ? null : ScoreTrend.fromJson(json["score_trend"]),
        performanceInsight: json["performance_insight"] == null ? null : PerformanceInsight.fromJson(json["performance_insight"]),
    );

    Map<String, dynamic> toJson() => {
        "property_header": propertyHeader?.toJson(),
        "overall_property_score": overallPropertyScore?.toJson(),
        "performance_breakdown": performanceBreakdown == null ? [] : List<dynamic>.from(performanceBreakdown!.map((x) => x.toJson())),
        "performance_summary": performanceSummary?.toJson(),
        "score_trend": scoreTrend?.toJson(),
        "performance_insight": performanceInsight?.toJson(),
    };
}

class OverallPropertyScore {
    dynamic score;
    int? total;
    String? performanceLabel;
    String? lastUpdated;

    OverallPropertyScore({
        this.score,
        this.total,
        this.performanceLabel,
        this.lastUpdated,
    });

    factory OverallPropertyScore.fromJson(Map<String, dynamic> json) => OverallPropertyScore(
        score: json["score"],
        total: json["total"],
        performanceLabel: json["performance_label"],
        lastUpdated: json["last_updated"],
    );

    Map<String, dynamic> toJson() => {
        "score": score,
        "total": total,
        "performance_label": performanceLabel,
        "last_updated": lastUpdated,
    };
}

class PerformanceBreakdown {
    String? label;
    int? value;
    String? suffix;

    PerformanceBreakdown({
        this.label,
        this.value,
        this.suffix,
    });

    factory PerformanceBreakdown.fromJson(Map<String, dynamic> json) => PerformanceBreakdown(
        label: json["label"],
        value: json["value"],
        suffix: json["suffix"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "value": value,
        "suffix": suffix,
    };
}

class PerformanceInsight {
    String? title;
    String? description;

    PerformanceInsight({
        this.title,
        this.description,
    });

    factory PerformanceInsight.fromJson(Map<String, dynamic> json) => PerformanceInsight(
        title: json["title"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
    };
}

class PerformanceSummary {
    String? inspections;
    String? maintenance;
    String? servicesResolved;
    String? openIssues;

    PerformanceSummary({
        this.inspections,
        this.maintenance,
        this.servicesResolved,
        this.openIssues,
    });

    factory PerformanceSummary.fromJson(Map<String, dynamic> json) => PerformanceSummary(
        inspections: json["inspections"],
        maintenance: json["maintenance"],
        servicesResolved: json["services_resolved"],
        openIssues: json["open_issues"],
    );

    Map<String, dynamic> toJson() => {
        "inspections": inspections,
        "maintenance": maintenance,
        "services_resolved": servicesResolved,
        "open_issues": openIssues,
    };
}

class PropertyHeader {
    String? propertyNameNumber;
    String? complexName;
    String? status;

    PropertyHeader({
        this.propertyNameNumber,
        this.complexName,
        this.status,
    });

    factory PropertyHeader.fromJson(Map<String, dynamic> json) => PropertyHeader(
        propertyNameNumber: json["property_name_number"],
        complexName: json["complex_name"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "property_name_number": propertyNameNumber,
        "complex_name": complexName,
        "status": status,
    };
}

class ScoreTrend {
    String? label;
    String? improvement;
    List<ChartDatum>? chartData;

    ScoreTrend({
        this.label,
        this.improvement,
        this.chartData,
    });

    factory ScoreTrend.fromJson(Map<String, dynamic> json) => ScoreTrend(
        label: json["label"],
        improvement: json["improvement"],
        chartData: json["chart_data"] == null ? [] : List<ChartDatum>.from(json["chart_data"]!.map((x) => ChartDatum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "improvement": improvement,
        "chart_data": chartData == null ? [] : List<dynamic>.from(chartData!.map((x) => x.toJson())),
    };
}

class ChartDatum {
    String? month;
    dynamic score;

    ChartDatum({
        this.month,
        this.score,
    });

    factory ChartDatum.fromJson(Map<String, dynamic> json) => ChartDatum(
        month: json["month"],
        score: json["score"],
    );

    Map<String, dynamic> toJson() => {
        "month": month,
        "score": score,
    };
}
