import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task_catalift/models/course.dart';
import 'package:flutter_task_catalift/utils/theme.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback onTap;
  final Widget? trailing;

  const CourseCard({
    super.key,
    required this.course,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                image: DecorationImage(
                  image: AssetImage(course.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8), // Reduced from 12 to 8
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (trailing != null)
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: trailing!,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4), // Reduced from 8 to 4
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: AppTheme.starColor,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        course.rating.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '|',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${course.enrollments} Enrolled',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), // Reduced from 8 to 4
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/lessons.svg',
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              AppTheme.lightTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${course.lessons} Lessons',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.lightTextColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '₹${course.price}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
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