import 'package:flutter/material.dart';

class PatientHeader extends StatelessWidget {
  final Map<String, dynamic> patient;
  const PatientHeader({required this.patient});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        patient['fullName'],
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(patient['phone']),
      trailing: Text(
        'ID: ${patient['id']}',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}