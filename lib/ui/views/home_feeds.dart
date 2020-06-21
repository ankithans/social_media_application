import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:social_media_application/models/models.dart';
import 'package:social_media_application/ui/widgets/avatar_widget.dart';
import 'package:social_media_application/ui/widgets/post_widget.dart';

class HomeFeedPage extends StatefulWidget {
  final ScrollController scrollController;

  HomeFeedPage({this.scrollController});

  @override
  _HomeFeedPageState createState() => _HomeFeedPageState();
}

class _HomeFeedPageState extends State<HomeFeedPage> {
  final _posts = <Post>[
    Post(
      user: grootlover,
      imageUrls: [
        'https://image.shutterstock.com/image-photo/bright-spring-view-cameo-island-260nw-1048185397.jpg',
        'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg',
        'https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__340.jpg',
      ],
      likes: [
        Like(user: rocket),
        Like(user: starlord),
        Like(user: gamora),
        Like(user: nickwu241),
      ],
      comments: [
        Comment(
          text: 'So we’re saving the galaxy again? #gotg',
          user: rocket,
          commentedAt: DateTime(2019, 5, 23, 14, 35, 0),
          likes: [Like(user: nickwu241)],
        ),
      ],
      location: 'Earth',
      postedAt: DateTime(2020, 5, 23, 12, 35, 0),
    ),
    Post(
      user: nickwu241,
      imageUrls: [
        'https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__340.jpg'
      ],
      likes: [],
      comments: [],
      location: 'Knowhere',
      postedAt: DateTime(2019, 5, 21, 6, 0, 0),
    ),
    Post(
      user: nebula,
      imageUrls: [
        'https://cdn.pixabay.com/photo/2015/02/24/15/41/dog-647528__340.jpg'
      ],
      likes: [Like(user: nickwu241)],
      comments: [],
      location: 'Nine Realms',
      postedAt: DateTime(2019, 5, 2, 0, 0, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (ctx, i) {
          if (i == 0) {
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 8,
                ),
                StoriesBarWidget(),
                SizedBox(
                  height: 8,
                ),
              ],
            );
          }
          return PostWidget(_posts[i - 1]);
        },
        itemCount: _posts.length + 1,
        controller: widget.scrollController,
      ),
    );
  }
}

class StoriesBarWidget extends StatelessWidget {
  final _users = <User>[
    currentUser,
    grootlover,
    rocket,
    nebula,
    starlord,
    gamora,
  ];

  void _onUserStoryTap(BuildContext context, int i) {
    final message =
        i == 0 ? 'Add to Your Story' : "View ${_users[i].name}'s Story";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 106.0,
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (ctx, i) {
          return AvatarWidget(
            user: _users[i],
            onTap: () => _onUserStoryTap(context, i),
            isLarge: true,
            isShowingUsernameLabel: true,
            isCurrentUserStory: i == 0,
          );
        },
        itemCount: _users.length,
      ),
    );
  }
}
