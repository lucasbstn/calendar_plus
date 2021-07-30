import 'package:calendar_plus/src/controller.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

typedef CellBuilder = Widget Function(BuildContext, DateTime);

class CalendarPlus extends StatefulWidget {
  ///TableBorder used to display a grid in the calendar.
  final TableBorder? border;

  ///Controller used to for navigation in de calendar.
  ///[CalendarPlusController] extends [PageController] but adds some methods to navigate based on the date.
  final CalendarPlusController controller;

  ///Callback used to build each cell corresponding to a day of the month.
  ///
  ///Here's an example of a calendar that builds days in circled inkwells.
  ///```dart
  /// CalendarPlus(
  ///   controller:controller,
  ///   cellBuilder:(context, date) {
  ///       return Material(
  ///            shape: CircleBorder(),
  ///            color: Jiffy(date).isSame(Jiffy(), Units.DAY)
  ///                 ? Colors.blue
  ///                 : Colors.transparent,
  ///             child: InkWell(
  ///               hoverColor: Colors.grey.shade200,
  ///               customBorder: CircleBorder(),
  ///               onTap: () {},
  ///               child: Center(
  ///                  child: Text('${Jiffy(date).date}'
  ///          ),
  ///        ),
  ///      ),
  ///    );
  ///
  /// ```
  final CellBuilder cellBuilder;

  ///How many rows (weeks) should be displayed in the calendar.
  final int displayRowCount;

  const CalendarPlus(
      {Key? key,
      this.border,
      this.displayRowCount = 5,
      required this.controller,
      required this.cellBuilder})
      : super(key: key);

  @override
  _CalendarPlusState createState() => _CalendarPlusState();
}

class _CalendarPlusState extends State<CalendarPlus> {
  List<DateTime> getDays(DateTime date) {
    final start = Jiffy(date).startOf(Units.MONTH).startOf(Units.WEEK);
    return List.generate(
      widget.displayRowCount * 7,
      (index) => start.clone().add(days: index).dateTime,
    );
  }

  List<TableRow> getRows(DateTime date) {
    final days = getDays(date);

    final rows = <TableRow>[
      TableRow(
        children: [],
      ),
    ];

    for (final day in days) {
      if (rows.last.children!.length == 7) {
        rows.add(
          TableRow(
            children: [],
          ),
        );
      }

      rows.last.children!.add(
        _CalendarCell(date: day, builder: widget.cellBuilder),
      );
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth / 7 * widget.displayRowCount,
          child: PageView.builder(
            controller: widget.controller,
            itemBuilder: (context, index) {
              final month = Jiffy()
                  .add(months: index - CalendarPlusController.defaultOffset)
                  .dateTime;
              return Table(
                border: widget.border,
                children: getRows(month),
              );
            },
          ),
        );
      },
    );
  }
}

class _CalendarCell extends StatelessWidget {
  final DateTime date;
  final CellBuilder builder;
  const _CalendarCell({Key? key, required this.date, required this.builder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.minWidth,
          child: builder(context, date),
        );
      },
    );
  }
}
