import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animated_card.dart';

class TravelHeader extends StatelessWidget {
  final String greeting;
  final String subtitle;
  final String? avatarUrl;
  final VoidCallback? onMenuTap;
  final VoidCallback? onAvatarTap;

  const TravelHeader({
    super.key,
    required this.greeting,
    required this.subtitle,
    this.avatarUrl,
    this.onMenuTap,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInAnimation(
                  delay: const Duration(milliseconds: 100),
                  child: Text(
                    greeting,
                    style: AppTheme.headingMedium,
                  ),
                ),
                const SizedBox(height: 4),
                FadeInAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    subtitle,
                    style: AppTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          FadeInAnimation(
            delay: const Duration(milliseconds: 300),
            child: Row(
              children: [
                if (avatarUrl != null) ...[
                  GestureDetector(
                    onTap: onAvatarTap,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(avatarUrl!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                ],
                GestureDetector(
                  onTap: onMenuTap,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryBlack,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: AppTheme.primaryWhite,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TravelSearchBar extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const TravelSearchBar({
    super.key,
    this.hintText = 'Search destinations...',
    this.onTap,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 400),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(
              Icons.search,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            suffixIcon: const Icon(
              Icons.tune,
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryTabs extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategoryTabs({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SlideInAnimation(
      delay: const Duration(milliseconds: 500),
      child: Container(
        height: 40,
        margin: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == selectedCategory;
            
            return AnimatedContainer(
              duration: AppAnimations.medium,
              margin: const EdgeInsets.only(right: AppSpacing.sm),
              child: GestureDetector(
                onTap: () => onCategorySelected(category),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.primaryBlack : AppTheme.lightGray,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppTheme.primaryWhite : AppTheme.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final String title;
  final String location;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const DestinationCard({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      padding: EdgeInsets.zero,
      boxShadow: const [AppTheme.largeShadow],
      child: Container(
        height: 320,
        decoration: BoxDecoration(
          borderRadius: AppTheme.radiusXLarge,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: AppTheme.radiusXLarge,
            gradient: AppTheme.overlayGradient,
          ),
          child: Stack(
            children: [
              // Heart button
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: onFavorite,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : AppTheme.primaryWhite,
                      size: 20,
                    ),
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryWhite,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      location,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.primaryWhite.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.primaryWhite,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviewCount)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.primaryWhite.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TourCard extends StatelessWidget {
  final String title;
  final String details;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String price;
  final VoidCallback? onTap;

  const TourCard({
    super.key,
    required this.title,
    required this.details,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.price,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      margin: const EdgeInsets.only(right: AppSpacing.md),
      padding: EdgeInsets.zero,
      boxShadow: const [AppTheme.cardShadow],
      child: Container(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details,
                    style: AppTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryBlack,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '($reviewCount)',
                        style: AppTheme.caption,
                      ),
                      const Spacer(),
                      Text(
                        price,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accentTeal,
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
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppTheme.primaryButtonStyle,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryWhite),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}