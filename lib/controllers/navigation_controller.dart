import 'package:flutter/material.dart';

enum NavSection {
  dashboard,
  inventory,
  orders,
  analytics,
  settings,
}

class NavigationController extends ChangeNotifier {
  NavSection _activeSection = NavSection.dashboard;
  bool _isSidebarCollapsed = false;

  NavSection get activeSection => _activeSection;
  bool get isSidebarCollapsed => _isSidebarCollapsed;

  void setSection(NavSection section) {
    _activeSection = section;
    notifyListeners();
  }

  void toggleSidebar() {
    _isSidebarCollapsed = !_isSidebarCollapsed;
    notifyListeners();
  }
}
