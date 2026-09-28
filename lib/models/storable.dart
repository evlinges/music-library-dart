/// Базовий інтерфейс для будь-якого обʼєкта предметної області,
/// який можна серіалізувати у JSON. Реалізують обидві моделі — Track і Artist.
abstract class Storable {
  Map<String, dynamic> toJson();
}
