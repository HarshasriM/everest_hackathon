import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/color_scheme.dart';
import '../../../core/dependency_injection/di_container.dart';

import '../domain/entities/contact.dart';
import 'bloc/contacts_bloc.dart';
import '../widgets/add_contact_bottom_sheet.dart';
import '../widgets/contact_card.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  final TextEditingController _searchController = TextEditingController();
  late ContactsBloc _contactsBloc;

  @override
  void initState() {
    super.initState();
    print('[ContactsScreen] Initializing ContactsScreen');
    _contactsBloc = sl<ContactsBloc>();
    print('[ContactsScreen] ContactsBloc created, adding LoadContactsEvent');
    _contactsBloc.add(const LoadContactsEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _contactsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _contactsBloc,
      child: _buildContactsContent(),
    );
  }

  Widget _buildContactsContent() {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: Column(
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: AppColorScheme.primaryGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24.r),
                    bottomRight: Radius.circular(24.r),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            Icons.contacts,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SOS Contacts',
                                style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Manage your emergency contacts',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (query) {
                          _contactsBloc.add(SearchContactsEvent(query));
                        },
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
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Contacts List
              Expanded(child: _buildContactsList()),

              Padding(
                padding: EdgeInsets.all(20.w),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddContactBottomSheet(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Emergency Contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColorScheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

    );
  }

  Widget _buildContactsList() {
    return BlocBuilder<ContactsBloc, ContactsState>(
      bloc: _contactsBloc,
      builder: (context, state) {
        print(
          '[ContactsScreen] Building contacts list with state: ${state.runtimeType}',
        );
        if (state is ContactsInitial || state is ContactsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContactsLoaded) {
          if (state.contacts.isEmpty) {
            return _buildEmptyState();
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            itemCount: state.contacts.length,
            itemBuilder: (context, index) {
              final contact = state.contacts[index];
              return ContactCard(
                contact: contact,
                onCall: () => _callContact(contact),
                onMessage: () => _messageContact(contact),
                onEdit: () => _editContact(contact),
                onDelete: () => _deleteContact(contact),
              );
            },
          );
        } else if (state is ContactsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error, size: 64.sp, color: Colors.red),
                SizedBox(height: 16.h),
                Text(
                  'Error loading contacts',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  state.message,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () {
                    _contactsBloc.add(const LoadContactsEvent());
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColorScheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.contacts_outlined,
              size: 48.sp,
              color: AppColorScheme.primaryColor,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'No Emergency Contacts',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add trusted contacts who will receive\nSOS alerts in emergency situations',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  void _showAddContactBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContactBottomSheet(
        onContactAdded: (contact) {
          _contactsBloc.add(AddContactEvent(contact));
        },
      ),
    );
  }

  void _editContact(Contact contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContactBottomSheet(
        contact: contact,
        onContactAdded: (updatedContact) {
          _contactsBloc.add(UpdateContactEvent(updatedContact));
        },
      ),
    );
  }

  void _deleteContact(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        elevation: 10,
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 10),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        title: const Text(
          'Delete Contact',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        content: Text(
          'Are you sure you want to delete ${contact.name}?',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
          foregroundColor: Colors.grey[700],
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _contactsBloc.add(DeleteContactEvent(contact.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              textStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _callContact(Contact contact) async {
    final uri = Uri(scheme: 'tel', path: contact.phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not call ${contact.name}')),
        );
      }
    }
  }

  Future<void> _messageContact(Contact contact) async {
    final uri = Uri(scheme: 'sms', path: contact.phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not message ${contact.name}')),
        );
      }
    }
  }
}
