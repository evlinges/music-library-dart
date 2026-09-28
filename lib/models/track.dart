import 'storable.dart';
import 'track_status.dart';

/// Основна модель предметної області — трек музичної фонотеки.
class Track implements Storable {
  final int id;
  final String title;
  final String artist;
  final String album;
  int year;
  TrackStatus status;

  Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.year,
    this.status = TrackStatus.wishlist,
  });

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'artist': artist,
    'album': album,
    'year': year,
    'status': status.name,
  };

  /// Фабричний конструктор для розбору запису з файла data.json.
  factory Track.fromJson(Map<String, dynamic> json) => Track(
    id: json['id'] as int,
    title: json['title'] as String,
    artist: json['artist'] as String,
    album: json['album'] as String,
    year: json['year'] as int,
    status: TrackStatusX.fromName(json['status'] as String?),
  );

  /// Фабричний конструктор для елемента відповіді iTunes Search API.
  factory Track.fromItunes(Map<String, dynamic> json) => Track(
    id: json['trackId'] as int? ?? 0,
    title: json['trackName'] as String? ?? 'Без назви',
    artist: json['artistName'] as String? ?? 'Невідомий виконавець',
    album: json['collectionName'] as String? ?? '—',
    year: DateTime.tryParse(json['releaseDate'] as String? ?? '')?.year ?? 0,
  );

  @override
  String toString() =>
      '#$id «$title» — $artist, $album ($year) [${status.label}]';
}
