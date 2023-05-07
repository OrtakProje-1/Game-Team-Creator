import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:game_team_creator_admin_panel/util/helpers.dart';
import 'package:http/http.dart' as http;

class FcmServices {
  static String _constructFCMPayload(String token, String title, String body) {
    return jsonEncode({
      'to': token,
      'data': {'click_action': 'FLUTTER_NOTIFICATION_CLICK'},
      'notification': {
        'title': title,
        'body': body,
      },
    });
  }

  static Future<void> sendNotification(
      String token, String title, String body) async {
    try {
      var res = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=${dotenv.env["FCM_API_KEY"] ?? ""}'
        },
        body: _constructFCMPayload(token, title, body),
      );
      debugPrint(res.statusCode.toString());
      debugPrint('FCM request for device sent!');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
