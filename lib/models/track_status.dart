/// Довідникове поле: статус треку в особистій фонотеці.
enum TrackStatus { wishlist, listening, favorite }

extension TrackStatusX on TrackStatus {
  /// Людиночитабельна назва статусу для консольного виводу.
  String get label => switch (this) {
    TrackStatus.wishlist => 'у списку бажань',
    TrackStatus.listening => 'слухаю',
    TrackStatus.favorite => 'улюблене',
  };

  /// Відновлення значення enum за назвою (з JSON); за замовчуванням — wishlist.
  static TrackStatus fromName(String? name) => TrackStatus.values.firstWhere(
    (s) => s.name == name,
    orElse: () => TrackStatus.wishlist,
  );
}
