// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:tutor_app/constants/colors.dart';
// import 'package:tutor_app/models/session_model.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'package:tutor_app/providers/auth_provider.dart';
// import 'package:tutor_app/providers/session_provider.dart';

// import '../../models/user_model.dart';

// class SessionScreen extends StatefulWidget {
//   const SessionScreen({Key? key, required this.session}) : super(key: key);

//   final Session session;

//   @override
//   _SessionScreenState createState() => _SessionScreenState();
// }

// class _SessionScreenState extends State<SessionScreen> {
//   PdfViewerController controller = PdfViewerController();

//   @override
//   void initState() {
//     sessionManager.establishConnection(currentUser.uid, widget.session.id, isHost: currentUser.isTutor);
//     sessionManager.pdfController = controller;
//     super.initState();
//   }

//   SessionProvider get sessionManager =>
//       Provider.of<SessionProvider>(context, listen: false);
//   AppUser get currentUser => AuthProvider.of(context).currentUser;

//   String? mediaLink;

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         //sessionManager.disconnect();
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: OrientationBuilder(builder: (context, orientation) {
//           return SafeArea(
//             child:
//                 Consumer<SessionProvider>(builder: (context, sessionProv, _) {
//               return Stack(
//                 children: [
//                   Column(
//                     children: [
//                       sessionManager.currentMedia == null
//                           ? const SizedBox.shrink()
//                           : SfPdfViewerTheme(
//                               data: SfPdfViewerThemeData(
//                                   brightness: Brightness.dark),
//                               child: Expanded(
//                                 child: SfPdfViewer.network(
//                                   widget.session.media!.values.first,
//                                   pageLayoutMode: PdfPageLayoutMode.single,
//                                   onPageChanged: (details) {
//                                     sessionManager
//                                         .updateSlideNo(details.newPageNumber);
//                                   },
//                                   enableDoubleTapZooming: true,
//                                   controller: controller,
//                                 ),
//                               ),
//                             ),
//                       Container()
//                     ],
//                   ),
//                   Align(
//                     alignment: orientation == Orientation.landscape
//                         ? Alignment.centerLeft
//                         : Alignment.topCenter,
//                     child: RotatedBox(
//                       quarterTurns:
//                           orientation == Orientation.landscape ? 1 : 0,
//                       child: Material(
//                         borderRadius: const BorderRadius.only(
//                             bottomLeft: Radius.circular(11),
//                             bottomRight: Radius.circular(11)),
//                         elevation: 5,
//                         color: Colors.black,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               const Spacer(),
//                               const Text(
//                                 'not connected',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               const Spacer(),
//                               Container(
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: const BoxDecoration(
//                                     color: primaryColor,
//                                     shape: BoxShape.circle),
//                                 child: CircleAvatar(
//                                   radius: 30,
//                                   backgroundImage: NetworkImage(widget
//                                       .session.student.getProfilePictureURL),
//                                   child: Align(
//                                     alignment: Alignment.bottomRight,
//                                     child: Container(
//                                       width: 14,
//                                       height: 14,
//                                       decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.grey),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: orientation == Orientation.landscape
//                         ? Alignment.centerRight
//                         : Alignment.bottomCenter,
//                     child: RotatedBox(
//                       quarterTurns:
//                           orientation == Orientation.landscape ? 1 : 0,
//                       child: Material(
//                         borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(11),
//                             topRight: Radius.circular(11)),
//                         elevation: 5,
//                         color: Colors.black,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(2),
//                                 decoration: const BoxDecoration(
//                                     color: primaryColor,
//                                     shape: BoxShape.circle),
//                                 child: CircleAvatar(
//                                   radius: 30,
//                                   backgroundImage: NetworkImage(
//                                       currentUser.getProfilePictureURL),
//                                   child: Align(
//                                     alignment: Alignment.bottomRight,
//                                     child: Container(
//                                       width: 14,
//                                       height: 14,
//                                       decoration: const BoxDecoration(
//                                           shape: BoxShape.circle,
//                                           color: Colors.green),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const Spacer(),
//                               RotatedBox(
//                                   quarterTurns:
//                                       orientation == Orientation.landscape
//                                           ? 3
//                                           : 0,
//                                   child: IconButton(
//                                       onPressed: () {},
//                                       icon: const Icon(
//                                         Icons.mic,
//                                         size: 26,
//                                         color: Colors.white,
//                                       ))),
//                               IconButton(
//                                   onPressed: () {},
//                                   icon: const Icon(
//                                     Icons.document_scanner,
//                                     size: 26,
//                                     color: Colors.white,
//                                   )),
//                               IconButton(
//                                   onPressed: () {
//                                     sessionManager.disconnect();
//                                     Navigator.pop(context);
//                                   },
//                                   icon: const Icon(
//                                     Icons.call_end,
//                                     size: 26,
//                                     color: Colors.red,
//                                   )),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   )
//                 ],
//               );
//             }),
//           );
//         }),
//       ),
//     );
//   }
// }
