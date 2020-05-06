import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class HomePageViewModel with ChangeNotifier {
  PageController pageController = PageController(
    initialPage: 0,
  );

  nextPage() {
    pageController.animateToPage(1,
        duration: Duration(milliseconds: 300), curve: Curves.easeIn);
  }

  previousPage() {
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future searchContact(String email) async {
    try {
      final result = await Firestore.instance
          .collectionGroup("users")
          .where("email", isEqualTo: "nhatnam11111@gmail.com")
          .getDocuments();
      return result;
    } catch (e) {
      print(e);
    }
  }
}
