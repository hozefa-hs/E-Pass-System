import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/validation_result.dart';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';
import '../widgets/loading_button.dart';

class TicketCheckerScreen extends StatefulWidget {
  const TicketCheckerScreen({super.key});

  @override
  State<TicketCheckerScreen> createState() => _TicketCheckerScreenState();
}

class _TicketCheckerScreenState extends State<TicketCheckerScreen> {
  final TextEditingController _passIdController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  ValidationResult? _validationResult;

  Future<void> _validatePass() async {
    if (_passIdController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a pass ID';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _validationResult = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final apiService = ApiService();

      final result = await apiService.validatePass(
        authProvider.user!.token,
        _passIdController.text.trim(),
      );

      setState(() {
        _validationResult = result;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to validate pass: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetValidation() {
    setState(() {
      _validationResult = null;
      _errorMessage = null;
      _passIdController.clear();
    });
  }

  MaterialColor _getResultColor() {
    if (_validationResult == null) return Colors.grey;

    switch (_validationResult!.displayColor) {
      case 'green':
        return Colors.green;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getResultIcon() {
    if (_validationResult == null) return Icons.search;

    if (_validationResult!.valid) {
      return Icons.check_circle;
    } else if (_validationResult!.status?.toString() == 'PassStatus.PENDING') {
      return Icons.hourglass_empty;
    } else {
      return Icons.cancel;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Checker'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.confirmation_number,
                              color: Colors.blue, size: 24),
                          SizedBox(width: 8),
                          Text(
                            'Pass Validation',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Enter pass ID to validate passenger travel eligibility',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Input Section
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Pass ID',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _passIdController,
                        decoration: const InputDecoration(
                          hintText: 'Enter pass ID',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge),
                        ),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: LoadingButton(
                              text: 'Validate pass',
                              onPressed: _validatePass,
                              isLoading: _isLoading,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (_validationResult != null)
                            IconButton(
                              onPressed: _resetValidation,
                              icon: const Icon(Icons.refresh),
                              tooltip: 'New Validation',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Error Message
              if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error, color: Colors.red.shade600),
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

              // Validation Result
              if (_validationResult != null) ...[
                const SizedBox(height: 24),
                _buildValidationResult(),
              ],
              const SizedBox(height: 20), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidationResult() {
    final result = _validationResult!;
    final color = _getResultColor();

    return Card(
      elevation: 8,
      color: color.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Status Icon and Title
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: color.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getResultIcon(),
                color: color.shade700,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),

            // Title and Subtitle
            Text(
              result.displayTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              result.displaySubtitle,
              style: TextStyle(
                fontSize: 16,
                color: color.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Pass Details
            if (result.passType != null && result.passDuration != null) ...[
              const Divider(),
              const SizedBox(height: 12),
              _buildDetailRow('Pass Type', result.passType!.displayName),
              const SizedBox(height: 8),
              _buildDetailRow('Duration', result.passDuration!.displayName),
              if (result.status != null) ...[
                const SizedBox(height: 8),
                _buildDetailRow('Status', result.status!.displayName),
              ],
              const SizedBox(height: 8),
              _buildDetailRow('Pass ID', result.passId),
              const SizedBox(height: 8),
              _buildDetailRow('Validated At', result.validatedAt),
            ],

            // Message
            if (result.message.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: color.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.message,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: color.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passIdController.dispose();
    super.dispose();
  }
}
