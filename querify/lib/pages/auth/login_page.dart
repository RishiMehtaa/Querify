// // import 'package:flutter/material.dart';
// // import '../../widgets/custom_textfield.dart';
// // import '../../widgets/custom_button.dart';

// // class LoginPage extends StatelessWidget {
// //   final email = TextEditingController();
// //   final password = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: SizedBox(
// //           width: 400,
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text("Login", style: TextStyle(fontSize: 28)),
// //               SizedBox(height: 20),
// //               CustomTextField(controller: email, label: "Email"),
// //               SizedBox(height: 10),
// //               CustomTextField(controller: password, label: "Password"),
// //               SizedBox(height: 20),
// //               CustomButton(
// //                 text: "Login",
// //                 onTap: () {
// //                   // Dummy condition
// //                   if (email.text.contains("org")) {
// //                     Navigator.pushNamed(context, '/org-home');
// //                   } else {
// //                     Navigator.pushNamed(context, '/chat');
// //                   }
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

// class LoginPage extends StatefulWidget {
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool isLoading = false;

//   void handleLogin() {
//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please fill all fields")),
//       );
//       return;
//     }

//     setState(() => isLoading = true);

//     // Simulate API call
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() => isLoading = false);

//       // Dummy check: if email contains "org" -> org user, else normal user
//       if (emailController.text.toLowerCase().contains("org")) {
//         Navigator.pushReplacementNamed(context, '/org-home');
//       } else {
//         Navigator.pushReplacementNamed(context, '/chat');
//       }
//     });
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//       body: Center(
//         child: SingleChildScrollView(
//           child: Card(
//             color: const Color.fromARGB(255, 1, 0, 72),
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
//                       fontSize: 46,
//                       fontWeight: FontWeight.bold,
//                       color: const Color.fromARGB(255, 89, 0, 255),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     "Welcome back!",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: const Color.fromARGB(255, 255, 255, 255),
//                     ),
//                   ),
//                   SizedBox(height: 40),

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
//                   SizedBox(height: 24),

//                   // Login Button
//                   isLoading
//                       ? Center(child: CircularProgressIndicator())
//                       : CustomButton(
//                           text: "Login",
//                           onTap: handleLogin,
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
//                           style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
//                         ),
//                       ),
//                       Expanded(child: Divider()),
//                     ],
//                   ),
//                   SizedBox(height: 20),

//                   // Signup Redirect
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don't have an account? ",
//                         style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pushReplacementNamed(context, '/signup');
//                         },
//                         child: Text(
//                           "Sign up",
//                           style: TextStyle(
//                             color: const Color.fromARGB(255, 81, 0, 255),
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

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  // void handleLogin() {
  //   if (emailController.text.isEmpty || passwordController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please fill all fields")),
  //     );
  //     return;
  //   }

  //   setState(() => isLoading = true);

  //   // Simulate API call
  //   Future.delayed(Duration(seconds: 1), () {
  //     setState(() => isLoading = false);

  //     // Dummy check: if email contains "org" -> org user, else normal user
  //     if (emailController.text.toLowerCase().contains("org")) {
  //       Navigator.pushReplacementNamed(context, '/org-home');
  //     } else {
  //       Navigator.pushReplacementNamed(context, '/chat');
  //     }
  //   });
  // }

  void handleLogin() async {
  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please fill all fields")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    final res = await ApiService.login(emailController.text, passwordController.text);
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
    emailController.dispose();
    passwordController.dispose();
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
                    "Welcome back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 40),

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
                  SizedBox(height: 24),

                  // Login Button
                  isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColours.primary,
                          ),
                        )
                      : GlowingButton(
                          text: "Login",
                          onTap: handleLogin,
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

                  // Signup Redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/signup');
                        },
                        child: Text(
                          "Sign up",
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