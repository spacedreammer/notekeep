import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

  //add notes
  Future<void> addNotes(String Note, String titleNote) {
    return notes
        .add({"note": Note, "title": titleNote, "timestamp": Timestamp.now()});
  }

  //read the notes from db

  Stream<QuerySnapshot> getNotes() {
    final streamNote = notes.orderBy("timestamp", descending: true).snapshots();

    return streamNote;
  }

  //update the notes
  Future<void> updateNote(String docID, String newTitle, String newNote) {
    return notes.doc(docID).update(
        {"title": newTitle, "note": newNote, "timestamp": Timestamp.now()});
  }

  //delete note
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
