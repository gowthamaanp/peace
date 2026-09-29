import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:peace/models/user.dart';
import 'package:peace/services/firestore_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = FirestoreService();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _ageController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactController;

  String _selectedGender = '';
  String _selectedContactMethod = '';

  bool _isLoading = false;
  bool _isSaving = false;

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
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phoneNumber);
    _ageController = TextEditingController(text: user.age);
    _emergencyContactNameController = TextEditingController(
      text: user.emergencyContactName,
    );
    _emergencyContactController = TextEditingController(
      text: user.emergencyContact,
    );
    _selectedGender = user.gender;
    _selectedContactMethod = user.preferredContactMethod;

    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userData = await _firestoreService.getUserProfile(
          currentUser.uid,
        );
        if (userData != null) {
          setState(() {
            _nameController.text = userData['name'] ?? user.name;
            _emailController.text = userData['email'] ?? user.email;
            _phoneController.text = userData['phoneNumber'] ?? user.phoneNumber;
            _ageController.text = userData['age'] ?? user.age;
            _selectedGender = userData['gender'] ?? user.gender;
            _emergencyContactNameController.text =
                userData['emergencyContactName'] ?? user.emergencyContactName;
            _emergencyContactController.text =
                userData['emergencyContact'] ?? user.emergencyContact;
            _selectedContactMethod =
                userData['preferredContactMethod'] ??
                user.preferredContactMethod;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
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

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context, true); // Return true to indicate success
        }
      } else {
        throw Exception(result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      setState(() => _isSaving = false);
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

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.white,
                    size: height * 0.04,
                  ),
                ),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_isSaving)
                  const Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          // Profile Picture Section
                          Center(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.blue.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: height * 0.08,
                                    backgroundColor: Colors.blue.shade100,
                                    child: Icon(
                                      Icons.person,
                                      size: height * 0.1,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Profile picture update coming soon!',
                                        ),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.camera_alt),
                                  label: const Text('Change Photo'),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Personal Information Section
                          _sectionHeader(
                            'Personal Information',
                            Icons.person_outline,
                            height,
                          ),
                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: _nameController,
                            label: 'Full Name',
                            icon: Icons.person,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!RegExp(
                                  r'^\+?[0-9]{10,15}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: _ageController,
                            label: 'Age',
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                final age = int.tryParse(value);
                                if (age == null || age < 1 || age > 150) {
                                  return 'Please enter a valid age';
                                }
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _buildDropdownField(
                            label: 'Gender',
                            icon: Icons.wc,
                            value: _selectedGender.isEmpty
                                ? null
                                : _selectedGender,
                            items: _genderOptions,
                            onChanged: (value) {
                              setState(() {
                                _selectedGender = value ?? '';
                              });
                            },
                          ),

                          const SizedBox(height: 30),

                          // Contact Preferences
                          _sectionHeader(
                            'Contact Preferences',
                            Icons.notifications_outlined,
                            height,
                          ),
                          const SizedBox(height: 15),

                          _buildDropdownField(
                            label: 'Preferred Contact Method',
                            icon: Icons.forum,
                            value: _selectedContactMethod.isEmpty
                                ? null
                                : _selectedContactMethod,
                            items: _contactMethods,
                            onChanged: (value) {
                              setState(() {
                                _selectedContactMethod = value ?? '';
                              });
                            },
                          ),

                          const SizedBox(height: 30),

                          // Emergency Contact Section
                          _sectionHeader(
                            'Emergency Contact',
                            Icons.emergency_outlined,
                            height,
                          ),
                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: _emergencyContactNameController,
                            label: 'Emergency Contact Name',
                            icon: Icons.person_pin,
                            validator: (value) {
                              // Optional field
                              return null;
                            },
                          ),

                          const SizedBox(height: 15),

                          _buildTextField(
                            controller: _emergencyContactController,
                            label: 'Emergency Contact Number',
                            icon: Icons.phone_in_talk,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!RegExp(
                                  r'^\+?[0-9]{10,15}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid phone number';
                                }
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 30),

                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isSaving ? null : _saveProfile,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade700,
                                disabledBackgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              child: _isSaving
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontSize: height * 0.025,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon, double height) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue, size: height * 0.03),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            fontSize: height * 0.025,
            fontWeight: FontWeight.w600,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        fillColor: Colors.transparent,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.blue.shade700),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        fillColor: Colors.transparent,
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }
}
