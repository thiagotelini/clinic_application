import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../screens/appointment_details_screen.dart';

class AppointmentTile extends StatelessWidget {
  final Appointment appointment;

  const AppointmentTile({super.key, required this.appointment});

  Color getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.finished:
        return Colors.green;
      case AppointmentStatus.missed:
        return Colors.orange;
      case AppointmentStatus.canceled:
        return Colors.red;
    }
  }

  String getStatusLabel(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.finished:
        return "Finalizado";
      case AppointmentStatus.missed:
        return "Falta";
      case AppointmentStatus.canceled:
        return "Cancelado";
      case AppointmentStatus.scheduled:
        return "Agendado";
    }
  }

  String formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = getStatusColor(appointment.status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AppointmentDetailsScreen(
                appointment: appointment,
              ),
            ),
          );

          if (context.mounted) {
            (context as Element).markNeedsBuild();
          }
        },

        child: Container(
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: statusColor,
                width: 5,
              ),
            ),
          ),

          child: ListTile(
            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

            title: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(
                    text: getStatusLabel(appointment.status),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const TextSpan(text: " - "),
                  TextSpan(text: appointment.patient),
                ],
              ),
            ),

            subtitle: RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  TextSpan(text: appointment.type),
                  const TextSpan(text: " • "),
                  TextSpan(text: appointment.payment),
                  const TextSpan(text: "\n"),
                  TextSpan(
                    text: appointment.doctor,
                    style: const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(height: 4),
                Text(
                  formatTime(appointment.dateTime),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}