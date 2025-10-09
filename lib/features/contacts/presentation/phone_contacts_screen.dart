import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as flutter_contacts;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/color_scheme.dart';
import '../services/phone_contacts_service.dart';

class PhoneContactsScreen extends StatefulWidget {
  final Function(String name, String phone) onContactSelected;

  const PhoneContactsScreen({
    super.key,
    required this.onContactSelected,
  });

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
            _errorMessage = 'Contacts permission permanently denied. Please enable it in app settings.';
          });
          return;
        }
        
        final granted = await _contactsService.requestContactsPermission();
        if (!granted) {
          setState(() {
            _hasPermission = false;
            _isLoading = false;
            _errorMessage = 'Contacts permission is required to access your phone contacts.';
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

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = _allContacts;
      } else {
        final lowercaseQuery = query.toLowerCase();
        _filteredContacts = _allContacts.where((contact) {
          final nameMatch = contact.displayName.toLowerCase().contains(lowercaseQuery);
          final phoneMatch = contact.phones.any((phone) => 
            phone.number.replaceAll(RegExp(r'[^\d]'), '').contains(
              query.replaceAll(RegExp(r'[^\d]'), '')
            )
          );
          return nameMatch || phoneMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Select Contact',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
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
                decoration: InputDecoration(
                  hintText: 'Search contacts...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 20.sp,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColorScheme.primaryColor),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
              ),
            ),
          ],
          
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColorScheme.primaryColor),
            ),
            SizedBox(height: 16.h),
            Text(
              'Loading contacts...',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (!_hasPermission || _errorMessage != null) {
      return _buildErrorState();
    }

    if (_filteredContacts.isEmpty) {
      return _buildEmptyState();
    }

    return _buildContactsList();
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'Cannot Access Contacts',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _errorMessage ?? 'Permission required to access contacts',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
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
                backgroundColor: AppColorScheme.primaryColor,
                foregroundColor: Colors.white,
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No Contacts Found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No contacts match your search'
                  : 'No contacts with phone numbers found',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
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
            widget.onContactSelected(contact.displayName, primaryPhone);
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
    return Card(
      margin: EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: CircleAvatar(
          radius: 24.r,
          backgroundColor: AppColorScheme.primaryColor.withValues(alpha: 0.1),
          child: Text(
            contact.displayName.isNotEmpty 
                ? contact.displayName[0].toUpperCase()
                : '?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColorScheme.primaryColor,
            ),
          ),
        ),
        title: Text(
          contact.displayName,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          primaryPhone.isNotEmpty ? primaryPhone : 'No phone number',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(
          Icons.add_circle_outline,
          color: AppColorScheme.primaryColor,
          size: 24.sp,
        ),
      ),
    );
  }
}
