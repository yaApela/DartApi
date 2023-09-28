import 'dart:async';
import 'dart:developer';
import 'dart:ffi';
import 'package:dart_application_cons/models/note_model.dart';
import 'package:quiver/iterables.dart';
import 'package:conduit/conduit.dart';

class PaginationNotes extends ResourceController {
  final ManagedContext managedContext;

  PaginationNotes(this.managedContext);

  @Operation.get()
  Future<Response> paginationNotes(
      @Bind.query('win') int win, @Bind.query('note') int note) async {
    final query = Query<Note>(managedContext)
      ..join(object: (x) => x.user,)
      ..join(object: (x) => x.category,);

    final Notes = await query.fetch();
    // разбитие массива на notes и win
    final wins = partition(Notes, note);

    return Response.ok({
      "data": _toJSON(wins.elementAt(win - 1)),
    });
  }

  List _toJSON(List<Note> Notes) {
    final array = [];
    for (var notes in Notes) {
      array.add({
        "id": notes.id,
        "numberNote": notes.numberNote,
        "nameNote": notes.nameNote,
        "content": notes.content,
        "dateCr": notes.createdAt.toString(),
        "dateUp": notes.updatedAt.toString(),
        "user": {
          "id": notes.user!.id,
          "username": notes.user!.username,
          "email": notes.user!.email,
        },
        "Category": {
          "id": notes.category!.id,
          "nameCategory": notes.category!.NameCategory,
        }
      });
    }
    return array;
  }
}
