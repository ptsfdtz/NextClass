import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/local/hive_settings_repository.dart';
import '../../data/models/app_settings.dart';
import '../../data/models/period.dart';
import 'period_editor_sheet.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final _repository = HiveSettingsRepository();

  @override
  Widget build(BuildContext context) {
    final settingsBox = Hive.box<Map>('settings');

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ValueListenableBuilder<Box<Map>>(
        valueListenable: settingsBox.listenable(),
        builder: (context, value, child) {
          final settings = _readSettings(value);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SettingsSection(
                title: '学期设置',
                children: [
                  _SettingsTile(
                    label: '学期起止日期',
                    value: _formatRange(settings.semesterStart, settings.semesterEnd),
                    onTap: () => _editSemesterRange(context, settings),
                  ),
                  _SettingsTile(
                    label: '一周起始日',
                    value: settings.weekStartDay == 1 ? '周一' : '周日',
                    onTap: () => _editWeekStart(context, settings),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SettingsSection(
                title: '节次设置',
                children: [
                  _SettingsTile(
                    label: '每日节次',
                    value: '${settings.periodCount} 节',
                    onTap: () => _editPeriodCount(context, settings),
                  ),
                  _SettingsTile(
                    label: '上课时间表',
                    value: '编辑',
                    onTap: () => _editPeriods(context, settings),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SettingsSection(
                title: '提醒',
                children: [
                  SwitchListTile.adaptive(
                    title: const Text('课程提醒'),
                    value: settings.reminderEnabled,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      _repository.save(settings.copyWith(reminderEnabled: value));
                    },
                  ),
                  _SettingsTile(
                    label: '提前时间',
                    value: '${settings.reminderMinutes} 分钟',
                    enabled: settings.reminderEnabled,
                    onTap: () => _editReminderMinutes(context, settings),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  AppSettings _readSettings(Box<Map> box) {
    final map = box.get('app');
    final settings = AppSettings.fromMap(map);
    if (map == null) {
      _repository.save(settings);
    }
    return settings;
  }

  String _formatRange(DateTime start, DateTime end) {
    return '${_formatDate(start)} - ${_formatDate(end)}';
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year/$month/$day';
  }

  Future<void> _editSemesterRange(BuildContext context, AppSettings settings) async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      initialDateRange: DateTimeRange(
        start: settings.semesterStart,
        end: settings.semesterEnd,
      ),
    );

    if (range == null) {
      return;
    }

    await _repository.save(
      settings.copyWith(semesterStart: range.start, semesterEnd: range.end),
    );
  }

  Future<void> _editWeekStart(BuildContext context, AppSettings settings) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('周一'),
                trailing: settings.weekStartDay == 1
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.of(context).pop(1),
              ),
              ListTile(
                title: const Text('周日'),
                trailing: settings.weekStartDay == 7
                    ? const Icon(Icons.check)
                    : null,
                onTap: () => Navigator.of(context).pop(7),
              ),
            ],
          ),
        );
      },
    );

    if (result == null) {
      return;
    }

    await _repository.save(settings.copyWith(weekStartDay: result));
  }

  Future<void> _editPeriodCount(BuildContext context, AppSettings settings) async {
    final options = [6, 8, 10, 12];
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (value) => ListTile(
                    title: Text('$value 节'),
                    trailing: settings.periodCount == value
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => Navigator.of(context).pop(value),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (result == null || result == settings.periodCount) {
      return;
    }

    final updated = _normalizePeriods(settings.periods, result);
    await _repository.save(settings.copyWith(periods: updated));
  }

  Future<void> _editPeriods(BuildContext context, AppSettings settings) async {
    final result = await showModalBottomSheet<List<Period>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PeriodEditorSheet(periods: settings.periods),
    );

    if (result == null) {
      return;
    }

    await _repository.save(settings.copyWith(periods: result));
  }

  Future<void> _editReminderMinutes(
    BuildContext context,
    AppSettings settings,
  ) async {
    if (!settings.reminderEnabled) {
      return;
    }

    final options = [5, 10, 15, 20, 30];
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map(
                  (value) => ListTile(
                    title: Text('$value 分钟'),
                    trailing: settings.reminderMinutes == value
                        ? const Icon(Icons.check)
                        : null,
                    onTap: () => Navigator.of(context).pop(value),
                  ),
                )
                .toList(),
          ),
        );
      },
    );

    if (result == null) {
      return;
    }

    await _repository.save(settings.copyWith(reminderMinutes: result));
  }

  List<Period> _normalizePeriods(List<Period> current, int count) {
    if (current.length == count) {
      return current;
    }

    if (count < current.length) {
      return current.take(count).toList();
    }

    final result = current
        .map((p) => Period(index: p.index, startTime: p.startTime, endTime: p.endTime))
        .toList();

    var lastEnd = _toMinutes(result.isNotEmpty ? result.last.endTime : '08:00');
    for (var index = result.length + 1; index <= count; index += 1) {
      final start = lastEnd + 10;
      final end = start + 45;
      result.add(
        Period(
          index: index,
          startTime: _fromMinutes(start),
          endTime: _fromMinutes(end),
        ),
      );
      lastEnd = end;
    }

    return result;
  }

  int _toMinutes(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      return 8 * 60;
    }
    final hour = int.tryParse(parts[0]) ?? 8;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour * 60 + minute;
  }

  String _fromMinutes(int minutes) {
    final hour = (minutes ~/ 60) % 24;
    final minute = minutes % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.label,
    required this.value,
    required this.onTap,
    this.enabled = true,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(color: enabled ? Colors.black54 : Colors.black26),
      ),
      onTap: enabled ? onTap : null,
    );
  }
}
