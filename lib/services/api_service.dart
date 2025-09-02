import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/rider.dart';
import '../models/training_progress.dart';

class ApiService {
  static const String baseUrl = 'YOUR_LAMBDA_API_ENDPOINT'; // Replace with your Lambda endpoint
  
  // Get rider information from replica database
  static Future<Rider?> getRiderInfo(String riderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rider-info?rider_id=$riderId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Rider.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching rider info: $e');
      return null;
    }
  }

  // Update training progress in Google Sheets
  static Future<bool> updateTrainingProgress(TrainingProgress progress) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/update-progress'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(progress.toJson()),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating training progress: $e');
      return false;
    }
  }

  // Mark module as started
  static Future<bool> markModuleStarted(String riderId, String day) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/module-started'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rider_id': riderId,
          'day': day,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error marking module started: $e');
      return false;
    }
  }

  // Mark module as completed
  static Future<bool> markModuleCompleted(String riderId, String day) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/module-completed'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rider_id': riderId,
          'day': day,
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error marking module completed: $e');
      return false;
    }
  }
}
