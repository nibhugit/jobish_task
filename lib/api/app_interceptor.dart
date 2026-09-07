import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  @override
  void onRequest(final RequestOptions options, final RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(final Response response, final ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(final DioException err, final ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
