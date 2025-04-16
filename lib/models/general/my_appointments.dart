
class Appointment {
  final int appointmentId;
  final String appointmentType;
  final String? meetingLink;
  final String status;
  final String paymentStatus;
  final String bookedAt;
  final String date;
  final String startTime;
  final String endTime;
  final String duration;
  final String nutritionist;

  Appointment({
    required this.appointmentId,
    required this.appointmentType,
    this.meetingLink,
    required this.status,
    required this.paymentStatus,
    required this.bookedAt,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.nutritionist,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      appointmentId: json['appointment_id'],
      appointmentType: json['appointment_type'],
      meetingLink: json['meeting_link'],
      status: json['status'],
      paymentStatus: json['payment_status'],
      bookedAt: json['booked_at'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      duration: json['duration'],
      nutritionist: json['nutritionist'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointment_id': appointmentId,
      'appointment_type': appointmentType,
      'meeting_link': meetingLink,
      'status': status,
      'payment_status': paymentStatus,
      'booked_at': bookedAt,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'duration': duration,
      'nutritionist': nutritionist,
    };
  }
}
