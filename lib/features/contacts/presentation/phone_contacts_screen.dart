import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/color_scheme.dart';
import '../services/phone_contacts_service.dart';

class PhoneContactsScreen extends StatefulWidget {
  final Function(String name, String phone) onContactSelected;

  const PhoneContactsScreen({super.key, required this.onContactSelected});

  @override
  State<PhoneContactsScreen> createState() => _PhoneContactsScreenState();
}

class _PhoneContactsScreenState extends State<PhoneContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PhoneContactsService _contactsService = PhoneContactsService.instance;

  List<flutter_contacts.Contact> _allContacts = [];
  List<flutter_contacts.Contact> _filteredContacts = [];
  bool _isLoading = true;
  bool _hasPermission = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final permissionStatus = await _contactsService.checkPermissionStatus();

      if (permissionStatus != ContactsPermissionStatus.granted) {
        if (permissionStatus == ContactsPermissionStatus.permanentlyDenied) {
          setState(() {
            _hasPermission = false;
            _isLoading = false;
            _errorMessage =
                'Contacts permission permanently denied. Please enable it in app settings.';
          });
          return;
        }

        final granted = await _contactsService.requestContactsPermission();
        if (!granted) {
          setState(() {
            _hasPermission = false;
            _isLoading = false;
            _errorMessage =
                'Contacts permission is required to access your phone contacts.';
          });
          return;
        }
      }

      final contacts = await _contactsService.getPhoneContacts();
      setState(() {
        _allContacts = contacts;
        _filteredContacts = contacts;
        _hasPermission = true;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasPermission = false;
        _errorMessage = e.toString();
      });
    }
  }

  static String getContactDisplayName(flutter_contacts.Contact contact) {
    if (contact.displayName.isNotEmpty) {
      return contact.displayName;
    }

    final firstName = contact.name.first;
    final lastName = contact.name.last;

    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '$firstName $lastName';
    } else if (firstName.isNotEmpty) {
      return firstName;
    } else if (lastName.isNotEmpty) {
      return lastName;
    }

    if (contact.phones.isNotEmpty) {
      return contact.phones.first.number;
    }

    return 'Unknown Contact';
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _allContacts;
      } else {
        final lowercaseQuery = query.toLowerCase();

        _filteredContacts = _allContacts.where((contact) {
          final displayName = contact.displayName.toLowerCase();
          final firstName = contact.name.first.toLowerCase();
          final lastName = contact.name.last.toLowerCase();
          final middleName = contact.name.middle.toLowerCase();
          final fullDisplayName = getContactDisplayName(contact).toLowerCase();

          final nameMatch =
              displayName.contains(lowercaseQuery) ||
              firstName.contains(lowercaseQuery) ||
              lastName.contains(lowercaseQuery) ||
              middleName.contains(lowercaseQuery) ||
              fullDisplayName.contains(lowercaseQuery);

          final isNumericQuery = RegExp(r'^\d+$').hasMatch(query.trim());
          final phoneMatch =
              isNumericQuery &&
              contact.phones.any(
                (phone) => phone.number
                    .replaceAll(RegExp(r'[^\d]'), '')
                    .contains(query.replaceAll(RegExp(r'[^\d]'), '')),
              );

          return nameMatch || phoneMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Contact',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: colorScheme.onSurface),
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          // Search Bar
          if (_hasPermission) ...[
            Padding(
              padding: EdgeInsets.all(16.w),
              child: TextField(
                controller: _searchController,
                onChanged: _filterContacts,
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontSize: 14.sp,
                ),
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: colorScheme.onSurfaceVariant,
                    size: 20.sp,
                  ),
                  filled: true,
                  fillColor: isDark
                      ? colorScheme.surface.withOpacity(0.06)
                      : colorScheme.surface.withOpacity(0.6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? colorScheme.surface.withOpacity(0.0)
                          : Colors.grey.shade200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: isDark
                          ? colorScheme.surface.withOpacity(0.0)
                          : Colors.grey.shade200,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: colorScheme.primary,
                      width: 1.5,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ],

          Expanded(child: _buildContent(context)),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading contacts...',
              style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    if (!_hasPermission || _errorMessage != null) {
      return _buildErrorState(context);
    }

    if (_filteredContacts.isEmpty) {
      return _buildEmptyState(context);
    }

    return _buildContactsList();
  }

  Widget _buildErrorState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.contacts_outlined, size: 64.sp, color: colorScheme.onSurfaceVariant),
            SizedBox(height: 16.h),
            Text(
              'Cannot Access Contacts',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _errorMessage ?? 'Permission required to access contacts',
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () async {
                if (_errorMessage?.contains('permanently denied') == true) {
                  await openAppSettings();
                } else {
                  _loadContacts();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                _errorMessage?.contains('permanently denied') == true
                    ? 'Open Settings'
                    : 'Try Again',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64.sp, color: colorScheme.onSurfaceVariant),
            SizedBox(height: 16.h),
            Text(
              'No Contacts Found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No contacts match your search'
                  : 'No contacts with phone numbers found',
              style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: _filteredContacts.length,
      itemBuilder: (context, index) {
        final contact = _filteredContacts[index];
        final primaryPhone = _contactsService.getPrimaryPhoneNumber(contact);

        return _ContactListTile(
          contact: contact,
          primaryPhone: primaryPhone,
          onTap: () {
            final displayName = _PhoneContactsScreenState.getContactDisplayName(
              contact,
            );
            widget.onContactSelected(displayName, primaryPhone);
            Navigator.pop(context);
          },
        );
      },
    );
  }
}

class _ContactListTile extends StatelessWidget {
  final flutter_contacts.Contact contact;
  final String primaryPhone;
  final VoidCallback onTap;

  const _ContactListTile({
    required this.contact,
    required this.primaryPhone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;

    // avatar background: subtle tint using primary or onSurface variant
    final avatarBg = isDark
        ? colorScheme.primary.withOpacity(0.12)
        : colorScheme.primary.withOpacity(0.12);

    final textColor = colorScheme.onSurface;
    final subtitleColor = colorScheme.onSurfaceVariant;

    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      color: colorScheme.surface, // adapts for dark/light
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          radius: 24.r,
          backgroundColor: avatarBg,
          child: Text(
            _PhoneContactsScreenState.getContactDisplayName(contact)[0].toUpperCase(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ),
        title: Text(
          _PhoneContactsScreenState.getContactDisplayName(contact),
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle: Text(
          primaryPhone.isNotEmpty ? primaryPhone : 'No phone number',
          style: TextStyle(fontSize: 14.sp, color: subtitleColor),
        ),
        trailing: Icon(
          Icons.add_circle_outline,
          color: colorScheme.primary,
          size: 24.sp,
        ),
      ),
    );
  }
}
