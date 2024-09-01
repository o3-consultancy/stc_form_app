import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  bool _isMale = false;
  bool _isSubmitting = false;

  int _currentStep = 0;
  bool _isFirstNameStepCompleted = false;
  bool _isLastNameStepCompleted = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        await FirebaseFirestore.instance.collection('users').add({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'gender': _isMale ? 'Male' : 'Female',
          'submittedAt': FieldValue.serverTimestamp(),
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ThankYouPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error submitting data')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
      _animationController.forward(from: 0.0);
    } else {
      _submitForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              LinearProgressIndicator(
                value: (_currentStep + 1) / 4,
                backgroundColor: Colors.grey[300],
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 20),
              if (_currentStep == 0) _buildFirstNameStep(),
              if (_currentStep == 1) _buildLastNameStep(),
              if (_currentStep == 2) _buildEmailStep(),
              if (_currentStep == 3) _buildPhoneStep(),
              if (_currentStep == 3)
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Checkbox(
                      value: _isMale,
                      onChanged: (bool? value) {
                        setState(() {
                          _isMale = value ?? false;
                        });
                      },
                    ),
                    const Text('Male'),
                    Checkbox(
                      value: !_isMale,
                      onChanged: (bool? value) {
                        setState(() {
                          _isMale = !(value ?? false);
                        });
                      },
                    ),
                    const Text('Female'),
                  ],
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _nextStep,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(_currentStep == 3 ? 'Submit' : 'Next'),
              ),
              const SizedBox(height: 20),
              FadeTransition(
                opacity: _fadeAnimation,
                child: _buildProgressFeedback(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFirstNameStep() {
    return Column(
      children: [
        const Text(
          'Step 1: Enter Your First Name',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _firstNameController,
          decoration: InputDecoration(
            labelText: 'First Name',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your first name';
            }
            return null;
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _isFirstNameStepCompleted = true;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildLastNameStep() {
    return Column(
      children: [
        const Text(
          'Step 2: Enter Your Last Name',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _lastNameController,
          decoration: InputDecoration(
            labelText: 'Last Name',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your last name';
            }
            return null;
          },
          onChanged: (value) {
            if (value.isNotEmpty) {
              setState(() {
                _isLastNameStepCompleted = true;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildEmailStep() {
    return Column(
      children: [
        const Text(
          'Step 3: Enter Your Email',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
              return 'Please enter a valid email address';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      children: [
        const Text(
          'Step 4: Enter Your Phone Number',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone Number',
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildProgressFeedback() {
    if (_currentStep == 0 && _isFirstNameStepCompleted) {
      return const Text(
        'Great! You\'ve completed the first step!',
        style: TextStyle(
            color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
      );
    } else if (_currentStep == 1 && _isLastNameStepCompleted) {
      return const Text(
        'Awesome! You\'re on a roll!',
        style: TextStyle(
            color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
      );
    } else if (_currentStep == 2) {
      return const Text(
        'Almost there! Just one more step to go!',
        style: TextStyle(
            color: Colors.orange, fontSize: 16, fontWeight: FontWeight.bold),
      );
    } else if (_currentStep == 3) {
      return const Text(
        'Final step! You\'re doing great!',
        style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

class ThankYouPage extends StatelessWidget {
  const ThankYouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Thank you for your submission!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
