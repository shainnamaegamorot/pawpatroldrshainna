class Appointment {
  const Appointment({
    required this.day,
    required this.time,
    required this.petName,
    required this.reason,
    required this.doctor,
    required this.status,
  });

  final int day;
  final String time;
  final String petName;
  final String reason;
  final String doctor;
  final String status;

  Map<String, Object> toJson() => {
        'day': day,
        'time': time,
        'petName': petName,
        'reason': reason,
        'doctor': doctor,
        'status': status,
      };

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      day: json['day'] as int? ?? 15,
      time: json['time'] as String? ?? 'Time not set',
      petName: json['petName'] as String? ?? 'Unnamed pet',
      reason: json['reason'] as String? ?? 'Checkup',
      doctor: _doctorName(json['doctor'] as String?),
      status: json['status'] as String? ?? 'Pending',
    );
  }

  static String _doctorName(String? value) {
    if (value == null || value == 'Shainna') return 'Dr. Shainna';
    return value.startsWith('Dr. ') ? value : 'Dr. $value';
  }
}

const sampleAppointments = <Appointment>[
  Appointment(day: 15, time: '09:00 AM', petName: 'Milo', reason: 'Yearly checkup', doctor: 'Dr. Shainna', status: 'Confirmed'),
  Appointment(day: 15, time: '10:30 AM', petName: 'Luna', reason: 'Vaccination follow-up', doctor: 'Dr. Robert Fox', status: 'Checked in'),
  Appointment(day: 15, time: '01:15 PM', petName: 'Charlie', reason: 'Follow-up check', doctor: 'Dr. Shainna', status: 'Confirmed'),
  Appointment(day: 15, time: '03:00 PM', petName: 'Bella', reason: 'Teeth checkup', doctor: 'Dr. Robert Fox', status: 'Pending'),
];
