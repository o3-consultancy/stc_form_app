import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stc_form_app/locale/locale_deletage.dart';
import 'package:stc_form_app/pages/thank_you_page.dart';
import 'package:stc_form_app/widgets/button.dart';

class FeedbackPage extends StatefulWidget {
  final Map<String, String> formData;

  const FeedbackPage({super.key, required this.formData});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  int _rating = 0;
  List<String> _selectedServices = [];

  bool _isLoading = false;

  // Options for the services, can be localized
  final List<Map<String, String>> _servicesOptions = [
    {'en': 'Qattah', 'ar': 'قطة'},
    {'en': 'Transfer through mobile number', 'ar': 'التحويل برقم الجوال'},
    {'en': 'Digital cards', 'ar': 'البطاقات الرقمية'},
    {'en': 'All STC pay services', 'ar': 'جميع الخدمات'},
  ];

  // Function to submit data to Firestore
  Future<void> _submitData(BuildContext context) async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });

    // Append feedback data to the form data
    widget.formData['rating'] = _rating.toString();
    widget.formData['services'] = _selectedServices.join(', ');

    try {
      // Add the data to the 'users' collection in Firestore
      await FirebaseFirestore.instance.collection('users').add({
        ...widget.formData,
        'timestamp': Timestamp.now(), // Use Firestore Timestamp
      });

      // Navigate to ThankYouPage with a smooth fade transition
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ThankYouPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    } catch (e) {
      // Handle the error, e.g., show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).translate('submit_error')),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false; // Reset loading state after submission
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detect the available height and whether the keyboard is visible
    final keyboardIsVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Positioned.fill(
            child: Image.asset(
              "assets/images/formpage.png",
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
          // Content
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15,
                    vertical: keyboardIsVisible
                        ? MediaQuery.of(context).size.height * 0.1
                        : MediaQuery.of(context).size.height * 0.23,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(
                          0, 0, 0, 0.25), // Card background color
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('survey_form'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        Text(
                          AppLocalizations.of(context)
                              .translate('feedback_question_1'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.yellow,
                              ),
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1;
                                });
                              },
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)
                              .translate('feedback_question_2'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: _servicesOptions.map((option) {
                            String text = option[
                                Localizations.localeOf(context).languageCode]!;
                            bool isSelected = _selectedServices.contains(text);

                            return CheckboxListTile(
                              title: Text(
                                text,
                                style: const TextStyle(color: Colors.white),
                              ),
                              value: isSelected,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedServices.add(text);
                                  } else {
                                    _selectedServices.remove(text);
                                  }
                                });
                              },
                              checkColor: Colors.white,
                              activeColor: const Color.fromRGBO(
                                  88, 193, 144, 1), // Green color when selected
                              controlAffinity: ListTileControlAffinity.leading,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 60),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Color.fromRGBO(88, 193, 144, 1)),
                                  )
                                : CustomLanguageButton(
                                    text: AppLocalizations.of(context)
                                        .translate('submit'),
                                    onPressed: () {
                                      if (!_isLoading) {
                                        if (_rating > 0 &&
                                            _selectedServices.isNotEmpty) {
                                          _submitData(context);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(AppLocalizations.of(
                                                      context)
                                                  .translate(
                                                      'please_fill_all_fields')),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
