import 'package:everest_hackathon/domain/entities/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/color_scheme.dart';
import '../presentation/phone_contacts_screen.dart';

class AddContactBottomSheet extends StatefulWidget {
  final Function(Contact) onContactAdded;
  final Contact? contact;

  const AddContactBottomSheet({
    super.key,
    required this.onContactAdded,
    this.contact,
  });

  @override
  State<AddContactBottomSheet> createState() => _AddContactBottomSheetState();
}

class _AddContactBottomSheetState extends State<AddContactBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  String _selectedRelationship = 'Family';
  bool _isPrimary = false;
  bool _isLoading = false;

  final List<String> _relationships = [
    'Family',
    'Friend',
    'Colleague',
    'Neighbor',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.name;
      // Remove +91 prefix for display in the text field
      String displayPhone = widget.contact!.phone;
      if (displayPhone.startsWith('+91')) {
        displayPhone = displayPhone.substring(3);
      }
      _phoneController.text = displayPhone;
      _selectedRelationship = widget.contact!.relationship;
      _isPrimary = widget.contact!.isPrimary;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Title
                  Text(
                    widget.contact == null
                        ? 'Add Emergency Contact'
                        : 'Edit Contact',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // Phone Contacts Button (only show when adding new contact)
                  if (widget.contact == null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _openPhoneContacts,
                        icon: Icon(
                          Icons.contacts,
                          size: 18.sp,
                          color: AppColorScheme.primaryColor,
                        ),
                        label: Text(
                          'Select from Phone Contacts',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColorScheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(
                            color: AppColorScheme.primaryColor.withValues(
                              alpha: 0.3,
                            ),
                            width: 1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          backgroundColor: AppColorScheme.primaryColor
                              .withValues(alpha: 0.05),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Divider with "OR" text
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: Colors.grey[300], thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: Colors.grey[300], thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ] else
                    SizedBox(height: 8.h),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter contact name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Phone Field
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    inputFormatters: [
                      // Allow only digits
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter 10-digit mobile number',
                      // helperText: 'Number will be saved with +91 prefix',
                      helperStyle: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                      counterText: '', // Hide the counter text
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a phone number';
                      }

                      // Remove any non-digit characters for validation
                      final digitsOnly = value.replaceAll(
                        RegExp(r'[^0-9]'),
                        '',
                      );

                      if (digitsOnly.length != 10) {
                        return 'Enter a valid 10-digit mobile number';
                      }

                      // Check if it's a valid Indian mobile number (starts with 6-9)
                      if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(digitsOnly)) {
                        return 'Enter a valid Indian mobile number';
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 16.h),

                  // Relationship Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedRelationship,
                    decoration: InputDecoration(
                      labelText: 'Relationship',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.family_restroom),
                    ),
                    items: _relationships.map((relationship) {
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
                  ),
                  // SizedBox(height: 16.h),

                  // Primary Contact Switch
                  // SwitchListTile(
                  //   title: const Text('Primary Contact'),
                  //   subtitle: const Text('This contact will be prioritized in emergencies'),
                  //   value: _isPrimary,
                  //   onChanged: (value) => setState(() => _isPrimary = value),
                  //   activeColor: AppColorScheme.primaryColor,
                  // ),
                  SizedBox(height: 40.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveContact,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorScheme.primaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  widget.contact == null
                                      ? 'Add Contact'
                                      : 'Update Contact',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openPhoneContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneContactsScreen(
          onContactSelected: (name, phone) {
            setState(() {
              _nameController.text = name;
              // Remove +91 prefix if present for display
              String displayPhone = phone;
              if (displayPhone.startsWith('+91')) {
                displayPhone = displayPhone.substring(3);
              }
              // Also remove any other country codes or formatting
              displayPhone = displayPhone.replaceAll(RegExp(r'[^0-9]'), '');
              // Take only the last 10 digits if longer
              if (displayPhone.length > 10) {
                displayPhone = displayPhone.substring(displayPhone.length - 10);
              }
              _phoneController.text = displayPhone;
            });
          },
        ),
      ),
    );
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cleanedPhone = _formatPhoneWithCountryCode(_phoneController.text.trim());
      final contact = Contact(
        id:
            widget.contact?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        phone: cleanedPhone,
        relationship: _selectedRelationship,
        isPrimary: _isPrimary,
        createdAt: widget.contact?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      widget.onContactAdded(contact);

      if (mounted) {
        Navigator.pop(context);
        // Don't show success snackbar here - let the BLoC handle success/error states
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving contact: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Format phone number with +91 country code for India
  String _formatPhoneWithCountryCode(String input) {
    // Remove all non-digit characters
    String digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');

    // If it's a 10-digit number, add +91 prefix
    if (digitsOnly.length == 10) {
      return '+91$digitsOnly';
    }

    // If it already has country code (13 digits starting with 91), add + if missing
    if (digitsOnly.length == 12 && digitsOnly.startsWith('91')) {
      return '+$digitsOnly';
    }

    // If it already has + and country code, return as is
    if (input.startsWith('+91') && digitsOnly.length == 12) {
      return input;
    }

    // Default: add +91 to whatever digits we have
    return '+91$digitsOnly';
  }
}
