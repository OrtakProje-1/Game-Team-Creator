import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/provider/auth_provider.dart';
import 'package:game_team_creator_admin_panel/provider/firebase_provider.dart';
import 'package:game_team_creator_admin_panel/provider/user_provider.dart';

import '../main.dart';

abstract class ProviderListener {
  FirestoreProvider get firestoreP;
  UserProvider get userP;
  AuthProvider get authP;
  FirebaseMessaging get messaging;

  late Ref ref;
  void onDispose();
  void onInit();
}

mixin ProvidersImplementation implements ProviderListener {
  @override
  late Ref ref;

  @override
  FirestoreProvider get firestoreP => ref.read(firestoreProvider);

  @override
  AuthProvider get authP => ref.read(kAuthProvider);

  @override
  UserProvider get userP => ref.read(kUserProvider.notifier);

  @override
  BuildContext? get context => RootApp.rootNavigator.currentContext;

  @override
  FirebaseMessaging get messaging => FirebaseMessaging.instance;
}

abstract class StateNotifierProviders<T> extends StateNotifier<T>
    with ProvidersImplementation {
  StateNotifierProviders({required T state, required Ref ref}) : super(state) {
    super.ref = ref;
    ref.onDispose(onDispose);
    onInit();
  }
}

abstract class Providers with ProvidersImplementation {
  Providers({required Ref ref}) {
    super.ref = ref;
    ref.onDispose(onDispose);
    onInit();
  }
}
