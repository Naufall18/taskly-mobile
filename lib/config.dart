import 'package:flutter/material.dart';

class AppConfig {
  static const String appName = 'Taskly';
  static const Color seedColor = Color(0xFF3F51B5);
  static const String noun = 'Task';

  static const bool usesValue = false;
  static const bool usesFlag = true;
  static const bool tab2Flagged = false;

  static const String valueLabel = 'Amount';
  static const String flagLabel = 'Done';
  static const String detailLabel = 'Note';
  static const String categoryLabel = 'List';

  static const String tab1 = 'All';
  static const String tab2 = 'Active';
  static const String tab3 = 'Insights';
  static const IconData icon1 = Icons.checklist;
  static const IconData icon2 = Icons.pending_actions;
  static const IconData icon3 = Icons.insights;

  // seed rows: [title, detail, value, flag, category]
  static const List<List<Object>> seed = [
    ['Finish UI mockups', 'Design homepage', 0, false, 'Design'],
    ['Reply to client email', 'Follow up quote', 0, true, 'Work'],
    ['Grocery shopping', 'Weekly run', 0, false, 'Personal'],
    ['Prepare sprint slides', 'Review deck', 0, false, 'Work'],
    ['Book dentist', 'Annual checkup', 0, true, 'Health'],
    ['Read Flutter docs', 'Isolates chapter', 0, false, 'Learning'],
  ];
}
