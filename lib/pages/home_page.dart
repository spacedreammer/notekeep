import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notekeep/services/auth/auth_service.dart';
import 'package:notekeep/services/firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() async {
    AuthService authService = AuthService();
    await authService.signOut();
  }

  final FirebaseService firebaseService = FirebaseService();

  final TextEditingController noteEditingController = TextEditingController();
  final TextEditingController titleEditingController = TextEditingController();

  void alertButton({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.grey[200],
              content: Container(
                width: 450,
                height: 100,
                child: Column(
                  children: [
                    TextField(
                      controller: titleEditingController,
                      decoration: const InputDecoration(hintText: "Title"),
                    ),
                    TextField(
                      controller: noteEditingController,
                      decoration: const InputDecoration(hintText: "Note"),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firebaseService.addNotes(noteEditingController.text,
                            titleEditingController.text);
                      } else {
                        firebaseService.updateNote(
                            docID,
                            titleEditingController.text,
                            noteEditingController.text);
                      }

                      noteEditingController.clear();
                      titleEditingController.clear();

                      //close the note
                      Navigator.pop(context);
                    },
                    child: Text("Save"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            width: 356,
            height: 53,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[200]),
            child: Row(
              children: [
                const IconButton(onPressed: null, icon: Icon(Icons.menu)),
                const Text(
                  "Search your note",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 88,
                ),
                IconButton(onPressed: null, icon: Icon(Icons.grid_view)),
                IconButton(onPressed: signOut, icon: Icon(Icons.logout)),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firebaseService.getNotes(),
        builder: (context, snapshot) {
          //check if snapshot has data
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: noteList.length,
                itemBuilder: ((context, index) {
                  //get individual document
                  DocumentSnapshot document = noteList[index];
                  String docID = document.id;

                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  String noteText = data['note'];
                  String titleText = data['title'];

                  return ListTile(
                    title: Text(titleText),
                    subtitle: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          //update
                          onPressed: () => alertButton(docID: docID),
                          icon: Icon(Icons.settings),
                        ),

                        //delete
                        IconButton(
                          onPressed: () => firebaseService.deleteNote(docID),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                }));
          }
          return Text('No Notes to show');
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[200],
        onPressed: alertButton,
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
