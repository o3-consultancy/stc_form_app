import 'package:flutter/material.dart';
import 'package:stc_form_app/locale/locale_deletage.dart';
import 'package:stc_form_app/pages/welcome_page.dart';

class ThankYouPage extends StatefulWidget {
  const ThankYouPage({super.key});

  @override
  _ThankYouPageState createState() => _ThankYouPageState();
}

class _ThankYouPageState extends State<ThankYouPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        // Check if the widget is still mounted before navigating
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const WelcomePage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/thankyoupage.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.02, // 2% from the top
            right:
                MediaQuery.of(context).size.width * 0.05, // 5% from the right
            child: SizedBox(
              height:
                  MediaQuery.of(context).size.height * 0.2, // 1/8 of the height
              child: AspectRatio(
                aspectRatio: 1, // To maintain the aspect ratio of the logo
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.contain, // Ensure the logo retains its shape
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              AppLocalizations.of(context).translate('thank_you'),
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.height * 0.035,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
