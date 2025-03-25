import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? docId;
  final String? initialTitle;
  final String? initialContent;

  NoteEditorScreen({this.docId, this.initialTitle, this.initialContent});

  @override
  _NoteEditorScreenState createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {

  final CollectionReference notesRef =
  FirebaseFirestore.instance.collection('notes');

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? "");
    _contentController = TextEditingController(text: widget.initialContent ?? "");
  }
  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _contentController.dispose();
  }

  void saveNote() {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    var data = {
      'title': title,
      'content': content,
      'userId': user.uid, // Store user ID
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (widget.docId == null) {
      notesRef.add(data); // Create new note
    } else {
      notesRef.doc(widget.docId).update(data); // Update existing note
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Note something down",
                  border: InputBorder.none,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}