import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color themeColor = Color(0xFF700202);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PassGen',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: themeColor,
          secondary: themeColor,
          tertiary: themeColor,
          inversePrimary: themeColor,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'PassGen'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isEnabled = false;
  bool isEnabledSymbols = false;
  bool isEnabledNumbers = false;
  bool isEnabledUppercaseLetters = false;
  int _currentSliderValue = 12;
  String password = ""; // Store the generated password

  @override
  void initState() {
    super.initState();
    generatePassword(); // Initialize the password when the widget is built
  }

  void generatePassword() {
    String letters = "abcdefghijklmnopqrstuvwxyz";
    String lettersUpper = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    String numbers = "0123456789";
    String symbols = "!@#\$%^&*()_+";

    var random = Random();
    List<String> charSets = [letters];

    if (isEnabledSymbols) {
      charSets.add(symbols);
    }
    if (isEnabledNumbers) {
      charSets.add(numbers);
    }
    if (isEnabledUppercaseLetters) {
      charSets.add(lettersUpper);
    }

    String selectedChars = charSets.join();

    if (selectedChars.isNotEmpty) {
      password = '';
      for (int i = 0; i < _currentSliderValue; i++) {
        int index = random.nextInt(selectedChars.length);
        password += selectedChars[index];
      }
    } else {
      password = "Error";
    }
  }

  @override
  build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                'https://raw.githubusercontent.com/danikeinox/passGen/main/assets/PassGen-logo.png',
                width: 200,
                height: 200,
              ),
              CheckboxListTile(
                value: isEnabledSymbols,
                title: const Text('Enable Symbols'),
                onChanged: (bool? value) {
                  setState(() {
                    isEnabledSymbols = value!;
                  });
                },
              ),
              CheckboxListTile(
                value: isEnabledNumbers,
                title: const Text('Enable Numbers'),
                onChanged: (bool? value) {
                  setState(() {
                    isEnabledNumbers = value!;
                  });
                },
              ),
              CheckboxListTile(
                value: isEnabledUppercaseLetters,
                title: const Text('Enable Uppercase Letters'),
                onChanged: (bool? value) {
                  setState(() {
                    isEnabledUppercaseLetters = value!;
                  });
                },
              ),
              Slider(
                  value: _currentSliderValue.toDouble(),
                  min: 1,
                  max: 30,
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value.toInt();
                    });
                  }),
              Text(_currentSliderValue.toString()),
              Text(
                password, // Use the stored password
                style: password.length > 22
                    ? Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(fontSize: 18)
                    : Theme.of(context).textTheme.headlineMedium,
              ),
              IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: password));
                },
                tooltip: 'Copy to Clipboard',
                icon: const Icon(Icons.copy),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          generatePassword(); // Regenerate the password
          setState(() {}); // Trigger a rebuild to update the displayed password
        },
        tooltip: 'Generate Password',
        child: const Icon(Icons.autorenew),
      ),
    );
  }
}
