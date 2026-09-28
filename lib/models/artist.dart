import 'storable.dart';
import 'track.dart';

/// Друга модель, повʼязана з Track: виконавець і кількість його треків у фонотеці.
class Artist implements Storable {
  final String name;
  final int trackCount;

  Artist({required this.name, this.trackCount = 0});

  /// Побудова виконавця за списком треків — звʼязок між моделями.
  factory Artist.fromTracks(String name, List<Track> tracks) => Artist(
    name: name,
    trackCount: tracks.where((t) => t.artist == name).length,
  );

  @override
  Map<String, dynamic> toJson() => {'name': name, 'trackCount': trackCount};

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    name: json['name'] as String,
    trackCount: json['trackCount'] as int? ?? 0,
  );

  @override
  String toString() => '$name — $trackCount трек(ів)';
}
