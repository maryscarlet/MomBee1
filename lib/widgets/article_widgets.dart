import 'package:flutter/material.dart';
import '../models/article.dart';
import '../theme/app_theme.dart';

class ArticleCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const ArticleCard({
    super.key,
    required this.article,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(color: AppColors.borderCard),
              boxShadow: AppShadows.subtleCard,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Image.network(
                    article.imageUrl,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 90,
                      height: 90,
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(Icons.article_rounded,
                          color: AppColors.outline),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.08),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              article.category,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            article.readTime,
                            style: const TextStyle(
                              fontFamily: 'Noto Sans Bengali',
                              fontSize: 11,
                              color: AppColors.outline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.verified_user_rounded,
                              size: 13, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              article.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void showMomBeeArticleDetails(BuildContext context, Article article) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.90,
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDim,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Image.network(
                    article.imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 200,
                      color: AppColors.surfaceContainerHigh,
                      child: const Icon(Icons.image, color: AppColors.outline),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        article.category,
                        style: const TextStyle(
                          fontFamily: 'Noto Sans Bengali',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${article.readTime}',
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 12,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      article.publishedDate,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 12,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                        height: 1.35,
                      ),
                ),
                const SizedBox(height: 14),

                // Doctor Information Badge
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryFixed.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.medical_services_rounded,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  article.author,
                                  style: const TextStyle(
                                    fontFamily: 'Noto Sans Bengali',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.verified_rounded,
                                    size: 16, color: AppColors.primary),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              article.doctorDegree,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              article.hospital,
                              style: const TextStyle(
                                fontFamily: 'Noto Sans Bengali',
                                fontSize: 11.5,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.7),
                                borderRadius:
                                    BorderRadius.circular(AppRadius.sm),
                              ),
                              child: Text(
                                article.reviewedBy,
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF40000E),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Summary Callout Box
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF6D6),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(
                        color: const Color(0xFFFECB17).withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: Color(0xFF745B00), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          article.summary,
                          style: const TextStyle(
                            fontFamily: 'Noto Sans Bengali',
                            fontSize: 13,
                            height: 1.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF584400),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32),

                // In-depth Paragraphs
                ...article.paragraphs.map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Text(
                      p,
                      style: const TextStyle(
                        fontFamily: 'Noto Sans Bengali',
                        fontSize: 14.5,
                        height: 1.7,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                ),

                // Dos and Don'ts if provided
                if (article.dosAndDonts != null) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'করণীয় ও বর্জনীয় নির্দেশনা',
                    style: TextStyle(
                      fontFamily: 'Noto Sans Bengali',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (article.dosAndDonts!['করণীয়'] != null)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: const Color(0xFFA5D6A7)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF2E7D32), size: 18),
                              SizedBox(width: 8),
                              Text(
                                'করণীয়:',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ...article.dosAndDonts!['করণীয়']!.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4.0, left: 26.0),
                              child: Text(
                                '• $item',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 13,
                                  color: Color(0xFF1B5E20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (article.dosAndDonts!['বর্জনীয়'] != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: const Color(0xFFFFCDD2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.cancel_rounded,
                                  color: Color(0xFFC62828), size: 18),
                              SizedBox(width: 8),
                              Text(
                                'বর্জনীয়:',
                                style: TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFC62828),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ...article.dosAndDonts!['বর্জনীয়']!.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4.0, left: 26.0),
                              child: Text(
                                '• $item',
                                style: const TextStyle(
                                  fontFamily: 'Noto Sans Bengali',
                                  fontSize: 13,
                                  color: Color(0xFFB71C1C),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
