import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsSection(
            title: '学期设置',
            children: const [
              _SettingsTile(label: '学期起止日期', value: '2026/02/01 - 2026/06/30'),
              _SettingsTile(label: '一周起始日', value: '周一'),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: '节次设置',
            children: const [
              _SettingsTile(label: '每日节次', value: '10 节'),
              _SettingsTile(label: '上课时间表', value: '编辑'),
            ],
          ),
          const SizedBox(height: 12),
          _SettingsSection(
            title: '提醒',
            children: const [
              _SettingsTile(label: '课程提醒', value: '已开启'),
              _SettingsTile(label: '提前时间', value: '10 分钟'),
            ],
          ),
        ],
      ),
    );
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
  const _SettingsTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      trailing: Text(value, style: const TextStyle(color: Colors.black54)),
      onTap: () {},
    );
  }
}
