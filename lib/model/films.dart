import 'package:uuid/uuid.dart';

class Films {
  final String id;
  final String title;
  final String description;
  bool isFavorite;
  Films({
    required this.title,
    required this.description,
    required this.isFavorite,
    String? id,
  }) : id = id ?? const Uuid().v4();

  Films copyWith({
    String? id,
    String? title,
    String? description,
    bool? isFavorite,
  }) {
    return Films(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  String toString() {
    return 'Films(id: $id, title: $title, description: $description, isFavorite: $isFavorite)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Films &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isFavorite == isFavorite;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        description.hashCode ^
        isFavorite.hashCode;
  }

  static List<Films> listFilms = [
    Films(
      id: '1',
      title: 'The Shawshank Redemption',
      description: 'Two imprisoned',
      isFavorite: false,
    ),
    Films(
      id: '2',
      title: 'The Godfather',
      description:
          'The aging patriarch of an organized crime dynasty transfers control of his clandestine empire to his reluctant son.',
      isFavorite: false,
    ),
    Films(
      id: '3',
      title: 'The Dark Knight',
      description:
          'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, the caped crusader must come to terms with one of the greatest psychological tests of his ability to fight injustice.',
      isFavorite: false,
    ),
    Films(
      id: '4',
      title: 'The Godfather: Part II',
      description:
          'The early life and career of Vito Corleone in 1920s New York is portrayed while his son, Michael, expands and tightens his grip on the family crime syndicate.',
      isFavorite: false,
    ),
  ];
}
