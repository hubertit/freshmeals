
class Appointment {
  final int appointmentId;
  final String appointmentDate;
  final String timeSlot;
  final String duration;
  final String status;
  final String nutritionist;

  Appointment({
    required this.appointmentId,
    required this.appointmentDate,
    required this.timeSlot,
    required this.duration,
    required this.status,
    required this.nutritionist,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'],
      appointmentDate: json['appointment_date'],
      timeSlot: json['time_slot'],
      duration: json['duration'],
      status: json['status'],
      nutritionist: json['nutritionist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'appointment_date': appointmentDate,
      'time_slot': timeSlot,
      'duration': duration,
      'status': status,
      'nutritionist': nutritionist,
    };
  }
}
