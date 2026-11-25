import 'package:flutter/material.dart';

class LibraryCollectionModel {
  final String fileName;
  final String title;
  final String description;
  final IconData icon;

  const LibraryCollectionModel({
    required this.fileName,
    required this.title,
    required this.description,
    required this.icon,
  });

  static const List<LibraryCollectionModel> available = [
    LibraryCollectionModel(
      fileName: 'baby_names.json',
      title: 'Baby Names',
      description: 'Explore meaningful names and their origins.',
      icon: Icons.child_care_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'content_library.json',
      title: 'Content Library',
      description: 'Browse selected Islamic texts and references.',
      icon: Icons.menu_book_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'daily_ahadees.json',
      title: 'Daily Ahadees',
      description: 'Read hadith and their references.',
      icon: Icons.format_quote_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'daily_ayats.json',
      title: 'Daily Ayats',
      description: 'Reflect on Quranic verses and meanings.',
      icon: Icons.auto_stories_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'daily_reminders.json',
      title: 'Daily Reminders',
      description: 'Browse reminders for everyday worship.',
      icon: Icons.notifications_active_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'daily_waqeats.json',
      title: 'Daily Waqeats',
      description: 'Read stories and lessons from Islamic history.',
      icon: Icons.history_edu_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'events.json',
      title: 'Islamic Events',
      description: 'Learn about important occasions and their practices.',
      icon: Icons.event_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'guides.json',
      title: 'Guides',
      description: 'Step-by-step guides for acts of worship.',
      icon: Icons.menu_book_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'islamic_jar_notes.json',
      title: 'Good Deed Jar',
      description: 'Small deeds and reminders to put into practice.',
      icon: Icons.volunteer_activism_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'kalmay.json',
      title: 'Kalmay',
      description: 'Read the kalmay with transliteration and meaning.',
      icon: Icons.mosque_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'wazaif.json',
      title: 'Wazaif',
      description: 'Browse supplications and their references.',
      icon: Icons.spa_rounded,
    ),
    LibraryCollectionModel(
      fileName: 'zakat_config.json',
      title: 'Zakat Guide',
      description: 'Review Zakat guidance and calculation details.',
      icon: Icons.volunteer_activism_rounded,
    ),
  ];
}
