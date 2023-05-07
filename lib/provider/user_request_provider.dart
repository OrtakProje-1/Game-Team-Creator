import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/models/admin_user_model.dart';
import 'package:game_team_creator_admin_panel/provider/providers.dart';
import 'package:game_team_creator_admin_panel/services/fcm_service.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';

class UserRequestProvider
    extends StateNotifierProviders<List<AdminUserModel>?> {
  UserRequestProvider(Ref ref) : super(ref: ref, state: []);

  StreamSubscription? _currentUserRequestSubscription;

  void setUserRequest(List<AdminUserModel> request) {
    state = request;
  }

  List<AdminUserModel> get userRequest {
    return state ?? [];
  }

  @override
  void onDispose() {
    _currentUserRequestSubscription?.cancel();
  }

  Future<void> requestAnswer(AdminUserModel user, bool isAllow) async {
    try {
      await firestoreP.requestAuthorizeUsersReference.doc(user.id).delete();
    } catch (_) {}
    user.authorize = isAllow;
    try {
      await firestoreP.adminUsersReference.doc(user.id).set(user);
      if (user.token != null) {
        await FcmServices.sendNotification(
            user.token!,
            "Merhaba ${user.name}",
            isAllow
                ? "Tebrikler, Uygulamaya erişim izniniz verilmiştir. Sizlerle daha iyi yerleye geleceğimize eminiz."
                : "Üzgünüm, Uygulamaya erişim izniniz reddilmiştir. Yeni projelerde görüşmek dileğiyle, kendine iyi bak.");
      }
    } catch (_) {}
  }

  @override
  Future<void> onInit() async {
    _currentUserRequestSubscription =
        firestoreP.getUserRequestStream().listen((event) {
      setUserRequest(event.getDatas());
    });
  }
}
