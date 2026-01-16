import 'package:flutter/material.dart';

class StatusDot extends StatelessWidget {
  final String status;
  const StatusDot(this.status, {super.key});

  @override
  Widget build(BuildContext context) {

    Color color;

    switch (status) {
      case 'SCHEDULED':
        color = Colors.orange;
        break;
      case 'CONFIRMED':
        color = Colors.blue;
        break;
      case 'COMPLETED':
        color = Colors.green;
        break;
      case 'CANCELLED':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return CircleAvatar(
      radius: 6,
      backgroundColor: color,
    );
  }
}