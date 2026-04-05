class Appointment {
  final String patient;
  final String doctor;
  final String type;
  final String payment;
  final DateTime dateTime;

  AppointmentStatus status;

  Appointment({
    required this.patient,
    required this.doctor,
    required this.type,
    required this.payment,
    required this.dateTime,
    this.status = AppointmentStatus.scheduled,
  });
}

enum AppointmentStatus {
  scheduled,
  finished,
  missed,
  canceled,
}