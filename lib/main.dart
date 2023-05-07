import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:game_team_creator_admin_panel/models/admin_user_model.dart';
import 'package:game_team_creator_admin_panel/models/game.dart';
import 'package:game_team_creator_admin_panel/models/game_type.dart';
import 'package:game_team_creator_admin_panel/provider/admin_users_provider.dart';
import 'package:game_team_creator_admin_panel/provider/auth_provider.dart';
import 'package:game_team_creator_admin_panel/provider/firebase_provider.dart';
import 'package:game_team_creator_admin_panel/provider/game_types_provider.dart';
import 'package:game_team_creator_admin_panel/provider/games_provider.dart';
import 'package:game_team_creator_admin_panel/provider/user_provider.dart';
import 'package:game_team_creator_admin_panel/provider/user_request_provider.dart';
import 'package:game_team_creator_admin_panel/screens/login/login.dart';
import 'package:game_team_creator_admin_panel/util/helpers.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationHelper.setupFlutterNotifications();
  NotificationHelper.showFlutterNotification(message);
  debugPrint('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  await HiveHelper.init();
  await NotificationHelper.init();
  await FirebaseMessagingHelper.init();
  runApp(const ProviderScope(child: RootApp()));
}

final firestoreProvider = Provider((ref) => FirestoreProvider(ref: ref));
final kGamesProvider = StateNotifierProvider<GamesProvider, List<Game>?>(
    (ref) => GamesProvider(ref));
final kUserProvider = StateNotifierProvider<UserProvider, AdminUserModel?>(
    (ref) => UserProvider(ref));
final kAuthProvider = Provider((ref) => AuthProvider(ref));
final kGameTypesProvider =
    StateNotifierProvider<GameTypesProvider, List<GameType>?>(
        (ref) => GameTypesProvider(ref));
final kUserRequestProvider =
    StateNotifierProvider<UserRequestProvider, List<AdminUserModel>?>(
        (ref) => UserRequestProvider(ref));
final kAdminUsersProvider =
    StateNotifierProvider<AdminUsersProvider, List<AdminUserModel>?>(
        (ref) => AdminUsersProvider(ref));

class RootApp extends ConsumerWidget {
  const RootApp({super.key});
  static final GlobalKey<NavigatorState> rootNavigator =
      GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: rootNavigator,
      title: 'Takım Oluşturucu Admin',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
