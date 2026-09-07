import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:jobish_task/api/app_interceptor.dart';
import 'package:jobish_task/app_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioHelper {
  static final Dio dio = Dio()
    ..transformer = BackgroundTransformer()
    ..options = BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      baseUrl: ApiConfig.baseUrl,
    );

  static Future<void> init() async {
    final cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);
    final customCacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.refresh,
      priority: CachePriority.high,
      maxStale: const Duration(seconds: 10),
    );

    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      PrettyDioLogger(requestHeader: true, requestBody: true),
      AppInterceptor(),
      DioCacheInterceptor(options: customCacheOptions),
    ]);
  }

  static Future<Response<dynamic>> getData({
    required final String url,
    final Map<String, dynamic>? query,
  }) => dio.get(
    url,
    queryParameters: query,
    options: Options(
      validateStatus: (final status) => status != null && status < 500,
      responseType: ResponseType.json,
    ),
  );

  static Future<Response<dynamic>> postData({
    required final String url,
    final Map<dynamic, dynamic>? data,
    final FormData? formData,
  }) => dio.post(
    url,
    data: formData ?? data,
    options: Options(
      validateStatus: (final status) => status != null && status < 500,
      responseType: ResponseType.json,
    ),
  );

  static Future<Response<dynamic>> putData({
    required final String url,
    required final Map<String, dynamic> data,
    final Map<String, dynamic>? query,
  }) => dio.put(
    url,
    queryParameters: query,
    data: data,
    options: Options(
      validateStatus: (final status) => status != null && status < 500,
      responseType: ResponseType.json,
    ),
  );

  static Future<Response<dynamic>> deleteData({
    required final String url,
    final Map<dynamic, dynamic>? data,
  }) => dio.delete(
    url,
    data: data,
    options: Options(
      validateStatus: (final status) => status != null && status < 500,
      responseType: ResponseType.json,
    ),
  );
}
