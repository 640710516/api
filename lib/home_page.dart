import 'package:flutter/material.dart';
import 'package:api/api.dart';
import 'package:api/pages/favorite.dart';
import 'package:api/pages/history.dart';

var kBottomBarBackgroundColor = Colors.red;
var kBottomBarForegroundColor = Colors.white;
var kBottomBarForegroundInactiveColor = Colors.white60;
var kSplashColor = Colors.red[600];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget _buildPageBody(){
      switch (_selectedIndex) {
      case 0:
        return const Favorite();
      case 1:
        return const History();
      case 2:
        return const ApiPage();
      default:
        return const Favorite();    
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartoons List',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
        centerTitle: true,
        backgroundColor: Colors.red,
        
      ),
      floatingActionButton: SizedBox(
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: kBottomBarBackgroundColor,
          shape: CircleBorder(),
          onPressed: () {},
          child: AppBottomMenuItem(
            icon: Icons.check,
            text: 'ประวัติล่าสุด',
            isSelected: _selectedIndex == 1,
            onClick: () => _onItemTapped(1),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 64,
        padding: EdgeInsets.zero,
        color: kBottomBarBackgroundColor,
        shape: const CircularNotchedRectangle(),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: AppBottomMenuItem(
                icon: Icons.favorite,
                text: 'รายการโปรด',
                isSelected: _selectedIndex == 0,
                onClick: () => _onItemTapped(0),
              ),
            ),
            SizedBox(width: 100),
            Expanded(
              child: AppBottomMenuItem(
                icon: Icons.live_tv_sharp,
                text: 'รายชื่อการ์ตูนทั้งหมด',
                isSelected: _selectedIndex == 2,
                onClick: () => _onItemTapped(2),
              )
            ),
          ]
        ),
      ),
      body: Container(child: Center(child: _buildPageBody())),
    );
  
    
  }
}

class AppBottomMenuItem extends StatelessWidget{
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
    var theme = Theme.of(context);
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
              SizedBox(height: 4),
              Text(
                text,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelMedium!.copyWith(
                  color: color,
                  // fontWeight: isSelected ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );   
  }
}