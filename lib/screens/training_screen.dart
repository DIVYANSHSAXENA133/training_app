import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/training_provider.dart';
import '../models/training_module.dart';
import '../widgets/attendance_check.dart';
import '../widgets/order_simulation.dart';

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({super.key});

  @override
  State<TrainingScreen> createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  bool _attendanceMarked = false;
  bool _orderSimulationCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlitzNow Training'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Consumer<TrainingProvider>(
        builder: (context, provider, child) {
          if (provider.currentModule == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final module = provider.currentModule!;
          final rider = provider.currentRider;
        if (rider == null) return const Center(child: CircularProgressIndicator());

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Rider Info
                _buildRiderInfoCard(rider, module),
                
                const SizedBox(height: 20),
                
                // Progress Bar
                _buildProgressBar(provider),
                
                const SizedBox(height: 20),
                
                // Training Content
                _buildTrainingContent(module, provider),
                
                const SizedBox(height: 20),
                
                // Action Buttons
                _buildActionButtons(provider, module),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRiderInfoCard(dynamic rider, TrainingModule module) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF1E3A8A),
                  child: Text(
                    rider.riderId?.toString().substring(0, 2).toUpperCase() ?? 'ID',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Rider ID: ${rider.riderId}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Module: ${module.moduleType.toString().split('.').last}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Day: ${module.dayType.toString().split('.').last}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(TrainingProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Joining Bonus Progress',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDayProgress(provider, 'day1', 'Day 1', 500.0),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDayProgress(provider, 'day2', 'Day 2', 500.0),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDayProgress(provider, 'day3', 'Day 3', 500.0),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Total Earned: ₹${provider.getTotalJoiningBonus()}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayProgress(TrainingProvider provider, String day, String label, double amount) {
    final isCompleted = provider.isDayCompleted(day);
    final isStarted = provider.isDayStarted(day);
    
    return Column(
      children: [
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted 
                ? Colors.green 
                : isStarted 
                    ? Colors.orange 
                    : Colors.grey[300],
          ),
          child: Icon(
            isCompleted 
                ? Icons.check 
                : isStarted 
                    ? Icons.pending 
                    : Icons.schedule,
            color: isCompleted || isStarted ? Colors.white : Colors.grey,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
        Text(
          '₹$amount',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isCompleted ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildTrainingContent(TrainingModule module, TrainingProvider provider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              module.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              module.description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            
            // Training Content
            const Text(
              'Training Content:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...module.content.map((line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                line,
                style: const TextStyle(fontSize: 16),
              ),
            )),
            
            const SizedBox(height: 20),
            
            // Tasks
            const Text(
              'Today\'s Tasks:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...module.tasks.map((task) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: Colors.grey),
                  const SizedBox(width: 12),
                  Expanded(child: Text(task, style: const TextStyle(fontSize: 16))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(TrainingProvider provider, TrainingModule module) {
    final day = module.dayType.toString().split('.').last;
    final isStarted = provider.isDayStarted(day);
    final isCompleted = provider.isDayCompleted(day);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!isStarted) ...[
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _startModule(provider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E3A8A),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Start Day $day Training',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ] else if (!isCompleted) ...[
              // Attendance Check
              if (!_attendanceMarked) ...[
                const Text(
                  'Mark Your Attendance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                AttendanceCheck(
                  onAttendanceMarked: () {
                    setState(() {
                      _attendanceMarked = true;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
              
              // Order Simulation (only for Day 1)
              if (_attendanceMarked && !_orderSimulationCompleted && module.dayType.toString().split('.').last == 'day1') ...[
                const Text(
                  'Order Simulation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                OrderSimulation(
                  onSimulationCompleted: () {
                    setState(() {
                      _orderSimulationCompleted = true;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
              
              // Complete Module Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _canCompleteTraining(module) ? () => _completeModule(provider) : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Complete Day $day Training',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 30),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Day $day Training Completed! 🎉',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _startModule(TrainingProvider provider) async {
    final success = await provider.startModule();
    if (success && mounted) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Training started successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _completeModule(TrainingProvider provider) async {
    final success = await provider.completeModule();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Training completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  bool _canCompleteTraining(TrainingModule module) {
    final day = module.dayType.toString().split('.').last;
    
    // For Day 1, both attendance and order simulation must be completed
    if (day == 'day1') {
      return _attendanceMarked && _orderSimulationCompleted;
    }
    
    // For other days, only attendance is required
    return _attendanceMarked;
  }

  void _logout(BuildContext context) {
    context.read<TrainingProvider>().clearRider();
    Navigator.pushReplacementNamed(context, '/');
  }
}
