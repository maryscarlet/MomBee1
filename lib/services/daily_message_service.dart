import '../models/journey_type.dart';
import '../state/app_state.dart';

class DailyMessage {
  final String greeting;
  final String title;
  final String message;
  final String doctorQuote;
  final String doctorName;
  final String doctorRole;
  final String category;

  const DailyMessage({
    required this.greeting,
    required this.title,
    required this.message,
    required this.doctorQuote,
    required this.doctorName,
    required this.doctorRole,
    required this.category,
  });
}

class DailyMessageService {
  static String getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'সুপ্রভাত ☀️';
    } else if (hour >= 12 && hour < 17) {
      return 'শুভ দুপুর 🌤️';
    } else if (hour >= 17 && hour < 20) {
      return 'শুভ সন্ধ্যা 🌆';
    } else {
      return 'শুভ রাত্রি 🌙';
    }
  }

  static DailyMessage getDailyMessageForCurrentProfile() {
    final journey = AppState.instance.selectedJourney;
    final greeting = getTimeBasedGreeting();

    switch (journey) {
      case JourneyType.planning:
        final cycleDay = AppState.instance.periodData.currentCycleDay;
        if (cycleDay >= 10 && cycleDay <= 16) {
          return DailyMessage(
            greeting: greeting,
            title: 'উর্বর সময় (Fertile Window) চলছে',
            message: 'আপনার সাইকেল দিন $cycleDay। আজ থেকে পরবর্তী কয়েক দিন গর্ভধারণের সর্বোচ্চ সম্ভাবনাময় সময়। পর্যাপ্ত পানি পান করুন এবং মানসিক চাপমুক্ত থাকুন।',
            doctorQuote: 'ওভুলেশন সময়ে ভিটামিন সি ও অ্যান্টিঅক্সিডেন্ট সমৃদ্ধ তাজা ফলমূল ডিম্বাণুর কার্যক্ষমতা বৃদ্ধি করে।',
            doctorName: 'ডা. তানিয়া রহমান',
            doctorRole: 'প্রসূতি ও বন্ধ্যাত্ব বিশেষজ্ঞ (BSMMU)',
            category: 'উর্বরতা ও ওভুলেশন',
          );
        } else if (cycleDay <= 5) {
          return DailyMessage(
            greeting: greeting,
            title: 'মাসিককালীন বিশেষ যত্ন ও বিশ্রাম',
            message: 'আপনার সাইকেল দিন $cycleDay। এই সময়ে শরীরে আয়রনের ঘাটতি পূরণে পুষ্টিকর খাবার ও পর্যাপ্ত বিশ্রাম নিন। কুসুম গরম পানি পান করুন।',
            doctorQuote: 'মাসিকের দিনগুলোতে প্রতিদিন নিয়ম করে ফলিক এসিড (৪০০ mcg) গ্রহণ বজায় রাখুন।',
            doctorName: 'ডা. শারমিন আক্তার',
            doctorRole: 'কনসালট্যান্ট গাইনি ও প্রসূতি',
            category: 'মাসিক ও পুষ্টি',
          );
        } else {
          return DailyMessage(
            greeting: greeting,
            title: 'প্রাক-গর্ভধারণ স্বাস্থ্য প্রস্তুতি',
            message: 'গর্ভধারণের প্রস্তুতিতে আপনার সুষম খাদ্যাভ্যাস ও হালকা শরীরচর্চা অত্যন্ত কার্যকরী। দৈনিক অন্তত ৮-১০ গ্লাস বিশুদ্ধ পানি নিশ্চিত করুন।',
            doctorQuote: 'প্রতিদিনের খাবারে সবুজ শাকসবজি, ডিম ও বাদাম অন্তর্ভুক্ত করা হরমোনের স্বাভাবিক ভারসাম্য বজায় রাখে।',
            doctorName: 'ডা. ফারহানা আহমেদ',
            doctorRole: 'সিনিয়র কনসালট্যান্ট, ডিএমসিএইচ',
            category: 'পুষ্টি ও লাইফস্টাইল',
          );
        }

      case JourneyType.pregnant:
        final week = AppState.instance.currentPregnancyWeek;
        final isSetup = AppState.instance.isPregnancySetup;

        if (!isSetup) {
          return DailyMessage(
            greeting: greeting,
            title: 'আপনার গর্ভকালীন সপ্তাহ সেট করুন',
            message: 'আপনার শেষ মাসিকের ১ম দিন (LMP) সেট করে গর্ভকালীন সপ্তাহভিত্তিক সুনির্দিষ্ট পুষ্টি, ডাক্তারি পরামর্শ ও শিশুর বৃদ্ধি ট্র্যাকিং শুরু করুন।',
            doctorQuote: 'সঠিক সপ্তাহ গণনা গর্ভকালীন টেস্ট ও আল্ট্রাসাউন্ডের সময় নির্ধারণে সবচেয়ে গুরুত্বপূর্ণ।',
            doctorName: 'ডা. ফারহানা আহমেদ',
            doctorRole: 'সিনিয়র কনসালট্যান্ট, ডিএমসিএইচ',
            category: 'গর্ভকালীন গাইড',
          );
        }

        if (week <= 13) {
          return DailyMessage(
            greeting: greeting,
            title: '১ম ট্রাইমেস্টার: ভ্রূণের প্রধান অঙ্গ গঠনের সময়',
            message: 'আপনি এখন $weekতম সপ্তাহে আছেন। এই সময়ে ক্লান্তি ও বমি ভাব কমাতে অল্প অল্প করে বারবার শুকনো খাবার খান এবং ফলিক এসিড সাপ্লিমেন্ট মিস করবেন না।',
            doctorQuote: 'প্রথম তিন মাসে ভারী ওজন তোলা বা অতিরিক্ত গরম পানি দিয়ে গোসল করা এড়িয়ে চলা উচিত।',
            doctorName: 'ডা. রেজওয়ানা কবির',
            doctorRole: 'রেডিওলজিস্ট ও আল্ট্রাসাউন্ড স্পেশালিস্ট',
            category: '১ম ট্রাইমেস্টার যত্ন',
          );
        } else if (week <= 27) {
          return DailyMessage(
            greeting: greeting,
            title: '২য় ট্রাইমেস্টার: সোনালী সময় ও শিশুর কিক',
            message: 'আপনি এখন $weekতম সপ্তাহে আছেন। শিশু এখন নিয়মিত নড়াচড়া করছে এবং বাইরের শব্দ শুনতে পাচ্ছে। ওর সাথে কথা বলুন ও পছন্দের সুর শুনুন।',
            doctorQuote: '১৮-২২ সপ্তাহের মধ্যে অ্যানোমালি স্ক্যান করিয়ে শিশুর প্রতিটি অঙ্গের গঠন নিশ্চিত করে নিন।',
            doctorName: 'ডা. সুলতানা রাজিয়া',
            doctorRole: 'ফেলো ফিটাল মেডিসিন, ইউনাইটেড হাসপাতাল',
            category: '২য় ট্রাইমেস্টার যত্ন',
          );
        } else {
          return DailyMessage(
            greeting: greeting,
            title: '৩য় ট্রাইমেস্টার: প্রসব প্রস্তুতি ও হাসপাতাল ব্যাগ',
            message: 'আপনি এখন $weekতম সপ্তাহে আছেন। প্রসবের সময় ঘনিয়ে এসেছে। হাসপাতালের ব্যাগ গুছিয়ে রাখুন এবং প্রতিদিন খাবার পর কিক কাউন্ট পর্যবেক্ষণ করুন।',
            doctorQuote: 'তরল পানি ভাঙা বা নিয়মিত বিরতিতে তলপেটে তীব্র টান অনুভব করলে অবিলম্বে হাসপাতালে যোগাযোগ করুন।',
            doctorName: 'ডা. রেহানা পারভীন',
            doctorRole: 'অধ্যাপক (অবস ও গাইনি)',
            category: 'প্রসব প্রস্তুতি',
          );
        }

      case JourneyType.baby:
        final babyName = AppState.instance.babyData.name.isNotEmpty
            ? AppState.instance.babyData.name
            : 'আপনার সোনামণি';
        final ageStr = AppState.instance.babyData.ageStringBangla;

        return DailyMessage(
          greeting: greeting,
          title: '$babyName-এর বয়স: $ageStr',
          message: '$babyName-এর প্রতিদিনের হাসি ও নতুন বিকাশ উপভোগ করুন। বয়স অনুযায়ী নিয়মিত টিকাদান সূচি ও সঠিক পুষ্টি নিশ্চিত করুন।',
          doctorQuote: 'শিশুর মানসিক ও বুদ্ধিবৃত্তিক বিকাশের জন্য প্রথম ২ বছর ডিজিটাল স্ক্রিনমুক্ত রেখে বেশি বেশি কথা বলা ও গল্প শোনানো সেরা উপায়।',
          doctorName: 'ডা. মো. রফিকুজ্জামান',
          doctorRole: 'শিশুরোগ বিশেষজ্ঞ, বাংলাদেশ শিশু হাসপাতাল',
          category: 'শিশু যত্ন ও প্যারেন্টিং',
        );

      case JourneyType.general:
        return DailyMessage(
          greeting: greeting,
          title: 'আজকের সুস্থ মাতৃত্ব ও স্বাস্থ্য পরামর্শ',
          message: 'পরিবারের সার্বিক সুস্থতায় মায়ের শারীরিক ও মানসিক প্রশান্তি সবচেয়ে গুরুত্বপূর্ণ। সুষম খাবার, পর্যাপ্ত ঘুম ও নিয়মিত স্বাস্থ্য পরীক্ষা বজায় রাখুন।',
          doctorQuote: 'দৈনন্দিন দেশীয় টাটকা শাকসবজি, ডিম, ডাল ও মৌসুমি ফল যেকোনো বিদেশি সাপ্লিমেন্টের চেয়ে বেশি কার্যকর।',
          doctorName: 'ডা. আফরোজা হক',
          doctorRole: 'ক্লিনিক্যাল নিউট্রিশনিস্ট, বারডেম',
          category: 'সার্বিক স্বাস্থ্য',
        );
    }
  }
}
