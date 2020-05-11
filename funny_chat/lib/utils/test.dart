// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:funny_chat/core/models/account/user.dart';

// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   TextEditingController searchController = TextEditingController();

//   Future<QuerySnapshot> searchResultsFuture;

//   handleSearch(String query) {
//     Future<QuerySnapshot> users = Firestore.instance
//         .collection("path")
//         .where("profilename", isGreaterThanOrEqualTo: query)
//         .getDocuments()
//         .then((value) {
//       setState(() {
//         searchResultsFuture = value;
//       });
//     });

//     // searchResultsFuture = users;
//   }

//   clearSearch() {
//     searchController.clear();
//   }

//   AppBar buildSearchField() {
//     return AppBar(
//       backgroundColor: Colors.white,
//       title: TextFormField(
//         controller: searchController,
//         decoration: InputDecoration(
//           hintText: "Search Your Friends",
//           filled: true,
//           prefixIcon: Icon(
//             Icons.account_box,
//             size: 28.0,
//           ),
//           suffixIcon: IconButton(
//             icon: Icon(Icons.clear),
//             onPressed: clearSearch,
//           ),
//         ),
//         onFieldSubmitted: handleSearch,
//       ),
//     );
//   }

//   Container buildNoContent() {
//     final Orientation orientation = MediaQuery.of(context).orientation;
//     return Container(
//       child: ListView(
//         shrinkWrap: true,
//         children: <Widget>[
//           Icon(
//             Icons.group,
//             color: Colors.white,
//             size: orientation == Orientation.portrait ? 400.0 : 200.0,
//           ),
//           Text(
//             "Find Users",
//             textAlign: TextAlign.center,
//             style: TextStyle(
//                 color: Colors.white,
//                 fontStyle: FontStyle.italic,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 65.0),
//           ),
//         ],
//       ),
//     );
//   }

//   buildSearchResults() {
//     return FutureBuilder(
//         future: searchResultsFuture,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return CircularProgressIndicator();
//           }
//           List<UserResult> searchResults = [];
//           snapshot.data.documents.forEach((doc) {
//             User user = User.fromDocument(doc);
//             UserResult searchResult = UserResult(user);
//             searchResults.add(searchResult);
//           });
//           return ListView(
//             children: searchResults,
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: buildSearchField(),
//       body:
//           searchResultsFuture == null ? buildNoContent() : buildSearchResults(),
//     );
//   }
// }

// class UserResult extends StatelessWidget {
//   final User eachUser;

//   UserResult(this.eachUser);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Theme.of(context).primaryColor.withOpacity(0.7),
//       child: Column(
//         children: <Widget>[
//           GestureDetector(
//             onTap: () => print("tapped"),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 backgroundImage: CachedNetworkImageProvider(eachUser.url),
//               ),
//               title: eachUser.profileName != null
//                   ? Text(
//                       eachUser.profileName,
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     )
//                   : 'User',
//               subtitle: Text(
//                 eachUser.username,
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//           Divider(
//             height: 2.0,
//             color: Colors.white54,
//           ),
//         ],
//       ),
//     );
//   }
// }
