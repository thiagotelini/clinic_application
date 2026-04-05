import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/appointment_service.dart';

final AppointmentService service = AppointmentService();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clínica',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: Colors.teal,
          secondary: Colors.tealAccent,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
      ),
      home: HomeScreen(service: service),
    );
  }
}