import 'package:flutter/material.dart';

import '../../data/models/period.dart';

class PeriodEditorSheet extends StatefulWidget {
  const PeriodEditorSheet({super.key, required this.periods});

  final List<Period> periods;

  @override
  State<PeriodEditorSheet> createState() => _PeriodEditorSheetState();
}

class _PeriodEditorSheetState extends State<PeriodEditorSheet> {
  late List<Period> _periods;

  @override
  void initState() {
    super.initState();
    _periods = widget.periods
        .map((p) => Period(index: p.index, startTime: p.startTime, endTime: p.endTime))
        .toList();
  }

  Future<void> _pickTime(int index, bool isStart) async {
    final period = _periods[index];
    final current = isStart ? period.startTime : period.endTime;
    final parsed = _parseTime(current) ?? const TimeOfDay(hour: 8, minute: 0);

    final result = await showTimePicker(
      context: context,
      initialTime: parsed,
    );

    if (result == null) {
      return;
    }

    setState(() {
      final time = _formatTime(result);
      _periods[index] = Period(
        index: period.index,
        startTime: isStart ? time : period.startTime,
        endTime: isStart ? period.endTime : time,
      );
    });
  }

  TimeOfDay? _parseTime(String input) {
    final parts = input.split(':');
    if (parts.length != 2) {
      return null;
    }
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.75;

    return Material(
      color: Colors.transparent,
      child: Container(
        height: height,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '编辑节次时间',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: _periods.length,
                  separatorBuilder: (context, index) => const Divider(height: 16),
                  itemBuilder: (context, index) {
                    final period = _periods[index];
                    return Row(
                      children: [
                        SizedBox(
                          width: 42,
                          child: Text(
                            '第${period.index}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _pickTime(index, true),
                            child: Text(period.startTime),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('-'),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => _pickTime(index, false),
                            child: Text(period.endTime),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(_periods),
                  child: const Text('保存'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
