import '../models/appointment.dart';

class AppointmentService {
  final List<Appointment> _appointments = [];

  List<Appointment> getAll() => List.unmodifiable(_appointments);

  void add(Appointment appointment) {
    _validateAppointment(appointment);

    final exists = _appointments.any(
          (a) =>
      a.doctor == appointment.doctor &&
          _isSameDateTime(a.dateTime, appointment.dateTime),
    );

    if (exists) {
      throw Exception("Horário já ocupado para este médico");
    }

    _appointments.add(appointment);
  }

  void _validateAppointment(Appointment appointment) {
    if (appointment.patient.trim().isEmpty) {
      throw Exception("Nome do paciente é obrigatório");
    }

    if (appointment.dateTime.isBefore(DateTime.now())) {
      throw Exception("Não é possível agendar no passado");
    }

    if (appointment.dateTime.minute % 30 != 0) {
      throw Exception("Os horários devem ser de 30 em 30 minutos");
    }
  }

  bool _isSameDateTime(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day &&
        a.hour == b.hour &&
        a.minute == b.minute;
  }
}