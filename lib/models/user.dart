import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:peace/services/firestore_service.dart';

class User {
  String _name;
  String _email;
  String _phoneNumber;
  String _age;
  String _gender;
  String _emergencyContact;
  String _emergencyContactName;
  String _preferredContactMethod;

  // Keep registerNumber for backward compatibility with existing data
  String _registerNumber;
  String _department;
  String _uid;

  User(
    this._name,
    this._email,
    this._phoneNumber,
    this._age,
    this._gender,
    this._emergencyContact,
    this._emergencyContactName,
    this._preferredContactMethod, {
    String registerNumber = "",
    String department = "",
    String uid = "",
  }) : _registerNumber = registerNumber,
       _department = department,
       _uid = uid;

  String get name => _name;
  String get email => _email;
  String get phoneNumber => _phoneNumber;
  String get age => _age;
  String get gender => _gender;
  String get emergencyContact => _emergencyContact;
  String get emergencyContactName => _emergencyContactName;
  String get preferredContactMethod => _preferredContactMethod;
  String get registerNumber => _registerNumber;
  String get department => _department;
  String get uid => _uid;

  set name(newName) => _name = newName;
  set email(newEmail) => _email = newEmail;
  set phoneNumber(newPhone) => _phoneNumber = newPhone;
  set age(newAge) => _age = newAge;
  set gender(newGender) => _gender = newGender;
  set emergencyContact(newContact) => _emergencyContact = newContact;
  set emergencyContactName(newName) => _emergencyContactName = newName;
  set preferredContactMethod(newMethod) => _preferredContactMethod = newMethod;
  set registerNumber(newRegisterNumber) => _registerNumber = newRegisterNumber;
  set department(newDepartment) => _department = newDepartment;
  set uid(newUid) => _uid = newUid;

  /// Convert User to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': _name,
      'email': _email,
      'phoneNumber': _phoneNumber,
      'age': _age,
      'gender': _gender,
      'emergencyContact': _emergencyContact,
      'emergencyContactName': _emergencyContactName,
      'preferredContactMethod': _preferredContactMethod,
      'registerNumber': _registerNumber,
      'department': _department,
      'uid': _uid,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  /// Create User from Firestore document
  factory User.fromFirestore(Map<String, dynamic> data) {
    return User(
      data['name'] ?? '',
      data['email'] ?? '',
      data['phoneNumber'] ?? '',
      data['age'] ?? '',
      data['gender'] ?? '',
      data['emergencyContact'] ?? '',
      data['emergencyContactName'] ?? '',
      data['preferredContactMethod'] ?? '',
      registerNumber: data['registerNumber'] ?? '',
      department: data['department'] ?? '',
      uid: data['uid'] ?? '',
    );
  }

  /// Create a copy of User with updated fields
  User copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? age,
    String? gender,
    String? emergencyContact,
    String? emergencyContactName,
    String? preferredContactMethod,
    String? registerNumber,
    String? department,
    String? uid,
  }) {
    return User(
      name ?? _name,
      email ?? _email,
      phoneNumber ?? _phoneNumber,
      age ?? _age,
      gender ?? _gender,
      emergencyContact ?? _emergencyContact,
      emergencyContactName ?? _emergencyContactName,
      preferredContactMethod ?? _preferredContactMethod,
      registerNumber: registerNumber ?? _registerNumber,
      department: department ?? _department,
      uid: uid ?? _uid,
    );
  }
}

void setUpUser(UserModel student) {
  user.name = student.name;
  user.registerNumber = student.registerNumber;
  user.email = student.email;
  user.department =
      student.registerNumber.isNotEmpty && student.registerNumber.length > 2
      ? student.registerNumber.substring(2, 4)
      : "";
}

User user = User("", "", "", "", "", "", "", "");
