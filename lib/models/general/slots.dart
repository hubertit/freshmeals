class Slot {
  final String name;
  final String startTime;
  final String endTime;

  Slot({
    required this.name,
    required this.startTime,
    required this.endTime,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      name: json['name'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
    );
  }
}
