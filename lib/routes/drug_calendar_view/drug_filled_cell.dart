// Copied and edited from the calendar_view package

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';

import '../../models/drug_entry.dart';
import '../../util/colors.dart';

class DrugsFilledCell<T extends Object?> extends StatelessWidget {
  /// Date of current cell.
  final DateTime date;

  /// List of events on for current date.
  final List<CalendarEventData<DrugEntry>> events;

  /// defines date string for current cell.
  final StringProvider? dateStringBuilder;

  /// Defines if cell should be highlighted or not.
  /// If true it will display date title in a circle.
  final bool shouldHighlight;

  /// Defines background color of cell.
  final Color backgroundColor;

  /// Defines highlight color.
  final Color highlightColor;

  /// Color for event tile.
  final Color tileColor;

  /// Called when user taps on any event tile.
  final TileTapCallback<DrugEntry>? onTileTap;

  /// defines that [date] is in current month or not.
  final bool isInMonth;

  /// defines radius of highlighted date.
  final double highlightRadius;

  /// color of cell title
  final Color titleColor;

  /// color of highlighted cell title
  final Color highlightedTitleColor;

  /// This class will defines how cell will be displayed.
  /// This widget will display all the events as tile below date title.
  const DrugsFilledCell({
    super.key,
    required this.date,
    required this.events,
    this.isInMonth = false,
    this.shouldHighlight = false,
    this.backgroundColor = Colors.blue,
    this.highlightColor = Colors.blue,
    this.onTileTap,
    this.tileColor = Colors.blue,
    this.highlightRadius = 11,
    this.titleColor = Colors.black,
    this.highlightedTitleColor = Colors.white,
    this.dateStringBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          const SizedBox(
            height: 5.0,
          ),
          CircleAvatar(
            radius: highlightRadius,
            backgroundColor:
                shouldHighlight ? highlightColor : Colors.transparent,
            child: Text(
              dateStringBuilder?.call(date) ?? "${date.day}",
              style: TextStyle(
                color: shouldHighlight
                    ? highlightedTitleColor
                    : isInMonth
                        ? titleColor
                        : titleColor.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ),
          if (events.isNotEmpty)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 5.0),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      events.length,
                      (index) => CellEventItem(
                          onTileTap: onTileTap, event: events[index]),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CellEventItem extends StatelessWidget {
  const CellEventItem({
    super.key,
    required this.onTileTap,
    required this.event,
  });

  final TileTapCallback<DrugEntry>? onTileTap;
  final CalendarEventData<DrugEntry> event;

  @override
  Widget build(BuildContext context) {
    final drug = event.event!;
    final drugColor = getDrugColor(drug.color, Theme.of(context).colorScheme);
    return GestureDetector(
      onTap: () => onTileTap?.call(event, event.date),
      child: Container(
        decoration: BoxDecoration(
          color: drugColor,
          borderRadius: BorderRadius.circular(4.0),
        ),
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
        padding: const EdgeInsets.all(2.0),
        alignment: Alignment.center,
        child: Row(
          children: [
            Expanded(
              child: Text(
                event.title,
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: event.titleStyle ??
                    TextStyle(
                      color: getTextColor(drugColor),
                      fontSize: 12,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
