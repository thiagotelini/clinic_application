import 'package:flutter/material.dart';
import '../models/appointment.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final Appointment appointment;

  const AppointmentDetailsScreen({super.key, required this.appointment});

  void updateStatus(BuildContext context, AppointmentStatus status) {
    appointment.status = status;
    Navigator.pop(context);
  }

  Color getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.finished:
        return Colors.green;
      case AppointmentStatus.missed:
        return Colors.orange;
      case AppointmentStatus.canceled:
        return Colors.red;
      case AppointmentStatus.scheduled:
        return Colors.blueGrey;
    }
  }

  Widget buildActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required AppointmentStatus status,
  }) {

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => updateStatus(context, status),
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget buildInfo() {
    final time =
        "${appointment.dateTime.hour.toString().padLeft(2, '0')}:${appointment.dateTime.minute.toString().padLeft(2, '0')}";

    return Column(
      children: [
        Text(
          appointment.patient,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text("${appointment.doctor} • $time"),
        const SizedBox(height: 4),
        Text("${appointment.type} • ${appointment.payment}"),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Atendimento"),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildInfo(),

                const SizedBox(height: 24),

                const Text(
                  "Ações do Atendimento",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                buildActionButton(
                  context: context,
                  label: "Finalizar",
                  icon: Icons.check_circle,
                  status: AppointmentStatus.finished,
                ),

                const SizedBox(height: 12),

                buildActionButton(
                  context: context,
                  label: "Marcar Falta",
                  icon: Icons.person_off,
                  status: AppointmentStatus.missed,
                ),

                const SizedBox(height: 12),

                buildActionButton(
                  context: context,
                  label: "Cancelar Agendamento",
                  icon: Icons.cancel,
                  status: AppointmentStatus.canceled,
                ),

                const SizedBox(height: 12),

                buildActionButton(
                  context: context,
                  label: "Manter Agendamento",
                  icon: Icons.schedule,
                  status: AppointmentStatus.scheduled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}