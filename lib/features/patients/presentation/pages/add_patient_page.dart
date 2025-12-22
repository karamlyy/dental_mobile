import 'package:flutter/material.dart';

class AddPatientPage extends StatelessWidget {
  const AddPatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Pasiyent Əlavə Et')),
      body: const Center(
        child: Text('Pasiyent əlavə etmə formu burada olacaq.'),
      ),
    );
  }
}
