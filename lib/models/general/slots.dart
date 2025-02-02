class Slot {
  final String startTime;
  final String endTime;

  Slot({
    required this.startTime,
    required this.endTime,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }
}
