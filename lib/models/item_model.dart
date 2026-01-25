class ItemModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final bool isRequired;

  ItemModel({
    required this.id,
    required this.name,
    this.description = '',
    this.imageUrl,
    this.isRequired = true,
  });

  // JSONからオブジェクトを生成
  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      isRequired: json['isRequired'] as bool? ?? true,
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
    };
  }

  // コピーメソッド
  ItemModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    bool? isRequired,
  }) {
    return ItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isRequired: isRequired ?? this.isRequired,
    );
  }
}
