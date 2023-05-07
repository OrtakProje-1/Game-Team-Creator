import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/models/admin_user_model.dart';
import 'package:game_team_creator_admin_panel/provider/providers.dart';

class UserProvider extends StateNotifierProviders<AdminUserModel?> {
  UserProvider(Ref ref) : super(ref: ref, state: null);

  StreamSubscription? _currentUserSubscription;
  StreamSubscription? _messagingTokenSubscription;
  User? get currentUser => FirebaseAuth.instance.currentUser;

  AdminUserModel? get user {
    return state;
  }

  void setUser(AdminUserModel? user) {
    if (user?.id != state?.id) {
      state = user;
      _currentUserSubscription?.cancel();
    } else {
      state = user;
    }
  }

  void updateUserToken(String token) {
    if (state == null) return;
    updateUser(state!.copyWith(token: token));
    firestoreP.adminUsersReference.doc(state!.id).update(state!.toMap());
  }

  void updateUser(AdminUserModel user) {
    firestoreP.adminUsersReference.doc(user.id).update(user.toMap());
    state = user;
  }

  Future<bool> addUser() async {
    if (currentUser == null) return false;
    String? token = await messaging.getToken();
    var map = await firestoreP.adminUsersReference.doc(currentUser!.uid).get();
    if (map.data() != null) {
      var user = map.data()!;
      user.token = token;
      updateUser(user);
      setUser(user);
      return true;
    } else {
      var user = AdminUserModel(
        name: currentUser!.displayName ?? "Name",
        email: currentUser!.email ?? "",
        id: currentUser!.uid,
        image: currentUser!.photoURL ?? "",
        isSuperAdmin: false,
        authorize: null,
        token: token,
      );
      debugPrint(user.token);
      setUser(user);
      return true;
    }
  }

  @override
  void onDispose() {
    _currentUserSubscription?.cancel();
    _messagingTokenSubscription?.cancel();
  }

  @override
  void onInit() {
    debugPrint("init userP");
  }
}
