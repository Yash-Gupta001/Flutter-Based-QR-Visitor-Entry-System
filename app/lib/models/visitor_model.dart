class VisitorModel {
  final String id;
  final String name;
  final String phone;
  final String purpose;
  final String date;
  final String time;
  final String status;
  final String? checkIn;
  final String? checkOut;
  final String? qrCode;
  final String? registeredByName;

  VisitorModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.purpose,
    required this.date,
    required this.time,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.qrCode,
    this.registeredByName,
  });

  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    // Handle registeredBy whether it is an object, a string, or null.
    final dynamic registeredBy = json['registeredBy'];

    String? parsedRegisteredByName;

    if (registeredBy is Map) {
      parsedRegisteredByName = registeredBy['name']?.toString();
    } else if (registeredBy is String) {
      // A string ID is not necessarily the person's name.
      parsedRegisteredByName = null;
    }

    return VisitorModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      purpose: json['purpose']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      checkIn: json['checkIn']?.toString(),
      checkOut: json['checkOut']?.toString(),
      qrCode: json['qrCode']?.toString(),
      registeredByName: parsedRegisteredByName ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'phone': phone,
      'purpose': purpose,
      'date': date,
      'time': time,
      'status': status,
      'checkIn': checkIn,
      'checkOut': checkOut,
      'qrCode': qrCode,
      'registeredBy': registeredByName,
    };
  }
}
