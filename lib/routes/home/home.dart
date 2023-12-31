import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../add_drug_form/add_drug_form.dart';
import '../drug_calendar_view/drug_calendar_view.dart';
import '../drug_list/drug_list.dart';
import '../settings/settings.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage(this.title, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  final monthKey = GlobalKey<MonthViewState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
          const DrugList(),
          DrugCalendarView(monthKey: monthKey),
          const SettingsView(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.homeViewTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calendar_today_outlined),
            selectedIcon: const Icon(Icons.calendar_today),
            label: AppLocalizations.of(context)!.calendarViewTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settingsViewTitle,
          ),
        ],
        selectedIndex: currentPageIndex,
      ),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: const Interval(0.5, 1, curve: Curves.easeOut),
        switchOutCurve: const Interval(0.5, 1, curve: Curves.easeOut),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: child,
        ),
        child: _buildFAB(currentPageIndex),
      ),
    );
  }

  FloatingActionButton? _buildFAB(int pageIndex) {
    return switch (pageIndex) {
      0 => _buildNewDrugFormFAB(),
      1 => _buildCalendarFAB(),
      _ => null,
    };
  }

  FloatingActionButton _buildNewDrugFormFAB() {
    return FloatingActionButton(
      key: const ValueKey(1),
      tooltip: AppLocalizations.of(context)!.addDrugButtonTooltip,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddDrugForm()),
        );
      },
      child: const Icon(Icons.add_outlined),
    );
  }

  FloatingActionButton _buildCalendarFAB() {
    return FloatingActionButton(
      key: const ValueKey(2),
      tooltip: AppLocalizations.of(context)!.calendarTodayButtonTooltip,
      onPressed: () {
        monthKey.currentState?.animateToMonth(DateTime.now());
      },
      child: const Icon(Icons.today_outlined),
    );
  }
}
