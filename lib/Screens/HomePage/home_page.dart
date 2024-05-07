import 'package:flutter/material.dart';
import '../../Styles/colors.dart';
import '../Camera/camera_screen.dart';
import '../Cart/cart_screen.dart';
import '../Favorites/favorite_screen.dart';
import '../HomeScreen/home_screen.dart';
import '../Search_Screen/search_screen.dart';
import '../Settings/settings_screen.dart';


class HomeDesign extends StatefulWidget {
  const HomeDesign({super.key});

  @override
  _HomeDesignState createState() => _HomeDesignState();
}

class _HomeDesignState extends State<HomeDesign> {
  int _currentIndex = 0; // Initial index
  final List<Widget> _screens = [
    HomeScreen(), // Replace with your actual screens
    CameraScreen(),
    FavoritesScreen(),
    SettingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: const Text(
          'Beauty Mate',
          style: TextStyle(
            fontFamily: 'Ephesis',
            color: defaultColor,
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Products(),
                ),
              );
            },
            icon: const Icon(
              Icons.search,
              color: defaultColor,
              size: 25.0,
            ),
          ),
          // IconButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => FavoritesScreen(),
          //       ),
          //     );
          //   },
          //   icon: const Icon(
          //     Icons.favorite_border,
          //     color: defaultColor,
          //     size: 25.0,
          //   ),
          // ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: defaultColor,
              size: 25.0,
            ),
          ),
        ],
      ),
      body: _screens[_currentIndex], // Display the selected screen
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Update the index when a tab is tapped
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 25.0,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt,
              size: 25.0,
            ),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border_outlined,
              size: 25.0,
            ),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.people_outline,
              size: 25.0,
            ),
            label: 'Setting',
          ),
        ],
        backgroundColor: Colors.white,
        selectedItemColor: defaultColor,
        unselectedItemColor: defaultColor,
        selectedFontSize: 15.0,
      ),
    );
  }
}
