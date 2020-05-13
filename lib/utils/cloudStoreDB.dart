import 'package:cloud_firestore/cloud_firestore.dart';
//ARCHIVO  .yaml
//cloud_firestore: ^0.13.0+1

class CSDB {
  final db = Firestore.instance;

  Future<DocumentReference> createData(String collection, data) async {
    DocumentReference ref = await db
        .collection(collection)
        .add({'name': 'nombre c', 'todo': 'amigo'});

    return ref;
  }

  void updateData(
      String collection, String field, String value, String documentId) async {
    await db
        .collection(collection)
        .document(documentId)
        .updateData({field: value});
  }

  void deleteData(String collection, DocumentSnapshot doc) async {
    await db.collection(collection).document(doc.documentID).delete();
  }
}
