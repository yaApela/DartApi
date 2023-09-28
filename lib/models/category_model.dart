import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/note_model.dart';

class Category extends ManagedObject<_Category> implements _Category{}

class _Category
{
  @Column(primaryKey: true)
  int? id;
  @Column(unique:true, indexed: true)
  String? NameCategory;
   ManagedSet<Note>? Notes;

}