class CalorieData {
  final int code;
  final String status;
  final String target;
  final String? averageConsumed;
  final double? averageProgress;
  final List<DailyEntry>? dailyEntries;

  CalorieData({
    required this.code,
    required this.status,
    required this.target,
    this.averageConsumed,
    this.averageProgress,
    this.dailyEntries,
  });

  factory CalorieData.fromJson(Map<String, dynamic> json) {
    return CalorieData(
      code: json['code'] as int,
      status: json['status'] as String,
      target: json['target'] ?? "0",
      averageConsumed: json['average_consumed'] as String?,
      averageProgress: _toDouble(json['average_progress']),
      dailyEntries: (json['daily_entries'] as List<dynamic>?)
          ?.map((e) => DailyEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'status': status,
      'target': target,
      'average_consumed': averageConsumed,
      'average_progress': averageProgress,
      'daily_entries': dailyEntries?.map((e) => e.toJson()).toList(),
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value.replaceAll('%', ''));
    return null;
  }
}

class DailyEntry {
  final String date;
  final String calories;
  final double? percentage;

  DailyEntry({
    required this.date,
    required this.calories,
    this.percentage,
  });

  factory DailyEntry.fromJson(Map<String, dynamic> json) {
    return DailyEntry(
      date: json['date']??"2025-03-06",
      calories: json['calories']??'',
      percentage: CalorieData._toDouble(json['percentage']),
    );
  }
  factory DailyEntry.empty() {
    return DailyEntry(date: '', calories: '0', percentage: 0.0);
  }
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'calories': calories,
      'percentage': percentage,
    };
  }
}
