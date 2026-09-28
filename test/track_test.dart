import 'package:music_library/models/track.dart';
import 'package:music_library/models/track_status.dart';
import 'package:test/test.dart';

void main() {
  group('Track', () {
    final track = Track(
      id: 1,
      title: 'Bohemian Rhapsody',
      artist: 'Queen',
      album: 'A Night at the Opera',
      year: 1975,
      status: TrackStatus.favorite,
    );

    test('toJson повертає правильну мапу', () {
      expect(track.toJson(), {
        'id': 1,
        'title': 'Bohemian Rhapsody',
        'artist': 'Queen',
        'album': 'A Night at the Opera',
        'year': 1975,
        'status': 'favorite',
      });
    });

    test('fromJson відновлює обʼєкт (перевірка «туди й назад»)', () {
      final restored = Track.fromJson(track.toJson());
      expect(restored.title, equals('Bohemian Rhapsody'));
      expect(restored.year, equals(1975));
      expect(restored.status, equals(TrackStatus.favorite));
    });

    test('пошук за виконавцем працює (where)', () {
      final list = [
        track,
        Track(
          id: 2,
          title: 'Imagine',
          artist: 'John Lennon',
          album: 'Imagine',
          year: 1971,
        ),
      ];
      final queen = list.where((t) => t.artist == 'Queen').toList();
      expect(queen, hasLength(1));
      expect(queen.first.title, 'Bohemian Rhapsody');
    });

    test('сортування за роком працює (sort)', () {
      final list = [
        Track(id: 1, title: 'B', artist: 'X', album: 'X', year: 2000),
        Track(id: 2, title: 'A', artist: 'Y', album: 'Y', year: 1990),
      ];
      list.sort((a, b) => a.year.compareTo(b.year));
      expect(list.first.year, 1990);
      expect(list.last.year, 2000);
    });

    test('некоректні дані спричиняють очікувану помилку', () {
      expect(
        () => Track.fromJson({'id': 'not-an-int'}),
        throwsA(isA<TypeError>()),
      );
    });
  });
}
