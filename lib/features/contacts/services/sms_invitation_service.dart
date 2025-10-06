import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/user_entity.dart';

/// Service for sending SMS invitations to emergency contacts
class SmsInvitationService {
  static const String _appName = 'SHE (Safety Help Emergency)';
  static const String _appStoreLink = 'https://play.google.com/store/apps/details?id=com.example.everest_hackathon';
  
  /// Send SMS invitation to a contact when they are added as an emergency contact
  static Future<bool> sendInvitation({
    required EmergencyContactEntity contact,
    required UserEntity user,
  }) async {
    try {
      final message = _buildInvitationMessage(contact: contact, user: user);
      final uri = Uri(
        scheme: 'sms',
        path: contact.phoneNumber,
        queryParameters: {'body': message},
      );
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Build the invitation message
  static String _buildInvitationMessage({
    required EmergencyContactEntity contact,
    required UserEntity user,
  }) {
    return '''Hi ${contact.name},

${user.name} has added you as an emergency contact in $_appName - a women's safety app.

You will receive SOS alerts with location information if ${user.name} is in danger.

Download the app: $_appStoreLink

Stay safe!
- $_appName Team''';
  }
  
  /// Send a test SOS alert (for demonstration purposes)
  static Future<bool> sendTestSosAlert({
    required EmergencyContactEntity contact,
    required UserEntity user,
    required String location,
  }) async {
    try {
      final message = _buildSosMessage(
        contact: contact,
        user: user,
        location: location,
      );
      
      final uri = Uri(
        scheme: 'sms',
        path: contact.phoneNumber,
        queryParameters: {'body': message},
      );
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Build SOS alert message
  static String _buildSosMessage({
    required EmergencyContactEntity contact,
    required UserEntity user,
    required String location,
  }) {
    return '''🚨 EMERGENCY ALERT 🚨

${user.name} is in DANGER and needs immediate help!

Location: $location

This is an automated SOS alert from $_appName.

Please contact ${user.name} immediately or call emergency services if needed.

Time: ${DateTime.now().toString()}''';
  }
  
  /// Send location sharing message
  static Future<bool> sendLocationShare({
    required EmergencyContactEntity contact,
    required UserEntity user,
    required String location,
    required String googleMapsLink,
  }) async {
    try {
      final message = _buildLocationMessage(
        contact: contact,
        user: user,
        location: location,
        googleMapsLink: googleMapsLink,
      );
      
      final uri = Uri(
        scheme: 'sms',
        path: contact.phoneNumber,
        queryParameters: {'body': message},
      );
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  /// Build location sharing message
  static String _buildLocationMessage({
    required EmergencyContactEntity contact,
    required UserEntity user,
    required String location,
    required String googleMapsLink,
  }) {
    return '''📍 Location Update from ${user.name}

Current Location: $location

View on Google Maps: $googleMapsLink

Shared via $_appName
Time: ${DateTime.now().toString()}''';
  }
}
