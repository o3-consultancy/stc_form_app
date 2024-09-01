import 'package:flutter/material.dart';
import 'package:stc_form_app/locale/locale_deletage.dart';
import 'package:stc_form_app/pages/feedback_page.dart';
import 'package:stc_form_app/widgets/button.dart';
import 'package:stc_form_app/widgets/textbox.dart';

class PersonalDetailsPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  // final TextEditingController emailController = TextEditingController();

  PersonalDetailsPage({super.key});

  // Function to validate input fields
  bool _validateFields(BuildContext context) {
    if (nameController.text.isEmpty ||
        dobController.text.isEmpty ||
        mobileController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)
                .translate('please_fill_all_fields'))),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/formpage.png",
              fit: BoxFit.cover,
            ),
          ),
          // Welcome Text
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
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.15,
                    vertical: MediaQuery.of(context).size.height * 0.23,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(
                          0, 0, 0, 0.3), // Card background color
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
                        CustomInputBox(
                          controller: nameController,
                          inputType: TextInputType.text,
                          labelText:
                              AppLocalizations.of(context).translate('name'),
                        ),
                        CustomInputBox(
                          controller: dobController,
                          inputType: TextInputType.datetime,
                          labelText:
                              AppLocalizations.of(context).translate('dob'),
                        ),
                        CustomInputBox(
                          controller: mobileController,
                          inputType: TextInputType.phone,
                          labelText:
                              AppLocalizations.of(context).translate('mobile'),
                        ),
                        // CustomInputBox(
                        //   controller: emailController,
                        //   inputType: TextInputType.emailAddress,
                        //   labelText:
                        //       AppLocalizations.of(context).translate('email'),
                        // ),
                        // CustomInputBox(
                        //   controller: positionController,
                        //   inputType: TextInputType.text,
                        //   labelText: AppLocalizations.of(context)
                        //       .translate('position'),
                        // ),
                        const SizedBox(height: 60),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.3, // Adjust the width here
                            child: CustomLanguageButton(
                              text: AppLocalizations.of(context)
                                  .translate('next'),
                              onPressed: () {
                                if (_validateFields(context)) {
                                  Map<String, String> formData = {
                                    'name': nameController.text,
                                    'dob': dobController.text,
                                    'mobile': mobileController.text,
                                    // 'email': emailController.text,
                                    // 'position': positionController.text,
                                  };
                                  // Use PageRouteBuilder for custom transition
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: const Duration(
                                          milliseconds:
                                              500), // Duration of the transition
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          FeedbackPage(formData: formData),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
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
