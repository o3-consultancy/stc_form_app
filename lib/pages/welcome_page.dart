import 'package:flutter/material.dart';
import 'package:stc_form_app/locale/locale_deletage.dart';
import 'package:stc_form_app/main.dart';
import 'package:stc_form_app/pages/personal_details.dart';
import 'package:stc_form_app/widgets/button.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller and animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Set the duration of the fade-in
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn, // Use an ease-in curve for smooth fading
    );

    // Start the animation as soon as the page loads
    _controller.forward();
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is removed from the tree
    _controller.dispose();
    super.dispose();
  }

  void _changeLanguage(BuildContext context, String languageCode) {
    Locale newLocale = Locale(languageCode, '');
    MyApp.setLocale(context, newLocale);

    // Use PageRouteBuilder for custom transition
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration:
            const Duration(milliseconds: 500), // Duration of the transition
        pageBuilder: (context, animation, secondaryAnimation) =>
            PersonalDetailsPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/background-notext.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * -0.02, // 5% from the top
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
          // Welcome Text with Fade-in Animation
          Positioned(
            top: MediaQuery.of(context).size.height * 0.280, // 20% from the top
            right: MediaQuery.of(context).size.height *
                0.121, // Align to the right with a small margin
            left: 16.0, // Keep a margin from the left
            child: Directionality(
              textDirection: TextDirection.ltr, // Force LTR for the Column
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('welcome_ar'),
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.055,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                        Text(
                          AppLocalizations.of(context).translate('welcome_en'),
                          style: TextStyle(
                            fontSize:
                                MediaQuery.of(context).size.height * 0.055,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Language Selection Buttons
          Positioned(
            bottom: MediaQuery.of(context).size.height *
                0.05, // 10 px from the bottom
            left: 16.0, // Margin from the left
            right: 16.0, // Margin from the right
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90,
                  child: CustomLanguageButton(
                    text: 'ع',
                    onPressed: () {
                      _changeLanguage(context, 'ar');
                    },
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 90,
                  child: CustomLanguageButton(
                    text: 'EN',
                    onPressed: () {
                      _changeLanguage(context, 'en');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
