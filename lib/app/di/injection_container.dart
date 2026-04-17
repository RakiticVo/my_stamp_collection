import 'package:camera/camera.dart';
import 'package:get_it/get_it.dart';

import '../../core/database/app_database.dart';
import '../../core/network/api_client.dart';
import '../../features/capture/presentation/cubit/capture_cubit.dart';
import '../../features/collection/data/datasources/collection_local_datasource.dart';
import '../../features/collection/data/repositories/collection_repository_impl.dart';
import '../../features/collection/domain/repositories/collection_repository.dart';
import '../../features/collection/domain/usecases/add_stamp.dart';
import '../../features/collection/domain/usecases/filter_stamps.dart';
import '../../features/collection/domain/usecases/get_collection_summaries.dart';
import '../../features/collection/domain/usecases/get_stamps.dart';
import '../../features/collection/presentation/cubit/collection_cubit.dart';
import '../../features/home/data/datasources/home_local_datasource.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_feed.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../cubit/app_tab_cubit.dart';

final GetIt sl = GetIt.instance;

Future<void> initDependencies({List<CameraDescription> cameras = const []}) async {
  sl
    ..registerLazySingleton<AppDatabase>(AppDatabase.new)
    ..registerLazySingleton<ApiClient>(ApiClient.new)
    ..registerLazySingleton<HomeLocalDataSource>(HomeLocalDataSource.new)
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSource(sl<ApiClient>()),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(
        localDataSource: sl<HomeLocalDataSource>(),
        remoteDataSource: sl<HomeRemoteDataSource>(),
      ),
    )
    ..registerLazySingleton<GetHomeFeed>(
      () => GetHomeFeed(sl<HomeRepository>()),
    )
    ..registerLazySingleton<CollectionLocalDataSource>(
      () => CollectionLocalDataSource(sl<AppDatabase>()),
    )
    ..registerLazySingleton<CollectionRepository>(
      () => CollectionRepositoryImpl(sl<CollectionLocalDataSource>()),
    )
    ..registerLazySingleton<GetStamps>(
      () => GetStamps(sl<CollectionRepository>()),
    )
    ..registerLazySingleton<GetCollectionSummaries>(
      () => GetCollectionSummaries(sl<CollectionRepository>()),
    )
    ..registerLazySingleton<AddStamp>(
      () => AddStamp(sl<CollectionRepository>()),
    )
    ..registerLazySingleton<FilterStamps>(FilterStamps.new)
    ..registerFactory<AppTabCubit>(AppTabCubit.new)
    ..registerFactory<HomeCubit>(() => HomeCubit(sl<GetHomeFeed>()))
    ..registerFactory<CollectionCubit>(
      () => CollectionCubit(
        getStamps: sl<GetStamps>(),
        getCollectionSummaries: sl<GetCollectionSummaries>(),
        filterStamps: sl<FilterStamps>(),
      ),
    )
    ..registerFactory<CaptureCubit>(
      () => CaptureCubit(
        sl<AddStamp>(),
        sl<CollectionLocalDataSource>(),
        cameras: cameras,
      ),
    );
}
