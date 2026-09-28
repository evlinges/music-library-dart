import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:music_library/services/itunes_service.dart';
import 'package:test/test.dart';

void main() {
  group('ItunesService', () {
    test('searchTracks розбирає відповідь через MockClient', () async {
      final mock = MockClient((request) async {
        final body = jsonEncode({
          'resultCount': 1,
          'results': [
            {
              'trackId': 10,
              'trackName': 'Test Song',
              'artistName': 'Tester',
              'collectionName': 'Test Album',
              'releaseDate': '2020-05-01T00:00:00Z',
            },
          ],
        });
        return http.Response(body, 200);
      });

      final service = ItunesService(client: mock);
      final tracks = await service.searchTracks('test');

      expect(tracks, hasLength(1));
      expect(tracks.first.title, 'Test Song');
      expect(tracks.first.artist, 'Tester');
      expect(tracks.first.year, 2020);
    });

    test('ненульовий statusCode спричиняє виняток', () {
      final mock = MockClient((request) async => http.Response('error', 500));
      final service = ItunesService(client: mock);
      expect(() => service.searchTracks('x'), throwsA(isA<Exception>()));
    });
  });
}
