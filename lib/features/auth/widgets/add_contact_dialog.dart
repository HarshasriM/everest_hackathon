import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/user_entity.dart';

/// Dialog for adding an emergency contact
class AddContactDialog extends StatefulWidget {
  final EmergencyContactEntity? contact;

  const AddContactDialog({
    super.key,
    this.contact,
  });

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedRelationship = 'Friend';
  bool _isPrimary = false;
  bool _canReceiveSosAlerts = true;
  bool _canTrackLocation = false;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      _phoneController.text = widget.contact!.phoneNumber;
      _emailController.text = widget.contact!.email ?? '';
      _selectedRelationship = widget.contact!.relationship;
      _isPrimary = widget.contact!.isPrimary;
      _canReceiveSosAlerts = widget.contact!.canReceiveSosAlerts;
      _canTrackLocation = widget.contact!.canTrackLocation;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final contact = EmergencyContactEntity(
        id: widget.contact?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.replaceAll(RegExp(r'\D'), ''),
        email: _emailController.text.trim().isEmpty 
            ? null 
            : _emailController.text.trim(),
        relationship: _selectedRelationship,
        isPrimary: _isPrimary,
        canReceiveSosAlerts: _canReceiveSosAlerts,
        canTrackLocation: _canTrackLocation,
      );
      
      Navigator.of(context).pop(contact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20.w),
        constraints: BoxConstraints(maxWidth: 400.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title
                Text(
                  widget.contact != null 
                      ? 'Edit Emergency Contact' 
                      : 'Add Emergency Contact',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Name *',
                    hintText: 'Enter contact name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: Validators.validateContactName,
                  textCapitalization: TextCapitalization.words,
                ),
                
                SizedBox(height: 16.h),
                
                // Phone Field
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Phone Number *',
                    hintText: '9999999999',
                    prefixIcon: Icon(Icons.phone_outlined),
                    prefixText: '+91 ',
                    counterText: '',
                  ),
                  validator: Validators.validatePhoneNumber,
                ),
                
                SizedBox(height: 16.h),
                
                // Email Field (Optional)
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email (Optional)',
                    hintText: 'Enter email address',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: Validators.validateEmail,
                ),
                
                SizedBox(height: 16.h),
                
                // Relationship Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedRelationship,
                  decoration: const InputDecoration(
                    labelText: 'Relationship *',
                    prefixIcon: Icon(Icons.group_outlined),
                  ),
                  items: AppConstants.relationships.map((relationship) {
                    return DropdownMenuItem(
                      value: relationship,
                      child: Text(relationship),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedRelationship = value);
                    }
                  },
                  validator: Validators.validateRelationship,
                ),
                
                SizedBox(height: 24.h),
                
                // Settings Section
                Text(
                  'Settings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                
                SizedBox(height: 12.h),
                
                // Primary Contact Switch
                SwitchListTile(
                  title: const Text('Primary Contact'),
                  subtitle: const Text('This contact will be notified first'),
                  value: _isPrimary,
                  onChanged: (value) => setState(() => _isPrimary = value),
                  contentPadding: EdgeInsets.zero,
                ),
                
                // SOS Alerts Switch
                SwitchListTile(
                  title: const Text('Receive SOS Alerts'),
                  subtitle: const Text('Send emergency alerts to this contact'),
                  value: _canReceiveSosAlerts,
                  onChanged: (value) => setState(() => _canReceiveSosAlerts = value),
                  contentPadding: EdgeInsets.zero,
                ),
                
                // Location Tracking Switch
                SwitchListTile(
                  title: const Text('Share Live Location'),
                  subtitle: const Text('Allow this contact to track your location'),
                  value: _canTrackLocation,
                  onChanged: (value) => setState(() => _canTrackLocation = value),
                  contentPadding: EdgeInsets.zero,
                ),
                
                SizedBox(height: 24.h),
                
                // Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    SizedBox(width: 12.w),
                    ElevatedButton(
                      onPressed: _handleSave,
                      child: Text(widget.contact != null ? 'Update' : 'Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
