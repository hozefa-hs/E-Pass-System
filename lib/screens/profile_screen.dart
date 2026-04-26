import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/profile_data.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  ProfileData? _profileData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final apiService = ApiService();
      
      final profileData = await apiService.getUserProfile(authProvider.user!.token);
      setState(() {
        _profileData = profileData;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load profile: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadProfile,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, size: 64, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadProfile,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                : _profileData == null
                    ? const Center(
                        child: Text('No profile data available'),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Header Card
                            Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  children: [
                                    // Avatar
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: _profileData!.isActive ? Colors.green : Colors.red,
                                      child: Icon(
                                        Icons.person,
                                        size: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    // Email
                                    Text(
                                      _profileData!.email,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Role Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _profileData!.roleDisplayName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Status Badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _profileData!.isActive ? Colors.green : Colors.red,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        _profileData!.statusText,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Account Details Card
                            Card(
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Account Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    
                                    _buildDetailRow(
                                      'User ID',
                                      _profileData!.id,
                                      Icons.badge,
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    _buildDetailRow(
                                      'Email',
                                      _profileData!.email,
                                      Icons.email,
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    _buildDetailRow(
                                      'Role',
                                      _profileData!.roleDisplayName,
                                      Icons.assignment_ind,
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    _buildDetailRow(
                                      'Account Status',
                                      _profileData!.statusText,
                                      _profileData!.isActive ? Icons.check_circle : Icons.cancel,
                                      color: _profileData!.isActive ? Colors.green : Colors.red,
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    _buildDetailRow(
                                      'Account Created',
                                      _profileData!.formattedCreatedAt,
                                      Icons.calendar_today,
                                    ),
                                    const SizedBox(height: 12),
                                    
                                    _buildDetailRow(
                                      'Last Login',
                                      _profileData!.formattedLastLogin,
                                      Icons.access_time,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            
                            // Info Card
                            Card(
                              elevation: 2,
                              color: Colors.blue.shade50,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        'This is your profile information. Contact support if you need to update your details.',
                                        style: TextStyle(
                                          color: Colors.blue.shade700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, {Color? color}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color ?? Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
