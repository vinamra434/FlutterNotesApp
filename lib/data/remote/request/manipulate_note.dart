class ManipulateNote {
  String noteTitle;
  String noteContent;

  ManipulateNote({this.noteTitle, this.noteContent});

  ManipulateNote.fromJson(Map<String, dynamic> json) {
    noteTitle = json['noteTitle'];
    noteContent = json['noteContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['noteTitle'] = this.noteTitle;
    data['noteContent'] = this.noteContent;
    return data;
  }
}
