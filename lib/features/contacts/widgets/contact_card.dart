import 'package:everest_hackathon/domain/entities/contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/color_scheme.dart';


class ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ContactCard({
    super.key,
    required this.contact,
    this.onCall,
    this.onMessage,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            Row(
              children: [
                // Avatar
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    gradient: AppColorScheme.primaryGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                
                // Contact Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              contact.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        contact.phone,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        contact.relationship,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColorScheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action Menu
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        onEdit?.call();
                        break;
                      case 'delete':
                        onDelete?.call();
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12.h),
            
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.call,
                    label: 'Call',
                    color: Colors.green,
                    onTap: onCall,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.message,
                    label: 'Message',
                    color: Colors.blue,
                    onTap: onMessage,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: color,
            ),
            SizedBox(width: 4.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
