class Note {
  int? id;
  String? note;
  String? created_at;
  int? user_id;
  bool? isdone;

  Note({this.note, this.created_at, this.user_id, this.id, this.isdone});

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json["id"],
      note: json["note"],
      created_at: json["created_at"],
      user_id: json["user_id"],
      isdone: json["isdone"],
    );
  }

}
