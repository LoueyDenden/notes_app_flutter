import 'package:flutter/material.dart';
import '../sql_helper.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _selectedLabel;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _selectedLabel = '';
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
      appBar: AppBar(title: Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
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
              onPressed: _saveNote,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNote() async {
    await SQLHelper.createNote(
      _titleController.text,
      _descriptionController.text,
      _selectedLabel,
    );
    Navigator.pop(context); // Return to the previous page (home page)
  }
}
