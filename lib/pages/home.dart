import 'package:flutter/material.dart';
import '../sql_helper.dart';
import '../widgets/drawer_widget.dart';
import 'package:notes_app/pages/edit.dart';

import 'add.dart'; // Import your edit note page

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  Future<void> _refreshNotes() async {
    setState(() {
      _notesFuture = SQLHelper.getNotes();
    });
  }

  Color _getCardColor(String label) {
    switch (label) {
      case 'Urgent':
        return Colors.redAccent; // Example color for Urgent notes
      case 'Important':
        return Colors.greenAccent; // Example color for Important notes
      case 'Casual':
        return Colors.lightBlueAccent; // Example color for Casual notes
      default:
        return Colors.white; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(title: Text("Notes App")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final notes = snapshot.data ?? [];
            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final String label = note['label'] ?? ''; // Get label value
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditNotePage(noteId: note['id']),
                      ),
                    ).then((_) {
                      // Refresh notes after returning from EditNotePage
                      _refreshNotes();
                    });
                  },
                  child: Card(
                    margin: EdgeInsets.all(8.0),
                    color: _getCardColor(label), // Set card color based on label
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNotePage(),
            ),
          ).then((_) {
            // Refresh notes after returning from EditNotePage
            _refreshNotes();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
