import '../state/app_state.dart';

class AppLocalization {
  static bool get isEnglish => AppState.instance.isEnglish;

  // Navigation
  static String get navHome => isEnglish ? 'Home' : 'হোম';
  static String get navTracker => isEnglish ? 'Tracker' : 'ট্র্যাকার';
  static String get navLearn => isEnglish ? 'Learn' : 'শিখুন';
  static String get navVideos => isEnglish ? 'Videos' : 'ভিডিও';
  static String get navProfile => isEnglish ? 'Profile' : 'প্রোফাইল';

  // Profile Screen
  static String get profileTitle => isEnglish ? 'Profile' : 'প্রোফাইল';
  static String get myActivity => isEnglish ? 'My Activity' : 'আমার কার্যক্রম';
  static String get settings => isEnglish ? 'Settings' : 'সেটিংস';
  static String get changeJourney =>
      isEnglish ? 'Change My Journey' : 'আমার Journey পরিবর্তন করুন';
  static String get editHealthInfo =>
      isEnglish ? 'Edit Health & Pregnancy Info' : 'স্বাস্থ্য ও প্রেগন্যান্সি তথ্য এডিট করুন';
  static String get editProfile =>
      isEnglish ? 'Edit Profile' : 'প্রোফাইল এডিট করুন';
  static String get savedContent =>
      isEnglish ? 'Saved Content' : 'সেভ করা কন্টেন্ট';
  static String get appointments =>
      isEnglish ? 'Appointments' : 'অ্যাপয়েন্টমেন্ট';
  static String get notifications =>
      isEnglish ? 'Notifications' : 'নোটিফিকেশন';
  static String get language => isEnglish ? 'Language' : 'ভাষা (Language)';
  static String get privacyPolicy =>
      isEnglish ? 'Privacy & Policy' : 'প্রাইভেসি ও পলিসি';
  static String get aboutMomBee =>
      isEnglish ? 'About MomBee' : 'MomBee সম্পর্কে';
  static String get logout => isEnglish ? 'Log Out' : 'লগ আউট';
  static String get logoutConfirmTitle =>
      isEnglish ? 'Want to Log Out?' : 'লগ আউট করতে চান?';
  static String get logoutConfirmMessage => isEnglish
      ? 'Are you sure you want to log out of your MomBee account?'
      : 'আপনি কি নিশ্চিত যে আপনি MomBee অ্যাকাউন্ট থেকে লগ আউট হতে চান?';
  static String get cancel => isEnglish ? 'Cancel' : 'বাতিল';
  static String get completedVaccinesLabel =>
      isEnglish ? 'Completed Vaccines & Tasks' : 'সম্পন্ন টিকা ও স্বাস্থ্যটাস্ক';
  static String get selectLanguage =>
      isEnglish ? 'Select Language' : 'ভাষা নির্বাচন করুন';
  static String get nameLabel => isEnglish ? 'Name' : 'নাম';
  static String get ageLabel => isEnglish ? 'Age' : 'বয়স';
  static String get yearsLabel => isEnglish ? 'years' : 'বছর';
  static String get selectAvatar =>
      isEnglish ? 'Select Profile Picture' : 'প্রোফাইল ছবি নির্বাচন করুন';
  static String get saveChanges =>
      isEnglish ? 'Save Changes' : 'তথ্য সংরক্ষণ করুন';
  static String get profileUpdated => isEnglish
      ? 'Profile updated successfully!'
      : 'প্রোফাইল সফলভাবে আপডেট হয়েছে!';
  static String get editNameAndAge =>
      isEnglish ? 'Edit Profile Information' : 'প্রোফাইলের নাম ও তথ্য পরিবর্তন';

  // Home & Dashboard
  static String get todayMessageTitle =>
      isEnglish ? "Today's Special Message" : 'আজকের বিশেষ বার্তা';
  static String get markAsRead =>
      isEnglish ? 'Read, Thanks' : 'পড়েছি, ধন্যবাদ';
  static String get messageReadDone =>
      isEnglish ? 'Today’s message marked as read!' : 'আজকের বার্তা পড়া হয়েছে!';
  static String get weekOfPregnancy =>
      isEnglish ? 'Weeks of Pregnancy' : 'সপ্তাহের গর্ভাবস্থা';
  static String get currentCycleDay =>
      isEnglish ? 'Current Cycle Day' : 'বর্তমান সাইকেল দিন';
  static String get babyAgeLabel =>
      isEnglish ? "Baby's Age" : 'শিশুর বয়স';
  static String get articlesAndGuides =>
      isEnglish ? 'Articles & Guides' : 'আর্টিকেল ও গাইড';
  static String get setupNow => isEnglish ? 'Set up now' : 'সেটআপ করুন';
  static String get noNewNotifications =>
      isEnglish ? 'No new notifications right now.' : 'আপাতত নতুন কোনো নোটিফিকেশন নেই।';

  // Learn Hub
  static String get searchHint =>
      isEnglish ? 'What do you want to know on MomBee?' : 'MomBee-তে কী জানতে চান?';
  static String get categories => isEnglish ? 'Categories' : 'ক্যাটাগরি';
  static String get reset => isEnglish ? 'Reset' : 'রিসেট';
  static String get featuredArticles =>
      isEnglish ? 'Featured Articles' : 'বিশেষ প্রবন্ধ';
  static String get articlesCountSuffix =>
      isEnglish ? 'Articles' : 'টি প্রবন্ধ';
  static String get noArticlesFound =>
      isEnglish ? 'No articles found' : 'কোনো প্রবন্ধ খুঁজে পাওয়া যায়নি';

  // Common Units
  static String get week => isEnglish ? 'Week' : 'সপ্তাহ';
  static String get day => isEnglish ? 'Day' : 'দিন';
  static String get days => isEnglish ? 'Days' : 'দিন';
}
