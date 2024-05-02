import 'package:flutter/material.dart';
import '../sql_helper.dart';
import '../widgets/drawer_widget.dart';
import 'edit.dart'; // Import your edit note page

class ImportantNotesPage extends StatefulWidget {
  const ImportantNotesPage({Key? key});

  @override
  _ImportantNotesPageState createState() => _ImportantNotesPageState();
}

class _ImportantNotesPageState extends State<ImportantNotesPage> {
  late Future<List<Map<String, dynamic>>> _importantNotesFuture;

  @override
  void initState() {
    super.initState();
    _refreshImportantNotes();
  }

  Future<void> _refreshImportantNotes() async {
    setState(() {
      _importantNotesFuture = SQLHelper.getLabel('Important');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("Important Notes")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _importantNotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final importantNotes = snapshot.data ?? [];
            return ListView.builder(
              itemCount: importantNotes.length,
              itemBuilder: (context, index) {
                final note = importantNotes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNotePage(noteId: note['id']),
                      ),
                    ).then((_) {
                      // Refresh important notes after returning from EditNotePage
                      _refreshImportantNotes();
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.greenAccent,
                    child: ListTile(
                      title: Text(note['title'] ?? ''),
                      subtitle: Text(note['description'] ?? ''),
                      // You can customize the card's appearance further if needed
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
