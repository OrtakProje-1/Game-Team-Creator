// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/models/admin_user_model.dart';
import 'package:game_team_creator_admin_panel/provider/providers.dart';
import 'package:game_team_creator_admin_panel/screens/login/login.dart';
import 'package:game_team_creator_admin_panel/screens/password_page/password_page.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends Providers {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProvider(Ref ref) : super(ref: ref);

  Future<void> checkUser() async {
    if (FirebaseAuth.instance.currentUser != null) {
      if (await userP.addUser() && userP.user!.authorize == true) {
        await context!.pushAndRemoveUntil(const PasswordPage());
      } else {
        await FirebaseAuth.instance.signOut();
        await GoogleSignIn().disconnect();
      }
    }
  }

  Future<void> signInWithGoogle() async {
    UserCredential userCredential;
    GoogleSignInAccount? googleUser;
    try {
      googleUser = await GoogleSignIn().signIn();
    } on PlatformException catch (_) {
      return;
    }

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final GoogleAuthCredential googleAuthCredential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ) as GoogleAuthCredential;

      userCredential = await FirebaseAuth.instance
          .signInWithCredential(googleAuthCredential);

      final user = userCredential.user;
      if (user == null) {
        return;
      }

      if (await userP.addUser() && userP.user != null) {
        var authorize = userP.user!.authorize;
        if (authorize == null) {
          if (await requestAuthorize(userP.user!)) {
            context!.showSnackbar(
              "Erişim isteği gönderildi. Lütfen yöneticilerin isteğinize cevap vermesini bekleyin, size haber vereceğiz",
              second: 8,
            );
          }
        } else if (authorize == false) {
          context!.showSnackbar(
            "Erişim isteğiniz reddedilmiştir. Erişim izni için lütfen yöneticiler ile iletişime geçiniz",
            second: 5,
          );
        } else if (context != null) {
          await context!.pushAndRemoveUntil(const PasswordPage());
        }
      }
    } else {
      context!.showSnackbar(
        "Giriş yaparken hata oluştu",
        second: 3,
      );
    }
  }

  Future<bool> requestAuthorize(AdminUserModel user) async {
    try {
      var requestUser =
          (await firestoreP.requestAuthorizeUsersReference.doc(user.id).get())
              .data();
      if (requestUser == null) {
        await firestoreP.requestAuthorizeUsersReference.doc(user.id).set(user);
        return true;
      } else {
        if (requestUser.token != user.token) {
          await firestoreP.requestAuthorizeUsersReference
              .doc(user.id)
              .update({"token": user.token});
        }
        context!.showSnackbar(
          "Bekleyen bir erişim isteğiniz mevcut lütfen yöneticilerin cevap vermesini bekleyin",
          second: 6,
        );
      }
    } catch (e) {
      context!.showSnackbar(
        "Erişim isteği gönderilirken hata oluştu",
        second: 5,
      );
      debugPrint(e.toString());
    }
    return false;
  }

  void signOut() async {
    await _auth.signOut();
    await GoogleSignIn().disconnect();
    if (context != null) {
      await context!.pushAndRemoveUntil(const Login());
    }
  }

  @override
  void onDispose() {}

  @override
  void onInit() {
    checkUser();
  }
}

const token =
    "cBCoIpovT6WF03_mB4HDYK:APA91bFi4Jnq3MoxCuyvW1s1-gqz1QHjUdXcoSKrUGbtDGakTgvilL6MxrWeUcEwZyyEgHrCJF28xcrposrqf6M8snP8uDNVInRbFrqkP_pV0lhEkPE0NgPITwaV7Stw3lAcqes_omwL";
