class ItemModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final bool isRequired;
  final bool isWeekday;
  final bool isWeekend;

  ItemModel({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl,
    this.isRequired = false,
    this.isWeekday = false,
    this.isWeekend = false,
  });

  // JSONからオブジェクトを生成
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      isRequired: json['isRequired'] as bool? ?? false,
      isWeekday: json['isWeekday'] as bool? ?? false,
      isWeekend: json['isWeekend'] as bool? ?? false,
    );
  }

  // オブジェクトをJSONに変換
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'isRequired': isRequired,
      'isWeekday': isWeekday,
      'isWeekend': isWeekend,
    };
  }

  // コピーメソッド
  ItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isRequired,
    bool? isWeekday,
    bool? isWeekend,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isRequired: isRequired ?? this.isRequired,
      isWeekday: isWeekday ?? this.isWeekday,
      isWeekend: isWeekend ?? this.isWeekend,
    );
  }
}
