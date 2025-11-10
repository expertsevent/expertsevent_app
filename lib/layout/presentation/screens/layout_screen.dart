
import 'package:flutter/material.dart';

import '../../../more/presentation/screens/more_screen.dart';
import 'bottom_nav_tabs_screen.dart';
class LayoutScreen extends StatefulWidget {
  const LayoutScreen({Key? key}) : super(key: key);

  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: const [
            BottomNavTabsScreen(),
          ],
        ),
      ),
    );
  }
}
