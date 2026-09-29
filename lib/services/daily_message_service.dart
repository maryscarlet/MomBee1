import '../models/journey_type.dart';
import '../models/daily_message_model.dart';
import '../state/app_state.dart';

export '../models/daily_message_model.dart';

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
    final appointments = AppState.instance.appointments;
    final now = DateTime.now();

    // Check for upcoming appointments within the next 48 hours
    final upcomingApp = appointments.where((a) {
      final diff = a.dateTime.difference(now).inHours;
      return diff >= 0 && diff <= 48;
    }).toList();

    if (upcomingApp.isNotEmpty) {
      final app = upcomingApp.first;
      return DailyMessage(
        greeting: greeting,
        title: 'আসন্ন ডাক্তারের অ্যাপয়েন্টমেন্ট রিমাইন্ডার',
        message:
            'আপনার "${app.doctorName}"-এর সাথে অ্যাপয়েন্টমেন্ট নির্ধারিত রয়েছে। প্রয়োজনীয় পূর্ববর্তী প্রেসক্রিপশন ও মেডিকেল টেস্টের ফাইলগুলো গুছিয়ে সঙ্গে রাখুন।',
        careTip:
            'ডাক্তারের কাছে যাওয়ার আগে আপনার শারীরিক কোনো লক্ষণ বা প্রশ্ন থাকলে তা নোটে লিখে নিন।',
        category: 'অ্যাপয়েন্টমেন্ট রিমাইন্ডার',
      );
    }

    switch (journey) {
      case JourneyType.planning:
        final cycleDay = AppState.instance.periodData.currentCycleDay;
        if (cycleDay >= 10 && cycleDay <= 16) {
          return DailyMessage(
            greeting: greeting,
            title: 'উর্বর সময় (Fertile Window) চলছে',
            message:
                'আপনার সাইকেল দিন $cycleDay। আজ থেকে পরবর্তী কয়েক দিন গর্ভধারণের সর্বোচ্চ সম্ভাবনাময় সময়। পর্যাপ্ত পানি পান করুন এবং মানসিক চাপমুক্ত থাকুন।',
            careTip:
                'ওভুলেশন সময়ে ভিটামিন সি ও অ্যান্টিঅক্সিডেন্ট সমৃদ্ধ তাজা ফলমূল স্বাভাবিক হরমোন ও প্রজনন স্বাস্থ্যে ইতিবাচক ভূমিকা রাখে।',
            category: 'উর্বরতা ও ওভুলেশন',
          );
        } else if (cycleDay <= 5) {
          return DailyMessage(
            greeting: greeting,
            title: 'মাসিককালীন বিশেষ যত্ন ও বিশ্রাম',
            message:
                'আপনার সাইকেল দিন $cycleDay। এই সময়ে শরীরে আয়রনের ঘাটতি পূরণে পুষ্টিকর খাবার ও পর্যাপ্ত বিশ্রাম নিন। কুসুম গরম পানি পান করুন।',
            careTip:
                'মাসিকের দিনগুলোতে প্রতিদিন নিয়ম করে ফলিক এসিড (৪০০ mcg) গ্রহণ বজায় রাখুন এবং আয়রনসমৃদ্ধ খাবার যেমন কচুশাক, কলিজা বা ডাল খান।',
            category: 'মাসিক ও পুষ্টি',
          );
        } else {
          return DailyMessage(
            greeting: greeting,
            title: 'প্রাক-গর্ভধারণ স্বাস্থ্য প্রস্তুতি',
            message:
                'গর্ভধারণের প্রস্তুতিতে আপনার সুষম খাদ্যাভ্যাস ও হালকা শরীরচর্চা অত্যন্ত কার্যকরী। দৈনিক অন্তত ৮-১০ গ্লাস বিশুদ্ধ পানি নিশ্চিত করুন।',
            careTip:
                'প্রতিদিনের খাবারে সবুজ শাকসবজি, ডিম ও বাদাম অন্তর্ভুক্ত করা স্বাভাবিক হরমোনাল ভারসাম্য বজায় রাখতে সাহায্য করে।',
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
            message:
                'আপনার শেষ মাসিকের ১ম দিন (LMP) সেট করে গর্ভকালীন সপ্তাহভিত্তিক সুনির্দিষ্ট পুষ্টি, ডাক্তারি পরামর্শ ও শিশুর বৃদ্ধি ট্র্যাকিং শুরু করুন।',
            careTip:
                'সঠিক সপ্তাহ গণনা গর্ভকালীন টেস্ট ও আল্ট্রাসাউন্ডের সময় নির্ধারণে সবচেয়ে গুরুত্বপূর্ণ পদক্ষেপ।',
            category: 'গর্ভকালীন গাইড',
          );
        }

        if (week <= 13) {
          return DailyMessage(
            greeting: greeting,
            title: '১ম ট্রাইমেস্টার: ভ্রূণের প্রধান অঙ্গ গঠনের সময়',
            message:
                'আপনি এখন $weekতম সপ্তাহে আছেন। এই সময়ে ক্লান্তি ও বমি ভাব কমাতে অল্প অল্প করে বারবার শুকনো খাবার খান এবং ফলিক এসিড সাপ্লিমেন্ট মিস করবেন না।',
            careTip:
                'প্রথম তিন মাসে ভারী ওজন তোলা বা অতিরিক্ত গরম পানিতে গোসল করা এড়িয়ে চলা উচিত।',
            category: '১ম ট্রাইমেস্টার যত্ন',
          );
        } else if (week <= 27) {
          return DailyMessage(
            greeting: greeting,
            title: '২য় ট্রাইমেস্টার: সোনালী সময় ও শিশুর কিক',
            message:
                'আপনি এখন $weekতম সপ্তাহে আছেন। শিশু এখন নিয়মিত নড়াচড়া করছে এবং বাইরের শব্দ শুনতে পাচ্ছে। ওর সাথে কথা বলুন ও পছন্দের সুর শুনুন।',
            careTip:
                '১৮-২২ সপ্তাহের মধ্যে অ্যানোমালি স্ক্যান করিয়ে শিশুর প্রতিটি অঙ্গের বৃদ্ধি নিশ্চিত করে নিন।',
            category: '২য় ট্রাইমেস্টার যত্ন',
          );
        } else {
          return DailyMessage(
            greeting: greeting,
            title: '৩য় ট্রাইমেস্টার: প্রসব প্রস্তুতি ও সতর্কতা',
            message:
                'আপনি এখন $weekতম সপ্তাহে আছেন। প্রসবের সময় ঘনিয়ে এসেছে। হাসপাতালের ব্যাগ গুছিয়ে রাখুন এবং প্রতিদিন খাবার পর কিক কাউন্ট পর্যবেক্ষণ করুন।',
            careTip:
                'তরল পানি ভাঙা, রক্তপাত বা নিয়মিত বিরতিতে তলপেটে তীব্র টান অনুভব করলে অবিলম্বে হাসপাতালে যোগাযোগ করুন।',
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
          message:
              '$babyName-এর প্রতিদিনের হাসি ও নতুন বিকাশ উপভোগ করুন। বয়স অনুযায়ী নিয়মিত টিকাদান সূচি ও সঠিক পুষ্টি নিশ্চিত করুন।',
          careTip:
              'শিশুর মানসিক ও বুদ্ধিবৃত্তিক বিকাশের জন্য প্রথম ২ বছর ডিজিটাল স্ক্রিনমুক্ত রেখে বেশি বেশি কথা বলা ও গল্প শোনানো সেরা উপায়।',
          category: 'শিশু যত্ন ও প্যারেন্টিং',
        );

      case JourneyType.general:
        return DailyMessage(
          greeting: greeting,
          title: 'আজকের সুস্থ মাতৃত্ব ও স্বাস্থ্য পরামর্শ',
          message:
              'পরিবারের সার্বিক সুস্থতায় মায়ের শারীরিক ও মানসিক প্রশান্তি সবচেয়ে গুরুত্বপূর্ণ। সুষম খাবার, পর্যাপ্ত ঘুম ও নিয়মিত স্বাস্থ্য পরীক্ষা বজায় রাখুন।',
          careTip:
              'দৈনন্দিন দেশীয় টাটকা শাকসবজি, ডিম, ডাল ও মৌসুমি ফল সার্বিক সুস্থতা ও রোগ প্রতিরোধ ক্ষমতা বৃদ্ধিতে অত্যন্ত কার্যকর।',
          category: 'সার্বিক স্বাস্থ্য',
        );
    }
  }
}
