import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_team_creator_admin_panel/models/admin_user_model.dart';
import 'package:game_team_creator_admin_panel/models/game.dart';
import 'package:game_team_creator_admin_panel/models/game_type.dart';
import 'package:game_team_creator_admin_panel/models/my_user.dart';
import 'package:game_team_creator_admin_panel/provider/providers.dart';
import 'package:game_team_creator_admin_panel/util/extensions.dart';

class FirestoreProvider extends Providers {
  FirestoreProvider({required super.ref});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<AdminUserModel> get adminUsersReference =>
      _firestore.collection("AdminUsers").withConverter(
          fromFirestore: (snapshot, options) =>
              AdminUserModel.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap());

  CollectionReference<MyUser> get usersReference =>
      _firestore.collection("Users").withConverter(
          fromFirestore: (snapshot, options) =>
              MyUser.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap());

  CollectionReference<Game> get gamesReference =>
      _firestore.collection("Games").withConverter(
          fromFirestore: (snapshot, options) => Game.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap());

  CollectionReference<GameType> get gameTypesReference =>
      _firestore.collection("GameTypes").withConverter(
          fromFirestore: (snapshot, options) =>
              GameType.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap());

  CollectionReference<AdminUserModel> get requestAuthorizeUsersReference =>
      _firestore.collection("RequestAuthorizeUsers").withConverter(
          fromFirestore: (snapshot, options) =>
              AdminUserModel.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap());

  Stream<DocumentSnapshot<AdminUserModel>> getUserStreamFromId(String id) {
    return adminUsersReference.doc(id).snapshots();
  }

  Stream<QuerySnapshot<Game>> getGamesStream() {
    return gamesReference.snapshots();
  }

  Future<List<Game>> getGames() async {
    return gamesReference.getDatas();
  }

  Stream<QuerySnapshot<GameType>> getGameTypesStream() {
    return gameTypesReference.snapshots();
  }

  Stream<QuerySnapshot<AdminUserModel>> getUserRequestStream() {
    return requestAuthorizeUsersReference.snapshots();
  }

  Stream<QuerySnapshot<AdminUserModel>> getAdminUsersStream() {
    return adminUsersReference.snapshots();
  }

  Future<List<GameType>> getGameTypes() async {
    return gameTypesReference.getDatas();
  }

  Future<DocumentReference<Game>> addGame(Game game) async {
    return gamesReference.add(game);
  }

  Future<bool> removeGame(Game game) async {
    try {
      var doc =
          await gamesReference.where("id", isEqualTo: game.id).limit(1).get();
      if (doc.docs.isNotEmpty) {
        await doc.docs[0].reference.delete();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateGame(Game game) async {
    try {
      var doc =
          await gamesReference.where("id", isEqualTo: game.id).limit(1).get();
      if (doc.docs.isNotEmpty) {
        await doc.docs[0].reference.update(game.toMap());
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<DocumentReference<GameType>> addGameType(GameType gameType) async {
    return gameTypesReference.add(gameType);
  }

  Future<bool> removeGameType(GameType gameType) async {
    try {
      var doc = await gameTypesReference
          .where("id", isEqualTo: gameType.id)
          .limit(1)
          .get();
      if (doc.docs.isNotEmpty) {
        await doc.docs[0].reference.delete();
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateGameType(GameType gameType) async {
    try {
      var doc = await gameTypesReference
          .where("id", isEqualTo: gameType.id)
          .limit(1)
          .get();
      if (doc.docs.isNotEmpty) {
        await doc.docs[0].reference.update(gameType.toMap());
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  void onDispose() {}

  @override
  void onInit() {}
}
