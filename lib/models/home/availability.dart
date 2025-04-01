class Availability {
  final String slotId;
  final String date;
  final String startTime;
  final String endTime;

  Availability({
    required this.slotId,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      slotId: json['slot_id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }
}
