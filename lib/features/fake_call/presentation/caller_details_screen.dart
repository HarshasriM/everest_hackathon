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
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Caller Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
              ],
            ),
            toolbarHeight: 70.h,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Set up caller image
                _buildCallerImageSection(state),
                SizedBox(height: 32.h),

                // Set up a fake caller
                _buildFakeCallerSection(),
                SizedBox(height: 32.h),

                // Pre-set timer
                _buildTimerSection(),
                SizedBox(height: 40.h),

                // Save button
                _buildSaveButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCallerImageSection(FakeCallState state) {
    final imagePath = state.callerImagePath;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set up caller image',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
            ),
            SizedBox(width: 16.w),

            // Preset button
            _buildImageSourceButton(
              icon: Icons.account_circle_outlined,
              label: 'Preset',
              onTap: _usePresetAvatar,
            ),

            const Spacer(),

            // Preview image
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                color: AppColorScheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.account_circle,
                      size: 60.sp,
                      color: AppColorScheme.primaryColor,
                    ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageSourceButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 28.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildFakeCallerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Set up a fake caller',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),

        // Name input
        TextField(
          controller: _nameController,
          decoration: InputDecoration(
            hintText: 'Enter name',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Number input
        TextField(
          controller: _numberController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter number',
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            // suffixIcon: Container(
            //   margin: EdgeInsets.all(8.w),
            //   padding: EdgeInsets.all(8.w),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(8.r),
            //   ),
            //   child: Icon(
            //     Icons.contacts,
            //     color: Colors.black87,
            //     size: 20.sp,
            //   ),
            // ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pre-set timer',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16.h),

        // Timer options
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            _buildTimerOption(5, '5 sec'),
            _buildTimerOption(10, '10 sec'),
            _buildTimerOption(60, '1 min'),
            _buildTimerOption(300, '5 min'),
          ],
        ),
      ],
    );
  }

  Widget _buildTimerOption(int seconds, String label) {
    final isSelected = _selectedTimerSeconds == seconds;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTimerSeconds = seconds;
        });
        context.read<FakeCallBloc>().add(
              FakeCallEvent.setTimerDuration(seconds: seconds),
            );
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 60.w) / 2,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColorScheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: isSelected
                ? AppColorScheme.primaryColor
                : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: Container(
        width: 240.w,
        height: 50.h,
        decoration: BoxDecoration(
          color: AppColorScheme.primaryColor,
          borderRadius: BorderRadius.circular(25.r),
          boxShadow: [
            BoxShadow(
              color: AppColorScheme.primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
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
            borderRadius: BorderRadius.circular(12.r),
            child: Center(
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
