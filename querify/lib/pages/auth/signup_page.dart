// // import 'package:flutter/material.dart';
// // import '../../widgets/custom_textfield.dart';
// // import '../../widgets/custom_button.dart';

// // class SignupPage extends StatefulWidget {
// //   @override
// //   _SignupPageState createState() => _SignupPageState();
// // }

// // class _SignupPageState extends State<SignupPage> {
// //   final username = TextEditingController();
// //   final email = TextEditingController();
// //   final password = TextEditingController();
// //   String role = 'user';
// //   final orgName = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: SizedBox(
// //           width: 400,
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text("Signup", style: TextStyle(fontSize: 28)),
// //               SizedBox(height: 20),
// //               CustomTextField(controller: username, label: "Username"),
// //               SizedBox(height: 10),
// //               CustomTextField(controller: email, label: "Email"),
// //               SizedBox(height: 10),
// //               CustomTextField(controller: password, label: "Password"),
// //               SizedBox(height: 10),
// //               DropdownButton(
// //                 value: role,
// //                 items: [
// //                   DropdownMenuItem(child: Text("User"), value: "user"),
// //                   DropdownMenuItem(child: Text("Org"), value: "org"),
// //                 ],
// //                 onChanged: (v) => setState(() => role = v.toString()),
// //               ),
// //               if (role == 'user') ...[
// //                 SizedBox(height: 10),
// //                 CustomTextField(controller: orgName, label: "Organization Name"),
// //               ],
// //               SizedBox(height: 20),
// //               CustomButton(
// //                 text: "Create Account",
// //                 onTap: () {
// //                   Navigator.pushNamed(context, '/login');
// //                 },
// //               )
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import '../../widgets/custom_textfield.dart';
// import '../../widgets/custom_button.dart';

// class SignupPage extends StatefulWidget {
//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final usernameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final orgNameController = TextEditingController();
  
//   String role = 'user';
//   bool isLoading = false;

//   void handleSignup() {
//     if (usernameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please fill all required fields")),
//       );
//       return;
//     }

//     if (role == 'user' && orgNameController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please enter organization name")),
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     // Simulate API call
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() => isLoading = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Account created successfully!")),
//       );

//       // Redirect based on role
//       if (role == 'org') {
//         Navigator.pushReplacementNamed(context, '/org-home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/chat');
//       }
//     });
//   }

//   @override
//   void dispose() {
//     usernameController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     orgNameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: Center(
//         child: SingleChildScrollView(
//           child: Card(
//             elevation: 8,
//             margin: EdgeInsets.all(20),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Container(
//               width: 450,
//               padding: EdgeInsets.all(40),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Logo/Title
//                   Text(
//                     "Querify",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                       color: AppColours.primary,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "Create your account",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                   SizedBox(height: 40),

//                   // Username Field
//                   CustomTextField(
//                     controller: usernameController,
//                     label: "Username",
//                   ),
//                   SizedBox(height: 16),

//                   // Email Field
//                   CustomTextField(
//                     controller: emailController,
//                     label: "Email",
//                   ),
//                   SizedBox(height: 16),

//                   // Password Field
//                   CustomTextField(
//                     controller: passwordController,
//                     label: "Password",
//                     isPassword: true,
//                   ),
//                   SizedBox(height: 20),

//                   // Role Selection
//                   Text(
//                     "Select Role",
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.grey[700],
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey[400]!),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: DropdownButtonHideUnderline(
//                       child: DropdownButton<String>(
//                         value: role,
//                         isExpanded: true,
//                         items: [
//                           DropdownMenuItem(
//                             child: Text("User"),
//                             value: "user",
//                           ),
//                           DropdownMenuItem(
//                             child: Text("Organization"),
//                             value: "org",
//                           ),
//                         ],
//                         onChanged: (v) {
//                           setState(() => role = v!);
//                         },
//                       ),
//                     ),
//                   ),

//                   // Organization Name (only for users)
//                   if (role == 'user') ...[
//                     SizedBox(height: 16),
//                     CustomTextField(
//                       controller: orgNameController,
//                       label: "Organization Name",
//                     ),
//                   ],
//                   SizedBox(height: 24),

//                   // Signup Button
//                   isLoading
//                       ? Center(child: CircularProgressIndicator())
//                       : CustomButton(
//                           text: "Create Account",
//                           onTap: handleSignup,
//                         ),
//                   SizedBox(height: 20),

//                   // Divider
//                   Row(
//                     children: [
//                       Expanded(child: Divider()),
//                       Padding(
//                         padding: EdgeInsets.symmetric(horizontal: 16),
//                         child: Text(
//                           "OR",
//                           style: TextStyle(color: Colors.grey[600]),
//                         ),
//                       ),
//                       Expanded(child: Divider()),
//                     ],
//                   ),
//                   SizedBox(height: 20),

//                   // Login Redirect
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Already have an account? ",
//                         style: TextStyle(color: Colors.grey[700]),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacementNamed(context, '/login');
//                         },
//                         child: Text(
//                           "Login",
//                           style: TextStyle(
//                             color: AppColours.primary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import '../../services/api_service.dart';
import '../../services/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:querify/constants/appcolours.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/glowing_button.dart';
import '../../widgets/animated_background.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final orgNameController = TextEditingController();
  
  String role = 'user';
  bool isLoading = false;

  // void handleSignup() {
  //   if (usernameController.text.isEmpty ||
  //       emailController.text.isEmpty ||
  //       passwordController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please fill all required fields")),
  //     );
  //     return;
  //   }

  //   if (role == 'user' && orgNameController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please enter organization name")),
  //     );
  //     return;
  //   }

  //   setState(() => isLoading = true);

  //   // Simulate API call
  //   Future.delayed(Duration(seconds: 1), () {
  //     setState(() => isLoading = false);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Account created successfully!")),
  //     );

  //     // Redirect based on role
  //     if (role == 'org') {
  //       Navigator.pushReplacementNamed(context, '/org-home');
  //     } else {
  //       Navigator.pushReplacementNamed(context, '/chat');
  //     }
  //   });
  // }
void handleSignup() async {
  if (usernameController.text.isEmpty ||
      emailController.text.isEmpty ||
      passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill all required fields")),
    );
    return;
  }

  if (role == 'user' && orgNameController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter organization name")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    final res = await ApiService.signup(
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      role: role,
      orgName: role == 'org' ? usernameController.text : orgNameController.text,
    );
    AuthState.instance.setFromAuth(
      token: res.token,
      role: res.role,
      username: res.username,
    );
    if (res.role == 'org') {
      Navigator.pushReplacementNamed(context, '/org-home');
    } else {
      Navigator.pushReplacementNamed(context, '/chat');
    }
  } on ApiException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.message)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Something went wrong. Try again.")),
    );
  } finally {
    setState(() => isLoading = false);
  }
}

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    orgNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: Center(
        child: SingleChildScrollView(
          child: Card(
            color: AppColours.secondary.withOpacity(0.8),
            elevation: 8,
            margin: EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: AppColours.primary.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Container(
              width: 450,
              padding: EdgeInsets.all(40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Title
                  Text(
                    "Querify",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      color: AppColours.primary,
                      shadows: [
                        Shadow(
                          color: AppColours.primary.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Create your account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Username Field
                  CustomTextField(
                    controller: usernameController,
                    label: "Username",
                  ),
                  SizedBox(height: 16),

                  // Email Field
                  CustomTextField(
                    controller: emailController,
                    label: "Email",
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  CustomTextField(
                    controller: passwordController,
                    label: "Password",
                    isPassword: true,
                  ),
                  SizedBox(height: 20),

                  // Role Selection
                  Text(
                    "Select Role",
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
                        value: role,
                        isExpanded: true,
                        dropdownColor: AppColours.secondary,
                        style: TextStyle(color: Colors.white),
                        items: [
                          DropdownMenuItem(
                            child: Text("User"),
                            value: "user",
                          ),
                          DropdownMenuItem(
                            child: Text("Organization"),
                            value: "org",
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => role = v!);
                        },
                      ),
                    ),
                  ),

                  // Organization Name (only for users)
                  if (role == 'user') ...[
                    SizedBox(height: 16),
                    CustomTextField(
                      controller: orgNameController,
                      label: "Organization Name",
                    ),
                  ],
                  SizedBox(height: 24),

                  // Signup Button
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColours.primary,
                          ),
                        )
                      : GlowingButton(
                          text: "Create Account",
                          onTap: handleSignup,
                        ),
                  SizedBox(height: 20),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.white.withOpacity(0.2)),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "OR",
                          style: TextStyle(color: Colors.white.withOpacity(0.6)),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.white.withOpacity(0.2)),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Login Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: AppColours.primary,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: AppColours.primary.withOpacity(0.5),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}