import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';

class Language extends StatefulWidget {
  const Language({Key? key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  String _pdfPath = "";
  String _pdfText = "";
  static String detectedLang = '';
  static Map<String, List<String>> languageMap = {};

  identifyAndStoreLanguages(String text) async {
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      check(words[i]);
    }
  }

  void check(String word) async {
    final lang = LanguageIdentifier(confidenceThreshold: 0.5);
    final String resp = await lang.identifyLanguage(word);
    final List<IdentifiedLanguage> possibleLanguages =
        await lang.identifyPossibleLanguages(word);
    if (possibleLanguages.isNotEmpty) {
      setState(() {
        detectedLang = possibleLanguages[0].languageTag;
      });
    } else {
      setState(() {
        detectedLang = "Language not identified.";
      });
    }
    if (languageMap.containsKey(detectedLang)) {
      languageMap[detectedLang]!.add(word);
    } else {
      languageMap[detectedLang] = [word];
    }
  }

  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        _pdfPath = result.files.single.path!;
        _loadPdfText();
      });
    }
  }

  void _loadPdfText() async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(_pdfPath);
    } on PlatformException {
      print('Failed to get PDF text.');
    }
    setState(() {
      _pdfText = text;
    });
    identifyAndStoreLanguages(_pdfText);
  }

  Widget printMap() {
    return Column(
      children: [
        for (int i = 0; i < languageMap.length; i++)
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              "${languageMap.keys.elementAt(i)} : ${languageMap.values.elementAt(i)}",
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double hght = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 25),
            Stack(
              children: [
                Container(
                  height: 70,
                  width: wid,
                  child: Image.asset(
                    'assets/images/appbar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            Container(
              child: _pdfPath.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.all(40),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Text(
                          "Languages are:",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        'No PDF selected',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
              height: hght,
              width: wid,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.deepPurple],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFiles,
        tooltip: 'Pick PDF',
        child: Icon(Icons.file_upload),
      ),
    );
  }
}
