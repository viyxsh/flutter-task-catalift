import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_task_catalift/data/course_data.dart';
import 'package:flutter_task_catalift/models/course.dart';
import 'package:flutter_task_catalift/screens/course_details_screen.dart';
import 'package:flutter_task_catalift/utils/theme.dart';
import 'package:flutter_task_catalift/widgets/category_chip.dart';
import 'package:flutter_task_catalift/widgets/course_card.dart';

class HomeScreen extends StatefulWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;
  final void Function(int) navigateToScreen;

  const HomeScreen({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.navigateToScreen,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Course> filteredFeaturedCourses = featuredCourses.where((course) {
      return course.title.toLowerCase().contains(_searchQuery);
    }).toList();

    final List<Course> filteredSimilarCourses = similarCourses.where((course) {
      final matchesSearch = course.title.toLowerCase().contains(_searchQuery);
      final matchesCategory = widget.selectedCategory == 'ALL' ||
          course.category == widget.selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Course Marketplace',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchBar(),
            _buildFeaturedCoursesSlider(context, filteredFeaturedCourses),
            _buildFiltersSection(),
            _buildSimilarCoursesSection(context, filteredSimilarCourses),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search courses...',
          prefixIcon: const Icon(
            Icons.search,
            color: AppTheme.lightTextColor,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusExtraLarge),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusExtraLarge),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusExtraLarge),
            borderSide: const BorderSide(color: AppTheme.primaryColor),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildFeaturedCoursesSlider(BuildContext context, List<Course> filteredFeaturedCourses) {
    List<Course> displayCourses = filteredFeaturedCourses;
    if (displayCourses.isEmpty && _searchQuery.isNotEmpty) {
      displayCourses = similarCourses.where((course) {
        return course.title.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return displayCourses.isNotEmpty
        ? CarouselSlider.builder(
      itemCount: displayCourses.length,
      itemBuilder: (context, index, realIndex) {
        final course = displayCourses[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CourseDetailsScreen(
                  course: course,
                  similarCourses: similarCourses,
                  selectedCategory: widget.selectedCategory,
                  onCategoryChanged: widget.onCategoryChanged,
                  navigateToScreen: widget.navigateToScreen,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(course.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppTheme.starColor,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              course.rating.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              '|',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${course.enrollments} Enrolled',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.9,
        aspectRatio: 2.0,
      ),
    )
        : const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        'No courses match your search',
        style: TextStyle(
          fontSize: 16,
          color: AppTheme.lightTextColor,
        ),
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: courseCategories.length,
            itemBuilder: (context, index) {
              final category = courseCategories[index];
              final isSelected = widget.selectedCategory == category;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CategoryChip(
                  label: category,
                  isSelected: isSelected,
                  onTap: () {
                    widget.onCategoryChanged(category);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarCoursesSection(
      BuildContext context, List<Course> filteredCourses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        filteredCourses.isEmpty
            ? const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'No courses found',
            style: TextStyle(
              fontSize: 16,
              color: AppTheme.lightTextColor,
            ),
          ),
        )
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75, // Adjusted to 3:4 ratio
          ),
          itemCount: filteredCourses.length,
          itemBuilder: (context, index) {
            final course = filteredCourses[index];
            return CourseCard(
              course: course,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseDetailsScreen(
                      course: course,
                      similarCourses: similarCourses,
                      selectedCategory: widget.selectedCategory,
                      onCategoryChanged: widget.onCategoryChanged,
                      navigateToScreen: widget.navigateToScreen,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}