import 'package:flutter/material.dart';
import 'package:api/api.dart';
import 'package:api/pages/favorite.dart';
import 'package:api/pages/history.dart';



var kBottomBarBackgroundColor = Colors.black;
var kBottomBarForegroundColor = Colors.white;
var kBottomBarForegroundInactiveColor = Colors.white60;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = -1; // Set initial index to -1
  
  

  @override
  void initState() {
    _selectedIndex = 0; // Set initial index to -1 when initializing state
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildPageBody() {
    switch (_selectedIndex) {
      case 0:
        return History();
      case 1:
        return FavoritePage();
      case 2:
        return const ApiPage();
      default:
        return History();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: PreferredSize(
          preferredSize: Size(screenSize.width, 50),
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 24),
              color: Colors.black,
              child: SafeArea(
                  child: Row(children: [
                IconButton(
                  onPressed: () => _onItemTapped(0),
                  icon: Icon(Icons.home_filled),
                  color: Colors.red,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(width: 12),
                      InkWell(
                        onTap: () => _onItemTapped(1),
                        child: Text(
                          'รายการโปรด',
                          style: TextStyle(
                            color: Colors.white,
                            decoration:
                                TextDecoration.underline, // เพิ่มขีดเส้นใต้
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      InkWell(
                        onTap: () => _onItemTapped(2),
                        child: Text(
                          'Cartoons',
                          style: TextStyle(
                            color: Colors.white,
                            decoration:
                                TextDecoration.underline, // เพิ่มขีดเส้นใต้
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ])))),

      //floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 64,
        padding: EdgeInsets.zero,
        color: kBottomBarBackgroundColor,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: AppBottomMenuItem(
                icon: Icons.favorite,
                text: 'รายการโปรด',
                isSelected: _selectedIndex == 1,
                onClick: () => _onItemTapped(1),
              ),
            ),
            Expanded(
              child: AppBottomMenuItem(
                icon: Icons.home_filled,
                text: 'หน้าเเรก',
                isSelected: _selectedIndex == 0,
                onClick: () => _onItemTapped(0),
              ),
            ),
            Expanded(
              child: AppBottomMenuItem(
                icon: Icons.live_tv_sharp,
                text: 'รายการทั้งหมด',
                isSelected: _selectedIndex == 2,
                onClick: () => _onItemTapped(2),
              ),
            ),
          ],
        ),
      ),

      body: Container(child: Center(child: _buildPageBody())),
    );
  }
}

class AppBottomMenuItem extends StatelessWidget {
  const AppBottomMenuItem({
    super.key,
    required this.icon,
    required this.text,
    required this.isSelected,
    required this.onClick,
  });
  final IconData icon;
  final String text;
  final bool isSelected;
  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    var color = isSelected
        ? kBottomBarForegroundColor
        : kBottomBarForegroundInactiveColor;

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onClick,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
