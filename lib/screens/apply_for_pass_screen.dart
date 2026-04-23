import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/pass.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/loading_button.dart';
import 'document_upload_screen.dart';

class ApplyForPassScreen extends StatefulWidget {
  const ApplyForPassScreen({Key? key}) : super(key: key);

  @override
  State<ApplyForPassScreen> createState() => _ApplyForPassScreenState();
}

class _ApplyForPassScreenState extends State<ApplyForPassScreen> {
  PassType? _selectedPassType;
  PassDuration? _selectedDuration;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _applyForPass() async {
    if (_selectedPassType == null || _selectedDuration == null) {
      setState(() {
        _errorMessage = 'Please select pass type and duration';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final apiService = ApiService();
      
      final request = PassRequest(
        passType: _selectedPassType!,
        duration: _selectedDuration!,
      );

      // Apply for pass
      final pass = await apiService.applyForPass(authProvider.user!.token, request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pass application submitted! Please upload required photo.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Auto-redirect to document upload screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DocumentUploadScreen(pass: pass),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('ApiException: ', '');
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
        title: const Text('Apply for Pass'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.card_membership,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Apply for Bus Pass',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 8),
              
              const Text(
                'Select your pass type and duration',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              
              const Text(
                'Photo will be required on the next screen',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.orange,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 24),

              // Pass Type Selection
              const Text(
                'Pass Type',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              ...PassType.values.map((type) {
                return RadioListTile<PassType>(
                  title: Text(type.displayName),
                  subtitle: Text(_getPassTypeDescription(type)),
                  value: type,
                  groupValue: _selectedPassType,
                  onChanged: (PassType? value) {
                    setState(() {
                      _selectedPassType = value;
                    });
                  },
                  activeColor: Colors.blue,
                );
              }).toList(),
              
              const SizedBox(height: 24),

              // Duration Selection
              const Text(
                'Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              ...PassDuration.values.map((duration) {
                return RadioListTile<PassDuration>(
                  title: Text(duration.displayName),
                  subtitle: Text(_getDurationDescription(duration)),
                  value: duration,
                  groupValue: _selectedDuration,
                  onChanged: (PassDuration? value) {
                    setState(() {
                      _selectedDuration = value;
                    });
                  },
                  activeColor: Colors.blue,
                );
              }).toList(),
              
              const SizedBox(height: 32),

              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade200),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),

              LoadingButton(
                text: 'Submit Application',
                onPressed: _applyForPass,
                isLoading: _isLoading,
              ),
              
              const SizedBox(height: 16),
              
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.blue, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Important Information',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '· One active pass per user\n'
                        '· Student Pass: 40% discount (College ID required)\n'
                        '· Senior Citizen: Free travel (Age proof required)\n'
                        '· Corporate Pass: Fixed price (Company letter required)\n'
                        '· Photo upload required on next screen\n'
                        '· Photo must be PNG, JPG, or JPEG (max 5MB)',
                        style: const TextStyle(fontSize: 13),
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

  String _getPassTypeDescription(PassType type) {
    switch (type) {
      case PassType.STUDENT:
        return '40% discount on tickets';
      case PassType.SENIOR_CITIZEN:
        return 'Free travel';
      case PassType.CORPORATE:
        return 'Fixed price pass';
    }
  }

  String _getDurationDescription(PassDuration duration) {
    switch (duration) {
      case PassDuration.ONE_MONTH:
        return 'Valid for 1 month';
      case PassDuration.THREE_MONTHS:
        return 'Valid for 3 months';
      case PassDuration.SIX_MONTHS:
        return 'Valid for 6 months';
    }
  }
}
