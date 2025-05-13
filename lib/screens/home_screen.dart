// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uber_taxi/auth/providers/auth_provider.dart' show AuthProvider;
// import 'login_screen.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final user = authProvider.user;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               final success = await authProvider.signOut();
//               if (success && context.mounted) {
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(builder: (_) => const LoginScreen()),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child:
//             authProvider.isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // User info card
//                       Card(
//                         elevation: 4,
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 30,
//                                     backgroundColor: Colors.blue.shade100,
//                                     child: Text(
//                                       user?.name.isNotEmpty == true
//                                           ? user!.name[0].toUpperCase()
//                                           : '?',
//                                       style: TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.blue.shade700,
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           user?.name ?? 'User',
//                                           style: const TextStyle(
//                                             fontSize: 20,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           user?.email ?? 'Email not available',
//                                           style: TextStyle(
//                                             color: Colors.grey.shade700,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 16),
//                               const Divider(),
//                               const SizedBox(height: 8),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         'Role',
//                                         style: TextStyle(color: Colors.grey),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         user?.role?.toUpperCase() ?? 'N/A',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       const Text(
//                                         'Status',
//                                         style: TextStyle(color: Colors.grey),
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         user?.status?.toUpperCase() ?? 'N/A',
//                                         style: const TextStyle(
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   if (user?.phoneNumber != null)
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         const Text(
//                                           'Phone',
//                                           style: TextStyle(color: Colors.grey),
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           user?.phoneNumber ?? 'N/A',
//                                           style: const TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // Content area
//                       Expanded(
//                         child: Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               const Icon(
//                                 Icons.check_circle_outline,
//                                 size: 64,
//                                 color: Colors.green,
//                               ),
//                               const SizedBox(height: 16),
//                               const Text(
//                                 'Authentication Successful',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               const Text(
//                                 'You are now logged in!',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }
// }
