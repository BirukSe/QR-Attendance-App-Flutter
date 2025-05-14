// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:crossplatform_flutter/application/course/course_controller.dart';
// import 'package:crossplatform_flutter/domain/course/course.dart';
// import 'package:crossplatform_flutter/infrastructure/course/course_repository.dart';

// class QRDisplayPage extends ConsumerStatefulWidget {
//   final String? courseId;
  
//   const QRDisplayPage({
//     super.key,
//     this.courseId,
//   });

//   @override
//   ConsumerState<QRDisplayPage> createState() => _QRDisplayPageState();
// }

// class _QRDisplayPageState extends ConsumerState<QRDisplayPage> {
//   String? _qrImageBase64;
//   String _courseName = "Loading...";
//   String _teacherName = "Loading...";
//   bool _isLoading = true;
//   String? _error;

//   @override
//   void initState() {
//     super.initState();
//     _fetchQRCode();
//   }

//   Future<void> _fetchQRCode() async {
//     setState(() {
//       _isLoading = true;
//       _error = null;
//     });

//     try {
//       // If courseId is provided, fetch that specific course's QR code
//       if (widget.courseId != null) {
//         final courseRepo = ref.read(courseRepositoryProvider);
//         final course = await courseRepo.getCourseById(widget.courseId!);
        
//         // Get QR code for this course
//         final qrData = await courseRepo.generateQRCode(widget.courseId!);
        
//         setState(() {
//           _qrImageBase64 = qrData;
//           _courseName = course.name;
//           _teacherName = "Teacher: ${course.teacherName ?? 'Unknown'}";
//           _isLoading = false;
//         });
//       } else {
//         // If no courseId is provided, show a dialog to select a course
//         final courses = await ref.read(courseRepositoryProvider).getAllCourses();
        
//         if (courses.isEmpty) {
//           setState(() {
//             _error = "No courses available";
//             _isLoading = false;
//           });
//           return;
//         }
        
//         // Use the first course by default
//         final course = courses.first;
//         final courseRepo = ref.read(courseRepositoryProvider);
//         final qrData = await courseRepo.generateQRCode(course.id);
        
//         setState(() {
//           _qrImageBase64 = qrData;
//           _courseName = course.name;
//           _teacherName = "Teacher: ${course.teacherName ?? 'Unknown'}";
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = "Failed to load QR code: $e";
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A1A2F),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Header with back button
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Row(
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.white),
//                     onPressed: () => context.pop(),
//                   ),
//                   const Spacer(),
//                   IconButton(
//                     icon: const Icon(Icons.refresh, color: Colors.white),
//                     onPressed: _fetchQRCode,
//                   ),
//                 ],
//               ),
//             ),
//             // Main content area
//             Expanded(
//               child: Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(16),
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                   ),
//                 ),
//                 child: _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : _error != null
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   _error!,
//                                   style: const TextStyle(color: Colors.red),
//                                   textAlign: TextAlign.center,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 ElevatedButton(
//                                   onPressed: _fetchQRCode,
//                                   child: const Text('Retry'),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : _buildQRContent(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQRContent(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Course title and teacher
//         Text(
//           _courseName,
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Text(
//           _teacherName,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(height: 24),
//         // QR code section
//         Expanded(
//           child: Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Scan the QR code for Attendance',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//                 // QR code image
//                 Container(
//                   width: 250,
//                   height: 250,
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 10,
//                         spreadRadius: 5,
//                       ),
//                     ],
//                   ),
//                   child: _qrImageBase64 != null
//                       ? Image.memory(
//                           base64Decode(_qrImageBase64!),
//                           width: 220,
//                           height: 220,
//                         )
//                       : const Center(
//                           child: Text('QR code not available'),
//                         ),
//                 ),
//                 const SizedBox(height: 24),
//                 const Text(
//                   'Simply scan the QR code when you enter class to mark your attendance automatically!',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // Regenerate button
//         Center(
//           child: ElevatedButton.icon(
//             onPressed: _fetchQRCode,
//             icon: const Icon(Icons.refresh),
//             label: const Text('Regenerate QR'),
//             style: ElevatedButton.styleFrom(
//               minimumSize: const Size(200, 50),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
