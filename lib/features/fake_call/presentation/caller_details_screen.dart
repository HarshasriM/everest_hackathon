import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/color_scheme.dart';
import '../bloc/fake_call_bloc.dart';
import '../bloc/fake_call_event.dart';
import '../bloc/fake_call_state.dart';

/// Caller Details Screen - Set up caller information
class CallerDetailsScreen extends StatefulWidget {
  const CallerDetailsScreen({super.key});

  @override
  State<CallerDetailsScreen> createState() => _CallerDetailsScreenState();
}

class _CallerDetailsScreenState extends State<CallerDetailsScreen> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _imagePicker = ImagePicker();
  int _selectedTimerSeconds = 5;

  @override
  void initState() {
    super.initState();
    // Load existing data if any
    final state = context.read<FakeCallBloc>().state;
    state.maybeWhen(
      settingUp: (name, number, image, timer) {
        _nameController.text = name;
        _numberController.text = number;
        _selectedTimerSeconds = timer;
      },
      detailsSaved: (name, number, image, timer) {
        _nameController.text = name;
        _numberController.text = number;
        _selectedTimerSeconds = timer;
      },
      orElse: () {},
    );

    // Listen to text changes
    _nameController.addListener(_onNameChanged);
    _numberController.addListener(_onNumberChanged);
  }

  void _onNameChanged() {
    context.read<FakeCallBloc>().add(
          FakeCallEvent.setCallerName(name: _nameController.text),
        );
  }

  void _onNumberChanged() {
    context.read<FakeCallBloc>().add(
          FakeCallEvent.setCallerNumber(number: _numberController.text),
        );
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image != null) {
      context.read<FakeCallBloc>().add(
            FakeCallEvent.setCallerImage(imagePath: image.path),
          );
    }
  }

  void _usePresetAvatar() {
    // Use null for preset avatar (will show default avatar)
    context.read<FakeCallBloc>().add(
          const FakeCallEvent.setCallerImage(imagePath: null),
        );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FakeCallBloc, FakeCallState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final isDark = theme.brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Caller Details',
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            toolbarHeight: 70.h,
            iconTheme: IconThemeData(color: colorScheme.onSurface),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Set up caller image
                _buildCallerImageSection(state, colorScheme, isDark),
                SizedBox(height: 32.h),

                // Set up a fake caller
                _buildFakeCallerSection(colorScheme, isDark),
                SizedBox(height: 32.h),

                // Pre-set timer
                _buildTimerSection(colorScheme, isDark),
                SizedBox(height: 40.h),

                // Save button
                _buildSaveButton(colorScheme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallerImageSection(FakeCallState state, ColorScheme colorScheme, bool isDark) {
    final imagePath = state.callerImagePath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set up caller image',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            // Gallery button
            _buildImageSourceButton(
              icon: Icons.image_outlined,
              label: 'Gallery',
              onTap: _pickImageFromGallery,
              colorScheme: colorScheme,
              isDark: isDark,
            ),
            SizedBox(width: 16.w),

            // Preset button
            _buildImageSourceButton(
              icon: Icons.account_circle_outlined,
              label: 'Preset',
              onTap: _usePresetAvatar,
              colorScheme: colorScheme,
              isDark: isDark,
            ),

            const Spacer(),

            // Preview image
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: AppColorScheme.getPrimaryGradient(isDark),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: imagePath != null
                    ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _defaultAvatar(colorScheme),
                      )
                    : _defaultAvatar(colorScheme),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _defaultAvatar(ColorScheme colorScheme) {
    return Container(
      color: colorScheme.surface,
      child: Center(
        child: Icon(
          Icons.account_circle,
          size: 60.sp,
          color: colorScheme.onSurface.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surface.withOpacity(0.08) : Colors.white,
              border: Border.all(color: colorScheme.onSurface.withOpacity(0.06)),
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.12 : 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 26.sp, color: colorScheme.primary),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp, color: colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildFakeCallerSection(ColorScheme colorScheme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set up a fake caller',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),

        // Name input
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter name',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: isDark ? colorScheme.surface.withOpacity(0.06) : colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
          ),
          style: TextStyle(color: colorScheme.onSurface),
        ),
        SizedBox(height: 12.h),

        // Number input
        TextField(
          controller: _numberController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter number',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: isDark ? colorScheme.surface.withOpacity(0.06) : colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            suffixIcon: Icon(Icons.contacts, color: colorScheme.onSurfaceVariant),
          ),
          style: TextStyle(color: colorScheme.onSurface),
        ),
      ],
    );
  }

  Widget _buildTimerSection(ColorScheme colorScheme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pre-set timer',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 16.h),

        // Timer options
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            _buildTimerOption(5, '5 sec', colorScheme),
            _buildTimerOption(10, '10 sec', colorScheme),
            _buildTimerOption(60, '1 min', colorScheme),
            _buildTimerOption(300, '5 min', colorScheme),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerOption(int seconds, String label, ColorScheme colorScheme) {
    final isSelected = _selectedTimerSeconds == seconds;
    final bgColor = isSelected ? colorScheme.primary : colorScheme.surface;
    final borderColor = isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.08);
    final textColor = isSelected ? colorScheme.onPrimary : colorScheme.onSurface;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTimerSeconds = seconds;
        });
        context.read<FakeCallBloc>().add(
              FakeCallEvent.setTimerDuration(seconds: seconds),
            );
      },
      borderRadius: BorderRadius.circular(25.r),
      child: Container(
        width: (MediaQuery.of(context).size.width - 60.w) / 2,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.18),
                blurRadius: 8,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(ColorScheme colorScheme) {
    return Center(
      child: Container(
        width: 240.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.read<FakeCallBloc>().add(
                    const FakeCallEvent.saveCallerDetails(),
                  );
              Navigator.of(context).pop();
            },
            borderRadius: BorderRadius.circular(25.r),
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
