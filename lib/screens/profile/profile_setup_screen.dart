import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:peace/models/user.dart';
import 'package:peace/services/firestore_service.dart';
import 'package:peace/services/user_profile_service.dart';
import 'package:peace/screens/home_screen.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();
  final _userProfileService = UserProfileService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactController;

  String _selectedGender = '';
  String _selectedContactMethod = '';

  bool _isSaving = false;
  int _currentStep = 0;

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say',
  ];
  final List<String> _contactMethods = ['Email', 'Phone', 'SMS', 'WhatsApp'];

  @override
  void initState() {
    super.initState();
    // Initialize with phone number if available
    final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController(
      text: currentUser?.phoneNumber ?? '',
    );
    _ageController = TextEditingController();
    _emergencyContactNameController = TextEditingController();
    _emergencyContactController = TextEditingController();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGender.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your gender'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedContactMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your preferred contact method'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user logged in');
      }

      final result = await _firestoreService.updateUserProfile(
        uid: currentUser.uid,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        age: _ageController.text.trim(),
        gender: _selectedGender,
        emergencyContact: _emergencyContactController.text.trim(),
        emergencyContactName: _emergencyContactNameController.text.trim(),
        preferredContactMethod: _selectedContactMethod,
      );

      if (result == 'SUCCESS') {
        // Update global user object
        user.name = _nameController.text.trim();
        user.email = _emailController.text.trim();
        user.phoneNumber = _phoneController.text.trim();
        user.age = _ageController.text.trim();
        user.gender = _selectedGender;
        user.emergencyContact = _emergencyContactController.text.trim();
        user.emergencyContactName = _emergencyContactNameController.text.trim();
        user.preferredContactMethod = _selectedContactMethod;
        user.uid = currentUser.uid;

        // Load the complete profile
        await _userProfileService.loadUserProfile();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile created successfully! Welcome to Peace.'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to home screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } else {
        throw Exception(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating profile: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate basic info
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
        return;
      }
      if (_emailController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your email')),
        );
        return;
      }
      if (!_emailController.text.contains('@')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email')),
        );
        return;
      }
      if (_ageController.text.trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Please enter your age')));
        return;
      }
      if (_selectedGender.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender')),
        );
        return;
      }
      setState(() => _currentStep = 1);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primaryContainer,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_circle_outlined,
                          color: theme.colorScheme.onPrimary,
                          size: height * 0.04,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Complete Your Profile',
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontSize: height * 0.028,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Help us get to know you better',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.9,
                        ),
                        fontSize: height * 0.018,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Progress indicator
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: _currentStep >= 0
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: _currentStep >= 1
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Step ${_currentStep + 1} of 2',
                      style: TextStyle(
                        color: theme.colorScheme.onPrimary.withValues(
                          alpha: 0.8,
                        ),
                        fontSize: height * 0.016,
                      ),
                    ),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: _currentStep == 0
                        ? _buildBasicInfoStep(height, theme)
                        : _buildEmergencyContactStep(height, theme),
                  ),
                ),
              ),

              // Bottom buttons
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _previousStep,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: theme.colorScheme.primary),
                          ),
                          child: const Text('Back'),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      flex: _currentStep > 0 ? 1 : 1,
                      child: ElevatedButton(
                        onPressed: _isSaving
                            ? null
                            : (_currentStep == 1 ? _saveProfile : _nextStep),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isSaving
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                _currentStep == 1 ? 'Complete Setup' : 'Next',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoStep(double height, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: height * 0.024,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Let us know who you are',
          style: TextStyle(
            fontSize: height * 0.018,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 24),

        // Name field
        _buildTextField(
          controller: _nameController,
          label: 'Full Name',
          icon: Icons.person_outline,
          hint: 'Enter your full name',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Email field
        _buildTextField(
          controller: _emailController,
          label: 'Email',
          icon: Icons.email_outlined,
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your email';
            }
            if (!value.contains('@') || !value.contains('.')) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Phone field (read-only, already set from login)
        _buildTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          hint: 'Your phone number',
          enabled: false,
        ),
        const SizedBox(height: 20),

        // Age field
        _buildTextField(
          controller: _ageController,
          label: 'Age',
          icon: Icons.cake_outlined,
          hint: 'Enter your age',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your age';
            }
            final age = int.tryParse(value);
            if (age == null || age < 1 || age > 120) {
              return 'Please enter a valid age';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Gender selection
        Text(
          'Gender',
          style: TextStyle(
            fontSize: height * 0.02,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _genderOptions.map((gender) {
            final isSelected = _selectedGender == gender;
            return ChoiceChip(
              label: Text(gender),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedGender = selected ? gender : '';
                });
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEmergencyContactStep(double height, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emergency Contact',
          style: TextStyle(
            fontSize: height * 0.024,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'This information helps us reach someone in case of emergency',
          style: TextStyle(
            fontSize: height * 0.018,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 24),

        // Emergency contact name
        _buildTextField(
          controller: _emergencyContactNameController,
          label: 'Emergency Contact Name',
          icon: Icons.person_add_outlined,
          hint: 'Name of emergency contact',
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter emergency contact name';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Emergency contact number
        _buildTextField(
          controller: _emergencyContactController,
          label: 'Emergency Contact Number',
          icon: Icons.phone_outlined,
          hint: 'Phone number',
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter emergency contact number';
            }
            if (value.length < 10) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
        const SizedBox(height: 20),

        // Preferred contact method
        Text(
          'Preferred Contact Method',
          style: TextStyle(
            fontSize: height * 0.02,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _contactMethods.map((method) {
            final isSelected = _selectedContactMethod == method;
            return ChoiceChip(
              label: Text(method),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedContactMethod = selected ? method : '';
                });
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}
