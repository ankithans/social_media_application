import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_application/models/profile/following.dart';

class FollowingCard extends StatefulWidget {
  final GetFollowing getfollowing;
  final int index;

  const FollowingCard({Key key, this.getfollowing, this.index})
      : super(key: key);

  @override
  _FollowingCardState createState() => _FollowingCardState();
}

class _FollowingCardState extends State<FollowingCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFFF8B66),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage:
                    NetworkImage(widget.getfollowing.result[widget.index].pic),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  widget.getfollowing.result[widget.index].name,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Here Bio will come',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            RaisedButton(
              onPressed: () {},
              elevation: 0,
              padding: EdgeInsets.all(0),
              color: Color(0xFFFF8B66),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: Colors.white,
                ),
              ),
              child: Text(
                'Unfollow',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
