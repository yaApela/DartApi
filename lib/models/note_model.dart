import 'package:conduit/conduit.dart';
import 'package:dart_application_cons/models/category_model.dart';
import 'package:dart_application_cons/models/user_model.dart';
import 'category_model.dart';

class Note extends ManagedObject<_Note> implements _Note{}
class _Note
{
  @primaryKey
  int? id;
  @Column(unique:true, indexed: true)
  String? numberNote;
    @Column(unique:true, indexed: true)
  String? nameNote;
    @Column(unique:true, indexed: true)
  String? content;
   @Relate(#Notes)
  Category? category;
   @Column(indexed: true)
   DateTime? createdAt;
   @Column(indexed: true)
   DateTime? updatedAt;
   @Relate(#Notes)
  User? user;
  @Column(defaultValue: 'false')
  bool? deleted;


}