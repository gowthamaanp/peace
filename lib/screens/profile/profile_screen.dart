import 'package:flutter/material.dart';
import 'package:peace/models/user.dart';
import 'package:peace/screens/profile/edit_profile_screen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: <Widget>[
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
              children: <Widget>[
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
                  'My Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfilePage(),
                      ),
                    );
                    // Refresh the profile page if data was updated
                    if (result == true) {
                      setState(() {});
                    }
                  },
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Colors.white,
                    size: height * 0.035,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  // Profile Picture Section
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
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
                      SizedBox(height: 15),
                      Text(
                        user.name.isNotEmpty ? user.name : "User Name",
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: height * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      if (user.email.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            user.email,
                            style: TextStyle(
                              fontSize: height * 0.022,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Personal Information Section
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader(
                          'Personal Information',
                          Icons.person_outline,
                          height,
                        ),
                        SizedBox(height: 15),
                        _buildInfoCard(context, [
                          if (user.age.isNotEmpty)
                            _infoRow(
                              'Age',
                              user.age,
                              Icons.cake_outlined,
                              height,
                            ),
                          if (user.gender.isNotEmpty)
                            _infoRow(
                              'Gender',
                              user.gender,
                              Icons.wc_outlined,
                              height,
                            ),
                          if (user.phoneNumber.isNotEmpty)
                            _infoRow(
                              'Phone Number',
                              user.phoneNumber,
                              Icons.phone_outlined,
                              height,
                            ),
                        ]),

                        SizedBox(height: 25),

                        // Contact Preferences
                        _sectionHeader(
                          'Contact Preferences',
                          Icons.notifications_outlined,
                          height,
                        ),
                        SizedBox(height: 15),
                        _buildInfoCard(context, [
                          if (user.preferredContactMethod.isNotEmpty)
                            _infoRow(
                              'Preferred Method',
                              user.preferredContactMethod,
                              Icons.forum_outlined,
                              height,
                            ),
                        ]),

                        SizedBox(height: 25),

                        // Emergency Contact Section
                        _sectionHeader(
                          'Emergency Contact',
                          Icons.emergency_outlined,
                          height,
                        ),
                        SizedBox(height: 15),
                        _buildInfoCard(context, [
                          if (user.emergencyContactName.isNotEmpty)
                            _infoRow(
                              'Contact Name',
                              user.emergencyContactName,
                              Icons.person_pin_outlined,
                              height,
                            ),
                          if (user.emergencyContact.isNotEmpty)
                            _infoRow(
                              'Contact Number',
                              user.emergencyContact,
                              Icons.phone_in_talk_outlined,
                              height,
                            ),
                        ]),

                        SizedBox(height: 30),

                        // Privacy Notice
                        Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.red.shade200,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.lock_outline,
                                color: Colors.red.shade700,
                                size: height * 0.03,
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your information is kept private and secure',
                                  style: TextStyle(
                                    fontSize: height * 0.02,
                                    color: Colors.red.shade900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
        SizedBox(width: 10),
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

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    if (children.isEmpty) {
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Center(
          child: Text(
            'No information available',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: MediaQuery.of(context).size.height * 0.022,
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value, IconData icon, double height) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.blue.shade700,
              size: height * 0.025,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: height * 0.02,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: height * 0.024,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
