import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/models/menu_item.dart';

/// Add/Edit menu item screen for restaurant owners
class AddEditItemScreen extends ConsumerStatefulWidget {
  final MenuItem? menuItem; // If null, adding new item

  const AddEditItemScreen({
    super.key,
    this.menuItem,
  });

  @override
  ConsumerState<AddEditItemScreen> createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends ConsumerState<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _sizeController = TextEditingController();

  String _selectedCategory = 'Starters';
  File? _imageFile;
  String? _imageUrl;
  File? _modelFile;
  String? _modelUrl;
  bool _isUploading = false;

  final List<String> _categories = [
    'Starters',
    'Main Course',
    'Desserts',
    'Beverages',
    'Snacks',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.menuItem != null) {
      _nameController.text = widget.menuItem!.name;
      _descriptionController.text = widget.menuItem!.description;
      _priceController.text = widget.menuItem!.price.toString();
      _sizeController.text = widget.menuItem!.size?.toString() ?? '';
      _selectedCategory = widget.menuItem!.category;
      _imageUrl = widget.menuItem!.imageUrl;
      _modelUrl = widget.menuItem!.modelUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _sizeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickModel() async {
    // TODO: Implement 3D model picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('3D model picker coming soon')),
    );
  }

  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });

      try {
        final storageService = StorageService.instance;

        // Upload image if new
        if (_imageFile != null) {
          _imageUrl = await storageService.uploadImage(
            imageFile: _imageFile!,
            path: AppConstants.imagesPath,
          );
        }

        // Upload 3D model if new
        if (_modelFile != null) {
          _modelUrl = await storageService.upload3DModel(
            modelFile: _modelFile!,
            path: AppConstants.modelsPath,
          );
        }

        // Create menu item
        final _menuItem = MenuItem(
          id: widget.menuItem?.id ?? '',
          restaurantId: '', // TODO: Get from user
          name: _nameController.text.trim(),
          description: _descriptionController.text.trim(),
          price: double.parse(_priceController.text),
          category: _selectedCategory,
          imageUrl: _imageUrl!,
          modelUrl: _modelUrl,
          size: double.tryParse(_sizeController.text),
          isAvailable: true,
          createdAt: widget.menuItem?.createdAt ?? DateTime.now(),
          updatedAt: DateTime.now(),
        );

        // TODO: Save to Firestore

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.menuItem == null
                    ? AppStrings.itemAdded
                    : AppStrings.itemUpdated,
              ),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.menuItem == null ? AppStrings.addItem : AppStrings.editItem,
        showBackButton: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppConstants.spacingLg),
          children: [
            // Image Upload
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: context.surfaceVariant,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusLg,
                  ),
                  border: Border.all(
                    color: context.border,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLg,
                        ),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : _imageUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLg,
                            ),
                            child: Image.network(
                              _imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildUploadPlaceholder(theme);
                              },
                            ),
                          )
                        : _buildUploadPlaceholder(theme),
              ),
            ).animate().fadeIn(),
            const SizedBox(height: AppConstants.spacingLg),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: AppStrings.itemName,
                hintText: 'Enter item name',
                prefixIcon: Icon(PhosphorIcons.textT(PhosphorIconsStyle.bold)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter item name';
                }
                return null;
              },
            ).animate().slideX(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 100),
              begin: -0.2,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // Description
            TextFormField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: AppStrings.description,
                hintText: 'Enter item description',
                prefixIcon: Icon(PhosphorIcons.textAlignLeft(PhosphorIconsStyle.bold)),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter description';
                }
                return null;
              },
            ).animate().slideX(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 200),
              begin: -0.2,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // Price
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppStrings.price,
                hintText: 'Enter price',
                prefixIcon: Icon(PhosphorIcons.currencyDollar(PhosphorIconsStyle.bold)),
                prefixText: '\$ ',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ).animate().slideX(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 300),
              begin: -0.2,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // Category
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                labelText: AppStrings.category,
                prefixIcon: Icon(PhosphorIcons.tag(PhosphorIconsStyle.bold)),
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ).animate().slideX(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 400),
              begin: -0.2,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // Size
            TextFormField(
              controller: _sizeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppStrings.size,
                hintText: 'Enter size in cm',
                prefixIcon: Icon(PhosphorIcons.ruler(PhosphorIconsStyle.bold)),
                suffixText: 'cm',
              ),
            ).animate().slideX(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 500),
              begin: -0.2,
            ),
            const SizedBox(height: AppConstants.spacingMd),

            // 3D Model Upload
            GestureDetector(
              onTap: _pickModel,
              child: Container(
                padding: const EdgeInsets.all(AppConstants.spacingMd),
                decoration: BoxDecoration(
                  color: context.surfaceVariant,
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadiusMd,
                  ),
                  border: Border.all(
                    color: _modelUrl != null ? AppColors.primary : context.border,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      PhosphorIcons.cube(PhosphorIconsStyle.bold),
                      color: _modelUrl != null ? AppColors.primary : theme.iconTheme.color,
                    ),
                    const SizedBox(width: AppConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.upload3DModel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _modelUrl != null ? 'Model uploaded' : 'Optional - .glb/.gltf files',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      PhosphorIcons.uploadSimple(PhosphorIconsStyle.bold),
                      color: theme.iconTheme.color,
                    ),
                  ],
                ),
              ),
            ).animate().slideX(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 600),
              begin: -0.2,
            ),
            const SizedBox(height: AppConstants.spacingXl),

            // Save Button
            PrimaryButton(
              text: AppStrings.save,
              onPressed: _saveItem,
              isLoading: _isUploading,
            ).animate().slideY(
              duration: AppConstants.defaultAnimationDuration,
              delay: const Duration(milliseconds: 700),
              begin: 0.2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadPlaceholder(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          PhosphorIcons.image(PhosphorIconsStyle.bold),
          size: 48,
          color: theme.iconTheme.color?.withOpacity(0.5),
        ),
        const SizedBox(height: AppConstants.spacingSm),
        Text(
          'Tap to upload image',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

extension AddEditItemExtension on BuildContext {
  Color get surfaceVariant => Theme.of(this).colorScheme.surfaceContainerHighest;
}
