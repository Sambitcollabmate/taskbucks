import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../core/theme/app_colors.dart';

/// Avatar shown at the top of Settings' Profile section, with a camera
/// badge that opens a picker sheet (camera / gallery / remove) and reports
/// the chosen file path back via [onImageSelected] — `null` means "remove".
class ProfileAvatarPicker extends StatelessWidget {
  final String name;
  final String? imagePath;
  final bool isSaving;
  final ValueChanged<String?> onImageSelected;

  const ProfileAvatarPicker({
    super.key,
    required this.name,
    required this.imagePath,
    required this.isSaving,
    required this.onImageSelected,
  });

  String get _initial => name.isEmpty ? '?' : name[0].toUpperCase();

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picked = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      onImageSelected(picked.path);
    }
  }

  void _showPickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(LucideIcons.camera, color: AppColors.primary),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.image, color: AppColors.primary),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
              if (imagePath != null)
                ListTile(
                  leading: const Icon(LucideIcons.trash2, color: Colors.red),
                  title: const Text('Remove photo', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onImageSelected(null);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryGradientStart, AppColors.primaryGradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: imagePath != null
                ? ClipOval(
                    child: Image.file(
                      File(imagePath!),
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                    ),
                  )
                : Text(
                    _initial,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          if (isSaving)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Material(
              color: AppColors.background,
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: isSaving ? null : () => _showPickerSheet(context),
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(LucideIcons.camera, size: 16, color: AppColors.primary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
