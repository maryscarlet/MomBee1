import '../models/vaccine_item.dart';

final List<VaccineItem> defaultVaccinesList = [
  // Pregnancy Vaccines
  const VaccineItem(
    id: 'tt_1',
    name: 'টিটি ১ম ডোজ (Tetanus Toxoid - 1)',
    targetAudience: 'গর্ভকালীন',
    schedule: 'গর্ভাবস্থার ৫ম বা ৬ষ্ঠ মাসে (২০-২৪ সপ্তাহ)',
    description: 'মা ও অনাগত নবজাতককে ধনুষ্টঙ্কার রোগ থেকে সুরক্ষা দেয়।',
    isCompleted: false,
  ),
  const VaccineItem(
    id: 'tt_2',
    name: 'টিটি ২য় ডোজ (Tetanus Toxoid - 2)',
    targetAudience: 'গর্ভকালীন',
    schedule: '১ম ডোজের কমপক্ষে ৪ সপ্তাহ পর (২৮ সপ্তাহে)',
    description: 'ধনুষ্টঙ্কারের বিরুদ্ধে পূর্ণ রোগ প্রতিরোধ ক্ষমতা তৈরি করে।',
    isCompleted: false,
  ),
  const VaccineItem(
    id: 'flu_vaccine',
    name: 'ইনফ্লুয়েঞ্জা ভ্যাকসিন (Flu Shot)',
    targetAudience: 'গর্ভকালীন',
    schedule: 'গর্ভাবস্থার যেকোনো ট্রাইমেস্টারে (বিশেষত ফ্লু মৌসুমে)',
    description: 'মা ও গর্ভস্থ শিশুকে মারাত্মক ভাইরাল ফ্লু ও নিউমোনিয়া থেকে রক্ষা করে।',
    isCompleted: false,
  ),

  // Child EPI Vaccines (Bangladesh National Immunization Program)
  const VaccineItem(
    id: 'bcg_opv0',
    name: 'বিসিজি ও ওপিভি-০ (BCG & OPV-0)',
    targetAudience: 'নবজাতক',
    schedule: 'জন্মের সাথে সাথে বা প্রথম সপ্তাহে',
    description: 'যক্ষ্মা (Tuberculosis) ও পোলিও রোগের বিরুদ্ধে কার্যকর প্রাথমিক প্রতিরোধ।',
    isCompleted: false,
  ),
  const VaccineItem(
    id: 'penta_1',
    name: 'পেন্টাভ্যালেন্ট-১, পিসিভি-১ ও ওপিভি-১',
    targetAudience: '১.৫ মাস (৬ সপ্তাহ)',
    schedule: '৬ সপ্তাহ বয়সে',
    description: 'ডিপথেরিয়া, হুপিং কাশি, ধনুষ্টঙ্কার, হেপাটাইটিস-বি, হিমোফিলাস ইনফ্লুয়েঞ্জা, নিউমোনিয়া ও পোলিও প্রতিরোধ করে।',
    isCompleted: false,
  ),
  const VaccineItem(
    id: 'penta_2',
    name: 'পেন্টাভ্যালেন্ট-২, পিসিভি-২ ও ওপিভি-২',
    targetAudience: '২.৫ মাস (১০ সপ্তাহ)',
    schedule: '১০ সপ্তাহ বয়সে',
    description: 'পেন্টাভ্যালেন্ট ও নিউমোকক্কাল ভ্যাকসিনের ২য় ডোজ।',
    isCompleted: false,
  ),
  const VaccineItem(
    id: 'penta_3',
    name: 'পেন্টাভ্যালেন্ট-৩, পিসিভি-৩, ওপিভি-৩ ও আইপিভি-১',
    targetAudience: '৩.৫ মাস (১৪ সপ্তাহ)',
    schedule: '১৪ সপ্তাহ বয়সে',
    description: 'পেন্টাভ্যালেন্ট ৩য় ডোজ এবং ইনজেকটেবল পোলিও ভ্যাকসিন (IPV)।',
    isCompleted: false,
  ),
  const VaccineItem(
    id: 'mr_1',
    name: 'এমআর-১ (Measles-Rubella - 1) ও আইপিভি-২',
    targetAudience: '৯ মাস',
    schedule: '৯ মাস পূর্ণ হলে',
    description: 'হাম (Measles) ও রুবেলা (Rubella) রোগের বিরুদ্ধে আজীবন সুরক্ষা।',
    isCompleted: false,
  ),
  const VaccineItem(
    id: 'mr_2',
    name: 'এমআর-২ (Measles-Rubella - 2 Booster)',
    targetAudience: '১৫ মাস',
    schedule: '১৫ মাস বয়সে',
    description: 'হাম ও রুবেলার বুস্টার ডোজ যা রোগ প্রতিরোধ ক্ষমতা দীর্ঘমেয়াদী করে।',
    isCompleted: false,
  ),
];
