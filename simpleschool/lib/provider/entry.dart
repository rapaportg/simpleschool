import 'package:flutter/material.dart';
import 'package:simpleschool/model/entry.dart';
import 'package:simpleschool/api/firebase_api.dart';

class EntryProvider extends ChangeNotifier {
  List<Entry> _entries = [];

  List<Entry> get entries =>
      _entries.where((entry) => entry.isDone == false).toList();

  List<Entry> get entriesCompleted =>
      _entries.where((entry) => entry.isDone == true).toList();

  void setEntries(List<Entry> entries) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _entries = entries;
        notifyListeners();
      });

  void addEntry(Entry entry) => FirebaseApi.createEntry(entry);

  void removeEntry(Entry entry) => FirebaseApi.deleteEntry(entry);

  bool toggleEntryCompletionStatus(Entry entry) {
    entry.isDone = !entry.isDone;
    FirebaseApi.updateEntry(entry);

    return entry.isDone;
  }

  // TODO - Add ability to update everything not just title
  void updateEntry(Entry entry, String title) {
    entry.title = title;

    FirebaseApi.updateEntry(entry);
  }
}
