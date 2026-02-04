import 'package:flutter/material.dart';

import '../../data/models/course.dart';

class CourseFormSheet extends StatefulWidget {
  const CourseFormSheet({super.key, this.initial, required this.maxPeriods});

  final Course? initial;
  final int maxPeriods;

  @override
  State<CourseFormSheet> createState() => _CourseFormSheetState();
}

class _CourseFormSheetState extends State<CourseFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _roomController;
  late final TextEditingController _teacherController;

  late int _weekday;
  late int _startPeriod;
  late int _endPeriod;
  late int _colorHex;

  final _colors = const [
    Color(0xFF5B8DEF),
    Color(0xFF36C9A5),
    Color(0xFFF4A261),
    Color(0xFFE76F51),
    Color(0xFF6C63FF),
    Color(0xFF2A9D8F),
    Color(0xFFF2C14E),
    Color(0xFFEF476F),
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _roomController = TextEditingController(text: initial?.location ?? '');
    _teacherController = TextEditingController(text: initial?.teacher ?? '');
    _weekday = initial?.weekday ?? 1;
    _startPeriod = (initial?.startPeriod ?? 1).clamp(1, widget.maxPeriods);
    _endPeriod = (initial?.endPeriod ?? (_startPeriod + 1))
        .clamp(1, widget.maxPeriods);
    _colorHex = initial?.colorHex ?? _colors.first.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    _teacherController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_endPeriod < _startPeriod) {
      setState(() {
        _endPeriod = _startPeriod;
      });
    }

    final id = widget.initial?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final course = Course(
      id: id,
      name: _nameController.text.trim(),
      teacher: _teacherController.text.trim().isEmpty
          ? null
          : _teacherController.text.trim(),
      location: _roomController.text.trim(),
      weekday: _weekday,
      startPeriod: _startPeriod,
      endPeriod: _endPeriod,
      weekStart: widget.initial?.weekStart ?? 1,
      weekEnd: widget.initial?.weekEnd ?? 20,
      colorHex: _colorHex,
      note: widget.initial?.note,
      reminderEnabled: widget.initial?.reminderEnabled ?? false,
      reminderMinutes: widget.initial?.reminderMinutes ?? 10,
    );

    Navigator.of(context).pop(course);
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.initial == null ? '新增课程' : '编辑课程',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: '课程名称',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '请输入课程名称';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _roomController,
                        decoration: const InputDecoration(
                          labelText: '教室',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '请输入教室';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _teacherController,
                        decoration: const InputDecoration(
                          labelText: '教师 (可选)',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildDaySelector()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildStartPeriod()),
                          const SizedBox(width: 12),
                          Expanded(child: _buildEndPeriod()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildColorPicker(),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: const Text('保存'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDaySelector() {
    const labels = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return DropdownButtonFormField<int>(
      value: _weekday,
      decoration: const InputDecoration(labelText: '周几'),
      items: List.generate(
        labels.length,
        (index) => DropdownMenuItem(
          value: index + 1,
          child: Text(labels[index]),
        ),
      ),
      onChanged: (value) {
        if (value != null) {
          setState(() => _weekday = value);
        }
      },
    );
  }

  Widget _buildStartPeriod() {
    return DropdownButtonFormField<int>(
      value: _startPeriod,
      decoration: const InputDecoration(labelText: '起始节次'),
      items: List.generate(
        widget.maxPeriods,
        (index) => DropdownMenuItem(
          value: index + 1,
          child: Text('第 ${index + 1} 节'),
        ),
      ),
      onChanged: (value) {
        if (value != null) {
          setState(() => _startPeriod = value);
        }
      },
    );
  }

  Widget _buildEndPeriod() {
    return DropdownButtonFormField<int>(
      value: _endPeriod,
      decoration: const InputDecoration(labelText: '结束节次'),
      items: List.generate(
        widget.maxPeriods,
        (index) => DropdownMenuItem(
          value: index + 1,
          child: Text('第 ${index + 1} 节'),
        ),
      ),
      onChanged: (value) {
        if (value != null) {
          setState(() => _endPeriod = value);
        }
      },
    );
  }

  Widget _buildColorPicker() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _colors.map((color) {
          final isSelected = _colorHex == color.value;
          return GestureDetector(
            onTap: () => setState(() => _colorHex = color.value),
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black87 : Colors.white,
                  width: isSelected ? 2 : 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
