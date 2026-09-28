import 'dart:convert';
import 'dart:io';

import '../models/track.dart';

/// Репозиторій, що зберігає та зчитує список треків у локальному файлі data.json.
class TrackRepository {
  final File _file;

  TrackRepository([String path = 'data.json']) : _file = File(path);

  /// Зчитує треки з файла. Якщо файла немає або він порожній — повертає [].
  Future<List<Track>> load() async {
    if (!await _file.exists()) return [];
    final raw = await _file.readAsString();
    if (raw.trim().isEmpty) return [];
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Track.fromJson(e as Map<String, dynamic>)).toList();
  }

  /// Записує список треків у файл з відступами (людиночитабельний JSON).
  Future<void> save(List<Track> tracks) async {
    const encoder = JsonEncoder.withIndent('  ');
    final data = tracks.map((t) => t.toJson()).toList();
    await _file.writeAsString(encoder.convert(data));
  }
}
