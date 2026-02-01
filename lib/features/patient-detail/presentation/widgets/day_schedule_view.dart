import 'package:flutter/material.dart';

class DayScheduleView extends StatelessWidget {
  final DateTime selectedDate;
  final TimeOfDay? selectedStartTime;
  final List<Map<String, dynamic>> appointments;
  final ValueChanged<TimeOfDay>? onTimeSelected;

  const DayScheduleView({
    super.key,
    required this.selectedDate,
    required this.appointments,
    this.selectedStartTime,
    this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Generate 15-minute slots from 09:00 to 21:00
    final startHour = 9;
    final endHour = 21;
    final slots = <TimeOfDay>[];

    for (var h = startHour; h < endHour; h++) {
      slots.add(TimeOfDay(hour: h, minute: 0));
      slots.add(TimeOfDay(hour: h, minute: 15));
      slots.add(TimeOfDay(hour: h, minute: 30));
      slots.add(TimeOfDay(hour: h, minute: 45));
    }

    final theme = Theme.of(context);
    final now = TimeOfDay.now();
    final isToday = _isSameDate(selectedDate, DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
          child: Text(
            'Günlük Cədvəl',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 60,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: slots.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final slotStart = slots[index];
              final slotEnd = _addMinutes(slotStart, 15);
              final isBusy = _isSlotBusy(slotStart, slotEnd);
              
              // Check if past
              bool isPast = false;
              if (isToday) {
                if (slotStart.hour < now.hour || (slotStart.hour == now.hour && slotStart.minute < now.minute)) {
                  isPast = true;
                }
              }

              final isSelected = selectedStartTime != null &&
                  _compareTime(selectedStartTime!, slotStart) >= 0 &&
                  _compareTime(selectedStartTime!, slotEnd) < 0;

              Color bgColor;
              Color borderColor;
              Color textColor;

              if (isSelected) {
                bgColor = theme.colorScheme.primary;
                borderColor = theme.colorScheme.primary;
                textColor = theme.colorScheme.onPrimary;
              } else if (isBusy) {
                bgColor = theme.colorScheme.errorContainer;
                borderColor = theme.colorScheme.error;
                textColor = theme.colorScheme.error;
              } else if (isPast) {
                bgColor = Colors.grey.shade200;
                borderColor = Colors.grey.shade400;
                textColor = Colors.grey.shade400;
              } else {
                bgColor = theme.colorScheme.surfaceContainerHighest;
                borderColor = Colors.transparent;
                textColor = theme.colorScheme.onSurface;
              }

              final bool canSelect = !isBusy && !isPast;

              return GestureDetector(
                onTap: canSelect && onTimeSelected != null
                    ? () => onTimeSelected!(slotStart)
                    : null,
                child: Container(
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: bgColor,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _formatTime(slotStart),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isBusy || isPast)
                      Text(
                        isBusy ? 'Məşğul' : 'Keçib',
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.8),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  TimeOfDay _addMinutes(TimeOfDay time, int minutes) {
    final totalMinutes = time.hour * 60 + time.minute + minutes;
    return TimeOfDay(hour: totalMinutes ~/ 60, minute: totalMinutes % 60);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  bool _isSlotBusy(TimeOfDay slotStart, TimeOfDay slotEnd) {
    for (var apt in appointments) {
      if (apt['status'] == 'CANCELLED') continue;

      final aptStart = _parseTime(apt['startTime']);
      final aptEnd = _parseTime(apt['endTime']);
      
      // Check for overlap
      if (_compareTime(slotStart, aptEnd) < 0 &&
          _compareTime(slotEnd, aptStart) > 0) {
        return true;
      }
    }
    return false;
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  int _compareTime(TimeOfDay a, TimeOfDay b) {
    final aMin = a.hour * 60 + a.minute;
    final bMin = b.hour * 60 + b.minute;
    return aMin - bMin;
  }
}
