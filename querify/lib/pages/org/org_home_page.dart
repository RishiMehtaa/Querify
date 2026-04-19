// import 'package:flutter/material.dart';
// import '../../widgets/custom_button.dart';

// class OrgHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Org Dashboard")),
//       body: Center(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             CustomButton(
//               text: "Manage DBs",
//               onTap: () => Navigator.pushNamed(context, '/access'),
//             ),
//             SizedBox(height: 20),
//             CustomButton(
//               text: "Query DBs",
//               onTap: () => Navigator.pushNamed(context, '/chat'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:querify/constants/appcolours.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/animated_background.dart';

class OrgHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 400,
              padding: EdgeInsets.all(32),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColours.secondary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColours.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Organization Dashboard",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColours.primary,
                      shadows: [
                        Shadow(
                          color: AppColours.primary.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40),

                  // Manage DBs Button
                  CustomButton(
                    text: "Manage DBs",
                    onTap: () => Navigator.pushNamed(context, '/access'),
                  ),
                  SizedBox(height: 20),

                  // Query DBs Button
                  CustomButton(
                    text: "Query DBs",
                    onTap: () => Navigator.pushNamed(context, '/chat'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
