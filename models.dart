import 'package:cloud_firestore/cloud_firestore.dart';

class StudentUser {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String studentId;
  final String? roomNumber;
  final DateTime createdAt;

  StudentUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.studentId,
    this.roomNumber,
    required this.createdAt,
  });

  factory StudentUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return StudentUser(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      studentId: data['studentId'] ?? '',
      roomNumber: data['roomNumber'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'studentId': studentId,
      'roomNumber': roomNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class Room {
  final String id;
  final String roomNumber;
  final String floor;
  final int capacity;
  final int occupiedBeds;
  final String type; // single, double, shared
  final double pricePerMonth;
  final List<String> facilities;
  final bool isAvailable;
  final List<String>? occupantIds;

  Room({
    required this.id,
    required this.roomNumber,
    required this.floor,
    required this.capacity,
    required this.occupiedBeds,
    required this.type,
    required this.pricePerMonth,
    required this.facilities,
    required this.isAvailable,
    this.occupantIds,
  });

  factory Room.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Room(
      id: doc.id,
      roomNumber: data['roomNumber'] ?? '',
      floor: data['floor'] ?? '',
      capacity: data['capacity'] ?? 0,
      occupiedBeds: data['occupiedBeds'] ?? 0,
      type: data['type'] ?? '',
      pricePerMonth: (data['pricePerMonth'] ?? 0).toDouble(),
      facilities: List<String>.from(data['facilities'] ?? []),
      isAvailable: data['isAvailable'] ?? false,
      occupantIds: data['occupantIds'] != null 
          ? List<String>.from(data['occupantIds']) 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomNumber': roomNumber,
      'floor': floor,
      'capacity': capacity,
      'occupiedBeds': occupiedBeds,
      'type': type,
      'pricePerMonth': pricePerMonth,
      'facilities': facilities,
      'isAvailable': isAvailable,
      'occupantIds': occupantIds ?? [],
    };
  }
}

class Booking {
  final String id;
  final String studentId;
  final String studentName;
  final String roomId;
  final String roomNumber;
  final DateTime bookingDate;
  final DateTime startDate;
  final DateTime? endDate;
  final String status; // pending, approved, rejected, active
  final double amount;

  Booking({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.roomId,
    required this.roomNumber,
    required this.bookingDate,
    required this.startDate,
    this.endDate,
    required this.status,
    required this.amount,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      roomId: data['roomId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      bookingDate: (data['bookingDate'] as Timestamp).toDate(),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: data['endDate'] != null 
          ? (data['endDate'] as Timestamp).toDate() 
          : null,
      status: data['status'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'roomId': roomId,
      'roomNumber': roomNumber,
      'bookingDate': Timestamp.fromDate(bookingDate),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': endDate != null ? Timestamp.fromDate(endDate!) : null,
      'status': status,
      'amount': amount,
    };
  }
}

class Complaint {
  final String id;
  final String studentId;
  final String studentName;
  final String title;
  final String description;
  final String category; // maintenance, food, cleanliness, security, other
  final String status; // pending, in_progress, resolved, closed
  final DateTime createdAt;
  final String? response;
  final DateTime? responseDate;

  Complaint({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
    this.response,
    this.responseDate,
  });

  factory Complaint.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Complaint(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      studentName: data['studentName'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      response: data['response'],
      responseDate: data['responseDate'] != null 
          ? (data['responseDate'] as Timestamp).toDate() 
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'response': response,
      'responseDate': responseDate != null 
          ? Timestamp.fromDate(responseDate!) 
          : null,
    };
  }
}

class Notice {
  final String id;
  final String title;
  final String description;
  final String category; // general, urgent, event, maintenance
  final DateTime postedDate;
  final String postedBy;
  final bool isPinned;
  final String? imageUrl;

  Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.postedDate,
    required this.postedBy,
    required this.isPinned,
    this.imageUrl,
  });

  factory Notice.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Notice(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      postedDate: (data['postedDate'] as Timestamp).toDate(),
      postedBy: data['postedBy'] ?? '',
      isPinned: data['isPinned'] ?? false,
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'postedDate': Timestamp.fromDate(postedDate),
      'postedBy': postedBy,
      'isPinned': isPinned,
      'imageUrl': imageUrl,
    };
  }
}
