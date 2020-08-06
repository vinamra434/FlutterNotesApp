import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:notes_http_app/data/remote/generic_api_response.dart';
import 'package:notes_http_app/data/remote/response/model_note_display.dart';
import 'package:notes_http_app/data/repository/note_repository.dart';
import 'package:notes_http_app/widgets/deletenote/delete_note_dialog.dart';
import 'package:notes_http_app/widgets/modifynote/note_modify.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NoteRepository get repository => GetIt.instance<NoteRepository>();
  bool _isLoading = false;

  GenericApiResponse<List<ModelNoteDisplay>> _apiResponse;

  @override
  void initState() {
    super.initState();
    _fetchNotes();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await repository.getNoteList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("List of Notes"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NoteModify())).then((value) => _fetchNotes());
          },
          child: Icon(Icons.add),
        ),
        body: Builder(
          builder: (BuildContext context) {
            if (_isLoading) {
              return Center(child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ));
            }

            if (_apiResponse.error) {
              return Center(child: Text(_apiResponse.message));
            }

            return ListView.separated(
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: ValueKey(_apiResponse.data[index].noteId),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {},
                    confirmDismiss: (direction) async {
                      var result = await showDialog(
                          context: context, builder: (context) => NoteDelete());

                      if(result) {
                        final deleteResult = await repository.deleteNote(_apiResponse.data[index].noteId);
                        var message;
                        if(deleteResult!= null && deleteResult.data == true) {
                          message = "message deleted successfully";
                        } else {
                          message = deleteResult?.message??"An error occurred";
                        }
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(message), duration: new Duration(milliseconds: 1000),));
                      }
                      return result?.data??false;
                    },
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    child: ListTile(
                      title: Text(_apiResponse.data[index].noteTitle),
                      subtitle: Text(
                          "Last Edited on ${formatDate(_apiResponse.data[index].lastEditedData ??
                              _apiResponse.data[index].createdDate)}"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NoteModify(
                                  noteId: _apiResponse.data[index].noteId,
                                ))).then((value) => _fetchNotes());
                      },
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) => Divider(
                      height: 1,
                      color: Colors.green,
                    ),
                itemCount: _apiResponse.data.length);
          },
        ));
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }
}
