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
}
