import 'package:calendar_plus/calendar_plus.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Center(
        child: SizedBox(
          width: 500,
          child: DndCalendarExample(),
        ),
      ),
    );
  }
}

class Event {
  final DateTime date;
  final String title;

  Event(this.date, this.title);

  Event copyWith({DateTime? date, String? title}) => Event(
        date ?? this.date,
        title ?? this.title,
      );
}

class MiniCalendarExample extends StatefulWidget {
  const MiniCalendarExample({Key? key}) : super(key: key);

  @override
  _MiniCalendarExampleState createState() => _MiniCalendarExampleState();
}

class _MiniCalendarExampleState extends State<MiniCalendarExample> {
  final events = [
    Event(DateTime.now(), 'test1'),
    Event(DateTime.now(), 'test2'),
    Event(DateTime.now(), 'test3'),
    Event(DateTime.now(), 'test4'),
  ];

  final controller = CalendarPlusController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: ["M", "T", "W", "T", 'F', 'S', 'S']
                      .map(
                        (e) => Expanded(
                          child: Center(child: Text(e)),
                        ),
                      )
                      .toList(),
                ),
                CalendarPlus(
                  displayRowCount: 10,
                  controller: controller,
                  cellBuilder: (context, date) {
                    return Material(
                      shape: CircleBorder(),
                      color: Jiffy(date).isSame(Jiffy(), Units.DAY)
                          ? Colors.blue
                          : Colors.transparent,
                      child: InkWell(
                        hoverColor: Colors.grey.shade200,
                        customBorder: CircleBorder(),
                        onTap: () {},
                        child: Center(
                          child: Text('${Jiffy(date).date}'),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DndCalendarExample extends StatefulWidget {
  const DndCalendarExample({Key? key}) : super(key: key);

  @override
  _DndCalendarExampleState createState() => _DndCalendarExampleState();
}

class _DndCalendarExampleState extends State<DndCalendarExample> {
  final events = [
    Event(DateTime.now(), 'test1'),
    Event(DateTime.now(), 'test2'),
    Event(DateTime.now(), 'test3'),
    Event(DateTime.now(), 'test4'),
  ];

  final controller = CalendarPlusController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => controller.previousPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                ),
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () => controller.nextPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeIn,
                ),
              ),
              ValueListenableBuilder<DateTime>(
                valueListenable: controller.currentDate,
                builder: (context, value, __) {
                  return Text(Jiffy(value).yMMMM);
                },
              ),
            ],
          ),
          Expanded(
            child: CalendarPlus(
              controller: controller,
              border: TableBorder.all(
                color: Colors.grey.shade300,
              ),
              cellBuilder: (context, date) => DragTarget<Event>(
                onWillAccept: (_) => true,
                onAcceptWithDetails: (d) {
                  d.data.copyWith(date: date);
                  events.removeWhere((e) => e.title == d.data.title);
                  events.add(
                    d.data.copyWith(date: date),
                  );
                  setState(() {});
                },
                builder: (context, _, __) {
                  final dayEvents = events.where(
                    (e) => Jiffy(e.date).isSame(Jiffy(date), Units.DAY),
                  );
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${Jiffy(date).yMMMMd}'),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: dayEvents
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 16),
                                  child: Draggable<Event>(
                                    data: e,
                                    child: Container(
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius:
                                            BorderRadius.circular(4.0),
                                      ),
                                      child: Text(e.title),
                                    ),
                                    feedback: Material(
                                      child: Text(
                                        e.title,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: SizedBox.shrink(),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
