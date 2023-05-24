class FileSystem {
  final int? id;
  final String name;
  final bool is_file;
  final int? parent_id;
  final String created_at;

  FileSystem(
      {this.id,
      required this.name,
      required this.is_file,
      required this.parent_id,
      required this.created_at});

  factory FileSystem.fromJson(Map<String, dynamic> json) {
    return FileSystem(
        id: json['id'],
        name: json['name'],
        is_file: json['is_file'],
        parent_id: json['parent_id'],
        created_at: json['created_at']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'is_file': is_file,
        'parent_id': parent_id,
        'created_at': created_at
      };
}
