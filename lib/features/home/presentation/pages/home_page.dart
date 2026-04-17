import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_dashboard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom,
        ), // Above the custom bottom nav
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 72), // Space for fixed header
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      switch (state.status) {
                        case HomeStatus.initial:
                        case HomeStatus.loading:
                          return const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        case HomeStatus.error:
                          return Center(
                            child: Text(
                              state.errorMessage ?? 'Unknown error',
                              style: const TextStyle(color: AppColors.error),
                            ),
                          );
                        case HomeStatus.loaded:
                          return HomeDashboard(
                            items: state.filteredItems,
                            query: state.query,
                            selectedCategory: state.selectedCategory,
                            onQueryChanged: context
                                .read<HomeCubit>()
                                .updateQuery,
                            onCategoryChanged: context
                                .read<HomeCubit>()
                                .updateCategory,
                          );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopAppBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopAppBar(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          color: AppColors.background.withValues(alpha: 0.8),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.all(12),
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
      ),
    );
  }
}
