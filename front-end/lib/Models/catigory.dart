class Catigory {
  final int id;
  final String type;
  Catigory({required this.id, required this.type});

  static Catigory categoryFromJson(Map json) {
    return Catigory(id: json['id'], type: json['name']);
  }
}
