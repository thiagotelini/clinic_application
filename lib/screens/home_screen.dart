import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/appointment_service.dart';
import '../widgets/appointment_tile.dart';
import 'add_appointment_screen.dart';
import '../models/appointment.dart';

class HomeScreen extends StatefulWidget {
  final AppointmentService service;

  const HomeScreen({super.key, required this.service});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedDoctorFilter = "Todos";

  final List<String> doctors = ["Todos", "Dr. João", "Dra. Márcia", "Dr. Douglas"];

  @override
  Widget build(BuildContext context) {
    final appointments = _getFilteredAppointments();
    final grouped = _groupByDate(appointments);

    return Scaffold(
      appBar: AppBar(title: const Text('Agendamentos')),

      body: Column(
        children: [
          _buildFilter(),

          Expanded(
            child: ListView(
              children: grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateHeader(entry.key),

                    ...entry.value.map(
                          (a) => AppointmentTile(appointment: a),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddAppointmentScreen(service: widget.service),
            ),
          );
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Appointment> _getFilteredAppointments() {
    var appointments = List<Appointment>.from(widget.service.getAll());

    if (selectedDoctorFilter != "Todos") {
      appointments = appointments
          .where((a) => a.doctor == selectedDoctorFilter)
          .toList();
    }

    appointments.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return appointments;
  }

  Map<String, List<Appointment>> _groupByDate(List<Appointment> appointments) {
    final Map<String, List<Appointment>> grouped = {};

    for (var a in appointments) {
      final key = DateFormat('dd/MM/yyyy').format(a.dateTime);

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(a);
    }

    return grouped;
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: doctors.map((d) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(d),
                selected: selectedDoctorFilter == d,
                onSelected: (_) {
                  setState(() {
                    selectedDoctorFilter = d;
                  });
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}