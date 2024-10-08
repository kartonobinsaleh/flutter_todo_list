import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_daily_notes/bloc/note/note_bloc.dart';
import 'package:flutter_daily_notes/extensions/router.dart';
import 'package:flutter_daily_notes/models/note.dart';
import 'package:flutter_daily_notes/screens/add_note_page.dart';
import 'package:flutter_daily_notes/widgets/custom_button.dart';
import 'package:intl/intl.dart';

class DetailNotePage extends StatefulWidget {
  final Note note;
  const DetailNotePage({required this.note, super.key});

  @override
  State<DetailNotePage> createState() => _DetailNotePageState();
}

class _DetailNotePageState extends State<DetailNotePage> {
  @override
  Widget build(BuildContext context) {
    final noteBloc = BlocProvider.of<NoteBloc>(context);
    return BlocBuilder<NoteBloc, NoteState>(
      builder: (context, state) {
        final note = state.notes.firstWhere((note) => note.id == widget.note.id);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.black87,
            centerTitle: true,
            title: const Text('Detail Note'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/${note.image}.png',
                        fit: BoxFit.cover,
                        height: 100,
                        width: double.infinity,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.alarm,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd MMMM yyyy HH:mm').format(note.date!),
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      note.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Update",
                      onPressed: () {
                        context.to(AddNotePage(note: note));
                      },
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: "Delete",
                      backgroundColor: Colors.red[400],
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Delete Note'),
                            content: const Text('Are you sure you want to delete this note?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: const Text('No'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: const Text('Yes'),
                              ),
                            ],
                          ),
                        );
                        if (confirm != true) {
                          return;
                        }

                        await Alarm.stop(widget.note.id);
                        noteBloc.add(RemoveNote(widget.note));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Note ${widget.note.title} has been deleted',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
