// // // import 'package:flutter/material.dart';

// // // class CustomTextField extends StatelessWidget {
// // //   final TextEditingController controller;
// // //   final String label;

// // //   CustomTextField({required this.controller, required this.label});

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return TextField(
// // //       controller: controller,
// // //       decoration: InputDecoration(
// // //         labelText: label,
// // //         border: OutlineInputBorder(),
// // //       ),
// // //     );
// // //   }
// // // }


// // import 'package:flutter/material.dart';

// // class CustomTextField extends StatefulWidget {
// //   final TextEditingController controller;
// //   final String label;
// //   final bool isPassword;

// //   const CustomTextField({
// //     required this.controller,
// //     required this.label,
// //     this.isPassword = false,
// //   });

// //   @override
// //   State<CustomTextField> createState() => _CustomTextFieldState();
// // }

// // class _CustomTextFieldState extends State<CustomTextField> {
// //   bool _obscureText = true;

// //   @override
// //   Widget build(BuildContext context) {
// //     return TextField(
// //       controller: widget.controller,
// //       obscureText: widget.isPassword ? _obscureText : false,
// //       decoration: InputDecoration(
// //         labelText: widget.label,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //         ),
// //         enabledBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: BorderSide(color: Colors.grey[400]!),
// //         ),
// //         focusedBorder: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(8),
// //           borderSide: BorderSide(color: AppColours.primary!, width: 2),
// //         ),
// //         suffixIcon: widget.isPassword
// //             ? IconButton(
// //                 icon: Icon(
// //                   _obscureText ? Icons.visibility_off : Icons.visibility,
// //                   color: Colors.grey[600],
// //                 ),
// //                 onPressed: () {
// //                   setState(() {
// //                     _obscureText = !_obscureText;
// //                   });
// //                 },
// //               )
// //             : null,
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';

// class CustomTextField extends StatefulWidget {
//   final TextEditingController controller;
//   final String label;
//   final bool isPassword;

//   const CustomTextField({
//     required this.controller,
//     required this.label,
//     this.isPassword = false,
//   });

//   @override
//   State<CustomTextField> createState() => _CustomTextFieldState();
// }

// class _CustomTextFieldState extends State<CustomTextField> {
//   bool _obscureText = true;

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: widget.controller,
//       obscureText: widget.isPassword ? _obscureText : false,
//       style: TextStyle(color: Colors.white),
//       decoration: InputDecoration(
//         labelText: widget.label,
//         labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(
//             color: AppColours.primary.withOpacity(0.3),
//           ),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8),
//           borderSide: BorderSide(
//             color: AppColours.primary,
//             width: 2,
//           ),
//         ),
//         filled: true,
//         fillColor: Colors.white.withOpacity(0.05),
//         suffixIcon: widget.isPassword
//             ? IconButton(
//                 icon: Icon(
//                   _obscureText ? Icons.visibility_off : Icons.visibility,
//                   color: AppColours.primary.withOpacity(0.6),
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _obscureText = !_obscureText;
//                   });
//                 },
//               )
//             : null,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:querify/constants/appcolours.dart';

class CustomTextField extends StatelessWidget {
final TextEditingController controller;
final String label;
final bool isPassword;
final Widget? suffixIcon;
final ValueChanged<String>? onChanged;
final ValueChanged<String>? onSubmitted;

const CustomTextField({
required this.controller,
required this.label,
this.isPassword = false,
this.suffixIcon,
this.onChanged,
this.onSubmitted,
});

@override
Widget build(BuildContext context) {
return TextField(
controller: controller,
obscureText: isPassword,
onChanged: onChanged,
onSubmitted: onSubmitted,
style: TextStyle(
color: Colors.white,
fontSize: 16,
),
decoration: InputDecoration(
labelText: label,
labelStyle: TextStyle(
color: Colors.white.withOpacity(0.8),
),
filled: true,
fillColor: Colors.white.withOpacity(0.05),
suffixIcon: suffixIcon,
contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(
color: AppColours.primary.withOpacity(0.3),
),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(
color: AppColours.primary.withOpacity(0.3),
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(
color: AppColours.primary,
width: 2,
),
),
),
);
}
}
