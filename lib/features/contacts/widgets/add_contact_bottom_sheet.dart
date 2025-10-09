import 'package:everest_hackathon/domain/entities/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/color_scheme.dart';


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
      _phoneController.text = widget.contact!.phone;
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
                    widget.contact == null ? 'Add Emergency Contact' : 'Edit Contact',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  
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
                      hintText: 'Enter phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: const Icon(Icons.phone),
                      counterText: '', // Hide the counter text
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a phone number';
                      }
                      final cleaned = _cleanPhone(value);
                      
                      final isValid = RegExp(r'^\+?[0-9]{10}$').hasMatch(cleaned);
                      if (!isValid) {
                        return 'Enter a valid phone (10 digits)';
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
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Text(
                                  widget.contact == null ? 'Add Contact' : 'Update Contact',
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

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final cleanedPhone = _cleanPhone(_phoneController.text.trim());
      final contact = Contact(
        id: widget.contact?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.contact == null 
                  ? 'Contact added successfully!' 
                  : 'Contact updated successfully!',
            ),
            backgroundColor: Colors.green,
          ),
        );
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

  // Remove spaces, dashes and parentheses, keep a single leading '+' if present
  String _cleanPhone(String input) {
    String s = input.trim();
    // Remove spaces, dashes, parentheses
    s = s.replaceAll(RegExp(r'[\s\-()]+'), '');
    // If multiple '+', keep only leading one; otherwise remove all '+' then re-add if first char was '+'
    if (s.startsWith('+')) {
      s = '+' + s.substring(1).replaceAll('+', '');
    } else {
      s = s.replaceAll('+', '');
    }
    return s;
  }
}
