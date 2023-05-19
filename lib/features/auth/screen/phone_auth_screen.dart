import 'package:flutter/material.dart';
import 'package:lilac_machine_test/app_config/utilities.dart';
import 'package:lilac_machine_test/features/auth/view_model/auth_view_model.dart';
import 'package:lilac_machine_test/widgets/custom_progress_bar.dart';
import 'package:provider/provider.dart';
import 'package:lilac_machine_test/app_config/routes.dart' as route;

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Mobile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone'),
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              onPressed: ()=> Provider.of<AuthViewModel>(context,listen: false).loginUsingNumber(
                  context, '+91${_phoneNumberController.text}'),
              child: auth.numberLoginLoading
                  ? const FittedBox(child: CustomProgressBar())
                  : const Text('Get OTP'),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'OTP'),
              controller: _otpController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
                onPressed: ()=> Provider.of<AuthViewModel>(context, listen: false)
                    .signInWithPhone(_otpController.text, context),
                child : auth.numberOtpLoading ? const FittedBox(child: CustomProgressBar()) :  const Text('Submit')),
          ],
        ),
      ),
    );
  }
}
