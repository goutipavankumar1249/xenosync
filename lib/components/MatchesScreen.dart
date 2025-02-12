// import 'package:flutter/material.dart';
// import 'liked_screen.dart';
// import 'disliked_screen.dart';
// import 'you_liked_screen.dart';
//
// class MatchesScreen extends StatefulWidget {
//   @override
//   _MatchesScreenState createState() => _MatchesScreenState();
// }
//
// class _MatchesScreenState extends State<MatchesScreen> {
//   int _selectedPageIndex = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(height: 10),
//         _buildButtonRow(context),
//         SizedBox(height: 10),
//         Expanded(
//           child: _buildPageContent(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildButtonRow(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildButton(context, "Liked", Colors.blue[100], 0),
//         _buildButton(context, "Disliked", Colors.red[100], 1),
//         _buildButton(context, "You Liked", Colors.orange[100], 2),
//       ],
//     );
//   }
//
//   Widget _buildButton(BuildContext context, String text, Color? backgroundColor, int index) {
//     return Container(
//       height: 40,
//       width: MediaQuery.of(context).size.width / 3,
//       margin: EdgeInsets.symmetric(horizontal: 0),
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           side: BorderSide(color: Colors.black, width: 1),
//         ),
//         onPressed: () {
//           setState(() {
//             _selectedPageIndex = index;
//           });
//         },
//         child: Text(
//           text,
//           style: TextStyle(
//             fontFamily: 'Montserrat',
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//             color: Colors.black,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildPageContent() {
//     switch (_selectedPageIndex) {
//       case 0:
//         return LikedScreen();
//       case 1:
//         return DislikedScreen();
//       case 2:
//         return YouLikedScreen();
//       default:
//         return Container();
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'liked_screen.dart';
import 'disliked_screen.dart';
import 'you_liked_screen.dart';

class MatchesScreen extends StatefulWidget {
  @override
  _MatchesScreenState createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  int _selectedPageIndex = 0;
  final List<TabInfo> _tabs = [
    TabInfo(title: "Liked", color: Colors.blue[100]!, screen: LikedScreen()),
    TabInfo(title: "Disliked", color: Colors.red[100]!, screen: DislikedScreen()),
    TabInfo(title: "You Liked", color: Colors.orange[100]!, screen: YouLikedScreen()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildTabBar(context),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // Add padding to the content
                child: _tabs[_selectedPageIndex].screen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth / _tabs.length;

    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;

          return SizedBox(
            width: buttonWidth,
            child: _buildTabButton(
              context: context,
              text: tab.title,
              backgroundColor: tab.color,
              index: index,
              isSelected: _selectedPageIndex == index,
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String text,
    required Color backgroundColor,
    required int index,
    required bool isSelected,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1),
          left: BorderSide(color: Colors.black, width: index == 0 ? 1 : 0),
          right: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedPageIndex = index;
          });
        },
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

// Helper class to organize tab information
class TabInfo {
  final String title;
  final Color color;
  final Widget screen;

  TabInfo({
    required this.title,
    required this.color,
    required this.screen,
  });
}
