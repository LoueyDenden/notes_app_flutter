import 'package:flutter/material.dart';
import '../sql_helper.dart';
import '../widgets/drawer_widget.dart';
import 'edit.dart'; // Import your edit note page

class UrgentNotesPage extends StatefulWidget {
  const UrgentNotesPage({Key? key});

  @override
  _UrgentNotesPageState createState() => _UrgentNotesPageState();
}

class _UrgentNotesPageState extends State<UrgentNotesPage> {
  late Future<List<Map<String, dynamic>>> _urgentNotesFuture;

  @override
  void initState() {
    super.initState();
    _refreshUrgentNotes();
  }

  Future<void> _refreshUrgentNotes() async {
    setState(() {
      _urgentNotesFuture = SQLHelper.getLabel('Urgent');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("Urgent Notes")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _urgentNotesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final urgentNotes = snapshot.data ?? [];
            return ListView.builder(
              itemCount: urgentNotes.length,
              itemBuilder: (context, index) {
                final note = urgentNotes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNotePage(noteId: note['id']),
                      ),
                    ).then((_) {
                      // Refresh urgent notes after returning from EditNotePage
                      _refreshUrgentNotes();
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    color: Colors.redAccent,
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
