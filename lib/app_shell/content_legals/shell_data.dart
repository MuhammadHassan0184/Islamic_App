import '../app_shell_io.dart';

class ShellContent {
  final String? image;
  final String title;
  final String info;
  final String? description;
  final List<String>? items;

  const ShellContent({
    this.image,
    required this.title,
    required this.info,
    this.description,
    this.items,
  });
}

/// ─────────────────────────────────────────────
/// ZitoKit (Zi_3) App Content Configuration
/// ─────────────────────────────────────────────

abstract class ShellData {
  ShellData._();

  // ─── App Identity ─────────────────────────────────────────
  static const ShellContent appInfo = ShellContent(
    image: ShellImages.logo,
    title: 'Islam786',
    info: 'Quran Pak & Namaz Time',
    description:
        'Your daily Islamic companion for Quran Pak, Namaz times, prayer notifications, daily Duas and Azkar, and a digital Tasbeeh counter.',
  );

  // ─── Splash ───────────────────────────────────────────────
  static const ShellContent appSplash = ShellContent(
    image: ShellImages.logo,
    title: 'ZitoKit',
    info: 'Launch your store in minutes',
    description: 'Powered by ZiCore',
  );

  // ─── Onboarding ───────────────────────────────────────────
  static const List<ShellContent> onboarding = [
    ShellContent(
      image: ShellImages.onBoarding1,
      title: 'Create Your Store in 5 Minutes',
      info: 'Set up products or services instantly with zero technical setup.',
      description: 'Perfect for small shops and local businesses.',
    ),
    ShellContent(
      image: ShellImages.onBoarding1,
      title: 'Replace WhatsApp Ordering Chaos',
      info: 'Turn chats into structured orders with a simple system.',
      description: 'No more missed or confused orders.',
    ),
    ShellContent(
      image: ShellImages.onBoarding1,
      title: 'Share Your Store Link',
      info: 'Customers browse and order directly from your public store page.',
      description: 'One link for all your products & services.',
    ),
  ];

  // ─── ZGate ────────────────────────────────────────────────
  static const ShellContent zGate = ShellContent(
    title: 'Welcome to Islam786',
    info:
        'Your comprehensive companion for daily prayers, authentic Duas, Azkar, and Islamic guidance.',
  );

  // ─── Auth ─────────────────────────────────────────────────
  static const ShellContent register = ShellContent(
    image: ShellImages.logo,
    title: 'Create Your Store Owner Account',
    info: 'Start building your online store in minutes.',
    description: 'Join early sellers going digital with ZitoKit.',
  );

  static const ShellContent login = ShellContent(
    image: ShellImages.logo,
    title: 'Welcome Back',
    info: 'Continue managing your store and orders.',
  );

  static const ShellContent forgotPassword = ShellContent(
    title: 'Forgot Password?',
    info: "Enter your email and we’ll send you a reset link.",
  );

  static const ShellContent resetPassword = ShellContent(
    title: 'Reset Password',
    info: 'Set a new password for your ZitoKit account.',
  );

  static const ShellContent editProfile = ShellContent(
    title: 'Update Profile',
    info: 'Keep your store owner details up to date.',
  );

  // ─── About App ────────────────────────────────────────────
  static const ShellContent appAbout = ShellContent(
    image: ShellImages.logo,
    title: 'Islam786',
    info: 'Our Vision',
    description:
        'To provide a clean, simple Islamic companion that helps Muslims maintain regular Salah, connect with the Holy Quran, and engage in daily Dhikr.',
    items: [
      'Provide prayer times using the app’s default calculation location and support local prayer reminders.',
      'Offer access to Quran Pak and Urdu translation; an internet connection may be needed to load Quran pages.',
      'Keep daily Duas, Azkar, and Tasbeeh tools easy to use.',
      'Keep app preferences and reading progress on the device where supported.',
    ],
  );

  // ─── Features (MVP Scope) ─────────────────────────────────
  static const ShellContent appFeatures = ShellContent(
    title: 'Islam786 Features & Tools',
    info: 'Features & Tools',
    description: 'Upcoming Releases',
    items: [
      'Complete Holy Quran (30 Para list) with Quran pages loaded from an online source.',
      'Namaz times calculated with the app’s default location preset, selected using the device time zone.',
      'Local prayer notifications controlled by notification permission and device settings.',
      'Digital Tasbeeh counter with saved counts and daily Dhikr tools.',
      'Daily Duas and Azkar.',
      'Urdu translation and additional Quran reading tools (Coming Soon).',
      'Audio recitation for popular Surahs (Coming Soon).',
      'Qibla compass (Coming Soon).',
      'Zakat calculator for savings, gold, and silver (Coming Soon).',
      'Hijri and Ramadan calendar with Sehri/Iftar timings (Coming Soon).',
    ],
  );

  // ─── Terms & Conditions ───────────────────────────────────
  static const ShellContent appTermsConditions = ShellContent(
    title: 'Terms & Conditions',
    info:
        'By using Islam786, you agree to these terms. Please review them before using the application.',
    items: [
      'Islam786 is provided for personal religious use, reference, and daily worship.',
      'Namaz times are calculated using an app-provided location preset selected by the device time zone. Verify timings with your local mosque when needed.',
      'Prayer notifications require notification permission. Delivery can also depend on device settings.',
      'Quran pages may require an internet connection because they are loaded from an online source.',
      'Bookmarks, reading progress, and Tasbeeh data may be stored locally on your device. Clearing app data or uninstalling the app can remove them.',
      'Features and calculation methods may be updated over time.',
    ],
  );

  // ─── Privacy Policy ───────────────────────────────────────
  static const ShellContent appPrivacyPolicy = ShellContent(
    title: 'Privacy Policy',
    info:
        'Islam786 is designed to keep app preferences and reading progress on your device where supported. Some content requires an internet connection.',
    items: [
      'Namaz does not request GPS location permission. Prayer times use an app-provided city preset selected according to the device time zone.',
      'Notification permission is used for local prayer reminders. Notification scheduling is handled on the device.',
      'Quran pages are loaded from an online source; the provider may receive a request when you open those pages.',
      'Reading progress, Tasbeeh counts, favorites, and preferences are stored locally where supported by the app.',
      'The app does not include third-party advertising or user-tracking analytics.',
      'For privacy questions, contact support@islam786app.com.',
    ],
  );

  // ─── Contact ──────────────────────────────────────────────
  static const ShellContent appContact = ShellContent(
    title: 'Support & Community',
    info: 'Have suggestions, feedback, or need help? Reach out to us directly.',
    items: [
      'Email: support@islam786app.com',
      'Website: https://islam786app.com',
      'Privacy Policy: Available inside app settings',
    ],
  );

  static const ShellContent appDevelopers = ShellContent(
    title: 'ZiCore',
    info: 'Built by ZiCore Team',
    items: [
      'Phone: +92 000 0000000',
      'Email: hello@zicore.dev',
      'Website: www.zicore.dev',
    ],
  );
}
