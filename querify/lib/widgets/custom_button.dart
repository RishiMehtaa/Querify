// // import 'package:flutter/material.dart';

// // class CustomButton extends StatelessWidget {
// //   final String text;
// //   final VoidCallback onTap;

// //   const CustomButton({required this.text, required this.onTap});

// //   @override
// //   Widget build(BuildContext context) {
// //     return ElevatedButton(
// //       onPressed: onTap,
// //       child: Text(text),
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';

// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onTap;
//   final Color? backgroundColor;
//   final Color? textColor;

//   const CustomButton({
//     required this.text,
//     required this.onTap,
//     this.backgroundColor,
//     this.textColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onTap,
//       style: ElevatedButton.styleFrom(
//         backgroundColor: backgroundColor ?? const Color.fromARGB(255, 60, 0, 255),
//         foregroundColor: textColor ?? Colors.white,
//         padding: EdgeInsets.symmetric(vertical: 16),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(8),
//         ),
//         elevation: 2,
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:querify/constants/appcolours.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  const CustomButton({
    required this.text,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColours.primary,
        foregroundColor: textColor ?? Colors.white,
        padding: EdgeInsets.all(36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 2,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}