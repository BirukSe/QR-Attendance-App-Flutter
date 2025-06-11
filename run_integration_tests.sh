#!/bin/bash

# Run all integration tests
echo "Running Authentication Flow Tests..."
flutter test integration_test/flows/auth_flow_test.dart

echo "Running Student-Teacher Interaction Tests..."
flutter test integration_test/flows/student_teacher_interaction_test.dart

echo "Running Course Management Tests..."
flutter test integration_test/flows/course_management_test.dart 