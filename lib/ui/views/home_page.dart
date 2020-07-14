import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:social_media_application/ui/views/home_feeds.dart';
import 'package:social_media_application/ui/views/notifications.dart';
import 'package:social_media_application/ui/views/posts/create_post.dart';
import 'package:social_media_application/ui/views/posts/home_feeds.dart';
import 'package:social_media_application/ui/views/profile/profilePage.dart';
import 'package:social_media_application/ui/views/search.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _kAddPhotoTabIndex = 1;
  int _tabSelectedIndex = 0;

  // Save the home page scrolling offset,
  // used when navigating back to the home page from another tab.
  double _lastFeedScrollOffset = 0;
  ScrollController _scrollController;

  @override
  void dispose() {
    _disposeScrollController();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController == null) {
      return;
    }
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 250),
      curve: Curves.decelerate,
    );
  }

  // Call this when changing the body that doesn't use a ScrollController.
  void _disposeScrollController() {
    if (_scrollController != null) {
      _lastFeedScrollOffset = _scrollController.offset;
      _scrollController.dispose();
      _scrollController = null;
    }
  }

  // Unselected tabs are outline icons, while the selected tab should be solid.
  Widget _buildBottomNavigation() {
    const unselectedIcons = <IconData>[
      OMIcons.home,
      OMIcons.search,
      Icons.add_circle_outline,
      Icons.notifications_none,
      Icons.person_outline,
    ];
    const selecteedIcons = <IconData>[
      Icons.home,
      Icons.search,
      Icons.add_circle,
      Icons.notifications,
      Icons.person,
    ];
    final bottomNaivgationItems = List.generate(5, (int i) {
      final iconData =
          _tabSelectedIndex == i ? selecteedIcons[i] : unselectedIcons[i];
      return BottomNavigationBarItem(
        icon: Icon(iconData),
        title: Container(),
      );
    }).toList();

    return Builder(builder: (BuildContext context) {
      return BottomNavigationBar(
        iconSize: 28.0,
        selectedIconTheme: IconThemeData(
          color: Colors.black,
          size: 32,
        ),
        type: BottomNavigationBarType.fixed,
        items: bottomNaivgationItems,
        currentIndex: _tabSelectedIndex,
        onTap: (int i) => _onTabTapped(context, i),
      );
    });
  }

  static List<Widget> _widgetOptions = <Widget>[
    HomeFeeds(),
    Search(),
    CreatePostScreen(),
    Notifications(),
    ProfilePage(),
  ];

  void _onTabTapped(BuildContext context, int index) {
    if (index == _tabSelectedIndex) {
      _scrollToTop();
    } else {
      setState(() => _tabSelectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_tabSelectedIndex),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
