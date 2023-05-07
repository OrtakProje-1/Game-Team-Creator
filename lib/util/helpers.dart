import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game_team_creator_admin_panel/main.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class ProviderHelper {
  static ProviderContainer? getContainer() {
    BuildContext? ctx = RootApp.rootNavigator.currentContext;
    if (ctx != null) {
      return ProviderScope.containerOf(ctx);
    }
    return null;
  }
}

class ToastHelper {
  static void showToast(
    String msg, {
    Color? bgColor,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color textColor = Colors.black,
  }) {
    Fluttertoast.showToast(
      backgroundColor: bgColor ?? Colors.grey.shade200,
      textColor: textColor,
      gravity: gravity,
      msg: msg,
    );
  }
}

class HiveHelper {
  static late Box<String> dataBox;
  static Future<void> init() async {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    dataBox = await Hive.openBox<String>("dataBox");
  }

  static bool get hasPassword => dataBox.containsKey("password");

  static String get password => dataBox.get("password")!;

  static Future<bool> setPassword(String password) async {
    try {
      dataBox.put("password", password);
      return true;
    } catch (_) {
      return false;
    }
  }
}

class NotificationHelper {
  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static Future<void> init() async {
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }
  }

  static Future<void> setupFlutterNotifications() async {
    var messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'game_team_creator_admin', // id
      'High Importance Notifications', // title
      description: 'Erişim izni bildirimleri.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'ic_notification',
          ),
        ),
      );
    }
  }
}

class FirebaseMessagingHelper {
  static Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    FirebaseMessaging.instance.getInitialMessage().then((value) {
      if (value != null) {
        NotificationHelper.showFlutterNotification(value);
      }
    });

    FirebaseMessaging.onMessage
        .listen(NotificationHelper.showFlutterNotification);
  }
}
