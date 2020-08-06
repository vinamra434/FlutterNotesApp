class ModelNoteDetail {
  String noteId;
  String noteTitle;
  String noteContent;
  DateTime createdDate, lastEditedData;

  ModelNoteDetail(
      {this.noteId,
      this.noteTitle,
      this.noteContent,
      this.createdDate,
      this.lastEditedData});


  factory ModelNoteDetail.fromJson(Map<String, dynamic> item) {
    return ModelNoteDetail(
        noteTitle: item["noteTitle"],
        noteId: item["noteID"],
        createdDate: DateTime.parse(
          item["createDateTime"],
        ),
        noteContent: item["noteContent"],
        lastEditedData: item["latestEditDateTime"] == null
            ? null
            : DateTime.parse(
          item["latestEditDateTime"],
        )
    );
  }
}
