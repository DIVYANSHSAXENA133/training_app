import 'package:flutter/foundation.dart';
import '../models/rider.dart';
import '../models/training_module.dart';
import '../models/training_progress.dart';
import '../services/api_service.dart';
import '../services/training_content_service.dart';

class TrainingProvider with ChangeNotifier {
  Rider? _currentRider;
  TrainingModule? _currentModule;
  TrainingProgress? _trainingProgress;
  bool _isLoading = false;
  String? _error;

  // Getters
  Rider? get currentRider => _currentRider;
  TrainingModule? get currentModule => _currentModule;
  TrainingProgress? get trainingProgress => _trainingProgress;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Set current rider and fetch info
  Future<bool> setRiderId(String riderId) async {
    _setLoading(true);
    _clearError();

    try {
      // Fetch rider info from backend
      final rider = await ApiService.getRiderInfo(riderId);
      print('rider: ${rider?.toJson()}');
      
      if (rider != null) {
        _currentRider = rider;
        
        // Determine which module to show based on rider age and node type
        final moduleType = _getModuleTypeFromNodeType(rider.nodeType);
        final dayType = _getDayTypeFromRiderAge(rider.riderAge);
        
        _currentModule = TrainingContentService.getModuleForRider(moduleType, dayType);
        
        // Initialize or fetch training progress
        await _initializeTrainingProgress(riderId);
        
        notifyListeners();
        return true;
      } else {
        _setError('Rider not found. Please check the Rider ID.');
        return false;
      }
    } catch (e) {
      _setError('Error fetching rider information: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Mark module as started
  Future<bool> startModule() async {
    if (_currentRider == null || _currentModule == null) return false;

    try {
      final day = _currentModule!.dayType.toString().split('.').last;
      final success = await ApiService.markModuleStarted(_currentRider!.riderId, day);
      
      if (success) {
        // Update local progress
        _updateLocalProgress(day, true, false);
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _setError('Error starting module: $e');
      return false;
    }
  }

  // Mark module as completed
  Future<bool> completeModule() async {
    if (_currentRider == null || _currentModule == null) return false;

    try {
      final day = _currentModule!.dayType.toString().split('.').last;
      final success = await ApiService.markModuleCompleted(_currentRider!.riderId, day);
      
      if (success) {
        // Update local progress
        _updateLocalProgress(day, true, true);
        notifyListeners();
      }
      
      return success;
    } catch (e) {
      _setError('Error completing module: $e');
      return false;
    }
  }

  // Get progress for specific day
  bool isDayCompleted(String day) {
    if (_trainingProgress == null) return false;
    return _trainingProgress!.moduleCompleted.containsKey(day) && 
           _trainingProgress!.moduleCompleted[day] != null;
  }

  bool isDayStarted(String day) {
    if (_trainingProgress == null) return false;
    return _trainingProgress!.moduleStarted.containsKey(day) && 
           _trainingProgress!.moduleStarted[day] != null;
  }

  // Get total joining bonus earned
  double getTotalJoiningBonus() {
    if (_trainingProgress == null) return 0.0;
    
    double total = 0.0;
    if (isDayCompleted('day1')) total += 500.0;
    if (isDayCompleted('day2')) total += 500.0;
    if (isDayCompleted('day3')) total += 500.0;
    
    return total;
  }

  // Helper methods
  ModuleType _getModuleTypeFromNodeType(String nodeType) {
    switch (nodeType.toLowerCase()) {
      case 'quick_hub':
      case 'quickhub':
        return ModuleType.quickHub;
      case 'lm_hub':
      case 'lmhub':
      case 'central_hub':
      case 'centralhub':
      default:
        return ModuleType.lmHub; // Default to LM Hub for central_hub and others
    }
  }

  DayType _getDayTypeFromRiderAge(int? riderAge) {
    // If rider_age is null or > 3, default to day 1
    if (riderAge == null || riderAge > 3) return DayType.day1;
    
    switch (riderAge) {
      case 1:
        return DayType.day1;
      case 2:
        return DayType.day2;
      case 3:
        return DayType.day3;
      default:
        return DayType.day1;
    }
  }

  Future<void> _initializeTrainingProgress(String riderId) async {
    // For now, create a new progress entry
    // In a real app, you'd fetch existing progress from backend
    _trainingProgress = TrainingProgress(
      riderId: riderId,
      moduleStarted: {},
      moduleCompleted: {},
      updatedAt: DateTime.now(),
    );
  }

  void _updateLocalProgress(String day, bool started, bool completed) {
    if (_trainingProgress == null) return;
    
    final now = DateTime.now().toIso8601String();
    
    if (started) {
      _trainingProgress!.moduleStarted[day] = now;
    }
    
    if (completed) {
      _trainingProgress!.moduleCompleted[day] = now;
    }
    
    _trainingProgress = _trainingProgress!.copyWith(updatedAt: DateTime.now());
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearRider() {
    _currentRider = null;
    _currentModule = null;
    _trainingProgress = null;
    _error = null;
    notifyListeners();
  }
}
