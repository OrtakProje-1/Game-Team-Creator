import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/models/admin_user_model.dart';
import 'package:game_team_creator_admin_panel/provider/providers.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';

class AdminUsersProvider extends StateNotifierProviders<List<AdminUserModel>?> {
  AdminUsersProvider(Ref ref) : super(ref: ref, state: null);

  StreamSubscription? _adminUserSubscription;

  List<AdminUserModel>? get adminUsers {
    return state;
  }

  void setAdminUsers(List<AdminUserModel> users) {
    state = users;
  }

  Future<void> updateUserAuthorize(AdminUserModel user, bool authorize) async {
    try {
      await firestoreP.adminUsersReference
          .doc(user.id)
          .update({"authorize": authorize});
    } catch (_) {}
  }

  Future<void> updateUserSuperAdmin(
      AdminUserModel user, bool superAdmin) async {
    try {
      await firestoreP.adminUsersReference
          .doc(user.id)
          .update({"isSuperAdmin": superAdmin});
    } catch (_) {}
  }

  @override
  void onDispose() {
    _adminUserSubscription?.cancel();
  }

  @override
  void onInit() {
    _adminUserSubscription = firestoreP.getAdminUsersStream().listen((event) {
      setAdminUsers(event.getDatas());
    });
  }
}
