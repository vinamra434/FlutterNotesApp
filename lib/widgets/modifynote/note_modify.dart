import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_http_app/data/remote/request/manipulate_note.dart';
import 'package:notes_http_app/data/remote/response/model_note_detail.dart';
import 'package:notes_http_app/data/repository/note_repository.dart';

class NoteModify extends StatefulWidget {
  String noteId;

  NoteModify({this.noteId});

  @override
  _NoteModifyState createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteId != null;

  NoteRepository get repository => GetIt.I<NoteRepository>();

  String errorMessage;
  ModelNoteDetail note;

  TextEditingController _titleEditingController = TextEditingController();
  TextEditingController _contentEditingController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    _fetchNote();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? "Edit note" : "Create note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(hintText: "Note Title"),
                    controller: _titleEditingController,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _contentEditingController,
                    decoration: InputDecoration(hintText: "Note Content"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () async {
                        if (isEditing) {

                          setState(() {
                            _isLoading = true;
                          });

                          final note = ManipulateNote(
                              noteTitle: _titleEditingController.text,
                              noteContent: _contentEditingController.text);
                          var response = await repository.updateNote(widget.noteId,note);

                          setState(() {
                            _isLoading = false;
                          });

                          final title = "Done";
                          final text = response.error
                              ? response.error ?? "An error occurred"
                              : "Note updated successfully";

                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          print("clicked");
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("ok"),
                                      )
                                    ],
                                  )).then((value) {
                            if (response.data) {
                              Navigator.of(context).pop();
                            }
                          });

                        } else {
                          setState(() {
                            _isLoading = true;
                          });

                          final note = ManipulateNote(
                              noteTitle: _titleEditingController.text,
                              noteContent: _contentEditingController.text);
                          var response = await repository.createNote(note);

                          setState(() {
                            _isLoading = false;
                          });

                          final title = "Done";
                          final text = response.error
                              ? response.error ?? "An error occurred"
                              : "Note created successfully";

                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text(title),
                                    content: Text(text),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          print("clicked");
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("ok"),
                                      )
                                    ],
                                  )).then((value) {
                            if (response.data) {
                              Navigator.of(context).pop();
                            }
                          });
                        }
                      },
                      child: Text("Submit"),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  void _fetchNote() {
    if (isEditing) {
      setState(() {
        _isLoading = true;
      });
      repository.getNote(widget.noteId).then((response) {
        if (response.error) {
          errorMessage = response.message ?? "An error occurred";
        }
        note = response.data;
        _titleEditingController.text = note.noteTitle;
        _contentEditingController.text = note.noteContent;

        setState(() {
          _isLoading = false;
        });
      });
    }
  }
}
