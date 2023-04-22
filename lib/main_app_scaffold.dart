import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:layover_party/router.dart';
import 'package:layover_party/styles/styles.dart';
import 'package:layover_party/styles/theme.dart';

const double _kNavBarIconSize = 24;

class MainAppScaffold extends StatefulWidget {
  final Widget body;

  MainAppScaffold({Key? key, required this.body}) : super(key: key);

  final List<NavigationTab> _bottomNavigationTabs = [
    NavigationTab(
      rootLocation: RoutePaths.search,
      icon: Icons.search_rounded,
      label: 'Search',
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
          child: CustomNavigationBar(
            tabs: widget._bottomNavigationTabs,
            selectedRoutePath: GoRouter.of(context).location,
          ),
        ),
      ],
    );
  }
}

class CustomNavigationBar extends StatelessWidget {
  final List<NavigationTab> tabs;
  final String selectedRoutePath;

  const CustomNavigationBar({
    Key? key,
    required this.tabs,
    required this.selectedRoutePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The nav bar does not have a scaffold as an ancestor and so is
    // missing a DefaultTextStyle. The Material provides the same
    // DefaultTextStyle as a scaffold, and also backs the navbar with the
    // scaffold background color.
    return Material(
      child: Column(
        children: [
          Container(height: 1, color: AppColors.of(context).dividerColor),
          const SizedBox(height: Insets.xs),
          SafeArea(
            top: false,
            minimum: const EdgeInsets.symmetric(vertical: Insets.xs),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var tab in tabs)
                  Expanded(
                    child: NavigationBarButton(
                      icon: tab.icon,
                      label: tab.label,
                      isActive: selectedRoutePath.startsWith(tab.rootLocation),
                      onTap: () => _onItemTapped(context, tab.rootLocation),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(BuildContext context, String rootLocation) {
    if (rootLocation == GoRouter.of(context).location) return;
    HapticFeedback.lightImpact();
    context.go(rootLocation);
  }
}

class NavigationBarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final GestureTapCallback onTap;

  const NavigationBarButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: _kNavBarIconSize),
          const SizedBox(height: Insets.xs),
          Text(
            label,
            style: TextStyles.caption.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
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
