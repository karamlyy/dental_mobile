import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientHeader extends StatelessWidget {
  final Map<String, dynamic> patient;
  const PatientHeader({super.key, required this.patient});

  Future<void> callPatient(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch $phone');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            child: Text(
              patient['fullName'][0],
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient['fullName'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  patient['phone'],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => callPatient(patient['phone']),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.call,
                color: Colors.green,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}