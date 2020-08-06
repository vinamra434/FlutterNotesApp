import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:notes_http_app/data/remote/generic_api_response.dart';
import 'package:notes_http_app/data/remote/request/manipulate_note.dart';
import 'package:notes_http_app/data/remote/response/model_note_detail.dart';
import 'package:notes_http_app/data/remote/response/model_note_display.dart';

class NoteRepository {
  static const API = "http://api.notes.programmingaddict.com/";
  static const headers = {"apiKey": "6e5b892f-dd06-4c41-b7bf-e284a7f2e3c6",  "Content-Type": "application/json"
};

  Future<GenericApiResponse<List<ModelNoteDisplay>>> getNoteList() {
    return http.get(API + "notes", headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final notes = <ModelNoteDisplay>[];
        for (var item in jsonData) {
          notes.add(ModelNoteDisplay.fromJson(item));
        }
        return GenericApiResponse<List<ModelNoteDisplay>>(data: notes);
      }
      return GenericApiResponse<List<ModelNoteDisplay>>(
          error: true, message: "An error occurred");
    }).catchError((error) => GenericApiResponse<List<ModelNoteDisplay>>(
        error: true, message: "An error occurred"));
  }

  Future<GenericApiResponse<ModelNoteDetail>> getNote(String noteId) {
    return http.get(API + "notes/" + noteId, headers: headers).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        return GenericApiResponse<ModelNoteDetail>(
            data: ModelNoteDetail.fromJson(jsonData));
      }
      return GenericApiResponse<ModelNoteDetail>(
          error: true, message: "An error occurred");
    }).catchError((error) => GenericApiResponse<ModelNoteDetail>(
        error: true, message: "An error occurred"));
  }

  Future<GenericApiResponse<bool>> createNote(ManipulateNote item) {
    return http
        .post(API + "notes", headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return GenericApiResponse<bool>(data: true);
      }
      return GenericApiResponse<bool>(
          error: true, message: "An error occurred");
    }).catchError((error) => GenericApiResponse<bool>(
            error: true, message: "An error occurred"));
  }

  Future<GenericApiResponse<bool>> updateNote(String noteId, ManipulateNote item) {
    return http
        .put(API + "notes/" + noteId, headers: headers, body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 204) {
        return GenericApiResponse<bool>(data: true);
      }
      return GenericApiResponse<bool>(
          error: true, message: "An error occurred");
    }).catchError((error) => GenericApiResponse<bool>(
            error: true, message: "An error occurred"));
  }

  Future<GenericApiResponse<bool>> deleteNote(String noteId) {
    return http
        .delete(API + "notes/" + noteId, headers: headers)
        .then((data) {
      if (data.statusCode == 204) {
        return GenericApiResponse<bool>(data: true);
      }
      return GenericApiResponse<bool>(
          error: true, message: "An error occurred");
    }).catchError((error) => GenericApiResponse<bool>(
            error: true, message: "An error occurred"));
  }
}
