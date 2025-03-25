import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // For formatted date
import 'note_editor_screen.dart';

class NotesListScreen extends StatefulWidget {
  @override
  _NotesListScreenState createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final CollectionReference notesRef = FirebaseFirestore.instance.collection('notes');
  Set<String> selectedNotes = {};
  bool isSelectionMode = false;

  void toggleSelection(String noteId) {
    setState(() {
      if (selectedNotes.contains(noteId)) {
        selectedNotes.remove(noteId);
      } else {
        selectedNotes.add(noteId);
      }
      isSelectionMode = selectedNotes.isNotEmpty;
    });
  }

  void deleteSelectedNotes() {
    for (String noteId in selectedNotes) {
      notesRef.doc(noteId).delete();
    }
    setState(() {
      selectedNotes.clear();
      isSelectionMode = false;
    });
  }

  Stream<QuerySnapshot> getUserNotes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Stream.empty();
    }
    return notesRef.where('userId', isEqualTo: user.uid).snapshots();
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return "Loading...";
    }
    DateTime date = timestamp.toDate();
    return DateFormat('hh:mm a, MM/dd/yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[200],
      appBar: AppBar(
        title: Text("Notepad"),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getUserNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var notes = snapshot.data!.docs;
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No notes yet", style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: notes.length,
            itemBuilder: (context, index) {
              var note = notes[index];
              bool isSelected = selectedNotes.contains(note.id);
              String content = note['content'] ?? "";
              String title = note['title'] ?? "";
              Timestamp? timestamp = note['updatedAt'];

              return GestureDetector(
                onLongPress: () => toggleSelection(note.id),
                onTap: () {
                  if (isSelectionMode) {
                    toggleSelection(note.id);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteEditorScreen(
                          docId: note.id,
                          initialTitle: note['title'],
                          initialContent: note['content'],
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 130,
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    color: isSelected
                        ? (isDarkMode ? Colors.blueGrey[700] : Colors.blue[100])
                        : (isDarkMode ? Colors.grey[850] : Colors.white),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      title: Text(
                        title.length > 30 ? "${title.substring(0, 25)}..." : title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content.length > 50 ? "${content.substring(0, 50)}..." : content,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDarkMode ? Colors.white70 : Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          // Display updated time at the bottom right of the card
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              formatTimestamp(timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: isDarkMode ? Colors.grey[400] : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: Colors.blue, size: 24)
                          : null,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: isSelectionMode
          ? FloatingActionButton.extended(
        backgroundColor: isDarkMode ? Colors.red[700] : Colors.red,
        onPressed: deleteSelectedNotes,
        label: Text('Delete (${selectedNotes.length})'),
        icon: Icon(Icons.delete, color: Colors.white),
      )
          : FloatingActionButton(
        backgroundColor: isDarkMode ? Colors.blueGrey[700] : Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditorScreen(),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}