import 'package:eopy_management_system/ui/order_history/order_history_list_page.dart';
import 'package:eopy_management_system/ui/overview/overview_page.dart';
import 'package:flutter/material.dart';

import '../order_list/order_list_page.dart';

class MainFramePage extends StatefulWidget {
  @override
  _MainFramePageState createState() => _MainFramePageState();
}

class _MainFramePageState extends State<MainFramePage> {
  int _selectedIndex = 0;
  final _scaffoldState = GlobalKey<ScaffoldState>();
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pageController.addListener(() {
      int currentIndex = _pageController.page.round();
      if (currentIndex != _selectedIndex) {
        _selectedIndex = currentIndex;

        setState(() {});
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Genel Bakış"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Siparişler"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "Geçmiş"),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          OverviewPage(),
          OrderListPage(),
          OrderHistoryListPage(),
        ],
      ),
    );
  }

  void _onTap(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }
}
