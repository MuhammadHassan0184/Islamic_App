class DhikrItem {
  final String id;
  final String arabic;
  final String transliteration;
  final String meaning;
  final int defaultTarget;

  const DhikrItem({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.meaning,
    this.defaultTarget = 33,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'arabic': arabic,
    'transliteration': transliteration,
    'meaning': meaning,
    'defaultTarget': defaultTarget,
  };

  factory DhikrItem.fromJson(Map<String, dynamic> json) => DhikrItem(
    id: json['id'] as String? ?? 'custom',
    arabic: json['arabic'] as String? ?? '',
    transliteration: json['transliteration'] as String? ?? '',
    meaning: json['meaning'] as String? ?? '',
    defaultTarget: (json['defaultTarget'] as num?)?.toInt() ?? 33,
  );

  static const List<DhikrItem> presets = [
    DhikrItem(
      id: 'subhanallah',
      arabic: 'سُبْحَانَ اللَّهِ',
      transliteration: 'SubhanAllah',
      meaning: 'Glory be to Allah',
      defaultTarget: 33,
    ),
    DhikrItem(
      id: 'alhamdulillah',
      arabic: 'الْحَمْدُ لِلَّهِ',
      transliteration: 'Alhamdulillah',
      meaning: 'Praise be to Allah',
      defaultTarget: 33,
    ),
    DhikrItem(
      id: 'allahuakbar',
      arabic: 'اللَّهُ أَكْبَرُ',
      transliteration: 'Allahu Akbar',
      meaning: 'Allah is the Greatest',
      defaultTarget: 34,
    ),
    DhikrItem(
      id: 'astaghfirullah',
      arabic: 'أَسْتَغْفِرُ اللَّهَ',
      transliteration: 'Astaghfirullah',
      meaning: 'I seek forgiveness from Allah',
      defaultTarget: 100,
    ),
    DhikrItem(
      id: 'lailahaillallah',
      arabic: 'لَا إِلٰهَ إِلَّا اللَّهُ',
      transliteration: 'La ilaha illallah',
      meaning: 'There is no god but Allah',
      defaultTarget: 100,
    ),
    DhikrItem(
      id: 'subhanallahi_wabihamdihi',
      arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      transliteration: 'SubhanAllahi wa bihamdihi',
      meaning: 'Glory be to Allah and Praise be to Him',
      defaultTarget: 100,
    ),
    DhikrItem(
      id: 'durood_sharif',
      arabic: 'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ',
      transliteration: 'Allahumma Salli Ala Muhammad',
      meaning: 'O Allah, send blessings upon Muhammad',
      defaultTarget: 100,
    ),
    DhikrItem(
      id: 'lahawla',
      arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      transliteration: 'La hawla wa la quwwata illa billah',
      meaning: 'There is no power nor strength except with Allah',
      defaultTarget: 100,
    ),
    DhikrItem(
      id: 'hasbunallah',
      arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
      transliteration: 'Hasbunallahu wa ni\'mal wakeel',
      meaning: 'Allah is sufficient for us, and He is the best disposer of affairs',
      defaultTarget: 100,
    ),
    DhikrItem(
      id: 'general',
      arabic: 'ذِكْرٌ عَامٌّ',
      transliteration: 'Free Counter',
      meaning: 'Open Dhikr / Custom Count',
      defaultTarget: 0,
    ),
  ];
}
