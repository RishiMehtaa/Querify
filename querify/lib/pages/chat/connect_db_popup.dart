


import 'package:flutter/material.dart';
import 'package:querify/constants/appcolours.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/custom_button.dart';
import '../../services/api_service.dart';
import '../../services/auth_state.dart';
class ConnectDBPopup extends StatefulWidget {
  @override
  State<ConnectDBPopup> createState() => _ConnectDBPopupState();
}

class _ConnectDBPopupState extends State<ConnectDBPopup> {
  final host = TextEditingController();
  final user = TextEditingController();
  final pass = TextEditingController();
  final dbname = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColours.secondary.withOpacity(0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: AppColours.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Connect Database",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
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
              SizedBox(height: 20),
              CustomTextField(controller: host, label: "Host"),
              SizedBox(height: 16),
              CustomTextField(controller: user, label: "User"),
              SizedBox(height: 16),
              CustomTextField(controller: pass, label: "Password", isPassword: true),
              SizedBox(height: 16),
              CustomTextField(controller: dbname, label: "Database Name"),
              SizedBox(height: 24),
              // CustomButton(
              //   text: "Connect",
              //   onTap: () => Navigator.pop(context),
              // ),
              isLoading
    ? Center(child: CircularProgressIndicator(color: AppColours.primary))
    : CustomButton(
        text: "Connect",
        onTap: () async {
          if (host.text.isEmpty || user.text.isEmpty ||
              pass.text.isEmpty || dbname.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please fill all fields")),
            );
            return;
          }
          setState(() => isLoading = true);
          try {
            final res = await ApiService.connectDB(
              host: host.text,
              user: user.text,
              password: pass.text,
              dbname: dbname.text,
              token: AuthState.instance.token,
            );
            Navigator.pop(context, {
              'connectionId': res.connectionId,
              'dbname': dbname.text,
            });
          } on ApiException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message)),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Connection failed. Check your credentials.")),
            );
          } finally {
            setState(() => isLoading = false);
          }
        },
      ),
            ],
          ),
        ),
      ),
    );
  }
}
