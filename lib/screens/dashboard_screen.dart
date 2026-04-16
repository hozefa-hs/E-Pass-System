import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/user.dart';
import 'apply_for_pass_screen.dart';
import 'my_pass_screen.dart';
import 'admin_pass_requests_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final user = authProvider.user;
          
          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: _getRoleColor(user.role),
                              child: Icon(
                                _getRoleIcon(user.role),
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.email,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Role: ${user.role.toString().split('.').last}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
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
                ),
                const SizedBox(height: 24),

                // Quick Actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: _buildActionCards(context, user.role),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildActionCards(BuildContext context, Role role) {
    List<Widget> cards = [];

    // Common cards for all roles
    cards.add(_buildActionCard(
      context,
      'View Profile',
      Icons.person,
      Colors.blue,
      () {
        // TODO: Navigate to profile screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile screen coming soon')),
        );
      },
    ));

    // Role-specific cards
    switch (role) {
      case Role.PASSENGER:
        cards.addAll([
          _buildActionCard(
            context,
            'Apply for Pass',
            Icons.card_membership,
            Colors.green,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ApplyForPassScreen(),
                ),
              );
            },
          ),
          _buildActionCard(
            context,
            'My Pass',
            Icons.credit_card,
            Colors.orange,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyPassScreen(),
                ),
              );
            },
          ),
          _buildActionCard(
            context,
            'Upload Documents',
            Icons.upload_file,
            Colors.purple,
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Document upload coming soon')),
              );
            },
          ),
        ]);
        break;
      case Role.ADMIN:
        cards.addAll([
          _buildActionCard(
            context,
            'Pass Requests',
            Icons.pending_actions,
            Colors.red,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminPassRequestsScreen(),
                ),
              );
            },
          ),
          _buildActionCard(
            context,
            'View Users',
            Icons.people,
            Colors.teal,
            () {
              // TODO: Navigate to users screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Users screen coming soon')),
              );
            },
          ),
        ]);
        break;
      case Role.TICKET_CHECKER:
        cards.add(_buildActionCard(
          context,
          'Validate Pass',
          Icons.qr_code_scanner,
          Colors.indigo,
          () {
            // TODO: Navigate to pass validation screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pass validation coming soon')),
            );
          },
        ));
        break;
    }

    return cards;
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(Role role) {
    switch (role) {
      case Role.PASSENGER:
        return Colors.blue;
      case Role.ADMIN:
        return Colors.red;
      case Role.TICKET_CHECKER:
        return Colors.orange;
    }
  }

  IconData _getRoleIcon(Role role) {
    switch (role) {
      case Role.PASSENGER:
        return Icons.person;
      case Role.ADMIN:
        return Icons.admin_panel_settings;
      case Role.TICKET_CHECKER:
        return Icons.verified_user;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
