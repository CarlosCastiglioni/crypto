import 'package:flutter/cupertino.dart';

class HomeController extends ChangeNotifier {
  int currentPage = 0;
  late PageController pc = PageController();
  setPage(page) async {
    currentPage = await page;
    pc = PageController(initialPage: currentPage);
    notifyListeners();
  }
}
