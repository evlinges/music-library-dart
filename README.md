# Музична фонотека (Dart, консольний застосунок)

Лабораторна робота з дисципліни **«Кросплатформенне програмування»** (викл. Кавара А.О.).
**Варіант 9 — Музична фонотека**, зовнішнє джерело даних — **iTunes Search API**.

Консольний застосунок мовою Dart: описує предметну область класами, отримує дані з
відкритого REST API, зберігає їх у файл `data.json` і відновлює під час наступного запуску.

## Можливості
- текстове меню: показати список, додати, видалити, пошук, сортування, завантажити з API, виконавці, вихід;
- збереження треків у локальному файлі `data.json` (серіалізація JSON);
- отримання треків із зовнішнього iTunes Search API (пакет `http`, `async/await`);
- дві повʼязані моделі (`Track`, `Artist`) на базі спільного інтерфейсу `Storable`;
- `enum TrackStatus` як довідникове поле;
- обробка помилок мережі та некоректного вводу через `try/catch`;
- модульні тести (пакет `test`, у т.ч. `MockClient`).

## Структура проєкту
```
bin/main.dart                     — точка входу, текстове меню
lib/models/storable.dart          — абстрактний інтерфейс toJson()
lib/models/track.dart             — модель треку (основна)
lib/models/artist.dart            — модель виконавця (повʼязана)
lib/models/track_status.dart      — enum статусу треку
lib/services/itunes_service.dart  — сервіс звернення до iTunes API
lib/repositories/track_repository.dart — збереження/читання data.json
test/                             — модульні тести
```

## Використане API
**iTunes Search API** (без авторизації):

```
https://itunes.apple.com/search?term=queen&entity=song&limit=10
```

Приклад відповіді (скорочено):
```json
{
  "resultCount": 10,
  "results": [
    {
      "trackId": 1440806041,
      "trackName": "Bohemian Rhapsody",
      "artistName": "Queen",
      "collectionName": "A Night at the Opera",
      "releaseDate": "1975-11-21T12:00:00Z"
    }
  ]
}
```

## Запуск
```bash
dart pub get
dart run bin/main.dart
```

## Тести та перевірка коду
```bash
dart test
dart format .
dart analyze
```

## Звіт
Повний звіт до лабораторної роботи (зі знімками роботи та результатами тестів): **[ЗВІТ.md](ЗВІТ.md)**
