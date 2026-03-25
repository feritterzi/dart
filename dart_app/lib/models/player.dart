class Player {
  String id;
  String name;

  Player({required this.id, required this.name});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};
}