import 'dart:io';

import 'package:music_library/models/artist.dart';
import 'package:music_library/models/track.dart';
import 'package:music_library/repositories/track_repository.dart';
import 'package:music_library/services/itunes_service.dart';

Future<void> main() async {
  final repository = TrackRepository();
  final service = ItunesService();
  final tracks = await repository.load();

  stdout.writeln('=== Музична фонотека (варіант 9, iTunes Search API) ===');
  stdout.writeln('Завантажено ${tracks.length} трек(ів) із data.json.');

  var running = true;
  while (running) {
    _printMenu();
    final choice = stdin.readLineSync()?.trim();
    switch (choice) {
      case '1':
        _showAll(tracks);
        break;
      case '2':
        _addTrack(tracks);
        await repository.save(tracks);
        break;
      case '3':
        _removeTrack(tracks);
        await repository.save(tracks);
        break;
      case '4':
        _search(tracks);
        break;
      case '5':
        _sort(tracks);
        break;
      case '6':
        await _fetchFromApi(tracks, service);
        await repository.save(tracks);
        break;
      case '7':
        _showArtists(tracks);
        break;
      case '0':
        running = false;
        break;
      default:
        stdout.writeln('Невідомий пункт меню. Спробуйте ще раз.');
    }
  }

  await repository.save(tracks);
  service.close();
  stdout.writeln('Дані збережено у data.json. До побачення!');
}

void _printMenu() {
  stdout.writeln('''
--- Меню ---
1 — показати список
2 — додати трек
3 — видалити трек
4 — пошук за виконавцем
5 — сортувати за роком
6 — завантажити з iTunes API
7 — показати виконавців
0 — вихід''');
  stdout.write('Оберіть пункт: ');
}

void _showAll(List<Track> tracks) {
  if (tracks.isEmpty) {
    stdout.writeln('Фонотека порожня.');
    return;
  }
  for (var i = 0; i < tracks.length; i++) {
    stdout.writeln('${i + 1}. ${tracks[i]}');
  }
}

void _addTrack(List<Track> tracks) {
  stdout.write('Назва треку: ');
  final title = stdin.readLineSync()?.trim() ?? '';
  stdout.write('Виконавець: ');
  final artist = stdin.readLineSync()?.trim() ?? '';
  stdout.write('Альбом: ');
  final album = stdin.readLineSync()?.trim() ?? '';
  stdout.write('Рік: ');
  final year = int.tryParse(stdin.readLineSync()?.trim() ?? '') ?? 0;

  if (title.isEmpty || artist.isEmpty) {
    stdout.writeln('Назва і виконавець обовʼязкові. Додавання скасовано.');
    return;
  }
  final id = _nextId(tracks);
  tracks.add(
    Track(
      id: id,
      title: title,
      artist: artist,
      album: album.isEmpty ? '—' : album,
      year: year,
    ),
  );
  stdout.writeln('Додано: ${tracks.last}');
}

void _removeTrack(List<Track> tracks) {
  _showAll(tracks);
  if (tracks.isEmpty) return;
  stdout.write('Номер для видалення: ');
  final n = int.tryParse(stdin.readLineSync()?.trim() ?? '');
  if (n == null || n < 1 || n > tracks.length) {
    stdout.writeln('Некоректний номер.');
    return;
  }
  final removed = tracks.removeAt(n - 1);
  stdout.writeln('Видалено: $removed');
}

void _search(List<Track> tracks) {
  stdout.write('Пошук за виконавцем: ');
  final query = (stdin.readLineSync()?.trim() ?? '').toLowerCase();
  final found = tracks
      .where((t) => t.artist.toLowerCase().contains(query))
      .toList();
  if (found.isEmpty) {
    stdout.writeln('Нічого не знайдено.');
    return;
  }
  found.forEach(stdout.writeln);
}

void _sort(List<Track> tracks) {
  tracks.sort((a, b) => a.year.compareTo(b.year));
  stdout.writeln('Відсортовано за роком (за зростанням):');
  _showAll(tracks);
}

Future<void> _fetchFromApi(List<Track> tracks, ItunesService service) async {
  stdout.write('Пошуковий запит для iTunes (напр. Queen): ');
  final term = stdin.readLineSync()?.trim() ?? '';
  if (term.isEmpty) {
    stdout.writeln('Порожній запит.');
    return;
  }
  try {
    final found = await service.searchTracks(term, limit: 10);
    if (found.isEmpty) {
      stdout.writeln('iTunes не повернув результатів.');
      return;
    }
    var maxId = tracks.isEmpty ? 0 : _nextId(tracks) - 1;
    for (final t in found) {
      maxId++;
      tracks.add(
        Track(
          id: maxId,
          title: t.title,
          artist: t.artist,
          album: t.album,
          year: t.year,
        ),
      );
    }
    stdout.writeln('Додано ${found.length} трек(ів) з iTunes.');
  } catch (e) {
    stdout.writeln('Не вдалося отримати дані з API: $e');
    stdout.writeln('Продовжуємо працювати з локальними даними.');
  }
}

void _showArtists(List<Track> tracks) {
  final names = tracks.map((t) => t.artist).toSet();
  if (names.isEmpty) {
    stdout.writeln('Немає виконавців.');
    return;
  }
  final artists = names.map((n) => Artist.fromTracks(n, tracks)).toList()
    ..sort((a, b) => b.trackCount.compareTo(a.trackCount));
  stdout.writeln('Виконавці у фонотеці:');
  artists.forEach(stdout.writeln);
}

int _nextId(List<Track> tracks) => tracks.isEmpty
    ? 1
    : tracks.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
