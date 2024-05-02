import 'package:flutter/material.dart';
import '../sql_helper.dart'; // Import your database helper
import 'package:notes_app/pages/home.dart'; // Import your home page

class EditNotePage extends StatefulWidget {
  final int noteId;

  const EditNotePage({Key? key, required this.noteId}) : super(key: key);

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedLabel = '';

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    final note = await SQLHelper.getNote(widget.noteId);
    setState(() {
      _titleController = TextEditingController(text: note[0]['title']);
      _descriptionController = TextEditingController(text: note[0]['description']);
      _selectedLabel = note[0]['label'] ?? '';
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
              maxLines: null, // Allow multiline input
            ),
            SizedBox(height: 16.0),
            Text('Label', style: TextStyle(fontSize: 18.0)),
            SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<String>(
                  title: Text('Urgent'),
                  value: 'Urgent',
                  groupValue: _selectedLabel,
                  onChanged: (value) {
                    setState(() {
                      _selectedLabel = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Important'),
                  value: 'Important',
                  groupValue: _selectedLabel,
                  onChanged: (value) {
                    setState(() {
                      _selectedLabel = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Casual'),
                  value: 'Casual',
                  groupValue: _selectedLabel,
                  onChanged: (value) {
                    setState(() {
                      _selectedLabel = value!;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateNote,
              child: Text('Save'),
            ),
            SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: _deleteNote,
              child: Text('Delete Note'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateNote() async {
    final int result = await SQLHelper.updateNote(
      widget.noteId,
      _titleController.text,
      _descriptionController.text,
      _selectedLabel,
    );
    if (result > 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note updated successfully')));
      Navigator.pop(context); // Return to the previous page (home page)
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update note')));
    }
  }

  Future<void> _deleteNote() async {
    await SQLHelper.deleteNote(widget.noteId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Note deleted')));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()), // Navigate to the home page
    );
  }
}
