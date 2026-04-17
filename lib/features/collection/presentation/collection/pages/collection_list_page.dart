import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/cubit/app_tab_cubit.dart';
import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/utils/responsive.dart';
import '../../cubit/collection_cubit.dart';
import '../../cubit/collection_state.dart';
import '../widgets/collection_empty_state.dart';
import '../widgets/collection_section.dart';
import 'collection_page.dart'; // CollectionStampsPage

class CollectionListPage extends StatelessWidget {
  const CollectionListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppTabCubit, int>(
      listenWhen: (previous, current) => current == 2,
      listener: (context, activeTab) {
        context.read<CollectionCubit>().loadCollections();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Main Content
            BlocBuilder<CollectionCubit, CollectionState>(
              builder: (context, state) {
                return _buildMainContent(context, state);
              },
            ),
            
            // Glassmorphic Header
            _buildGlassHeader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassHeader(BuildContext context) {
    final double horizontalPadding = Responsive.horizontalPadding(context);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 8, horizontalPadding, 16),
            color: AppColors.background.withValues(alpha: 0.8),
            child: SafeArea(
              bottom: false,
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Material(
                      color: AppColors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.menu_rounded,
                            size: 30,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Stampzy',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 40,
                  height: 40,
                  margin: EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainerHigh,
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                      ),
                    ],
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDucsE_mWYKwyXk5LDnhLG3zXC5fZ2Qe0FqFqD0_-xXaLtytxeyGh2dNLARFli8aBAVXkUSs97HblLjNRbaIlDYrH_Ctelq4EscHxt1lrC-C_yh8cYNCXt02iLXQk6SM-xjIwMqbp--bD8VUrIgG8VUrIgG8VXY8DJWt9JODsYP27unscSiYIqh3RK-Mp0msSSznflgUAZyIGYcXGJwx-uyBo6rsCqsjkmZQ5pM6Du5XwgoLSlHAtAgjSSyWy7IDoa_00vltNlgfJO20P7dL04',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildMainContent(BuildContext context, CollectionState state) {
    final double horizontalPadding = Responsive.horizontalPadding(context);

    return SafeArea(
      top: false, // Handled by header padding
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(horizontalPadding, 85, horizontalPadding, 120 + MediaQuery.of(context).padding.bottom),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          const SizedBox(height: 16),
          _buildSearchBar(),
          
          // Filter Chips
          const SizedBox(height: 24),
          _buildFilterChips(),
          
          const SizedBox(height: 32),
          
          // Collection List
          if (state.status == CollectionStatus.loading)
            const Center(child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(color: AppColors.primary),
            ))
          else if (state.status == CollectionStatus.error)
            Center(child: Text(state.errorMessage ?? 'Error loading collections'))
          else if (state.collections.isEmpty)
            const CollectionEmptyState()
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: state.collections.length,
              separatorBuilder: (_, _) => const SizedBox(height: 40),
              itemBuilder: (context, index) {
                final summary = state.collections[index];
                return CollectionSection(
                  summary: summary,
                  // Alternate layout for visual interest
                  layoutType: index % 2 != 0 
                      ? CollectionLayoutType.asymmetric 
                      : CollectionLayoutType.grid,
                  onViewAll: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CollectionStampsPage(
                          collectionId: summary.id,
                          collectionName: summary.name,
                        ),
                      ),
                    );
                  },
                  onStampTap: (stampIndex) {
                    // Navigate to detail
                  },
                );
              },
            ),
        ],
      ),
    ));
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: AppColors.onSurfaceVariant),
          SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search your collections...',
                hintStyle: TextStyle(
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Recent', 'Favorites', 'Europe Tour', 'Urban Scapes', 'Nature Parks'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final isSelected = entry.key == 0;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Text(
                entry.value,
                style: TextStyle(
                  color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
