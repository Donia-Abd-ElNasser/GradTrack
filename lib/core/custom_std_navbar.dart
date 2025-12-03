import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:gradtrack/core/constants.dart';
import 'package:gradtrack/core/routes.dart';

class CustomStdBottomNav extends StatelessWidget {
  const CustomStdBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: kGradient,
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          child: Builder(
            builder: (context) {
              final String location = GoRouterState.of(context).uri.toString();
              int selectedIndex = 0;
              if (location.startsWith(AppRoutes.kStdChatView)) {
                selectedIndex = 1;
              }
              if (location.startsWith(AppRoutes.kStdProfileView)) {
                selectedIndex = 2;
              }

             

              return BottomNavigationBar(
                currentIndex: selectedIndex,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      (context).go(AppRoutes.kstdHomeView);
                      break;
                    case 1:
                      (context).go(AppRoutes.kStdChatView);
                      break;
                   
                    case 2:
                      (context).go(AppRoutes.kStdProfileView);
                      break;
                  }
                },
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                items: [
                  NavigationItem(FontAwesomeIcons.house, selectedIndex == 0),
                 

                  NavigationItem(Icons.message, selectedIndex == 1),
                  NavigationItem(Icons.person, selectedIndex == 2),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

BottomNavigationBarItem NavigationItem(IconData icon, bool isSelected) {
  return BottomNavigationBarItem(
    icon: Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? const Color.fromARGB(255, 215, 214, 214) : Colors.transparent,
      ),
      child: Icon(
        icon,
        size: 20,
        color: isSelected ? Colors.blueAccent : Colors.black,
      ),
    ),
    label: "",
  );
}
