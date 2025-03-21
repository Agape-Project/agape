import 'package:agape/admin/home.dart';
import 'package:agape/admin/screens/file_export.dart';
import 'package:agape/admin/screens/setting_screen.dart';
import 'package:agape/admin/screens/statics_screens.dart';
import 'package:agape/common/screens/record_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AdminNavigation extends ConsumerStatefulWidget {
  const AdminNavigation({super.key});

  @override
  _AdminNavigationState createState() => _AdminNavigationState();
}

class _AdminNavigationState extends ConsumerState<AdminNavigation> {
  int _selectedIndex = 0; 
 
 final List<Widget>  _pages = [
      const AdminHome(),
      UserListPage(),
      DashboardStats(),
      ExportPage(),
      const SettingScreen(),

    ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], 
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_download),
            label: 'Export',
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Setting',
          ),
        ],
        currentIndex: _selectedIndex,

        selectedItemColor: Colors.brown, 
        unselectedItemColor: Colors.white, 
        backgroundColor: const Color.fromRGBO(9, 15, 44, 1), 
        selectedFontSize: 14, 
        unselectedFontSize: 12, 
        iconSize: 30, 
        onTap: _onItemTapped, 
      ),
    );
  }
}