class ModelNoteDisplay {
  String noteId;
  String noteTitle;
  DateTime createdDate, lastEditedData;

  ModelNoteDisplay(
      {this.noteId, this.noteTitle, this.createdDate, this.lastEditedData});

  factory ModelNoteDisplay.fromJson(Map<String, dynamic> item) {
    return ModelNoteDisplay(
        noteTitle: item["noteTitle"],
        noteId: item["noteID"],
        createdDate: DateTime.parse(
          item["createDateTime"],
        ),
        lastEditedData: item["latestEditDateTime"] == null
            ? null
            : DateTime.parse(
                item["latestEditDateTime"],
              )
    );
  }
}
