import 'package:flutter/material.dart';
import 'package:funny_chat/core/models/account/user.dart';
import 'package:funny_chat/core/responsitory/api.dart';

class CustomSearch extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: Api.searchContact(query),
        builder: (context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            print(snapshot.data);
            return ListTile(
              title: Text('result'),
            );
          }
          return Container();
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: Colors.red,
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.green),
      primaryColorBrightness: Brightness.dark,
      textTheme: theme.textTheme.copyWith(
        title: TextStyle(fontWeight: FontWeight.normal),
      ),
      // these ↓ do not work ☹️
      appBarTheme:
          theme.appBarTheme.copyWith(color: Colors.black12, elevation: 0),
      inputDecorationTheme:
          theme.inputDecorationTheme.copyWith(border: UnderlineInputBorder()),
    );
  }
}
