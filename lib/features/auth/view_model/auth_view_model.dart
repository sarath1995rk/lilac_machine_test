import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lilac_machine_test/app_config/utilities.dart';
import 'package:lilac_machine_test/app_config/routes.dart' as route;

class AuthViewModel with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  PhoneAuthCredential? phoneAuthCredential;
  String? phone;
  String? verificationIdentity;
  bool numberLoginLoading = false;
  bool numberOtpLoading = false;
  int? resendToken;

  /// Login Using Mobile Number
  loginUsingNumber(BuildContext context, String phone) async {
    if (phone.isEmpty) {
      Utilities.showSnackBar('Please enter a mobile number', context);
      return;
    }
    numberLoginLoading = true;
    notifyListeners();

    _auth.verifyPhoneNumber(
      timeout: const Duration(minutes: 2),
      phoneNumber: phone,
      forceResendingToken: resendToken,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        try {
          await _auth.signInWithCredential(phoneAuthCredential);
        } on Exception catch (e) {
          log(e.toString());
        }
      },
      verificationFailed: (verificationFailed) {
        numberLoginLoading = false;
        notifyListeners();
        log('error => ${verificationFailed.message}');

        if (verificationFailed.message ==
            'To send verification codes, provide a phone number for the recipient.') {
          Utilities.showSnackBar('Please enter a mobile number', context);
        } else if (verificationFailed.message == 'TOO_SHORT' ||
            verificationFailed.message ==
                'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_SHORT ]') {
          Utilities.showSnackBar('Please enter a valid mobile number', context);
        } else if (verificationFailed.message ==
                'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ Invalid format. ]' ||
            verificationFailed.message == 'Invalid format.') {
          Utilities.showSnackBar('Enter the country code', context);
        } else if (verificationFailed.message ==
            'Network error (such as timeout, interrupted connection or unreachable host) has occurred.') {
          Utilities.showSnackBar('No Internet Connection', context);
        } else if (verificationFailed.message ==
            'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_LONG ]') {
          Utilities.showSnackBar('Please enter a valid mobile number', context);
        } else {
          Utilities.showSnackBar('Please try again later', context);
        }
      },
      codeSent: (verificationId, resendingToken) async {
        log(verificationId);
        verificationIdentity = verificationId;
        resendToken = resendingToken;
        notifyListeners();
        numberLoginLoading = false;
        Utilities.showSnackBar('OTP send to the given number', context);
        notifyListeners();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        log('time out');
        numberLoginLoading = false;
        verificationId = verificationId;
        notifyListeners();
      },
    );
  }

  /// Confirm OTP
  signInWithPhone(String otp, BuildContext context) async {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationIdentity!, smsCode: otp);
    numberOtpLoading = true;
    notifyListeners();
    try {
      final authCredential =  await _auth.signInWithCredential(phoneAuthCredential);
      Navigator.of(context).pushNamedAndRemoveUntil(
          route.kHomeScreen,
              (route) => false
      );
    } on FirebaseAuthException catch (e) {
      numberOtpLoading = false;
      notifyListeners();
      log(e.message.toString());
      if (e.code == 'invalid-verification-code') {
        Utilities.showSnackBar('Invalid OTP', context);
      } else {
        Utilities.showSnackBar(e.toString(), context);
      }
    }
  }
}
