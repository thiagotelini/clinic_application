import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../services/appointment_service.dart';

class AddAppointmentScreen extends StatefulWidget {
  final AppointmentService service;

  const AddAppointmentScreen({super.key, required this.service});

  @override
  State<AddAppointmentScreen> createState() => _AddAppointmentScreenState();
}

class _AddAppointmentScreenState extends State<AddAppointmentScreen> {
  final _patientController = TextEditingController();

  String? doctor;
  String? type;
  String? healthPlan;
  String? payment;
  TimeOfDay? selectedTime;
  DateTime? selectedDate;

  late final List<TimeOfDay> times;

  @override
  void initState() {
    super.initState();
    times = _generateTimes();
  }

  @override
  void dispose() {
    _patientController.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return _patientController.text.trim().isNotEmpty &&
        doctor != null &&
        type != null &&
        payment != null &&
        selectedDate != null &&
        selectedTime != null &&
        (payment == "Particular" || healthPlan != null);
  }

  List<TimeOfDay> _generateTimes() {
    List<TimeOfDay> times = [];

    for (int hour = 8; hour <= 17; hour++) {
      times.add(TimeOfDay(hour: hour, minute: 0));
      times.add(TimeOfDay(hour: hour, minute: 30));
    }

    return times;
  }

  bool _isSameDateTime(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day &&
        a.hour == b.hour &&
        a.minute == b.minute;
  }

  bool isOccupied(TimeOfDay time) {
    if (selectedDate == null || doctor == null) return false;

    final dateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      time.hour,
      time.minute,
    );

    return widget.service.getAll().any(
          (a) =>
      a.doctor == doctor &&
          _isSameDateTime(a.dateTime, dateTime),
    );
  }

  void save() {
    try {
      final dateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      final finalPayment =
      payment == "Plano" ? healthPlan! : "Particular";

      widget.service.add(
        Appointment(
          patient: _patientController.text.trim(),
          doctor: doctor!,
          type: type!,
          payment: finalPayment,
          dateTime: dateTime,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabledGrid = selectedDate == null || doctor == null;

    return Scaffold(
      appBar: AppBar(title: const Text("Novo Agendamento")),

      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Paciente"),

                TextField(
                  controller: _patientController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: "Nome do paciente",
                  ),
                ),

                const SizedBox(height: 16),

                const Text("Médico"),

                Wrap(
                  spacing: 8,
                  children: ["Dr. João", "Dra. Márcia", "Dr. Douglas"].map((d) {
                    return ChoiceChip(
                      label: Text(d),
                      selected: doctor == d,
                      onSelected: (_) => setState(() => doctor = d),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                const Text("Data"),

                ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                  child: Text(
                    selectedDate == null
                        ? "Selecionar data"
                        : "Data: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                  ),
                ),

                const SizedBox(height: 16),

                const Text("Horário"),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: times.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2,
                  ),
                  itemBuilder: (context, index) {
                    final time = times[index];

                    final isSelected =
                        selectedTime != null &&
                            selectedTime!.hour == time.hour &&
                            selectedTime!.minute == time.minute;

                    final occupied = isOccupied(time);

                    return GestureDetector(
                      onTap: (occupied || disabledGrid)
                          ? null
                          : () => setState(() => selectedTime = time),
                      child: Container(
                        decoration: BoxDecoration(
                          color: disabledGrid
                              ? Colors.grey[700]
                              : occupied
                              ? Colors.red
                              : isSelected
                              ? Colors.teal
                              : Colors.grey[800],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(time.format(context)),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                const Text("Tipo"),

                Wrap(
                  spacing: 8,
                  children: ["Novo Atendimento", "Retorno"].map((t) {
                    return ChoiceChip(
                      label: Text(t),
                      selected: type == t,
                      onSelected: (_) => setState(() => type = t),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 16),

                const Text("Pagamento"),

                Wrap(
                  spacing: 8,
                  children: ["Plano", "Particular"].map((p) {
                    return ChoiceChip(
                      label: Text(p),
                      selected: payment == p,
                      onSelected: (_) {
                        setState(() {
                          payment = p;

                          if (payment != "Plano") {
                            healthPlan = null;
                          }
                        });
                      },
                    );
                  }).toList(),
                ),

                if (payment == "Plano") ...[
                  const SizedBox(height: 16),
                  const Text("Plano"),

                  Wrap(
                    spacing: 8,
                    children: ["Unimed", "Santa Casa"].map((plan) {
                      return ChoiceChip(
                        label: Text(plan),
                        selected: healthPlan == plan,
                        onSelected: (_) =>
                            setState(() => healthPlan = plan),
                      );
                    }).toList(),
                  ),
                ],

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isFormValid ? save : null,
                    child: const Text("Salvar"),
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