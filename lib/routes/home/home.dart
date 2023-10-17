import 'package:flutter/material.dart';
import 'package:mediary/routes/add_drug_form/add_drug_form.dart';
import 'package:mediary/routes/drug_list/drug_list.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../drug_calendar_view/drug_calendar_view.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage(this.title, {super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: <Widget>[
        const DrugList(),
        const DrugCalendarView(),
        Container()
      ][currentPageIndex],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddDrugForm()),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
