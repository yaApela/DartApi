import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/category_model.dart';
import 'package:dart_application_cons/models/note_model.dart';


class FilterController extends ResourceController {
  final ManagedContext managedContext;

  FilterController(this.managedContext);

  @Operation.get()
  Future<Response> filterCategory(
      @Bind.query('filterByCategory') int categoryId) async {
    try {
      final query = Query<Note>(managedContext)
        ..join(
          object: (x) => x.category,
        )
        ..where((x) => x.category!.id).equalTo(categoryId);

      final operations = await query.fetch();
      if (operations.isEmpty) {
        return Response.ok("not found");
      }

      return Response.ok(operations);
    } catch (e) {
      return Response.serverError(
          body: "Unsuccess");
    }
  }
}