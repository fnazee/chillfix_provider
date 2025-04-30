import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Form controllers
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _contactController;
  late TextEditingController _addressController;
  late TextEditingController _descriptionController;
  late TextEditingController _hourlyRateController;

  // State variables
  File? _profileImage;
  bool _isAvailable = true;
  bool _isEditing = false;
  String _serviceCategory = 'Plumbing';
  List<String> _documents = [];

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: "Venura Pieris");
    _contactController = TextEditingController(text: "0771234567");
    _addressController = TextEditingController(text: "123 Main St, Colombo");
    _descriptionController = TextEditingController(
        text: "Professional plumber with 10 years experience");
    _hourlyRateController = TextEditingController(text: "1500");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile saved successfully')),
                    );
                  }
                }
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : AssetImage('assets/default_profile.png') as ImageProvider,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: _pickImage,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Read-only fields
              if (!_isEditing) ...[
                _buildReadOnlyField('Provider ID', 'PROV-001'),
                SizedBox(height: 10),
                _buildReadOnlyField('Overall Rating', '4.8 ★'),
                SizedBox(height: 10),
                _buildReadOnlyField('Jobs Completed', '42'),
                SizedBox(height: 20),
              ],

              // Editable fields
              _buildEditableTextField(
                controller: _fullNameController,
                label: 'Full Name',
                icon: Icons.person,
              ),
              _buildEditableTextField(
                controller: _contactController,
                label: 'Contact Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildEditableTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on,
              ),
              _buildEditableTextField(
                controller: _descriptionController,
                label: 'Profile Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              _buildEditableTextField(
                controller: _hourlyRateController,
                label: 'Hourly Rate (LKR)',
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
              ),

              // Service Category Dropdown
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  value: _serviceCategory,
                  decoration: InputDecoration(
                    labelText: 'Service Category',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    'Plumbing',
                    'Carpentry',
                    'Cleaning',
                    'Electrical',
                    'Appliance Repair',
                    'Other',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: _isEditing
                      ? (newValue) {
                    setState(() {
                      _serviceCategory = newValue!;
                    });
                  }
                      : null,
                ),
              ),

              // Availability Toggle
              SwitchListTile(
                title: Text('Available for Work'),
                value: _isAvailable,
                onChanged: _isEditing
                    ? (value) {
                  setState(() {
                    _isAvailable = value;
                  });
                }
                    : null,
              ),

              // Documents Section
              SizedBox(height: 20),
              Text('Documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _buildDocumentUpload('NIC Copy', 'nic.pdf'),
              _buildDocumentUpload('GS Certificate', 'gs.pdf'),
              _buildDocumentUpload('Police Certificate', 'police.pdf'),
              _buildDocumentUpload('Previous Work Proof', 'work.pdf'),
              _buildDocumentUpload('Recommendation Letter', 'recommendation.pdf'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey)),
        Text(value, style: TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildEditableTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: !_isEditing,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDocumentUpload(String docName, String fileName) {
    return ListTile(
      leading: Icon(Icons.insert_drive_file),
      title: Text(docName),
      subtitle: Text(fileName),
      trailing: _isEditing
          ? IconButton(
        icon: Icon(Icons.upload),
        onPressed: () => _uploadDocument(docName),
      )
          : null,
    );
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });

        debugPrint('=== IMAGE PICKER DEBUG ===');
        debugPrint('Path: ${_profileImage?.path}');
        debugPrint('Exists: ${_profileImage?.existsSync()}');
        debugPrint('Size: ${_profileImage?.lengthSync()} bytes');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image selected successfully')),
        );
      }
    } catch (e) {
      debugPrint('Image picker error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image')),
      );
    }
  }

  Future<void> _uploadDocument(String docType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        setState(() {
          _documents.add(file.path); // Store file path
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$docType uploaded successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload $docType: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }
}