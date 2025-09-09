import 'package:flutter/material.dart';
import 'blitznow_app_mock.dart';

class OrderSimulation extends StatefulWidget {
  final VoidCallback? onSimulationCompleted;
  
  const OrderSimulation({super.key, this.onSimulationCompleted});

  @override
  State<OrderSimulation> createState() => _OrderSimulationState();
}

class _OrderSimulationState extends State<OrderSimulation> {
  bool _isSimulationCompleted = false;

  @override
  Widget build(BuildContext context) {
    if (_isSimulationCompleted) {
      return _buildCompletionScreen();
    }
    
    return _buildSimulationIntro();
  }

  Widget _buildSimulationIntro() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.phone_android, color: Colors.blue[700], size: 30),
              const SizedBox(width: 12),
              Text(
                'BlitzNow App Simulation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          const Text(
            'Experience the real BlitzNow delivery partner app!',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          const Text(
            'This simulation will show you exactly how the BlitzNow app works:',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          
          _buildFeatureItem('📱 Real app interface with tabs and navigation'),
          _buildFeatureItem('📦 Order management and acceptance flow'),
          _buildFeatureItem('💰 Live earnings tracking and COD management'),
          _buildFeatureItem('🚚 Complete delivery process simulation'),
          _buildFeatureItem('👤 Profile management and settings'),
          
          const SizedBox(height: 20),
          
          const Text(
            'You\'ll complete 3 realistic delivery orders just like a real BlitzNow partner!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
          
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _startAppSimulation,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E3A8A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Launch BlitzNow App',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCompletionScreen() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle,
            size: 60,
            color: Colors.green,
          ),
          const SizedBox(height: 16),
          const Text(
            'Order Simulation Completed! 🎉',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'You have successfully completed all test orders.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'You are now ready for delivery!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _startAppSimulation() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlitzNowAppMock(
          onTrainingCompleted: () {
            Navigator.of(context).pop();
            setState(() {
              _isSimulationCompleted = true;
            });
            widget.onSimulationCompleted?.call();
          },
        ),
      ),
    );
  }
}
