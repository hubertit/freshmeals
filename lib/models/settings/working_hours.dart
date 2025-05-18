class WorkingHours {
  final String day;
  final String workingHours;

  WorkingHours({
    required this.day,
    required this.workingHours,
  });

  factory WorkingHours.fromJson(Map<String, dynamic> json) {
    return WorkingHours(
      day: json['day'],
      workingHours: json['working_hours'],
    );
  }
}
