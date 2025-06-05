// Updated Sticky Notes UI inspired by the uploaded image

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const StickyNoteApp());
}

class StickyNoteApp extends StatelessWidget {
  const StickyNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticky Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const StickyNoteListScreen(),
    );
  }
}

class StickyNoteListScreen extends StatefulWidget {
  const StickyNoteListScreen({super.key});

  @override
  State<StickyNoteListScreen> createState() => _StickyNoteListScreenState();
}

class _StickyNoteListScreenState extends State<StickyNoteListScreen> {
  List<String> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notes = prefs.getStringList('notes') ?? [];
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('notes', _notes);
  }

  void _addNote() async {
    final newNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StickyNoteEditScreen()),
    );

    if (newNote != null && newNote is String && newNote.isNotEmpty) {
      setState(() {
        _notes.add(newNote);
      });
      _saveNotes();
    }
  }

  void _editNote(int index) async {
    final editedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StickyNoteEditScreen(initialText: _notes[index]),
      ),
    );

    if (editedNote != null && editedNote is String) {
      setState(() {
        if (editedNote.isEmpty) {
          _notes.removeAt(index);
        } else {
          _notes[index] = editedNote;
        }
      });
      _saveNotes();
    }
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
    _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Text('No notes yet. Tap + to add one!', style: TextStyle(fontSize: 18)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final colors = [
                  Colors.cyan[100],
                  Colors.orange[200],
                  Colors.yellow[100],
                  Colors.purple[100],
                  Colors.green[100],
                ];
                return GestureDetector(
                  onTap: () => _editNote(index),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colors[index % colors.length],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            _notes[index],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black54),
                          onPressed: () => _deleteNote(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: _addNote,
            backgroundColor: Colors.black,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'voice',
            onPressed: () {}, // Future enhancement for voice input
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.mic, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class StickyNoteEditScreen extends StatefulWidget {
  final String? initialText;

  const StickyNoteEditScreen({super.key, this.initialText});

  @override
  State<StickyNoteEditScreen> createState() => _StickyNoteEditScreenState();
}

class _StickyNoteEditScreenState extends State<StickyNoteEditScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialText ?? '');
  }

  void _saveAndExit() {
    Navigator.pop(context, _controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        title: Text(widget.initialText == null ? 'Add Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveAndExit,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: _controller,
          maxLines: null,
          style: const TextStyle(fontSize: 18),
          decoration: const InputDecoration.collapsed(
            hintText: 'Write your note here...'
          ),
        ),
      ),
    );
  }
}