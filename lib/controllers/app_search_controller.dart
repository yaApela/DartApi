import 'dart:developer';
import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/note_model.dart';
import '../utils/response_model.dart';

class SearchNotes extends ResourceController {
  final ManagedContext managedContext;
  SearchNotes(this.managedContext);
  @Operation.get()
  Future<Response> searchNotes(@Bind.query('nameNote') String nameNote) async {
    try {
      var query = Query<Note>(managedContext)
        ..where((x) => x.nameNote).contains(nameNote, caseSensitive: false)
        ..join(
          object: (x) => x.user,
        )
        ..join(object: (x) => x.category);

      List<Note> Notes = await query.fetch();

      if (Notes.isEmpty) {
        return Response.ok(ModelResponse(message: "not found"));
      }

      for (var note in Notes) {
        note.user!
            .removePropertiesFromBackingMap(['accessToken', 'refreshToken']);
      }

      return Response.ok(Notes);
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "not found"));
    }
  }
}