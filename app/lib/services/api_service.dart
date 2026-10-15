import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/visitor_model.dart';

class ApiService {
  static const String baseUrl =
      'https://qr-visitor-entry-system.onrender.com/api';

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<UserModel?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('user', jsonEncode(data));
      return UserModel.fromJson(data);
    }
    return null;
  }

  static Future<UserModel?> registerUser(
      String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
          {'name': name, 'email': email, 'password': password, 'role': role}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('user', jsonEncode(data));
      return UserModel.fromJson(data);
    }
    return null;
  }

  static Future<List<VisitorModel>> getVisitors() async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/visitors'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((v) => VisitorModel.fromJson(v)).toList();
    }
    return [];
  }

  static Future<List<VisitorModel>> getMyVisitors() async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/visitors/my'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((v) => VisitorModel.fromJson(v)).toList();
    }
    return [];
  }

  static Future<List<UserModel>> getUsers() async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/auth/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((v) => UserModel.fromJson(v)).toList();
    }
    return [];
  }

  static Future<VisitorModel?> getVisitorById(String id) async {
    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/visitors/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return VisitorModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<VisitorModel?> registerVisitor(
      Map<String, dynamic> visitorData) async {
    String? token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/visitors'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(visitorData),
    );

    if (response.statusCode == 201) {
      return VisitorModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  static Future<bool> updateVisitorStatus(String id, String status) async {
    String? token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/visitors/$id/status'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': status}),
    );
    return response.statusCode == 200;
  }

  static Future<bool> checkInVisitor(String id) async {
    String? token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/visitors/$id/checkin'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }

  static Future<Map<String, dynamic>> checkInVisitorWithMessage(
      String id) async {
    String? token = await getToken();
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/visitors/$id/checkin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Check-in Successful!'};
      } else if (response.statusCode == 403) {
        return {
          'success': false,
          'message': 'Visitor not approved by Admin yet!'
        };
      } else {
        final body = jsonDecode(response.body);
        return {
          'success': false,
          'message': body['message'] ?? 'Check-in Failed!'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Try again.'};
    }
  }

  static Future<bool> checkOutVisitor(String id) async {
    String? token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl/visitors/$id/checkout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return response.statusCode == 200;
  }
}
