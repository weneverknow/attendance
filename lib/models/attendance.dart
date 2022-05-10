class Attendance {
  final String fullname;
  final DateTime date;
  final int status; //0=in, 1=out

  const Attendance(
      {required this.fullname, required this.date, this.status = 0});

  factory Attendance.fromJson(Map<String, dynamic> json) {
    return Attendance(
        fullname: json['fullname'],
        date: DateTime.parse(json['date']),
        status: json['status']);
  }

  Map<String, dynamic> toJson() =>
      {"fullname": fullname, "date": date.toString(), "status": status};
}
