import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../app/di/injection_container.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/responsive.dart';
import '../../../../features/collection/data/datasources/collection_local_datasource.dart';
import '../../../../features/collection/data/models/stamp_item_model.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final CollectionLocalDataSource _dataSource = sl<CollectionLocalDataSource>();
  List<StampItemModel> _stamps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStamps();
  }

  Future<void> _loadStamps() async {
    try {
      final stamps = await _dataSource.getStamps();
      if (mounted) {
        setState(() {
          _stamps = stamps;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Content
          CustomScrollView(
            slivers: [
              _buildHeader(),
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                )
              else if (_stamps.isEmpty)
                _buildEmptyState()
              else
                _buildGrid(),
            ],
          ),

          // Close Button (Fixed Top Left)
          Positioned(
            top: 12,
            left: 20,
            child: SafeArea(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Responsive.horizontalPadding(context),
            80,
            Responsive.horizontalPadding(context),
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Capture Archive',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Your journey in snapshots. Browse and manage your collected memories.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library_outlined, size: 64, color: AppColors.outline.withValues(alpha: 0.5)),
            const SizedBox(height: 24),
            Text(
              'No stamps captured yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(
        Responsive.horizontalPadding(context),
        0,
        Responsive.horizontalPadding(context),
        40,
      ),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Responsive.isMobile(context) ? 2 : 3, // Responsive grid
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          childAspectRatio: 0.75,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final stamp = _stamps[index];
            return _buildGalleryItem(stamp);
          },
          childCount: _stamps.length,
        ),
      ),
    );
  }

  Widget _buildGalleryItem(StampItemModel stamp) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: stamp.imagePath != null && File(stamp.imagePath!).existsSync()
                    ? DecorationImage(
                        image: FileImage(File(stamp.imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : const DecorationImage(
                        image: NetworkImage('https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=400&h=600&fit=crop'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stamp.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  stamp.country.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.secondary.withValues(alpha: 0.6),
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
