import 'package:flutter_test/flutter_test.dart';
import 'package:crossplatform_flutter/domain/attendance/attendanceStats.dart';

void main() {
  group('Attendancestats', () {
    test('should create an Attendancestats instance with correct properties', () {
      // Arrange & Act
      final attendanceStats = Attendancestats(
        totalClasses: 10,
        presentCount: 8,
        absentCount: 2,
        className: 'Math',
        attendancePercentage: 80.0,
        attendanceList: [true, true, true, true, false, true, true, true, true, false],
      );

      // Assert
      expect(attendanceStats.totalClasses, equals(10));
      expect(attendanceStats.presentCount, equals(8));
      expect(attendanceStats.absentCount, equals(2));
      expect(attendanceStats.className, equals('Math'));
      expect(attendanceStats.attendancePercentage, equals(80.0));
      expect(attendanceStats.attendanceList.length, equals(10));
      expect(attendanceStats.attendanceList[0], isTrue);
      expect(attendanceStats.attendanceList[4], isFalse);
      expect(attendanceStats.attendanceList[9], isFalse);
    });

    test('should create an Attendancestats instance with default empty attendanceList', () {
      // Arrange & Act
      final attendanceStats = Attendancestats(
        totalClasses: 10,
        presentCount: 8,
        absentCount: 2,
        className: 'Math',
        attendancePercentage: 80.0,
      );

      // Assert
      expect(attendanceStats.attendanceList, isEmpty);
    });

    group('fromJson', () {
      test('should correctly parse Attendancestats from JSON', () {
        // Arrange
        final json = {
          'statistics': {
            'totalClasses': 10,
            'presentCount': 8,
            'absentCount': 2,
            'attendancePercentage': 80.0,
          },
          'history': [
            {'status': 'present'},
            {'status': 'present'},
            {'status': 'present'},
            {'status': 'present'},
            {'status': 'absent'},
            {'status': 'present'},
            {'status': 'present'},
            {'status': 'present'},
            {'status': 'present'},
            {'status': 'absent'},
          ],
          'class': {
            'name': 'Math',
          }
        };

        // Act
        final attendanceStats = Attendancestats.fromJson(json);

        // Assert
        expect(attendanceStats.totalClasses, equals(10));
        expect(attendanceStats.presentCount, equals(8));
        expect(attendanceStats.absentCount, equals(2));
        expect(attendanceStats.className, equals('Math'));
        expect(attendanceStats.attendancePercentage, equals(80.0));
        expect(attendanceStats.attendanceList.length, equals(10));
        expect(attendanceStats.attendanceList[0], isTrue);
        expect(attendanceStats.attendanceList[4], isFalse);
        expect(attendanceStats.attendanceList[9], isFalse);
      });

      test('should correctly convert history status to boolean values', () {
        // Arrange
        final json = {
          'statistics': {
            'totalClasses': 5,
            'presentCount': 3,
            'absentCount': 2,
            'attendancePercentage': 60.0,
          },
          'history': [
            {'status': 'present'},
            {'status': 'absent'},
            {'status': 'present'},
            {'status': 'absent'},
            {'status': 'present'},
          ],
          'class': {
            'name': 'Science',
          }
        };

        // Act
        final attendanceStats = Attendancestats.fromJson(json);

        // Assert
        expect(attendanceStats.attendanceList, equals([true, false, true, false, true]));
      });

      test('should handle empty history array', () {
        // Arrange
        final json = {
          'statistics': {
            'totalClasses': 0,
            'presentCount': 0,
            'absentCount': 0,
            'attendancePercentage': 0.0,
          },
          'history': [],
          'class': {
            'name': 'Math',
          }
        };

        // Act
        final attendanceStats = Attendancestats.fromJson(json);

        // Assert
        expect(attendanceStats.attendanceList, isEmpty);
      });

      test('should handle non-standard status values in history', () {
        // Arrange
        final json = {
          'statistics': {
            'totalClasses': 3,
            'presentCount': 1,
            'absentCount': 2,
            'attendancePercentage': 33.33,
          },
          'history': [
            {'status': 'present'},
            {'status': 'absent'},
            {'status': 'unknown'}, // Non-standard value
          ],
          'class': {
            'name': 'History',
          }
        };

        // Act
        final attendanceStats = Attendancestats.fromJson(json);

        // Assert
        expect(attendanceStats.attendanceList, equals([true, false, false]));
        // Any status that's not 'present' should be treated as false (absent)
      });
    });
  });
}