import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';

class CalendarPlusController extends PageController {
  static const defaultOffset = 10000;
  late ValueNotifier<DateTime> currentDate;

  CalendarPlusController._(
      {int initialPage = defaultOffset, required DateTime initialDate})
      : currentDate = ValueNotifier(initialDate),
        super(initialPage: initialPage);

  factory CalendarPlusController({DateTime? initialDate}) {
    final initialPage = initialDate != null
        ? _dateToPage(initialDate) + defaultOffset
        : defaultOffset;

    return CalendarPlusController._(
      initialPage: initialPage,
      initialDate: initialDate ?? DateTime.now(),
    );
  }

  static int _dateToPage(DateTime date) {
    return Jiffy(date).diff(Jiffy(), Units.MONTH).toInt();
  }

  DateTime _pageToDate(int page) {
    return Jiffy().add(months: page - defaultOffset).dateTime;
  }

  Future<void> animateToDate(DateTime date,
      {required Duration duration, required Curve curve}) {
    return super.animateToPage(
      _dateToPage(date),
      duration: duration,
      curve: curve,
    );
  }

  void jumpToDate(DateTime date) {
    jumpToPage(
      _dateToPage(date),
    );
  }

  @override
  Future<void> animateToPage(
    int page, {
    required Duration duration,
    required Curve curve,
  }) {
    currentDate.value = _pageToDate(page);
    return super.animateToPage(page, duration: duration, curve: curve);
  }

  @override
  void jumpToPage(int page) {
    currentDate.value = _pageToDate(page);
    super.jumpToPage(page);
  }

  @override
  void dispose() {
    currentDate.dispose();
    super.dispose();
  }
}
