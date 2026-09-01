import 'package:dio/dio.dart';
import '../constants/app_constants.dart';
import '../errors/app_exception.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({Dio? dio, String? baseUrl})
      : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl ?? AppConstants.defaultBaseUrl,
                connectTimeout: const Duration(seconds: AppConstants.connectTimeoutSeconds),
                receiveTimeout: const Duration(seconds: AppConstants.receiveTimeoutSeconds),
                headers: {
                  'Accept': 'application/json',
                  'User-Agent': 'TechDaily-Mobile/1.0',
                },
              ),
            );

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw AppException(message: 'Unexpected error occurred: $e', originalError: e);
    }
  }

  AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Connection timed out. Please check your internet connection.',
          originalError: error,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 404) {
          return const NotFoundException();
        }
        return ServerException(
          message: 'Server error ($statusCode). Please try again later.',
          statusCode: statusCode,
          originalError: error,
        );
      case DioExceptionType.cancel:
        return const AppException(message: 'Request was cancelled.');
      default:
        return NetworkException(
          message: 'Network error. Please check your internet connection and try again.',
          originalError: error,
        );
    }
  }
}
