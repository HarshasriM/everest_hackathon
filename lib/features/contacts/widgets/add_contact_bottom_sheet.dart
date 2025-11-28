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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // subtle background for sheet to match the theme
    final sheetBg = colorScheme.surface;
    final handleColor = colorScheme.onSurface.withOpacity(0.12);
    final dividerColor = colorScheme.onSurface.withOpacity(0.08);
    final fieldFill = isDark ? colorScheme.surface.withOpacity(0.03) : colorScheme.surface.withOpacity(0.88);
    final prefixIconColor = colorScheme.primary;
    final outlinedBorderColor = colorScheme.primary.withOpacity(0.28);

    return Container(
      decoration: BoxDecoration(
        color: sheetBg,
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
                        color: handleColor,
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
                      color: colorScheme.onSurface,
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
                          color: prefixIconColor,
                        ),
                        label: Text(
                          'Select from Phone Contacts',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: prefixIconColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          side: BorderSide(color: outlinedBorderColor, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          backgroundColor: colorScheme.primary.withOpacity(0.03),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Divider with "OR" text
                    Row(
                      children: [
                        Expanded(
                          child: Divider(color: dividerColor, thickness: 1),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(color: dividerColor, thickness: 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                  ] else
                    SizedBox(height: 8.h),

                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter contact name',
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: fieldFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      prefixIcon: Icon(Icons.person, color: prefixIconColor),
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
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(color: colorScheme.onSurface),
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Enter 10-digit mobile number',
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      helperStyle: TextStyle(
                        fontSize: 12.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      filled: true,
                      fillColor: fieldFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
                      ),
                      prefixIcon: Icon(Icons.phone, color: prefixIconColor),
                      prefixText: '+91 ',
                      prefixStyle: TextStyle(
                        fontSize: 16.sp,
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      counterText: '',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a phone number';
                      }

                      final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');

                      if (digitsOnly.length != 10) {
                        return 'Enter a valid 10-digit mobile number';
                      }

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
                      labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                      filled: true,
                      fillColor: fieldFill,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: dividerColor),
                      ),
                      prefixIcon: Icon(Icons.family_restroom, color: prefixIconColor),
                    ),
                    items: _relationships.map((relationship) {
                      return DropdownMenuItem(
                        value: relationship,
                        child: Text(relationship, style: TextStyle(color: colorScheme.onSurface)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedRelationship = value);
                      }
                    },
                  ),

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
                            side: BorderSide(color: colorScheme.primary.withOpacity(0.18)),
                            backgroundColor: Colors.transparent,
                            foregroundColor: colorScheme.primary,
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _saveContact,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colorScheme.onPrimary,
                                    ),
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

  void _openPhoneContacts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhoneContactsScreen(
          onContactSelected: (name, phone) {
            setState(() {
              _nameController.text = name;
              String displayPhone = phone;
              if (displayPhone.startsWith('+91')) {
                displayPhone = displayPhone.substring(3);
              }
              displayPhone = displayPhone.replaceAll(RegExp(r'[^0-9]'), '');
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

  String _formatPhoneWithCountryCode(String input) {
    String digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');

    if (digitsOnly.length == 10) {
      return '+91$digitsOnly';
    }

    if (digitsOnly.length == 12 && digitsOnly.startsWith('91')) {
      return '+$digitsOnly';
    }

    if (input.startsWith('+91') && digitsOnly.length == 12) {
      return input;
    }

    return '+91$digitsOnly';
  }
}
