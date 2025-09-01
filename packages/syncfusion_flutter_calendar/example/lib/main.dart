import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

void main() {
  return runApp(CalendarApp());
}

/// The app which hosts the home page which contains the calendar on it.
class CalendarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar Demo',
      theme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

/// The hove page which hosts the calendar
class MyHomePage extends StatefulWidget {
  /// Creates the home page to display teh calendar widget.
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _calendarController.view = CalendarView.week;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildViewButton(CalendarView.day, 'День'),
                  const SizedBox(width: 8),
                  _buildViewButton(CalendarView.week, 'Неделя'),
                  const SizedBox(width: 8),
                  _buildViewButton(CalendarView.month, 'Месяц'),
                  const SizedBox(width: 8),
                  _buildViewButton(CalendarView.schedule, 'Расписание'),
                ],
              ),
            ),
            Container(
              height: 700,
              child: SfCalendar(
                enablePreload: true,
                    controller: _calendarController,
                    dataSource: MeetingDataSource(_getDataSource()),
                    // by default the month appointment display mode set as Indicator, we can
                    // change the display mode as appointment using the appointment display
                    // mode property
                    monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
                  ),
            ),
          ],
        ));
  }

  Widget _buildViewButton(CalendarView view, String label) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _calendarController.view = view;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _calendarController.view == view ? Theme.of(context).primaryColor : null,
        foregroundColor: _calendarController.view == view ? Colors.white : null,
      ),
      child: Text(label),
    );
  }

  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));


  for (int i = 0; i < 10; i++)
   meetings.add(Meeting(  
    '${startTime.day}.${startTime.month}', startTime.copyWith(hour: 13, minute: i), endTime.copyWith(hour: 15,), const Color(0xFF0F8644), true));


        for (int i = 0; i <  120; i++) {
          final date = DateTime(2025, 07, 05);
          final startTime = date.add(Duration( days: i));
          final endTime = startTime.add(Duration(hours: 2));
          meetings.add(Meeting(' ${startTime.day}.${startTime.month}', startTime, endTime, const Color(0xFF0F8644), true));

           meetings.add(Meeting(
    '${startTime.day}.${startTime.month}', startTime.copyWith(hour: 13), endTime.copyWith(hour: 15), const Color(0xFF0F8644), false));

        }
    return meetings;
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
