
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
  int verificationStatus;
  double rating;
  double ratingCount;


  List<String> subjects;

  String educationLevel;
  String institute;


  bool get isGuest => this == guestUser;


  bool get isStudent=>userType==UserType.Student;

  bool get isTutor=>!isStudent;


  String get getProfilePictureURL => profilePictureURL.isNotEmpty
      ? profilePictureURL
      : AppImagePaths.defaultProfilePicture;

  AppUser(
      {this.uid = '',
      this.name = '',
      this.nickname='',
      required this.rating,
      required this.verificationStatus,
      required this.userType,
      required this.numberVerified,
      this.profileFilled=false,
      required this.ratingCount,
      this.notificationToken,
      // this.address = const {},
      this.email = '',
      this.gender = 'Prefer not to say',
      this.contactNum = '',
      this.profilePictureURL = '',
      dateOfBirth,
      this.educationLevel='',
      this.institute='',
      this.subjects=const [],
      this.selectedAddress = ''});

  static AppUser fromMap(Map<String, dynamic> data) => AppUser(
        uid: data['uid'],
        name: data['name'],
        educationLevel: data['education_level']??'',
        verificationStatus: data['verifiedStatus']??0,
        ratingCount: data['rateCount']??1,
        rating: data['rating']??3,
        institute: data['institute']??'',
        subjects: ((data['subjects'] as List?)??[]).map((e) => e.toString()).toList(),
        userType: UserType.values[data['type']],
        profileFilled: data['profile_filled']??false,
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
        'profile_filled':profileFilled,
        'name': name,
        'numberVerified':numberVerified,
        'nickname': nickname,
        'notification_token':notificationToken,
        //'address': address.map((key, value) => MapEntry(key, value.toMap())),
        'email': email,
        'gender': gender,
        'subjects':subjects,
        'education_level':educationLevel,
        'phone': contactNum,
        'photoUrl': profilePictureURL,
        'dob': dateOfBirth!=null?Timestamp.fromDate(dateOfBirth!):null,
        'selectedAddress': selectedAddress,
      };

  dynamic get dobString =>dateOfBirth==null?'N/A':
      '${dateOfBirth?.day}/${dateOfBirth?.month}/${dateOfBirth?.year}';
  AppUser copyWith({
    String? name,
    String? address,
    String? phone,
    bool? profile_filled,
    String? nickname,
    DateTime? dob,
    String? photoUrl,
  }) =>
      AppUser(
          uid: uid,
          rating: rating,
          ratingCount: ratingCount,
          userType: userType,
          subjects: subjects,
          educationLevel: educationLevel,
          verificationStatus: verificationStatus,
          institute: institute,
          numberVerified: numberVerified,
          notificationToken: notificationToken,
          name: name ?? this.name,
          email: email,
          profileFilled: profile_filled??profileFilled,
          dateOfBirth: dob??dateOfBirth,
          profilePictureURL: photoUrl??profilePictureURL,
          nickname: nickname?? this.nickname,
          contactNum: phone ?? contactNum);

  // List<String> getAddresses() =>
  //     address.entries.map((e) => '${e.key}: ${e.value}').toList();
}

AppUser guestUser = AppUser(
  uid: 'guestuid',
  rating: 5,
  ratingCount: 1,
  institute: '',
  educationLevel: '',
  subjects: [],
  verificationStatus: 0,
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