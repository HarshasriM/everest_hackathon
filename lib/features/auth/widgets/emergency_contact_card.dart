import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../domain/entities/user_entity.dart';

/// Widget to display an emergency contact card
class EmergencyContactCard extends StatelessWidget {
  final EmergencyContactEntity contact;
  final VoidCallback? onRemove;
  final VoidCallback? onEdit;

  const EmergencyContactCard({
    super.key,
    required this.contact,
    this.onRemove,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: contact.isPrimary
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.person,
            color: contact.isPrimary
                ? Theme.of(context).colorScheme.onPrimary
                : Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                contact.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (contact.isPrimary)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Primary',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '+91 ${contact.phoneNumber}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              contact.relationship,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (contact.canReceiveSosAlerts || contact.canTrackLocation)
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Row(
                  children: [
                    if (contact.canReceiveSosAlerts)
                      Icon(
                        Icons.notification_important,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    if (contact.canReceiveSosAlerts) SizedBox(width: 4.w),
                    if (contact.canTrackLocation)
                      Icon(
                        Icons.location_on,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  ],
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: onEdit,
                iconSize: 20.sp,
              ),
            if (onRemove != null)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onRemove,
                iconSize: 20.sp,
                color: Theme.of(context).colorScheme.error,
              ),
          ],
        ),
      ),
    );
  }
}
