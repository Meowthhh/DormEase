import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Authentication
  Future<User?> signUpWithEmail(String email, String password, String name, 
      String phoneNumber, String studentId) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('students').doc(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'phoneNumber': phoneNumber,
        'studentId': studentId,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential.user;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
  }

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Student Profile
  Future<StudentUser?> getStudentProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('students').doc(userId).get();
      if (doc.exists) {
        return StudentUser.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  // Rooms
  Stream<List<Room>> getAvailableRooms() {
    return _firestore
        .collection('rooms')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Room.fromFirestore(doc))
            .toList());
  }

  Future<Room?> getRoomById(String roomId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('rooms').doc(roomId).get();
      if (doc.exists) {
        return Room.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      print('Error getting room: $e');
      return null;
    }
  }

  // Bookings
  Future<String> createBooking(Booking booking) async {
    try {
      DocumentReference docRef = await _firestore.collection('bookings').add(booking.toMap());
      return docRef.id;
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }

  Stream<List<Booking>> getStudentBookings(String studentId) {
    return _firestore
        .collection('bookings')
        .where('studentId', isEqualTo: studentId)
        .orderBy('bookingDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromFirestore(doc))
            .toList());
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': 'cancelled',
      });
    } catch (e) {
      print('Error cancelling booking: $e');
      rethrow;
    }
  }

  // Complaints
  Future<String> submitComplaint(Complaint complaint) async {
    try {
      DocumentReference docRef = await _firestore.collection('complaints').add(complaint.toMap());
      return docRef.id;
    } catch (e) {
      print('Error submitting complaint: $e');
      rethrow;
    }
  }

  Stream<List<Complaint>> getStudentComplaints(String studentId) {
    return _firestore
        .collection('complaints')
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Complaint.fromFirestore(doc))
            .toList());
  }

  // Notices
  Stream<List<Notice>> getAllNotices() {
    return _firestore
        .collection('notices')
        .orderBy('isPinned', descending: true)
        .orderBy('postedDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Notice.fromFirestore(doc))
            .toList());
  }

  // Admin functions for adding sample data
  Future<void> addSampleRoom(Room room) async {
    await _firestore.collection('rooms').add(room.toMap());
  }

  Future<void> addSampleNotice(Notice notice) async {
    await _firestore.collection('notices').add(notice.toMap());
  }
}
