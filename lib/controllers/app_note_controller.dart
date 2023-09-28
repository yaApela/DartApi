import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/note_model.dart';
import '../models/user_model.dart';
import '../utils/app_utils.dart';
import '../utils/response_model.dart';

class NoteController extends ResourceController
{
  final ManagedContext managedContext;
  @Operation.post()
  Future<Response> NotesAdd(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Note Notes) async {
    try {
      final id = AppUtils.getIdFromHeader(header);

      final qFindUser = Query<User>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..returningProperties((x) => [x.salt, x.hashPassword]);

      final fUser = await qFindUser.fetchOne();

      final NotesAdd = Query<Note>(managedContext)
        ..values.numberNote = Notes.numberNote
        ..values.nameNote = Notes.nameNote
        ..values.createdAt = DateTime.now()
        ..values.updatedAt = DateTime.now()
        ..values.content = Notes.content
        ..values.category!.id = Notes.category!.id
        ..values.user = fUser;

      NotesAdd.insert();
      return Response.ok(ModelResponse(message: "Successful end of the operation (add)"));
    } on QueryException catch (e) {
      return Response.badRequest(
          body: ModelResponse(
              message: "Unsuccessful end of the operation (add)", error: e.message));
    }
  }

   @Operation.put('noteId')
  Future<Response> NoteUpdate(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.body() Note Notes,
      @Bind.path('noteId') int noteId) async {
    try {
      final id = AppUtils.getIdFromHeader(header);

      final qFindUser = Query<User>(managedContext)
        ..where((x) => x.id).equalTo(id)
        ..returningProperties((x) => [x.salt, x.hashPassword]);

      final fUser = await qFindUser.fetchOne();

      final noteUpdate = Query<Note>(managedContext)
        ..where((x) => x.id).equalTo(noteId)
         ..values.numberNote = Notes.numberNote
        ..values.nameNote = Notes.nameNote
        ..values.updatedAt = DateTime.now()
        ..values.content = Notes.content
        ..values.category!.id = Notes.category!.id
        ..values.user = fUser;


      noteUpdate.updateOne();
      return Response.ok(ModelResponse(message: "Successful end of the operation (update)"));
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Unsuccessful end of the operation (update)"));
    }
  }

 @Operation.delete('noteId')
  Future<Response> NotesDelete(
      @Bind.header(HttpHeaders.authorizationHeader) String header,
      @Bind.path('noteId') int noteId) async {
    try {
      final id = AppUtils.getIdFromHeader(header);
      var query = Query<Note>(managedContext)
        ..where((x) => x.id).equalTo(noteId);
        query.delete();
      return Response.ok(ModelResponse(message: "Successful end of the operation (delete)"));
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Unsuccessful end of the operation (delete)"));
    }
  }

  @Operation.get()
  Future<Response> NotesGet() async {
    try {
      var query = Query<Note>(managedContext)
        ..join(
          object: (x) => x.user,
        )
        ..join(
          object: (x) => x.category,
        );

      List<Note> notes = await query.fetch();

      for (var note in notes) {
        note.user!
            .removePropertiesFromBackingMap(['accessToken', 'refreshToken']);
      }

      return Response.ok(notes);
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Unsuccessful end of the operation (get)"));
    }
  }
   @Operation.get("noteId")
  Future<Response> NotesGetOne(
      @Bind.path('noteId') int noteId) async {
    try {
      var query = Query<Note>(managedContext)
        ..join(object: (x) => x.user)
        ..join(object: (x) => x.category,)
        ..where((x) => x.id).equalTo(noteId);

      final notes = await query.fetchOne();

      if (notes == null) {
        return Response.badRequest(
            body: ModelResponse(message: "not found"));
      }

      notes.user!
          .removePropertiesFromBackingMap(['refreshToken', 'accessToken']);
      return Response.ok(notes);
    } catch (e) {
      return Response.badRequest(
          body: ModelResponse(message: "Unsuccessful end of the operation (get one)"));
    }
  }
  NoteController(this.managedContext);
}