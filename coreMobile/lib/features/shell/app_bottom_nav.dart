import 'package:flutter/material.dart';

class AppTab {
  const AppTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const appTabs = <AppTab>[
  AppTab(
    label: 'Home',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  AppTab(
    label: 'Vault',
    icon: Icons.lock_outline_rounded,
    selectedIcon: Icons.lock_rounded,
  ),
  AppTab(
    label: 'Money',
    icon: Icons.account_balance_wallet_outlined,
    selectedIcon: Icons.account_balance_wallet_rounded,
  ),
  AppTab(
    label: 'Profile',
    icon: Icons.person_outline_rounded,
    selectedIcon: Icons.person_rounded,
  ),
];

const shellCanvas = Color(0xFFF5F9FC);
const shellAccent = Color(0xFF2E9BFD);
const shellAccentSoft = Color(0xFFDDF1FF);
const shellMuted = Color(0xFF71808F);
const shellDanger = Color(0xFFC44747);

const _navSurface = Color(0xFFFFFFFF);
const _navIcon = Color(0xFF52606D);

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final selected = selectedIndex.clamp(0, appTabs.length - 1);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Container(
          height: 72,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            color: _navSurface,
            borderRadius: BorderRadius.all(Radius.circular(26)),
            boxShadow: [
              BoxShadow(
                color: Color(0x1417212B),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final slot = constraints.maxWidth / appTabs.length;
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    left: slot * selected,
                    width: slot,
                    top: 0,
                    bottom: 0,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: shellAccentSoft,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < appTabs.length; i++)
                        Expanded(
                          child: _NavItem(
                            tab: appTabs[i],
                            selected: i == selected,
                            onTap: () => onSelected(i),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.selected,
    required this.onTap,
  });

  final AppTab tab;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? shellAccent : _navIcon;
    final labelColor = selected ? shellAccent : shellMuted;

    return Semantics(
      button: true,
      selected: selected,
      label: tab.label,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: ExcludeSemantics(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  selected ? tab.selectedIcon : tab.icon,
                  size: 22,
                  color: color,
                ),
                const SizedBox(height: 2),
                Text(
                  tab.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
