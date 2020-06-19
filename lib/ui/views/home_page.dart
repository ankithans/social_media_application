import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:social_media_application/ui/views/home_feeds.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _kAddPhotoTabIndex = 2;
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

  Widget _buildPlaceHolderTab(String tabName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 64.0),
        child: Column(
          children: <Widget>[
            Text(
              'Oops, the $tabName tab is\n under construction!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28.0),
            ),
            Image.asset('assets/images/building.gif'),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_tabSelectedIndex) {
      case 0:
        _scrollController =
            ScrollController(initialScrollOffset: _lastFeedScrollOffset);
        return HomeFeedPage(scrollController: _scrollController);
      default:
        const tabIndexToNameMap = {
          0: 'Home',
          1: 'Search',
          2: 'Add Photo',
          3: 'Notifications',
          4: 'Profile',
        };
        _disposeScrollController();
        return _buildPlaceHolderTab(tabIndexToNameMap[_tabSelectedIndex]);
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
    HomeFeedPage(),
    Text('Search'),
    Text('add Post'),
    Text('Notifications'),
    Text('Profile'),
  ];

  void _onTabTapped(BuildContext context, int index) {
    if (index == _kAddPhotoTabIndex) {
    } else if (index == _tabSelectedIndex) {
      _scrollToTop();
    } else {
      setState(() => _tabSelectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: AppBar(
          centerTitle: true,
          elevation: 1.0,
          backgroundColor: Colors.grey[50],
          leading: Icon(
            Icons.camera,
            color: Colors.black,
            size: 30,
          ),
          title: Text(
            'Social Media',
            style: GoogleFonts.meriendaOne(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
          actions: <Widget>[
            Builder(builder: (BuildContext context) {
              return IconButton(
                color: Colors.black,
                icon: Icon(OMIcons.nearMe),
                onPressed: () => {},
              );
            }),
          ],
        ),
      ),
      body: _widgetOptions.elementAt(_tabSelectedIndex),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}
