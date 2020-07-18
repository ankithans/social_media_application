import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_media_application/models/profile/search_users.dart';
import 'package:social_media_application/ui/views/profile/others_profile.dart';

class SearchDistricts extends SearchDelegate {
  final SearchUsers searchUsers;

  SearchDistricts(this.searchUsers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? searchUsers.result
        : searchUsers.result
            .where((element) => element.name.toLowerCase().startsWith(query))
            .toList();

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return FlatButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OthersProfile(
                  userId: suggestionList[index].userId,
                ),
              ),
            );
          },
          padding: EdgeInsets.all(0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      suggestionList[index].pic,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        suggestionList[index].name,
                        style: GoogleFonts.poppins(),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.78,
                        child: Text(
                          suggestionList[index].bio,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
