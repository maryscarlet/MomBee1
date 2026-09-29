import 'package:flutter/material.dart';

class FetalStageVisualData {
  final int stageNumber; // 1 to 10
  final int weekStart;
  final int weekEnd;
  final String stageTitleBangla;
  final String stageTitleEnglish;
  final String stageBadgeBangla;
  final String descriptionBangla;
  final List<String> milestonesBangla;
  final Color accentColor;
  final Color backgroundColor;
  final String defaultAssetPath;

  const FetalStageVisualData({
    required this.stageNumber,
    required this.weekStart,
    required this.weekEnd,
    required this.stageTitleBangla,
    required this.stageTitleEnglish,
    required this.stageBadgeBangla,
    required this.descriptionBangla,
    required this.milestonesBangla,
    required this.accentColor,
    required this.backgroundColor,
    required this.defaultAssetPath,
  });

  /// Get the corresponding gestational development stage for any pregnancy week (1 to 40)
  static FetalStageVisualData forWeek(int week) {
    final clampedWeek = week.clamp(1, 40);
    return allStages.firstWhere(
      (stage) => clampedWeek >= stage.weekStart && clampedWeek <= stage.weekEnd,
      orElse: () => allStages.first,
    );
  }

  static const List<FetalStageVisualData> allStages = [
    // Stage 1: Weeks 1 - 4
    FetalStageVisualData(
      stageNumber: 1,
      weekStart: 1,
      weekEnd: 4,
      stageTitleBangla: 'ব্লাস্টোসিস্ট ও প্রাথমিক প্রতিস্থাপন',
      stageTitleEnglish: 'Blastocyst & Implantation',
      stageBadgeBangla: 'প্রাথমিক কোষীয় পর্যায়',
      descriptionBangla:
          'নিষিক্ত ডিম্বাণু দ্রুত বিভাজিত হয়ে ব্লাস্টোসিস্ট তৈরি করে এবং জরায়ুর দেয়ালে নিরাপদে প্রতিস্থাপিত হয়। প্লাসেন্টা ও অ্যামনিওটিক থলি তৈরি হতে শুরু করে।',
      milestonesBangla: [
        'কোষ বিভাজন ও জাইগোট তৈরি',
        'জরায়ুর দেয়ালে সফল প্রতিস্থাপন',
        'অ্যামনিওটিক থলি ও প্লাসেন্টার সূচনা',
      ],
      accentColor: Color(0xFFD97706),
      backgroundColor: Color(0xFFFFFBEB),
      defaultAssetPath: 'assets/images/fetal/stage_1.png',
    ),

    // Stage 2: Weeks 5 - 8
    FetalStageVisualData(
      stageNumber: 2,
      weekStart: 5,
      weekEnd: 8,
      stageTitleBangla: 'প্রাথমিক অঙ্গ গঠন ও হৃদস্পন্দন',
      stageTitleEnglish: 'Early Organogenesis & Heartbeat',
      stageBadgeBangla: 'ক্ষুদ্র ভ্রূণ পর্যায়',
      descriptionBangla:
          'ভ্রূণের ক্ষুদ্র হৃদস্পন্দন শুরু হয়। মস্তিষ্ক, মেরুদণ্ড এবং হাত ও পায়ের ছোট কুঁড়ি (Limb buds) দ্রুত গঠিত হতে থাকে।',
      milestonesBangla: [
        'ক্ষুদ্র হৃদস্পন্দনের স্পন্দন শুরু',
        'নিউরাল টিউব ও মস্তিষ্ক গঠন',
        'হাত ও পায়ের ক্ষুদ্র কুঁড়ি প্রকাশ',
      ],
      accentColor: Color(0xFFE11D48),
      backgroundColor: Color(0xFFFFF1F2),
      defaultAssetPath: 'assets/images/fetal/stage_2.png',
    ),

    // Stage 3: Weeks 9 - 12
    FetalStageVisualData(
      stageNumber: 3,
      weekStart: 9,
      weekEnd: 12,
      stageTitleBangla: 'ফিটাস পর্যায় ও মুখের স্পষ্ট রূপরেখা',
      stageTitleEnglish: 'Fetal Transition & Facial Features',
      stageBadgeBangla: '১ম ট্রাইমেস্টার সমাপনী',
      descriptionBangla:
          'ভ্রূণ এখন আনুষ্ঠানিকভাবে ফিটাস নামে পরিচিত। মুখাবয়ব, চোখ, কান ও নাকের স্পষ্ট রূপরেখা তৈরি হয় এবং হাতের আঙুল আলাদা হয়ে যায়।',
      milestonesBangla: [
        'চোখ, কান ও মুখের স্পষ্ট রূপরেখা',
        'আঙুল ও নখের প্রাথমিক ভিত্তি',
        'স্বাভাবিক প্রাথমিক প্রতিবর্ত ক্রিয়া (Reflexes)',
      ],
      accentColor: Color(0xFFC026D3),
      backgroundColor: Color(0xFFFDF4FF),
      defaultAssetPath: 'assets/images/fetal/stage_3.png',
    ),

    // Stage 4: Weeks 13 - 16
    FetalStageVisualData(
      stageNumber: 4,
      weekStart: 13,
      weekEnd: 16,
      stageTitleBangla: '২য় ট্রাইমেস্টার ও কঙ্কাল পরিপক্বতা',
      stageTitleEnglish: '2nd Trimester & Bone Hardening',
      stageBadgeBangla: 'সক্রিয় নড়াচড়া',
      descriptionBangla:
          'শিশুর নরম হাড়গুলো শক্ত ও সুগঠিত হতে শুরু করে। ত্বকে অতি সূক্ষ্ম লোম (ল্যানুগো) জন্মায় এবং শিশু হাতের আঙুল চোষার অনুশীলন করতে পারে।',
      milestonesBangla: [
        'কঙ্কাল ও হাড়ের শক্তিবৃদ্ধি',
        'সূক্ষ্ম সুরক্ষামূলক ল্যানুগো লোম',
        'আঙুল চোষা ও নড়াচড়ার শক্তি সঞ্চয়',
      ],
      accentColor: Color(0xFF7C3AED),
      backgroundColor: Color(0xFFF5F3FF),
      defaultAssetPath: 'assets/images/fetal/stage_4.png',
    ),

    // Stage 5: Weeks 17 - 20
    FetalStageVisualData(
      stageNumber: 5,
      weekStart: 17,
      weekEnd: 20,
      stageTitleBangla: 'কুইকেনিং ও সংবেদনশীল বিকাশ',
      stageTitleEnglish: 'Quickening & Sensory Development',
      stageBadgeBangla: 'মধ্য-গর্ভাবস্থা মাইলফলক',
      descriptionBangla:
          'মা প্রথমবারের মতো মৃদু নড়াচড়া (কুইকেনিং) অনুভব করতে পারেন। শিশুর ত্বক সুরক্ষার জন্য ভারনিক্স ক্যাসিওসা স্তর তৈরি হয় এবং সে বাইরের শব্দ শুনতে পায়।',
      milestonesBangla: [
        'মায়ের প্রথম নড়াচড়া অনুভব (Quickening)',
        'ত্বক সুরক্ষাকারী ভারনিক্স আবরণ',
        'শব্দ ও সুর শোনার প্রাথমিক ক্ষমতা',
      ],
      accentColor: Color(0xFF881337), // MomBee Deep Rose
      backgroundColor: Color(0xFFFFF1F2),
      defaultAssetPath: 'assets/images/fetal/stage_5.png',
    ),

    // Stage 6: Weeks 21 - 24
    FetalStageVisualData(
      stageNumber: 6,
      weekStart: 21,
      weekEnd: 24,
      stageTitleBangla: 'ভায়াবিলিটি মাইলফলক ও ইন্দ্রিয় সক্রিয়তা',
      stageTitleEnglish: 'Viability Milestone & Sensory Awakening',
      stageBadgeBangla: 'জীবনীশক্তি সঞ্চার',
      descriptionBangla:
          'চিকিৎসাবিজ্ঞানে এটি ভায়াবিলিটি বা সক্ষমতার গুরুত্বপূর্ণ মাইলফলক। শিশুর চোখের পাতা আলাদা হয়, ফুসফুসের বিকাশ দ্রুত ঘটে এবং মায়ের পরিচিত কণ্ঠে সাড়া দেয়।',
      milestonesBangla: [
        'ভায়াবিলিটি বা জীবনীশক্তির গুরুত্বপূর্ণ ধাপ',
        'ফুসফুসে অ্যালভিওলাই ও বায়ুনালী তৈরি',
        'পরিচিত শব্দ ও স্পন্দনে নড়াচড়ার সাড়া',
      ],
      accentColor: Color(0xFF701A2B), // MomBee Primary Maroon
      backgroundColor: Color(0xFFFDF2F4),
      defaultAssetPath: 'assets/images/fetal/stage_6.png',
    ),

    // Stage 7: Weeks 25 - 28
    FetalStageVisualData(
      stageNumber: 7,
      weekStart: 25,
      weekEnd: 28,
      stageTitleBangla: '৩য় ট্রাইমেস্টারের সূচনা ও চোখ উন্মোচন',
      stageTitleEnglish: '3rd Trimester Threshold & Eye Opening',
      stageBadgeBangla: '৩য় ট্রাইমেস্টার সূচনা',
      descriptionBangla:
          '৩য় ট্রাইমেস্টার শুরু হয়। শিশু চোখ খুলতে ও বন্ধ করতে পারে। মস্তিষ্কে দ্রুত সংযোগ স্থাপিত হয় এবং সে হালকা আলো ও অন্ধকারের অনুভূতি বুঝতে পারে।',
      milestonesBangla: [
        'চোখের পাতা উন্মোচন ও পলক ফেলা',
        'মস্তিষ্কের স্মৃতি ও নিউরাল ওয়েভ বৃদ্ধি',
        'শ্বাস-প্রশ্বাসের ছন্দময় অনুশীলন',
      ],
      accentColor: Color(0xFF0D9488),
      backgroundColor: Color(0xFFF0FDFA),
      defaultAssetPath: 'assets/images/fetal/stage_7.png',
    ),

    // Stage 8: Weeks 29 - 32
    FetalStageVisualData(
      stageNumber: 8,
      weekStart: 29,
      weekEnd: 32,
      stageTitleBangla: 'দ্রুত বৃদ্ধি ও ত্বকের চর্বি সঞ্চয়',
      stageTitleEnglish: 'Rapid Growth & Subcutaneous Fat',
      stageBadgeBangla: 'শারীরিক পরিপক্বতা',
      descriptionBangla:
          'শিশুর ত্বকের নিচে সুরক্ষামূলক সাদা চর্বির স্তর জমে যা দেহের তাপমাত্রা নিয়ন্ত্রণে সাহায্য করে। নড়াচড়া ও লাথি এখন অত্যন্ত স্পষ্ট ও ছন্দময়।',
      milestonesBangla: [
        'শরীরে দ্রুত চর্বি সঞ্চয় ও কোমল ত্বক',
        'শক্তিশালী ছন্দময় লাথি ও অবস্থান পরিবর্তন',
        'শরীরের তাপমাত্রা নিয়ন্ত্রণ ব্যবস্থার বিকাশ',
      ],
      accentColor: Color(0xFF0284C7),
      backgroundColor: Color(0xFFF0F9FF),
      defaultAssetPath: 'assets/images/fetal/stage_8.png',
    ),

    // Stage 9: Weeks 33 - 36
    FetalStageVisualData(
      stageNumber: 9,
      weekStart: 33,
      weekEnd: 36,
      stageTitleBangla: 'প্রসবকালীন অবস্থান ও ফুসফুসের পূর্ণতা',
      stageTitleEnglish: 'Cephalic Positioning & Lung Maturity',
      stageBadgeBangla: 'প্রসব প্রস্তুতি পর্ব',
      descriptionBangla:
          'অধিকাংশ শিশুই প্রসবের অনুকূল হেড-ডাউন (Cephalic) অবস্থানে চলে আসে। ফুসফুসে পর্যাপ্ত সারফ্যাক্ট্যান্ট তৈরি হয় যা জন্মের পর শ্বাস নেয়ার জন্য প্রস্তুত করে।',
      milestonesBangla: [
        'হেড-ডাউন (Cephalic) প্রসবকালীন অবস্থান গ্রহণ',
        'ফুসফুসের সারফ্যাক্ট্যান্ট প্রায় সম্পূর্ণ প্রস্তুত',
        'মায়ের কাছ থেকে রোগ প্রতিরোধক অ্যান্টিবডি গ্রহণ',
      ],
      accentColor: Color(0xFF4F46E5),
      backgroundColor: Color(0xFFEEF2FF),
      defaultAssetPath: 'assets/images/fetal/stage_9.png',
    ),

    // Stage 10: Weeks 37 - 40
    FetalStageVisualData(
      stageNumber: 10,
      weekStart: 37,
      weekEnd: 40,
      stageTitleBangla: 'পূর্ণ মেয়াদী সুস্থ শিশু (প্রস্তুত)',
      stageTitleEnglish: 'Full Term Baby - Ready for Birth',
      stageBadgeBangla: 'পূর্ণ মেয়াদী (Full Term)',
      descriptionBangla:
          'গর্ভকালীন ৩৭ সপ্তাহ পার হলে শিশু পূর্ণ মেয়াদী (Full Term) হিসেবে গণ্য হয়। অঙ্গ-প্রত্যঙ্গ সম্পূর্ণ বিকশিত এবং যেকোনো দিন এই পৃথিবীতে আগমনের জন্য প্রস্তুত।',
      milestonesBangla: [
        'পূর্ণ মেয়াদী (Full Term) পরিপক্ব শিশু',
        'শক্তিশালী আঁকড়ে ধরার ক্ষমতা (Grasp reflex)',
        'পৃথিবীর আলোয় আসার জন্য পরিপূর্ণভাবে প্রস্তুত',
      ],
      accentColor: Color(0xFF500724), // MomBee Dark Maroon
      backgroundColor: Color(0xFFFFFBEB),
      defaultAssetPath: 'assets/images/fetal/stage_10.png',
    ),
  ];
}
