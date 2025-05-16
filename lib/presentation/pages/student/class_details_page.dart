import 'package:crossplatform_flutter/application/attendance/attendance_controller.dart';
import 'package:crossplatform_flutter/core/widgets/BooleanStrikeGrid.dart';
import 'package:crossplatform_flutter/core/widgets/attendanceSummary.dart';
import 'package:crossplatform_flutter/domain/attendance/attendanceStats.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ClassDetailsPage extends ConsumerWidget {
  final String courseId;
  final String courseName;
  final String teacherName;
  const ClassDetailsPage({super.key, required this.courseId, required this.courseName, required this.teacherName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    
    final attendanceNotifier = ref.read(attendanceControllerProvider.notifier);
   final attendanceFuture = attendanceNotifier.getAgainStudentAttendance(courseId);
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A2F),
      body: SafeArea(
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/Logo.png',
                    width: 80,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.business, size: 30),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                 
                    children: [
                      Padding(
                      
                        padding: const EdgeInsets.only(left: 50, top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              spacing: 6.6,
                              
                              children: [
                              IconButton(onPressed: (){context.go('/student-dashboard');}, icon: Icon(Icons.arrow_back_ios)),
                              Text(courseName, style: TextStyle(fontSize: 27))
                            ],),
                              Padding(
                                padding: const EdgeInsets.only(left: 50),
                                child: Text('Teacher: $teacherName', style: TextStyle(fontSize: 14)),
                              ),
                          ],
                        ),
                      ),
                     
                      
                       FutureBuilder<Attendancestats?>(
                        future: attendanceFuture,
                        builder: (context, snapshot){
                          return Expanded(
                           child: Column(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 50, top: 20),
                                 child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                   children: [
                                     Icon(Icons.outlet),
                                     Text('Tracking Summary', style: TextStyle(fontSize: 20))
                                   ],
                                 ),
                               ),
                               Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 188, 205, 214),
                          ),
                          
                          margin: EdgeInsets.all(30),
                          
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            
                            children: [
                          Icon(Icons.person_rounded),
                          Column(children: [
                            Text('Present', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('The number of days that\n the student was available', style: TextStyle()),
                            Text('${snapshot.data?.attendancePercentage}%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                          ],)
                         
                         ],),),
                          Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 188, 205, 214),
                          ),
                          
                          margin: EdgeInsets.all(30),
                          
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            
                            children: [
                          Icon(Icons.person_rounded),
                          Column(children: [
                            Text('Absent', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('The number of days that\n the student was not available', style: TextStyle()),
                            Text('${snapshot.data?.attendancePercentage}%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                          ],)
                         
                         ],),),
                           if (snapshot.connectionState == ConnectionState.waiting)
                const Center(child: CircularProgressIndicator())
              // Handle error state
              else if (snapshot.hasError)
                Center(
                  child: Text(
                    'Error loading attendance data',
                    style: TextStyle(color: Colors.red[400]),
                  ),
                )
              // Handle null or empty data
              else if (snapshot.data == null)
                const Center(child: Text('No attendance data available'))
              // Show data when available
              else
                BooleanStrikeGrid(
                  data: snapshot.data!.attendanceList,
                  size: 20,
                  gap: 4,
                  presentColor: Colors.green[400]!,
                  absentColor: Colors.red[400]!,
                ),
                             ],
                           ),
                         );
                        }
                         
                       ),
                        Padding(
                          padding: const EdgeInsets.only(left: 200, bottom: 20),
                          child: Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Navigate to QR scanner
                                        context.go('/qr_scanner_page/$courseId/$courseName/$teacherName');
                                      },
                                      icon: const Icon(Icons.qr_code_scanner),
                                      label: const Text('Scan'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF0A1A2F),
                                        foregroundColor: Colors.white,
                                        minimumSize: const Size(120, 50),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                  ),
                        ),
                       
                       
                      
                    ],
                  ),
                 
                ),
                
              ),
              
            ),
           

        ],)
      )
    );
  }
  // Widget _buildMainContent(){

  // }
   Widget _buildLoadingContent() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
   Widget _buildErrorContent(dynamic error, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 50),
          const SizedBox(height: 16),
          Text(
            'Failed to get attendance details',
            style: TextStyle(color: Colors.red[800], fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 24),
          // ElevatedButton(
          //   onPressed: () => ref.read(attendanceControllerProvider.notifier)
          //       .generateQrCode(courseId),
          //   child: const Text('Try Again'),
          // ),
        ],
      ),
    );
  }
}