import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import './feature_screen.dart';
import 'redeem_screen.dart';
import './orders_screen.dart';
import './products_home_screen.dart';
import 'profile_screen.dart';

enum pages {
  feature,
  home,
  redeem,
  orders,
  personal,
}

class TabsScreen extends StatefulWidget {
  State<TabsScreen> createState() => _TabsScreenState();
  BottomNavigationBar get bottomNavigationBar =>
      _TabsScreenState().bottomNavigationBar;
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) async {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label) {
    return BottomNavigationBarItem(
      backgroundColor: Theme.of(context).colorScheme.background,
      icon: Icon(icon),
      label: label,
    );
  }

  BottomNavigationBar get bottomNavigationBar => BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).colorScheme.background,
        showUnselectedLabels: false,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          _buildBottomNavigationBarItem(Icons.auto_awesome, 'Features'),
          _buildBottomNavigationBarItem(Icons.store, 'Home'),
          _buildBottomNavigationBarItem(Icons.card_giftcard, 'Reward'),
          _buildBottomNavigationBarItem(Icons.receipt_long, 'Orders'),
          _buildBottomNavigationBarItem(Icons.person, 'Personal'),
        ],
      );

  @override
  Widget build(BuildContext context) {
    // Provider.of<User>(context, listen: false);
    return DefaultTabController(
      length: 5,
      child: switch (pages.values[_selectedPageIndex]) {
        pages.feature => Scaffold(
            body: FeatureScreen(),
            bottomNavigationBar: bottomNavigationBar,
          ),
        pages.home => Scaffold(
            body: ProductsHomeScreen(),
            bottomNavigationBar: bottomNavigationBar,
          ),
        pages.redeem => Scaffold(
            body: RedeemScreen(),
            bottomNavigationBar: bottomNavigationBar,
          ),
        pages.orders => Scaffold(
            body: OrdersScreen(),
            bottomNavigationBar: bottomNavigationBar,
          ),
        pages.personal => Scaffold(
            body: ProfileScreen(),
            bottomNavigationBar: bottomNavigationBar,
          ),
      },
    );
  }
}
