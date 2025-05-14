import 'package:crossplatform_flutter/core/errors/AttendanceError.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class AttendanceRepository {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  AttendanceRepository(this._dio, this._secureStorage);

  Future<String> generateQrCode(String classId) async {
    print("I am in the generateQrCode method");
    print("Class ID: $classId");
    try {
      final token = await _secureStorage.read(key: 'auth_token');
      
      final response = await _dio.post(
        '/generate',
        data: {'classId': classId},
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );
      print("Response: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final qrCode = response.data['qrCodeImage'] as String?;
        print("QR Code: $qrCode");
        print(qrCode);
        if (qrCode == null) {
          throw QrGenerationException(
            message: 'QR code data is malformed',
            statusCode: response.statusCode,
          );
        }
        return qrCode;
      } else {
        throw QrGenerationException(
          message: response.data['message'] ?? 'Failed to generate QR code',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw QrGenerationException(
        message: e.response?.data['message'] ?? 'Network error occurred',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      throw QrGenerationException(
        message: 'Unexpected error occurred',
        error: e,
      );
    }
  }

  Future<bool> scanQrCode(String token, String classId) async {
    try {
      final response = await _dio.post(
        '/scan',
        data: {
          'token': token,
          'classId': classId,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $token',
        }),
      );

      if (response.statusCode == 200) {
        return response.data['success'] as bool? ?? false;
      } else {
        throw QrScanningException(
          message: response.data['message'] ?? 'Failed to scan QR code',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw QrScanningException(
        message: e.response?.data['message'] ?? 'Network error during scanning',
        statusCode: e.response?.statusCode,
        error: e,
      );
    } catch (e) {
      throw QrScanningException(
        message: 'Unexpected scanning error',
        error: e,
      );
    }
  }
}