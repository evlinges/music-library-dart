import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/track.dart';

/// Сервіс звернення до зовнішнього iTunes Search API.
///
/// http.Client приймається через конструктор, щоб у тестах можна було
/// підставити MockClient і перевірити розбір відповіді без реального запиту.
class ItunesService {
  final http.Client _client;

  ItunesService({http.Client? client}) : _client = client ?? http.Client();

  /// Пошук треків за запитом. Кидає Exception, якщо статус відповіді ≠ 200.
  Future<List<Track>> searchTracks(String term, {int limit = 10}) async {
    final uri = Uri.https('itunes.apple.com', '/search', {
      'term': term,
      'entity': 'song',
      'limit': '$limit',
    });

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Помилка запиту до iTunes API: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final results = data['results'] as List<dynamic>;
    return results
        .map((e) => Track.fromItunes(e as Map<String, dynamic>))
        .toList();
  }

  void close() => _client.close();
}
