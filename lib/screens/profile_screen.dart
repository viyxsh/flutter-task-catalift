import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_task_catalift/data/course_data.dart';
import 'package:flutter_task_catalift/models/user.dart';
import 'package:flutter_task_catalift/providers/bookmark_provider.dart';
import 'package:flutter_task_catalift/screens/course_details_screen.dart';
import 'package:flutter_task_catalift/utils/theme.dart';
import 'package:flutter_task_catalift/widgets/course_card.dart';

class ProfileScreen extends StatelessWidget {
  final void Function(int) navigateToScreen;

  const ProfileScreen({
    Key? key,
    required this.navigateToScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
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
            _buildUserProfile(),
            _buildYourCourses(),
            _buildBookmarkedCourses(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            backgroundImage: AssetImage(currentUser.profileImagePath),
          ),
          const SizedBox(height: 12),
          Text(
            currentUser.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            currentUser.email,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Text(
              currentUser.bio,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYourCourses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'Your Courses',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 50, 
          child: const Center(
            child: Text(
              'No courses purchased yet',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.lightTextColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkedCourses() {
    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, child) {
        final bookmarkedCourses = bookmarkProvider.bookmarkedCourses;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Bookmarked Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: bookmarkedCourses.isEmpty ? 50 : 220, 
              child: bookmarkedCourses.isEmpty
                  ? const Center(
                      child: Text(
                        'No bookmarked courses',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.lightTextColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: bookmarkedCourses.length,
                      itemBuilder: (context, index) {
                        final course = bookmarkedCourses[index];
                        return CourseCard(
                          course: course,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CourseDetailsScreen(
                                  course: course,
                                  similarCourses: similarCourses,
                                  selectedCategory: 'ALL',
                                  onCategoryChanged: (_) {},
                                  navigateToScreen: navigateToScreen,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}