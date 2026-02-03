import 'package:hive/hive.dart';

import '../models/app_settings.dart';

class HiveSettingsRepository {
  HiveSettingsRepository({Box<Map>? box}) : _box = box ?? Hive.box<Map>('settings');

  final Box<Map> _box;
  static const _key = 'app';

  Future<AppSettings> fetch() async {
    final raw = _box.get(_key);
    final settings = AppSettings.fromMap(raw);
    if (raw == null) {
      await _box.put(_key, settings.toMap());
    }
    return settings;
  }

  Future<void> save(AppSettings settings) async {
    await _box.put(_key, settings.toMap());
  }
}
