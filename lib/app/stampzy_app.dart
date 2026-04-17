import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/capture/presentation/cubit/capture_cubit.dart';
import '../features/collection/presentation/cubit/collection_cubit.dart';
import '../features/home/presentation/cubit/home_cubit.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../core/constants/app_constants.dart';
import 'cubit/app_tab_cubit.dart';
import 'di/injection_container.dart';
import 'theme/app_theme.dart';

class StampzyApp extends StatelessWidget {
  const StampzyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppTabCubit>(create: (_) => sl<AppTabCubit>()),
        BlocProvider<HomeCubit>(create: (_) => sl<HomeCubit>()..loadFeed()),
        BlocProvider<CaptureCubit>(create: (_) => sl<CaptureCubit>()),
        BlocProvider<CollectionCubit>(create: (_) => sl<CollectionCubit>()..loadCollections()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const SplashPage(),
      ),
    );
  }
}
