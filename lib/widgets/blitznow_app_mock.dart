import 'package:flutter/material.dart';

class BlitzNowAppMock extends StatefulWidget {
  final VoidCallback? onTrainingCompleted;
  
  const BlitzNowAppMock({super.key, this.onTrainingCompleted});

  @override
  State<BlitzNowAppMock> createState() => _BlitzNowAppMockState();
}

class _BlitzNowAppMockState extends State<BlitzNowAppMock> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Mock data
  final List<Map<String, dynamic>> _orders = [
    {
      'id': 'BLZ001',
      'customer': 'Rajesh Kumar',
      'phone': '+91 98765 43210',
      'address': '123 MG Road, Bangalore 560001',
      'landmark': 'Near Metro Station',
      'items': 'Electronics - iPhone 15 Pro',
      'amount': 125000,
      'type': 'COD',
      'instructions': 'Call before delivery, ID proof required',
      'distance': '2.5 km',
      'estimatedTime': '15 mins',
      'status': 'pending',
      'createdAt': '2025-01-03 14:30:00',
    },
    {
      'id': 'BLZ002',
      'customer': 'Priya Sharma',
      'phone': '+91 87654 32109',
      'address': '456 Brigade Road, Bangalore 560025',
      'landmark': 'Above Cafe Coffee Day',
      'items': 'Clothing - 2 T-shirts, 1 Jeans',
      'amount': 2500,
      'type': 'Prepaid',
      'instructions': 'Leave at reception if not available',
      'distance': '1.8 km',
      'estimatedTime': '12 mins',
      'status': 'pending',
      'createdAt': '2025-01-03 14:45:00',
    },
    {
      'id': 'BLZ003',
      'customer': 'Amit Singh',
      'phone': '+91 76543 21098',
      'address': '789 Koramangala 5th Block, Bangalore 560034',
      'landmark': 'Near Forum Mall',
      'items': 'Food - Pizza, Burger, Drinks',
      'amount': 850,
      'type': 'COD',
      'instructions': 'Deliver hot, call 5 mins before arrival',
      'distance': '3.2 km',
      'estimatedTime': '20 mins',
      'status': 'pending',
      'createdAt': '2025-01-03 15:00:00',
    },
  ];

  double _totalEarnings = 0.0;
  int _completedOrders = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E3A8A),
      foregroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'B',
                style: TextStyle(
                  color: Color(0xFF1E3A8A),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BlitzNow',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Delivery Partner',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBody() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildHomeScreen(),
        _buildOrdersScreen(),
        _buildEarningsScreen(),
        _buildProfileScreen(),
      ],
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ready to deliver? You have ${_orders.length} orders waiting',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard('Today\'s Earnings', '₹${_totalEarnings.toStringAsFixed(0)}', Icons.currency_rupee),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard('Orders Done', '$_completedOrders', Icons.local_shipping),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Start Delivery',
                  Icons.play_arrow,
                  Colors.green,
                  () => _startDelivery(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  'View Orders',
                  Icons.list_alt,
                  Colors.blue,
                  () => _tabController.animateTo(1),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Recent Orders
          const Text(
            'Recent Orders',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 12),
          ..._orders.take(2).map((order) => _buildOrderCard(order, isCompact: true)),
        ],
      ),
    );
  }

  Widget _buildOrdersScreen() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildEarningsScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Earnings Summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const Text(
                  'Today\'s Earnings',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '₹${_totalEarnings.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildEarningsItem('Orders', '$_completedOrders', Icons.local_shipping),
                    _buildEarningsItem('Avg/Order', '₹${_completedOrders > 0 ? (_totalEarnings / _completedOrders).toStringAsFixed(0) : '0'}', Icons.trending_up),
                    _buildEarningsItem('COD', '₹0', Icons.money),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Earnings History
          const Text(
            'Earnings History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3A8A),
            ),
          ),
          const SizedBox(height: 12),
          _buildEarningsHistory(),
        ],
      ),
    );
  }

  Widget _buildProfileScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Color(0xFF1E3A8A),
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Rider ID: 478',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Central Hub',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildProfileStat('Orders', '$_completedOrders'),
                    _buildProfileStat('Earnings', '₹${_totalEarnings.toStringAsFixed(0)}'),
                    _buildProfileStat('Rating', '4.8'),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Settings
          _buildSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, {bool isCompact = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order['id']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
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
          const SizedBox(height: 8),
          Text(
            order['customer'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            order['address'],
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          if (!isCompact) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(order['phone'], style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 16),
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text('${order['distance']} • ${order['estimatedTime']}', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Items: ${order['items']}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Amount: ₹${order['amount']}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            if (order['instructions'].isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        order['instructions'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptOrder(order),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Accept Order'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectOrder(order),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEarningsHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEarningsHistoryItem('Order #BLZ001', '₹150', '2:30 PM'),
          _buildEarningsHistoryItem('Order #BLZ002', '₹120', '1:45 PM'),
          _buildEarningsHistoryItem('Order #BLZ003', '₹180', '12:20 PM'),
        ],
      ),
    );
  }

  Widget _buildEarningsHistoryItem(String order, String amount, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E3A8A),
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildSettingsItem('Edit Profile', Icons.person_outline, () {}),
          _buildSettingsItem('Notification Settings', Icons.notifications_outlined, () {}),
          _buildSettingsItem('Help & Support', Icons.help_outline, () {}),
          _buildSettingsItem('Logout', Icons.logout, () => _logout()),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF1E3A8A)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF1E3A8A),
        unselectedLabelColor: Colors.grey,
        indicatorColor: const Color(0xFF1E3A8A),
        tabs: const [
          Tab(icon: Icon(Icons.home), text: 'Home'),
          Tab(icon: Icon(Icons.list_alt), text: 'Orders'),
          Tab(icon: Icon(Icons.currency_rupee), text: 'Earnings'),
          Tab(icon: Icon(Icons.person), text: 'Profile'),
        ],
      ),
    );
  }

  void _startDelivery() {
    _tabController.animateTo(1);
  }

  void _acceptOrder(Map<String, dynamic> order) {
    setState(() {
      order['status'] = 'accepted';
    });
    
    // Show delivery flow
    _showDeliveryFlow(order);
  }

  void _rejectOrder(Map<String, dynamic> order) {
    setState(() {
      order['status'] = 'rejected';
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${order['id']} rejected'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showDeliveryFlow(Map<String, dynamic> order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _DeliveryFlowDialog(
        order: order,
        onCompleted: () {
          setState(() {
            _totalEarnings += 150.0; // Mock earnings
            _completedOrders++;
            order['status'] = 'completed';
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order completed! Earnings: ₹150'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  void _logout() {
    widget.onTrainingCompleted?.call();
  }
}

class _DeliveryFlowDialog extends StatefulWidget {
  final Map<String, dynamic> order;
  final VoidCallback onCompleted;

  const _DeliveryFlowDialog({
    required this.order,
    required this.onCompleted,
  });

  @override
  State<_DeliveryFlowDialog> createState() => _DeliveryFlowDialogState();
}

class _DeliveryFlowDialogState extends State<_DeliveryFlowDialog> {
  int _currentStep = 0;
  
  final List<String> _steps = [
    'Navigate to pickup location',
    'Pick up order from merchant',
    'Navigate to delivery location',
    'Call customer',
    'Deliver order and collect payment',
    'Mark delivery as completed',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Order #${widget.order['id']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
              ),
            ),
            const SizedBox(height: 20),
            
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / _steps.length,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF1E3A8A)),
            ),
            const SizedBox(height: 20),
            
            // Current step
            Text(
              _steps[_currentStep],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Order details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Customer: ${widget.order['customer']}'),
                  Text('Address: ${widget.order['address']}'),
                  Text('Amount: ₹${widget.order['amount']}'),
                  if (widget.order['type'] == 'COD')
                    const Text('Payment: Cash on Delivery'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Action buttons
            Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                        });
                      },
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentStep < _steps.length - 1) {
                        setState(() {
                          _currentStep++;
                        });
                      } else {
                        Navigator.of(context).pop();
                        widget.onCompleted();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_currentStep < _steps.length - 1 ? 'Next' : 'Complete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
