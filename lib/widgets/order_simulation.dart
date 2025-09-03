import 'package:flutter/material.dart';

class OrderSimulation extends StatefulWidget {
  final VoidCallback? onSimulationCompleted;
  
  const OrderSimulation({super.key, this.onSimulationCompleted});

  @override
  State<OrderSimulation> createState() => _OrderSimulationState();
}

class _OrderSimulationState extends State<OrderSimulation> {
  int _currentOrderIndex = 0;
  bool _isSimulationCompleted = false;
  
  final List<Map<String, dynamic>> _testOrders = [
    {
      'id': 'ORD001',
      'customer': 'Rajesh Kumar',
      'address': '123 MG Road, Bangalore',
      'items': 'Electronics - Mobile Phone',
      'amount': 25000,
      'type': 'COD',
      'instructions': 'Call before delivery',
    },
    {
      'id': 'ORD002', 
      'customer': 'Priya Sharma',
      'address': '456 Brigade Road, Bangalore',
      'items': 'Clothing - 2 T-shirts',
      'amount': 1200,
      'type': 'Prepaid',
      'instructions': 'Leave at reception if not available',
    },
    {
      'id': 'ORD003',
      'customer': 'Amit Singh',
      'address': '789 Koramangala, Bangalore',
      'items': 'Food - Pizza & Drinks',
      'amount': 450,
      'type': 'COD',
      'instructions': 'Deliver hot, call 5 mins before arrival',
    },
  ];

  @override
  Widget build(BuildContext context) {
    if (_isSimulationCompleted) {
      return _buildCompletionScreen();
    }
    
    return _buildOrderScreen();
  }

  Widget _buildOrderScreen() {
    final order = _testOrders[_currentOrderIndex];
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_shipping, color: Colors.green[700], size: 30),
              const SizedBox(width: 12),
              Text(
                'Test Order ${_currentOrderIndex + 1} of ${_testOrders.length}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          _buildOrderCard(order),
          
          const SizedBox(height: 20),
          
          _buildSimulationSteps(),
          
          const SizedBox(height: 20),
          
          Row(
            children: [
              if (_currentOrderIndex > 0)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _previousOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Previous Order'),
                  ),
                ),
              if (_currentOrderIndex > 0) const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _nextOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_currentOrderIndex == _testOrders.length - 1 
                      ? 'Complete Simulation' 
                      : 'Next Order'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ID: ${order['id']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order['type'] == 'COD' ? Colors.orange : Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order['type'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(Icons.person, 'Customer', order['customer']),
            _buildInfoRow(Icons.location_on, 'Address', order['address']),
            _buildInfoRow(Icons.shopping_bag, 'Items', order['items']),
            _buildInfoRow(Icons.currency_rupee, 'Amount', '₹${order['amount']}'),
            _buildInfoRow(Icons.info, 'Instructions', order['instructions']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationSteps() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simulation Steps:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          _buildStep('1. Navigate to delivery location', true),
          _buildStep('2. Call customer (if COD)', true),
          _buildStep('3. Collect payment (if COD)', true),
          _buildStep('4. Hand over package', true),
          _buildStep('5. Mark delivery as completed', true),
          _buildStep('6. Take customer photo (if required)', true),
        ],
      ),
    );
  }

  Widget _buildStep(String step, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: completed ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              step,
              style: TextStyle(
                fontSize: 14,
                color: completed ? Colors.green[700] : Colors.grey[600],
                decoration: completed ? TextDecoration.lineThrough : null,
              ),
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

  void _previousOrder() {
    if (_currentOrderIndex > 0) {
      setState(() {
        _currentOrderIndex--;
      });
    }
  }

  void _nextOrder() {
    if (_currentOrderIndex < _testOrders.length - 1) {
      setState(() {
        _currentOrderIndex++;
      });
    } else {
      setState(() {
        _isSimulationCompleted = true;
      });
      
      // Notify parent widget that simulation is completed
      widget.onSimulationCompleted?.call();
    }
  }
}
