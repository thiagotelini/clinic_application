import 'package:flutter_test/flutter_test.dart';
import 'package:clinic_application/services/appointment_service.dart';
import 'package:clinic_application/models/appointment.dart';

void main() {
  late AppointmentService service;

  setUp(() {
    service = AppointmentService();
  });

  test('Deve adicionar um agendamento válido', () {
    final appointment = Appointment(
      patient: 'Thiago',
      doctor: 'Dr. João',
      type: 'Novo',
      payment: 'Particular',
      dateTime: DateTime(2027, 1, 1, 10, 0),
    );

    service.add(appointment);

    expect(service.getAll().length, 1);
  });

  test('Não deve permitir conflito de horário para mesmo médico', () {
    final date = DateTime(2027, 1, 1, 10, 0);

    final a1 = Appointment(
      patient: 'A',
      doctor: 'Dr. João',
      type: 'Novo',
      payment: 'Particular',
      dateTime: date,
    );

    final a2 = Appointment(
      patient: 'B',
      doctor: 'Dr. João',
      type: 'Novo',
      payment: 'Particular',
      dateTime: date,
    );

    service.add(a1);

    expect(() => service.add(a2), throwsException);
  });

  test('Permite mesmo horário para médicos diferentes', () {
    final date = DateTime(2027, 1, 1, 10, 0);

    final a1 = Appointment(
      patient: 'A',
      doctor: 'Dr. João',
      type: 'Novo',
      payment: 'Particular',
      dateTime: date,
    );

    final a2 = Appointment(
      patient: 'B',
      doctor: 'Dra. Márcia',
      type: 'Novo',
      payment: 'Particular',
      dateTime: date,
    );

    service.add(a1);
    service.add(a2);

    expect(service.getAll().length, 2);
  });

  test('Não deve permitir agendamento no passado', () {
    final appointment = Appointment(
      patient: 'Thiago',
      doctor: 'Dr. João',
      type: 'Novo',
      payment: 'Particular',
      dateTime: DateTime(2026, 1, 1, 10, 0),
    );

    expect(() => service.add(appointment), throwsException);
  });

  test('Não deve permitir horário fora de 30 minutos', () {
    final appointment = Appointment(
      patient: 'Thiago',
      doctor: 'Dr. João',
      type: 'Novo',
      payment: 'Particular',
      dateTime: DateTime(2027, 1, 1, 10, 0).add(const Duration(hours: 1, minutes: 15)),
    );

    expect(() => service.add(appointment), throwsException);
  });
}