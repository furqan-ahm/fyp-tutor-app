import 'dart:async';
import 'package:tutor_app/providers/user_state_provider.dart';
import 'package:tutor_app/repository/firebase_firestore_repo.dart';
import 'package:tutor_app/repository/firebase_storage_repo.dart';
// import 'package:tutor_app/screens/account_recovery/reset_password_screen.dart';
// import 'package:tutor_app/screens/account_recovery/verify_otp_screen.dart';
// import 'package:tutor_app/screens/auth/fill_profile_screen.dart';
// import 'package:tutor_app/screens/auth/verify_email_screen.dart';
// import 'package:tutor_app/screens/auth/welcome_screen.dart';
// import 'package:tutor_app/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:tutor_app/screens/auth/sign_in_screen.dart';
import 'package:tutor_app/screens/getting_started/education_level_screen.dart';
import 'package:tutor_app/screens/student/student_dashboard_screen.dart';
import 'package:tutor_app/screens/tutor/tutor_dashboard_screen.dart';
import '../models/user_model.dart';
import '../repository/firebase_auth_repo.dart';
import '../utils/utils.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    //doesnt quite work right so replaced with refreshUser function

    // FirebaseAuthRepository.getAuthUser().then((value) {
    //   _currentUser = value;
    //   notifyListeners();
    // });
  }

  bool get emailVerified => FirebaseAuth.instance.currentUser!.emailVerified;

  static AuthProvider of(BuildContext context) {
    return Provider.of<AuthProvider>(context, listen: false);
  }

  refreshVerificationStatus() {
    FirebaseAuth.instance.currentUser!
        .reload()
        .then((value) => notifyListeners());
  }

  Future<AppUser?> refreshUser() async {
    _currentUser = await FirebaseAuthRepository.getAuthUser();

    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null && _currentUser != null)
        FirestoreRepository.setNotificationToken(_currentUser!.uid, token);
    });

    notifyListeners();
    return _currentUser;
  }

  UserCredential? registerationPhoneUser;

  String verificationID = '';

  setPhoneAuthCredential(UserCredential credential) {
    registerationPhoneUser = credential;
    notifyListeners();
  }

  bool get isPhoneNumberVerified =>
      FirebaseAuth.instance.currentUser!.phoneNumber ==
      _currentUser!.contactNum;

  AppUser? _currentUser;

  AppUser get currentUser => _currentUser ?? guestUser;

  Future<bool> signIn(String email, String password, BuildContext context,
      {required bool rememberMe}) async {
    await FirebaseAuthRepository.loginWithEmailAndPassword(email, password)
        .then((value) async {
      if (value is AppUser) {
        _currentUser = value;

        // FirebaseMessaging.instance.getToken().then((token) {
        //   if (token != null)
        //     FirestoreRepository.setNotificationToken(value.uid, token);
        // });

        final userStateProvider =
            Provider.of<UserStateProvider>(context, listen: false);
        userStateProvider.saveLoginSharedPreference(rememberMe);

        if (_currentUser!.profileFilled) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => _currentUser!.isTutor
                    ? const TutorDashboardScreen()
                    : const StudentDashboardScreen(),
              ),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    EducationLevelScreen(selectedRole: currentUser.userType),
              ),
              (route) => false);
        }

        // Navigator.pushNamedAndRemoveUntil(
        //     context, RouteName.mainScreen, (route) => false);
      } else {
        Utils.showSnackbar(value.toString(), context);
      }
    });

    return true;
  }

  Future<bool> sendPasswordResetEmail(
      String email, BuildContext context) async {
    final res = await FirebaseAuthRepository.sendPasswordResetEmail(email);

    if (res is String) {
      Utils.showSnackbar(res, context);
      return false;
    }

    return true;
  }

  // Future<void> signInWithGoogle(BuildContext context) async {
  //   //for dialog context (so that we can handle its state and navigation)
  //   final dialogContextCompleter = Completer<BuildContext>();

  //   Utils.showFullScreenLoading(context, dialogContextCompleter);

  //   FirebaseAuthRepository.loginWithGoogle().then((value) async {
  //     // Close progress dialog
  //     BuildContext dialogContext =
  //         context; //a little workaround, if i do not initialize it with some context then the when complete thing won't work.
  //     dialogContext = await dialogContextCompleter.future.whenComplete(() {
  //       Navigator.pop(dialogContext);
  //       if (value is AppUser) {
  //         _currentUser = value;
  //         FirebaseMessaging.instance.getToken().then((token) {
  //           if (token != null)
  //             FirestoreRepository.setNotificationToken(value.uid, token);
  //         });
  //         final userStateProvider =
  //             Provider.of<UserStateProvider>(context, listen: false);
  //         userStateProvider.saveLoginSharedPreference(true);

  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => const MainScreen(),
  //             ),
  //             (route) => false);
  //         // Navigator.pushNamedAndRemoveUntil(
  //         //     context, RouteName.mainScreen, (route) => false);
  //       } else if (value is UserCredential) {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => FillProfileScreen(credentials: value),
  //             ));
  //       } else {
  //         Utils.showSnackbar(value.toString(), context);
  //       }
  //     });
  //   }).onError((error, stackTrace) async {
  //     BuildContext dialogContext = context;
  //     dialogContext = await dialogContextCompleter.future.whenComplete(() {
  //       Navigator.pop(dialogContext);

  //       Utils.showSnackbar(error.toString(), context);
  //     });
  //   });
  // }

  Future<void> signOut(BuildContext context) async {
    FirestoreRepository.setNotificationToken(currentUser.uid, '');
    GoogleSignIn().disconnect();
    FirebaseAuthRepository.logout().then((value) async {
      if (value is String) {
        Utils.showSnackbar(value.toString(), context);
      } else {
        _currentUser = null;
        registerationPhoneUser = null;
        // Update user session
        final userStateProvider =
            Provider.of<UserStateProvider>(context, listen: false);
        userStateProvider.deleteLoginSharedPreference();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInScreen(),
            ),
            (route) => false);
        // Navigator.pushNamedAndRemoveUntil(
        //     context, RouteName.getStarted, (route) => false);
      }
    }).onError(
        (error, stackTrace) => Utils.showSnackbar(error.toString(), context));
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
      BuildContext context, String email, String password,
      {required bool rememberMe}) async {
    final result =
        await FirebaseAuthRepository.createEmailAndPasswordCredentials(
            email, password);
    if (result is String) {
      Utils.showSnackbar(result.toString(), context);
    } else {
      UserCredential emailAndPasswordCredentials = result;

      return emailAndPasswordCredentials;
    }
    return null;
  }

  Future<bool> updateUserProfile(AppUser user, {String? imgPath}) async {
    try {
      if (imgPath != null) {
        user.profilePictureURL =
            (await uploadProfileImage(user.uid, imgPath)) ??
                user.profilePictureURL;
      }
      final result = await FirebaseAuthRepository.updateCurrentUser(user);
      _currentUser = result;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Future<bool> fillUserProfile({
  //   required BuildContext context,
  //   required UserCredential credentials,
  //   required String name,
  //   required String nickname,
  //   required DateTime dob,
  //   String? imgPath,
  //   required String email,
  //   String? notificationToken,
  //   required String phoneNumber,
  // }) async {
  //   String? token = await FirebaseMessaging.instance.getToken();
  //   AppUser appUser = AppUser(
  //     email: email,
  //     numberVerified: false,
  //     uid: credentials.user?.uid ?? '',
  //     name: name,
  //     notificationToken: token,
  //     dateOfBirth: dob,
  //     nickname: nickname,
  //     contactNum: phoneNumber,
  //   );

  //   if (imgPath != null) {
  //     appUser.profilePictureURL =
  //         (await uploadProfileImage(appUser.uid, imgPath)) ??
  //             appUser.profilePictureURL;
  //   }
  //   // print('appUser $appUser');

  //   await FirebaseAuthRepository.createNewUser(appUser).then((value) {
  //     if (value == null) {
  //       _currentUser = appUser;
  //       final userStateProvider =
  //           Provider.of<UserStateProvider>(context, listen: false);
  //       userStateProvider.saveLoginSharedPreference(true);

  //       Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const MainScreen(),
  //           ),
  //           (route) => false);
  //       // Navigator.pushNamedAndRemoveUntil(
  //       //     context, RouteName.mainScreen, (route) => false);
  //     } else {
  //       Utils.showSnackbar('Couldn\'t create new user.', context);
  //     }
  //   });
  //   return true;
  // }

  Future register({
    required BuildContext context,
    required String name,
    required String email,
    required UserType userType,
    required String password,
    required String phoneNumber,
  }
      // PhoneAuthCredential
      ) async {
    var value = await FirebaseAuthRepository.createEmailAndPasswordCredentials(
        email, password);

    if (value is String) {
      return Utils.showSnackbar(value.toString(), context);
    } else {
      UserCredential emailAndPasswordCredentials = value;

      AppUser appUser = AppUser(
        email: email,
        rating: 3,
        ratingCount: 1,
        userType: userType,
        verificationStatus: 0,
        uid: emailAndPasswordCredentials.user?.uid ?? '',
        name: name,
        numberVerified: false,
        contactNum: phoneNumber,
      );

      // print('appUser $appUser');

      try {
        await FirebaseAuthRepository.createNewUser(appUser).then((value) {
          if (value == null) {
            _currentUser = appUser;
            final userStateProvider =
                Provider.of<UserStateProvider>(context, listen: false);
            userStateProvider.saveLoginSharedPreference(true);

            if (_currentUser!.profileFilled) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _currentUser!.isTutor
                        ? const TutorDashboardScreen()
                        : const StudentDashboardScreen(),
                  ),
                  (route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EducationLevelScreen(
                        selectedRole: currentUser.userType),
                  ),
                  (route) => false);
            }
          } else {
            return Utils.showSnackbar('Couldn\'t create new user.', context);
          }
        });
      } catch (e) {
        print(e);
        return false;
      }
    }
    return true;
  }



  Future<dynamic> setEducationDetails(String educationLevel, String institute,List<String> subjects)async{
    currentUser.subjects=subjects;
    return await FirestoreRepository.updateAll(uid: currentUser.uid, valueMap: {'education_level':educationLevel, 'subjects':subjects, 'profile_filled':true, 'institute':institute});
  }

  //this will verfiy the phone number and when successful, it will return PhoneAuthCredentials
  // Future<void> verifyPhoneNumber(
  //   BuildContext context,
  //   String phoneNumber,
  // ) async {
  //   final dialogContextCompleter = Completer<BuildContext>();

  //   Utils.showFullScreenLoading(context, dialogContextCompleter);

  //   TextEditingController codeController = TextEditingController();

  //   bool res =
  //       await FirestoreRepository.isRegistered(phoneNumber).then((value) async {
  //     if (value is bool && value == true) {
  //       BuildContext dialogContext = context;
  //       Navigator.pop(dialogContext);

  //       Utils.showSnackbar(
  //           'This number is already registered, try different one', context);

  //       return value;
  //     } else if (value is bool && value == false) {
  //       return false;
  //     }
  //     Utils.showSnackbar(value, context);
  //     BuildContext dialogContext = context;
  //     Navigator.pop(dialogContext);

  //     return true;
  //   });

  //   //if the res is true meaning that we can't proceed further, then it will get out of the function.
  //   if (res) return;

  //   try {
  //     FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: '+92$phoneNumber',
  //       verificationCompleted: (phoneAuthCredential) async {
  //         Utils.showSnackbar('verified', context);

  //         debugPrint(
  //             'verificationCompleted PhoneAuthCredentials:  $phoneAuthCredential');
  //         // setPhoneAuthCredential(phoneAuthCredential);
  //       },
  //       verificationFailed: (error) {
  //         Utils.showSnackbar(error.toString(), context);
  //       },
  //       codeSent: (verificationId, forceResendingToken) {
  //         BuildContext dialogContext = context;
  //         Navigator.pop(dialogContext);
  //         //
  //         FocusScope.of(context).unfocus();

  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => VerifyOtpScreen(
  //                 textEditingController: codeController,
  //                 number: '+92$phoneNumber',
  //                 onSubmit: (BuildContext context) async {
  //                   final dialogContextCompleter = Completer<BuildContext>();
  //                   Utils.showFullScreenLoading(
  //                       context, dialogContextCompleter);

  //                   //
  //                   FocusScope.of(context).unfocus();
  //                   await verifyOTP(codeController.text.trim(), verificationId)
  //                       .then(
  //                     (value) {
  //                       BuildContext dialogContext = context;
  //                       Navigator.pop(dialogContext);

  //                       if (value is bool && value == false) {
  //                         Utils.showSnackbar('Wrong Pin', context);
  //                       } else if (value is String) {
  //                         if (value == 'invalid-verification-code') {
  //                           Utils.showSnackbar('Wrong Pin', context);
  //                         } else {
  //                           Utils.showSnackbar(value, context);
  //                         }
  //                       } else if (value is PhoneAuthCredential) {
  //                         FirebaseAuth.instance.currentUser
  //                             ?.linkWithCredential(value)
  //                             .then((value) {
  //                           FirestoreRepository.updateUserData(
  //                                   uid: value.user!.uid,
  //                                   key: 'numberVerified',
  //                                   value: true)
  //                               .then((value) {
  //                             Provider.of<AuthProvider>(context, listen: false)
  //                                 .refreshUser()
  //                                 .then((value) {
  //                               Navigator.pop(context);
  //                             });
  //                           });
  //                         });
  //                       }
  //                       // Navigator.pop(context);
  //                     },
  //                   );

  //                   return true;
  //                 },
  //               ),
  //             ));
  //       },
  //       codeAutoRetrievalTimeout: (verificationId) {},
  //       timeout: const Duration(seconds: 5),
  //     );
  //   } on FirebaseAuthRepository catch (e) {
  //     BuildContext dialogContext = context;
  //     Navigator.pop(dialogContext);
  //     print(e.toString());
  //     Utils.showSnackbar(e.toString(), context);
  //   } catch (e) {
  //     BuildContext dialogContext = context;
  //     Navigator.pop(dialogContext);

  //     debugPrint(e.toString());
  //   }
  // }

  // Future<dynamic> verifyOTP(String code, String verificationID) async {
  //   try {
  //     // making the credentials with sms code and the verification id that is given
  //     PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       smsCode: code,
  //       verificationId: verificationID,
  //     );
  //     // print('PhoneAuthCredentialsssssssss 1 $credential');

  //     // // sigining in with those credentials
  //     // UserCredential userCredential =
  //     //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     //checking if there exists a user with those usercredentials, if there is user then that indicates the the verification code was correct and that the login is succesfull.
  //     return credential;
  //   } on FirebaseAuthException catch (exception, s) {
  //     debugPrint(
  //       'message: ${exception.message},code: ${exception.code}, stack trace: $s',
  //     );
  //     return exception.code;
  //   } on PlatformException catch (exception, s) {
  //     debugPrint(
  //         'message: ${exception.message},code: ${exception.code}, stack trace: $s');
  //     return exception.code;
  //   } catch (exception) {
  //     return exception.toString();
  //   }
  // }

  // void passwordResetSMS(String phone, BuildContext context) async{
  //   final dialogContextCompleter = Completer<BuildContext>();

  //   Utils.showFullScreenLoading(context, dialogContextCompleter);

  //   TextEditingController codeController = TextEditingController();

  //   bool res =
  //       await FirestoreRepository.isRegistered(phone).then((value) async {
  //         print('value is $value');
  //     if (value is bool && value == false) {
  //       BuildContext dialogContext = context;
  //       Navigator.pop(dialogContext);

  //       Utils.showSnackbar(
  //           'This number is not registered/verified with any account!', context);

  //       return value;
  //     } else if (value is bool && value == true) {
  //       return value;
  //     }
  //     Utils.showSnackbar(value, context);
  //     BuildContext dialogContext = context;
  //     Navigator.pop(dialogContext);

  //     return value;
  //   });

  //   //if the res is false meaning that we can't proceed further, then it will get out of the function.
  //   if (!res) return;

  //   try {
  //     FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: '+92$phone',
  //       verificationCompleted: (phoneAuthCredential) async {
  //         Utils.showSnackbar('verified', context);

  //         debugPrint(
  //             'verificationCompleted PhoneAuthCredentials:  $phoneAuthCredential');
  //         // setPhoneAuthCredential(phoneAuthCredential);
  //       },
  //       verificationFailed: (error) {
  //         Utils.showSnackbar(error.toString(), context);
  //       },
  //       codeSent: (verificationId, forceResendingToken) {
  //         BuildContext dialogContext = context;
  //         Navigator.pop(dialogContext);
  //         //
  //         FocusScope.of(context).unfocus();

  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => VerifyOtpScreen(
  //                 textEditingController: codeController,
  //                 number: '+92$phone',
  //                 onSubmit: (BuildContext context) async {
  //                   final dialogContextCompleter = Completer<BuildContext>();
  //                   Utils.showFullScreenLoading(
  //                       context, dialogContextCompleter);

  //                   //
  //                   FocusScope.of(context).unfocus();
  //                   await verifyOTP(codeController.text.trim(), verificationId)
  //                       .then(
  //                     (value) async{
  //                       BuildContext dialogContext = context;
  //                       Navigator.pop(dialogContext);

  //                       if (value is bool && value == false) {
  //                         Utils.showSnackbar('Wrong Pin', context);
  //                       } else if (value is String) {
  //                         if (value == 'invalid-verification-code') {
  //                           Utils.showSnackbar('Wrong Pin', context);
  //                         } else {
  //                           Utils.showSnackbar(value, context);
  //                         }
  //                       } else if (value is PhoneAuthCredential) {
  //                         await FirebaseAuth.instance.signInWithCredential(value).then((value){
  //                           Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) => ResetPasswordScreen(userCredential: value,),));
  //                         });
  //                       }
  //                       // Navigator.pop(context);
  //                     },
  //                   );

  //                   return true;
  //                 },
  //               ),
  //             ));
  //       },
  //       codeAutoRetrievalTimeout: (verificationId) {},
  //       timeout: const Duration(seconds: 5),
  //     );
  //   } on FirebaseAuthRepository catch (e) {
  //     BuildContext dialogContext = context;
  //     Navigator.pop(dialogContext);
  //     print(e.toString());
  //     Utils.showSnackbar(e.toString(), context);
  //   } catch (e) {
  //     BuildContext dialogContext = context;
  //     Navigator.pop(dialogContext);

  //     debugPrint(e.toString());
  //   }
  // }
}


// make use of the loading thing in the phone verification and also register function
// and supply the user info thru out the app.
// add add address functionality in firebase.