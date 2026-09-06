class VideoItem {
  final String id;
  final String title;
  final String duration;
  final String views;
  final String uploadTime;
  final String channel;
  final String category;
  final String thumbnailUrl;
  final String description;
  final bool isFeatured;

  const VideoItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.views,
    required this.uploadTime,
    required this.channel,
    required this.category,
    required this.thumbnailUrl,
    required this.description,
    this.isFeatured = false,
  });
}

final List<VideoItem> sampleVideos = [
  const VideoItem(
    id: 'vid-1',
    title: 'নবজাতকের যত্ন: প্রথম ৩০ দিন - Dr. Tasnim Ayesha (MomBee Expert)',
    duration: '12:45',
    views: '45K views',
    uploadTime: '2 days ago',
    channel: 'MomBee Health',
    category: 'Baby',
    thumbnailUrl: 'https://images.unsplash.com/photo-1519689680058-324335c77eba?w=800&auto=format&fit=crop&q=80',
    description: 'নবজাতক জন্মের পর প্রথম এক মাস কী কী সতর্কতা অবলম্বন করবেন, শিশুকে গোসল করানোর সঠিক নিয়ম এবং জরুরি লক্ষণসমূহ।',
    isFeatured: true,
  ),
  const VideoItem(
    id: 'vid-2',
    title: 'গর্ভাবস্থায় পুষ্টিকর খাবার - Nutrition Guide',
    duration: '08:20',
    views: '12K views',
    uploadTime: '1 week ago',
    channel: 'Nutrition Series',
    category: 'Nutrition',
    thumbnailUrl: 'https://images.unsplash.com/photo-1490818387583-1baba5e638af?w=800&auto=format&fit=crop&q=80',
    description: 'গর্ভাবস্থার প্রতিটি ট্রাইমেস্টারে সুষম খাদ্য নিশ্চিত করার সহজ পরামর্শ ও রেসিপি।',
  ),
  const VideoItem(
    id: 'vid-3',
    title: 'Safe Exercises for 2nd Trimester',
    duration: '15:10',
    views: '8K views',
    uploadTime: '3 weeks ago',
    channel: 'Pregnancy Fitness',
    category: 'Pregnancy',
    thumbnailUrl: 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800&auto=format&fit=crop&q=80',
    description: 'দ্বিতীয় ট্রাইমেস্টারের জন্য নিরাপদ ও আরামদায়ক কিছু যোগাসন ও শ্বাস-প্রশ্বাসের ব্যায়াম।',
  ),
  const VideoItem(
    id: 'vid-4',
    title: 'Vaccination Schedule Simplified',
    duration: '05:45',
    views: '22K views',
    uploadTime: '1 month ago',
    channel: 'Baby Health',
    category: 'Baby',
    thumbnailUrl: 'https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?w=800&auto=format&fit=crop&q=80',
    description: 'বাংলাদেশ ইপিআই এবং প্রয়োজনীয় অতিরিক্ত টিকার সম্পূর্ণ চার্ট ও সময়সূচি।',
  ),
  const VideoItem(
    id: 'vid-5',
    title: 'Postpartum Mental Health: মায়ের মানসিক যত্ন',
    duration: '10:30',
    views: '18K views',
    uploadTime: '1 month ago',
    channel: 'Mother Care',
    category: 'Mother',
    thumbnailUrl: 'https://images.unsplash.com/photo-1531746020798-e6953c6e8e04?w=800&auto=format&fit=crop&q=80',
    description: 'সন্তান জন্মের পর বিষণ্ণতা (Postpartum Depression) কাটিয়ে ওঠার কার্যকরী উপায়।',
  ),
];
