import 'package:flutter/material.dart';
import 'package:social_media_application/models/profile/search_users.dart';

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
            .where((element) => element.name.startsWith(query))
            .toList();

    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return Container(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    searchUsers.result[index].pic,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(searchUsers.result[index].name),
              ),
            ],
          ),
        );
      },
    );
  }
}
