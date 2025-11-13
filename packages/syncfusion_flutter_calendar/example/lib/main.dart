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
    _calendarController.view = CalendarView.day;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = MeetingDataSource(_getDataSource());

    return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildViewButton(CalendarView.day, 'Day'),
                  const SizedBox(width: 8),
                  _buildViewButton(CalendarView.week, 'Week'),
                  const SizedBox(width: 8),
                  _buildViewButton(CalendarView.month, 'Month'),
                  const SizedBox(width: 8),
                  _buildViewButton(CalendarView.schedule, 'Schedule'),
                ],
              ),
            ),
            Container(
              height: 700,
              child: SfCalendar(
                allowAppointmentResize: true,
                allowDragAndDrop: true,
                enablePreload: true,
                timeSlotViewSettings: TimeSlotViewSettings(
                  timeFormat: 'HH:mm'
                ),
                dragAndDropSettings: DragAndDropSettings(
                  indicatorTimeFormat: 'HH:mm'
                ),
                onViewChanged: (d) {
                  // _calendarController.selectedDate = DateTime.now();
                  // _calendarController.displayDate = DateTime.now();
                },
                onEmptySpaceLongPressEnd: (startTime, endTime) async {
                  print('onEmptySpaceLongPressEnd: start: $startTime, end: $endTime');
                  await Future.delayed(Duration(seconds: 2));
                  
                },
                onTap: (calendarTapDetails) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tap on ${calendarTapDetails?.appointments?.firstOrNull?.subject}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onDragStart: (AppointmentDragStartDetails details) {
                  final app = (details.appointment as Appointment);
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Drag start: ${Colors.red.value==app.color.value}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                selectionDecoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                ),
                onDragUpdate: (AppointmentDragUpdateDetails details) {
                  // Handle drag update
                },
                onDragEnd: (AppointmentDragEndDetails details) {
                  final appointment = details.appointment as Appointment;
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Event moved: ${appointment.subject} ${appointment.startTime} - ${appointment.endTime}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                onAppointmentResizeStart: (AppointmentResizeStartDetails details) {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Resize start: ${details.appointment!.subject}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                onAppointmentResizeUpdate: (AppointmentResizeUpdateDetails details) {
                  print('RESIZE_UPDATE: ${details.appointment!.subject}, new time: ${details.resizingTime}, offset: ${details}');
                  // Handle resize update
                },
                onAppointmentResizeEnd: (AppointmentResizeEndDetails details) {
                  final appointment = details.appointment as Appointment;
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Event resized: ${appointment.subject} ${appointment.startTime} - ${appointment.endTime}'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                controller: _calendarController,
                dataSource: data,
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

  List<Appointment> _getDataSource() {
    final List<Appointment> meetings = <Appointment>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime endTime = startTime.add(const Duration(hours: 2));


  for (int i = 0; i < 10; i++)
    // Add appointments for the first 10 minutes of the day
    for (int i = 0; i < 10; i++) {
      meetings.add(Appointment(
        subject: '${startTime.day}.${startTime.month}',
        startTime:  startTime.copyWith(hour: 13, minute: i),
        endTime: endTime.copyWith(hour: 15),
        color: const Color(0xFF0F8644),
        isAllDay: true,
      ));
    }

    // Add appointments for the next 120 days
    final startDate = DateTime(2025, 7, 5); // Fixed month format from 07 to 7
    for (int i = 0; i < 120; i++) {
      final appointmentStart = startDate.add(Duration(days: i));
      final appointmentEnd = appointmentStart.add(const Duration(hours: 2));
      
      // Add full-day appointment
      meetings.add(Appointment(
        subject: '${appointmentStart.day}.${appointmentStart.month}',
        startTime: appointmentStart,
        endTime: appointmentEnd,
        color: const Color(0xFF0F8644),
        isAllDay: true,
      ));

      // Add specific time appointment
      meetings.add(Appointment(
        subject:  '${appointmentStart.day}.${appointmentStart.month}',
        startTime: appointmentStart.copyWith(hour: 13),
        endTime: appointmentEnd.copyWith(hour: 15),
        color: const Color(0xFF0F8644),
        isAllDay: false,
      ));
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
  MeetingDataSource(List<Appointment> source) {
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
