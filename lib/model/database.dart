import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('test');

class Database {
  static String? userUid;
}

//Writing Data
Future<void> addItem({
  required String title,
  required String description,
}) async {
  DocumentReference documentReferencer =
      _mainCollection.doc(Database.userUid).collection('test').doc();

  Map<String, dynamic> data = <String, dynamic>{
    "title": title,
    "description": description,
  };

  await documentReferencer
      .set(data)
      .whenComplete(() => print('Notes added Successfully'))
      .catchError((e) => print(e));
}

//Reading data using stream
Stream<QuerySnapshot> readItems(){
  CollectionReference notesItemCollection = _mainCollection.doc(Database.userUid).collection('items');
  return notesItemCollection.snapshots();
}

//Updating data
Future<void> updateItem({
required String title,
required String description,
required String docId,

}) async{
  DocumentReference documentReferencer= _mainCollection.doc(Database.userUid).collection('items').doc(docId);

  Map<String, dynamic> data= <String, dynamic>{
    'title': title,
    'description': description,
  };
  await documentReferencer.update(data).whenComplete(() => print("Updated")).catchError((e) => print(e));
}

//delete
Future<void> deleteItem({
  required String docId,
}) async {
  DocumentReference documentReferencer= _mainCollection.doc(Database.userUid).collection('items').doc(docId);

  await documentReferencer
  .delete().whenComplete(() => print('Deleted')).catchError((e) => print(e));
}