import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_catalift/models/course.dart';
import 'package:flutter_task_catalift/providers/bookmark_provider.dart';
import 'package:flutter_task_catalift/providers/cart_provider.dart';
import 'package:flutter_task_catalift/utils/theme.dart';
import 'package:flutter_task_catalift/widgets/app_bottom_navigation.dart';
import 'package:flutter_task_catalift/widgets/course_card.dart';
import 'package:flutter_task_catalift/widgets/notifier_widget.dart';

class CourseDetailsScreen extends StatefulWidget {
  final Course course;
  final List<Course> similarCourses;
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final void Function(int) navigateToScreen;

  const CourseDetailsScreen({
    super.key,
    required this.course,
    required this.similarCourses,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.navigateToScreen,
  });

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final filteredSimilarCourses = widget.similarCourses.where((course) {
      return course.category == widget.course.category && course.id != widget.course.id;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 60,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryColor,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        title: const Text(
          'Course Details',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Consumer<BookmarkProvider>(
            builder: (context, bookmarkProvider, child) {
              final isBookmarked = bookmarkProvider.isBookmarked(widget.course);

              return IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                onPressed: () {
                  bookmarkProvider.toggleBookmark(widget.course);
                  NotifierWidget.show(
                    context,
                    message: isBookmarked ? 'Bookmark removed!' : 'Course bookmarked!',
                    backgroundColor: AppTheme.primaryColor,
                    textColor: Colors.white,
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCourseHeader(),
            _buildCourseTitle(),
            _buildCourseRating(),
            _buildCourseDescription(),
            _buildActionButtons(),
            _buildSimilarCoursesSection(filteredSimilarCourses),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: 0,
        onTap: (index) {
          Navigator.of(context).pop();
          widget.navigateToScreen(index);
        },
      ),
    );
  }

  Widget _buildCourseHeader() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        image: DecorationImage(
          image: AssetImage(widget.course.imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildCourseTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.course.isHighlyEnrolled)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Highly Enrolled',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            widget.course.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseRating() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: AppTheme.starColor,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            widget.course.rating.toString(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            '|',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.course.enrollments} Enrolled',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const Spacer(),
          Text(
            '₹${widget.course.price}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseDescription() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16, bottom: 20),
      child: Text(
        widget.course.description ?? '',
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, child) {
        bool isInCart = cartProvider.isInCart(widget.course);

        return Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isInCart) {
                        cartProvider.removeItem(widget.course.id);
                      } else {
                        cartProvider.addItem(widget.course);
                      }
                      NotifierWidget.show(
                        context,
                        message: isInCart
                            ? 'Course removed from cart'
                            : 'Course added to cart',
                        backgroundColor: AppTheme.primaryColor,
                        textColor: Colors.white,
                      );
                    },
                    style: AppTheme.secondaryButtonStyle,
                    child: Text(
                      isInCart ? 'Remove from Cart' : 'Add To Cart',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!isInCart) {
                        cartProvider.addItem(widget.course);
                        NotifierWidget.show(
                          context,
                          message: 'Course added to cart',
                          backgroundColor: AppTheme.primaryColor,
                          textColor: Colors.white,
                        );
                      }
                      Navigator.of(context).pop();
                      widget.navigateToScreen(1);
                    },
                    style: AppTheme.primaryButtonStyle,
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSimilarCoursesSection(List<Course> filteredCourses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Similar Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.onCategoryChanged(widget.course.category);
                  Navigator.of(context).pop();
                  widget.navigateToScreen(0);
                },
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: filteredCourses.isEmpty
              ? const Center(
            child: Text(
              'No similar courses found',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.lightTextColor,
              ),
            ),
          )
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: filteredCourses.length,
            itemBuilder: (context, index) {
              final course = filteredCourses[index];
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 180, // Define width to ensure CourseCard renders
                  child: CourseCard(
                    course: course,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailsScreen(
                            course: course,
                            similarCourses: widget.similarCourses,
                            selectedCategory: widget.selectedCategory,
                            onCategoryChanged: widget.onCategoryChanged,
                            navigateToScreen: widget.navigateToScreen,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}