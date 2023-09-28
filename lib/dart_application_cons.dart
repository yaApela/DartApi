import 'dart:io';
import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/controllers/app_pagination_controller.dart';
import 'package:dart_application_cons/controllers/app_note_controller.dart';
import 'package:dart_application_cons/controllers/app_recover_note_controller.dart';
import 'package:dart_application_cons/controllers/app_search_controller.dart';
import 'controllers/app_auth_controller.dart';
import 'controllers/app_filter_controller.dart';
import 'controllers/app_token_controller.dart';
import 'controllers/app_user_controller.dart';

class AppService extends ApplicationChannel
{
  late final ManagedContext managedContext;
  
@override
  Future prepare() {
    final persistentStore = _initDatabase();

    managedContext = ManagedContext(
      ManagedDataModel.fromCurrentMirrorSystem(), persistentStore);
    return super.prepare();
  }
   @override
  Controller get entryPoint => Router()
    ..route('token/[:refresh]').link(
      () => AppAuthController(managedContext),
    )
    ..route('deleted-notes/[:operationId]')
        .link(AppTokenController.new)!
        .link(() => RecoverOperationController(managedContext))
    ..route('filter-notes/')
        .link(AppTokenController.new)!
        .link(() => FilterController(managedContext))
    ..route('user')
        .link(AppTokenController.new)!
        .link(() => AppUserController(managedContext))
    ..route('notes/[:noteId]')
        .link(AppTokenController.new)!
        .link(() => NoteController(managedContext))
    ..route('search/')
        .link(AppTokenController.new)!
        .link(() => SearchNotes(managedContext))
    ..route('pagination/')
        .link(AppTokenController.new)!
        .link(() => PaginationNotes(managedContext))
        ;

PersistentStore _initDatabase()
{
  final username = Platform.environment['DB_USERNAME'] ?? 'postgres';
  final password = Platform.environment['DB_PASSWORD'] ?? '123';
  final host = Platform.environment['DB_HOST'] ?? 'localhost';
  final port = int.parse(Platform.environment['DB_PORT'] ?? '5432');
  final databaseName = Platform.environment['DB_NAME'] ?? 'api_dart';
  return PostgreSQLPersistentStore(username, password, host, port, databaseName);
}

}


