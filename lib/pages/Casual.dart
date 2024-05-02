import 'package:flutter/material.dart';
import '../sql_helper.dart';
import '../widgets/drawer_widget.dart';
import 'edit.dart'; // Import your edit note page

class CasualNotesPage extends StatefulWidget {
  const CasualNotesPage({Key? key});

  @override
  _CasualNotesPageState createState() => _CasualNotesPageState();
}

class _CasualNotesPageState extends State<CasualNotesPage> {
  late Future<List<Map<String, dynamic>>> _casualNotesFuture;

  @override
  void initState() {
    super.initState();
    _refreshCasualNotes();
  }

  Future<void> _refreshCasualNotes() async {
    setState(() {
      _casualNotesFuture = SQLHelper.getLabel('Casual');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("Casual Notes")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _casualNotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final casualNotes = snapshot.data ?? [];
            return ListView.builder(
              itemCount: casualNotes.length,
              itemBuilder: (context, index) {
                final note = casualNotes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNotePage(noteId: note['id']),
                      ),
                    ).then((_) {
                      // Refresh casual notes after returning from EditNotePage
                      _refreshCasualNotes();
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.lightBlueAccent,
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
