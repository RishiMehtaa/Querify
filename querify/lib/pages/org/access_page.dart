// import 'package:flutter/material.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/custom_button.dart';

// class AccessPage extends StatefulWidget {
//   @override
//   _AccessPageState createState() => _AccessPageState();
// }

// class _AccessPageState extends State<AccessPage> {
//   final email = TextEditingController();
//   String accessLevel = "viewer";

//   List<Map<String, String>> orgUsers = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Manage Access")),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             CustomTextField(controller: email, label: "User Email"),
//             SizedBox(height: 10),
//             DropdownButton(
//               value: accessLevel,
//               items: [
//                 DropdownMenuItem(child: Text("Admin"), value: "admin"),
//                 DropdownMenuItem(child: Text("Data Analyst"), value: "analyst"),
//                 DropdownMenuItem(child: Text("Viewer"), value: "viewer"),
//               ],
//               onChanged: (v) => setState(() => accessLevel = v.toString()),
//             ),
//             SizedBox(height: 10),
//             CustomButton(
//               text: "Add User",
//               onTap: () {
//                 setState(() {
//                   orgUsers.add({
//                     "email": email.text,
//                     "level": accessLevel,
//                   });
//                 });
//               },
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: orgUsers.length,
//                 itemBuilder: (_, i) {
//                   final u = orgUsers[i];
//                   return ListTile(
//                     title: Text(u["email"]!),
//                     subtitle: Text("Access: ${u["level"]}"),
//                   );
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:querify/constants/appcolours.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/animated_background.dart';

class AccessPage extends StatefulWidget {
  @override
  _AccessPageState createState() => _AccessPageState();
}

class _AccessPageState extends State<AccessPage> {
  final emailController = TextEditingController();
  String accessLevel = "viewer";

  List<Map<String, String>> orgUsers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 500,
              padding: EdgeInsets.all(24),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Manage Access",
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
                  SizedBox(height: 24),

                  // Email Input
                  CustomTextField(
                    controller: emailController,
                    label: "User Email",
                  ),
                  SizedBox(height: 16),

                  // Access Level Dropdown
                  Text(
                    "Select Access Level",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(
                        color: AppColours.primary.withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: accessLevel,
                        isExpanded: true,
                        dropdownColor: AppColours.secondary,
                        style: TextStyle(color: Colors.white),
                        items: [
                          DropdownMenuItem(
                            child: Text("Admin"),
                            value: "admin",
                          ),
                          DropdownMenuItem(
                            child: Text("Data Analyst"),
                            value: "analyst",
                          ),
                          DropdownMenuItem(
                            child: Text("Viewer"),
                            value: "viewer",
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => accessLevel = v!);
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

                  // Add User Button
                  CustomButton(
                    text: "Add User",
                    onTap: () {
                      if (emailController.text.isEmpty) return;
                      setState(() {
                        orgUsers.add({
                          "email": emailController.text,
                          "level": accessLevel,
                        });
                        emailController.clear();
                      });
                    },
                  ),
                  SizedBox(height: 24),

                  // Users List
                  if (orgUsers.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: orgUsers.map((u) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColours.primary.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                u["email"]!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Access: ${u["level"]}",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
