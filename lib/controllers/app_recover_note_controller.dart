import 'dart:developer';
import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/note_model.dart';
import '../models/user_model.dart';
import '../utils/app_utils.dart';

class RecoverOperationController extends ResourceController {
  final ManagedContext managedContext;

  RecoverOperationController(this.managedContext);

  @Operation.get()
  Future<Response> getDeletedNotes(
      @Bind.header(HttpHeaders.authorizationHeader) String header) async {
    final id = AppUtils.getIdFromHeader(header);

    final query = Query<User>(managedContext)
      ..where((x) => x.id).equalTo(id)
      ..join(
        set: (x) => x.Notes,
      );
    final user = await query.fetchOne();

    final deletedNotes = user!.Notes!
        .where((element) => element.deleted == true)
        .toList();
    if (deletedNotes.isEmpty) {
      return Response.ok( "not data delete");
    }

    return Response.ok(deletedNotes);
  }

  @Operation.put("noteId")
  Future<Response> recover(@Bind.path('noteId') int noteId) async {
    final query = Query<Note>(managedContext)
      ..where((x) => x.id).equalTo(noteId);
    final note = await query.fetchOne();

    if (note == null) {
      return Response.badRequest(
          body:"not found note");
    }

    query..values.deleted = false;
    query.updateOne();

    return Response.ok("Success");
  }
}