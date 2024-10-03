import 'package:assignment/constants/manager/color/color.dart';
import 'package:assignment/core/logic/bloc/profile_bloc/profile_bloc.dart';
import 'package:assignment/core/logic/bloc/profile_bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55, // Custom height for the Bottom Navigation Bar
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: appColor.primarycolor,
        onTap: onItemTapped,
        selectedFontSize: 0, // Hide text label size to make bar smaller
        unselectedFontSize: 0, // Hide text label size to make bar smaller
        selectedIconTheme: const IconThemeData(size: 30), // Slightly smaller icons
        unselectedIconTheme:
            const IconThemeData(size: 30), // Same size for unselected
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: selectedIndex == 0
                  ? appColor.buttoncolor
                  : appColor.textcolor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: selectedIndex == 1
                  ? appColor.buttoncolor
                  : appColor.textcolor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              color: selectedIndex == 2
                  ? appColor.buttoncolor
                  : appColor.textcolor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_outlined,
              size: 25, // Slightly smaller for chat icon
              color: selectedIndex == 3
                  ? appColor.buttoncolor
                  : appColor.textcolor,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                 if (state is ProfileLoaded) {
                  return Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: appColor.buttoncolor, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(
                          state.profileImage), // Display fetched profile image
                    ),
                  );
                } else {
                  return Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      border: Border.all(color: appColor.buttoncolor, width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundImage: AssetImage(
                          'assets/image/google.png'), // Default profile image
                    ),
                  );
                }
              },
            ),
            label: '',
          ),
        ],
        type: BottomNavigationBarType.fixed, // Keep fixed to prevent shifting
      ),
    );
  }
}
