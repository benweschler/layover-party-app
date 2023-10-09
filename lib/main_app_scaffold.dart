import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:layover_party/router.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

final List<NavigationTab> _bottomNavigationTabs = [
  NavigationTab(
    rootLocation: RoutePaths.trips,
    icon: Icons.flight_takeoff_rounded,
    label: 'Trips',
  ),
  NavigationTab(
    rootLocation: RoutePaths.parties,
    icon: Icons.celebration_rounded,
    label: 'Parties',
  ),
  NavigationTab(
    rootLocation: RoutePaths.profile,
    icon: Icons.person_rounded,
    label: 'Profile',
  ),
];

class MainAppScaffold extends StatefulWidget {
  final Widget body;

  const MainAppScaffold({Key? key, required this.body}) : super(key: key);

  @override
  State<MainAppScaffold> createState() => _MainAppScaffoldState();
}

class _MainAppScaffoldState extends State<MainAppScaffold> {
  @override
  Widget build(BuildContext context) {
    // Use a Stack to allow the body to extend behind the navigation bar,
    // ensuring that each page's Scaffold is the full height of the screen.
    // Scaffolds that aren't the full height of the display cause errors,
    // such as adding padding to avoid on-screen keyboards incorrectly.
    // However, this workaround can cause issues since the app's body isn't
    // aware of the bottom navigation bar.
    return Stack(
      children: [
        widget.body,
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: SafeArea(
            bottom: false,
            child: Theme(
              data: Theme.of(context).copyWith(
                splashFactory: NoSplash.splashFactory,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.xl),
                child: SalomonBottomBar(
                  currentIndex: _bottomNavigationTabs.indexWhere(
                    (tab) => GoRouterState.of(context)
                        .matchedLocation
                        .startsWith(tab.rootLocation),
                  ),
                  selectedItemColor: AppColors.of(context).primary,
                  onTap: (tabIndex) => _onItemTapped(
                    context,
                    _bottomNavigationTabs[tabIndex].rootLocation,
                  ),
                  items: [
                    for (var tab in _bottomNavigationTabs)
                      SalomonBottomBarItem(
                        icon: Icon(tab.icon),
                        title: Text(
                          tab.label,
                          style: TextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onItemTapped(BuildContext context, String rootLocation) {
    if (rootLocation == GoRouterState.of(context).matchedLocation) return;
    HapticFeedback.lightImpact();
    context.go(rootLocation);
  }
}

class NavigationTab {
  final String rootLocation;
  final IconData icon;
  final String label;

  const NavigationTab({
    required this.rootLocation,
    required this.icon,
    required this.label,
  });
}
