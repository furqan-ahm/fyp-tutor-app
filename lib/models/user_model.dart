
import 'package:cloud_firestore/cloud_firestore.dart';

import '../resources/image_paths.dart';

enum UserType{Teacher, Student}

class AppUser {
  final String uid; //probably gonna need this with firebase

  String name;
  String nickname;
  String email;
  UserType userType;
  String profilePictureURL;
  String? notificationToken;
  String gender;
  String contactNum;
  bool numberVerified;
  DateTime? dateOfBirth;
  bool profileFilled;
  String? selectedAddress;

  bool get isGuest => this == guestUser;

  static isSelectedAddress(String key, String? selectedAddress) =>
      key == selectedAddress;

  String get getProfilePictureURL => profilePictureURL.isNotEmpty
      ? profilePictureURL
      : AppImagePaths.defaultProfilePicture;

  AppUser(
      {this.uid = '',
      this.name = '',
      this.nickname='',
      required this.userType,
      required this.numberVerified,
      this.profileFilled=false,
      this.notificationToken,
      // this.address = const {},
      this.email = '',
      this.gender = 'Prefer not to say',
      this.contactNum = '',
      this.profilePictureURL = '',
      dateOfBirth,
      this.selectedAddress = ''})
      : dateOfBirth = dateOfBirth ?? DateTime(1947, 8, 14);

  static AppUser fromMap(Map<String, dynamic> data) => AppUser(
        uid: data['uid'],
        name: data['name'],
        userType: UserType.values[data['type']],
        numberVerified: data['numberVerified']??false,
        nickname: data['nickname']??'',
        notificationToken: data['notification_token'],
        // address: data['address'] == null
        //     ? {}
        //     : (data['address'] as Map)
        //         .map((key, value) => MapEntry(key, Address.fromMap(value))),
        email: data['email'],
        gender: data['gender'] == '' ? 'Prefer not to say' : data['gender'],
        contactNum: data['phone'],
        profilePictureURL:
            data['photoUrl'] ?? AppImagePaths.defaultProfilePicture,
        dateOfBirth: data['dob']?.toDate() ?? DateTime(1947, 8, 14),
        selectedAddress:
            data['selectedAddress'] == '' ? '' : data['selectedAddress'],
      );

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'type':userType.index,
        'name': name,
        'numberVerified':numberVerified,
        'nickname': nickname,
        'notification_token':notificationToken,
        //'address': address.map((key, value) => MapEntry(key, value.toMap())),
        'email': email,
        'gender': gender,
        'phone': contactNum,
        'photoUrl': profilePictureURL,
        'dob': Timestamp.fromDate(dateOfBirth ?? DateTime(1947, 8, 14)),
        'selectedAddress': selectedAddress,
      };

  dynamic get dobString =>
      '${dateOfBirth?.day}/${dateOfBirth?.month}/${dateOfBirth?.year}';
  AppUser copyWith({
    String? name,
    String? address,
    String? phone,
    String? nickname,
    DateTime? dob,
    String? photoUrl,
  }) =>
      AppUser(
          uid: uid,
          userType: userType,
          numberVerified: numberVerified,
          notificationToken: notificationToken,
          name: name ?? this.name,
          email: email,
          dateOfBirth: dob??dateOfBirth,
          profilePictureURL: photoUrl??profilePictureURL,
          nickname: nickname?? this.nickname,
          contactNum: phone ?? contactNum);

  // List<String> getAddresses() =>
  //     address.entries.map((e) => '${e.key}: ${e.value}').toList();
}

AppUser guestUser = AppUser(
  uid: 'guestuid',
  userType: UserType.Student,
  name: 'GUEST ACCOUNT',
  numberVerified: false,
  notificationToken: '',
  //address: {},
  email: 'N/A',
  gender: 'Prefer not to say',
  contactNum: 'N/A',
  profilePictureURL: AppImagePaths.defaultProfilePicture,
  dateOfBirth: DateTime(1947, 8, 14),
  selectedAddress: '',
);


//have to make these default values centralized, ie for a default gender value, there should be a singular class which holds all these values.