import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/rider.dart';
import '../models/training_progress.dart';
import '../models/tutorial.dart';

class ApiService {
  static const String baseUrl = 'https://tlffrtmssa.execute-api.us-east-2.amazonaws.com'; // Replace with your Lambda endpoint
  
  // Get rider information from replica database
  static Future<Rider?> getRiderInfo(String riderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/rider-info?rider_id=$riderId'),
        headers: {'Content-Type': 'application/json'},
      );
      print('response: ${response}');

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
  static Future<bool> markModuleStarted(int riderId, String day) async {
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

  // Get training progress from Supabase
  static Future<TrainingProgress?> getTrainingProgress(String riderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/training-progress?rider_id=$riderId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TrainingProgress.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching training progress: $e');
      return null;
    }
  }

  // Mark module as completed
  static Future<bool> markModuleCompleted(int riderId, String day) async {
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

  // Get tutorials for a rider based on their day and hub type
  static Future<GetTutorialsResponse?> getTutorials(String riderId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get-tutorials?rider_id=$riderId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return GetTutorialsResponse.fromJson(data);
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching tutorials: $e');
      return null;
    }
  }

  // Update tutorial state (mark as completed/incomplete)
  static Future<bool> updateTutorialState(String riderId, String tutorialId, bool isDone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tutorial-state'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'rider_id': riderId,
          'tutorial_id': tutorialId,
          'isDone': isDone,
          'action': 'update',
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating tutorial state: $e');
      return false;
    }
  }

  // Create a new tutorial
  static Future<bool> createTutorial(String id, String title, {String subtitle = '', String description = ''}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tutorials'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'create',
          'id': id,
          'title': title,
          'subtitle': subtitle,
          'description': description,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error creating tutorial: $e');
      return false;
    }
  }

  // Get all tutorials
  static Future<List<Tutorial>?> getAllTutorials() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/tutorials'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'get',
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data']['tutorials'] != null) {
          return (data['data']['tutorials'] as List<dynamic>)
              .map((tutorial) => Tutorial.fromJson(tutorial))
              .toList();
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching all tutorials: $e');
      return null;
    }
  }

  // Create day-hub-tutorial mappings
  static Future<bool> createDayHubMappings(int day, String hubType, List<String> tutorialIds) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/day-hub-mappings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'create',
          'day': day,
          'hub_type': hubType,
          'tutorial_ids': tutorialIds,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error creating day-hub mappings: $e');
      return false;
    }
  }

  // Get day-hub-tutorial mappings
  static Future<List<Map<String, dynamic>>?> getDayHubMappings({int? day, String? hubType}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/day-hub-mappings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'get',
          'day': day,
          'hub_type': hubType,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data']['mappings'] != null) {
          return List<Map<String, dynamic>>.from(data['data']['mappings']);
        }
      }
      return null;
    } catch (e) {
      debugPrint('Error fetching day-hub mappings: $e');
      return null;
    }
  }
}
