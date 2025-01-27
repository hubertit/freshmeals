class CalendarDay {
  final String day;
  final String date;

  CalendarDay({required this.day, required this.date});

  factory CalendarDay.fromJson(Map<String, dynamic> json) {
    return CalendarDay(
      day: json['day'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'date': date,
    };
  }
}

var calenderDatas = [
  {"day": "Today", "date": "27"},
  {"day": "Tue", "date": "28"},
  {"day": "Wed", "date": "29"},
  {"day": "Thu", "date": "30"},
  {"day": "Fri", "date": "31"},
  {"day": "Sat", "date": "1"},
  {"day": "Sun", "date": "2"}
];
