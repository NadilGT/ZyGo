import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:zygo/core/network/dio_client.dart';
import 'package:zygo/core/network/token_interceptor.dart';
import 'package:zygo/core/storage/token_storage.dart';
import 'package:zygo/data/repository_impl/auth_repository_impl/auth_repository_impl.dart';
import 'package:zygo/data/repository_impl/profile_repository_impl/profile_repository_impl.dart';
import 'package:zygo/domain/repositories/profile_repository/profile_repository.dart';
import 'package:zygo/domain/usecases/login_usecase/login_use_case.dart';
import 'package:zygo/domain/usecases/profile_usecase/profile_usecase.dart';
import 'package:zygo/presentation/pages/Profile/profile_cubit/profile_cubit.dart';
import 'domain/repositories/auth_repository/auth_repository.dart';
import 'domain/service/api_service.dart';

final sl = GetIt.instance;

Future<void> initilizeDependencies() async {
  // ---------------------------
  // Dio setup
  // ---------------------------
  final dio = DioClient.dio;

  // Token interceptor with FlutterSecureStorage
  dio.interceptors.add(TokenInterceptor(dio));

  // Logging interceptor
  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
    logPrint: (object) => print(object),
  ));

  sl.registerSingleton<Dio>(dio);

  // ---------------------------
  // API Service
  // ---------------------------
  sl.registerSingleton<ApiService>(ApiService(dio));

  // ---------------------------
  // Repositories & Usecases
  // ---------------------------
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<ProfileRepository>(ProfileRepositoryImpl());
  sl.registerSingleton<ProfileUsecase>(ProfileUsecase());

  // ---------------------------
  // Cubits
  // ---------------------------
  sl.registerFactory<ProfileCubit>(() => ProfileCubit());
}
