import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  const SignLanguageApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Language Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  String selectedLanguage = 'English';
  String selectedOption = '';
  String displayText = '';
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  void selectLanguage(String language) {
    setState(() {
      selectedLanguage = language;
    });
  }

  void selectOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  Future<void> _showTextInput() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Text'),
          content: TextField(
            controller: _textController,
            decoration: const InputDecoration(hintText: "Type your message"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                setState(() {
                  displayText = _textController.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        displayText = "Image captured: ${image.path}";
      });
    }
  }

  Future<void> _openVoiceInput() async {
    // For now, we'll just show a placeholder message
    setState(() {
      displayText = "Voice input is not implemented yet.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Translator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              languageButton('English'),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Text('LOGO', style: TextStyle(color: Colors.white)),
              ),
              languageButton('Hindi'),
            ],
          ),
          const Spacer(),
          Center(
            child: Image.asset(
              'assets/character.png',
              height: 300,
            ),
          ),
          const Spacer(),
          Text(
            displayText,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              iconButton(Icons.mic, 'Voice', _openVoiceInput),
              iconButton(Icons.text_fields, 'Text', _showTextInput),
              iconButton(Icons.camera_alt, 'Camera', _openCamera),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget languageButton(String language) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedLanguage == language ? Colors.grey : Colors.white,
      ),
      onPressed: () {
        selectLanguage(language);
      },
      child: Text(
        language,
        style: TextStyle(
          color: selectedLanguage == language ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget iconButton(IconData icon, String label, Function onPressed) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: selectedOption == label ? Colors.white : Colors.grey,
            size: selectedOption == label ? 60 : 40,
          ),
          onPressed: () {
            selectOption(label);
            onPressed();
          },
        ),
        Text(
          label,
          style: TextStyle(
            color: selectedOption == label ? Colors.white : Colors.grey,
          ),
        ),
      ],
    );
  }
}