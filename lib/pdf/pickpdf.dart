import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package

class PickPdf extends StatefulWidget {
  const PickPdf({Key? key}) : super(key: key);

  @override
  State<PickPdf> createState() => _PickPdfState();
}

class _PickPdfState extends State<PickPdf> {
  GlobalKey<ScaffoldState> scaffState = GlobalKey<ScaffoldState>();
  String _pdfPath = "";
  String _pdfText = "";
  bool _loading = false; // Track the loading state

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
    setState(() {
      _loading = true; // Set loading state to true before loading text
    });

    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(_pdfPath);
    } on PlatformException {
      print('Failed to get PDF text.');
    }

    setState(() {
      _pdfText = text;
      _loading = false; // Set loading state to false after loading text
    });
  }

  @override
  Widget build(BuildContext context) {
    double hght = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffState,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
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
                SizedBox(
                  height: 70,
                  child: IconButton(
                    onPressed: () =>
                        scaffState.currentState!.openDrawer(),
                    icon: Icon(Icons.menu),
                  ),
                )
              ],
            ),
            Container(
              child: _pdfPath.isNotEmpty
                  ? _loading
                      ?  Container(width: 150, height:100.0,margin:EdgeInsets.only(top: 200,bottom :100),
            child: Shimmer.fromColors(baseColor: Colors.white,highlightColor: Colors.deepPurple,
             child: Center(child: Text('Please Wait.....',style: TextStyle(fontSize: 20),),),),) // Show shimmer while loading
                      : Container(
                          margin: EdgeInsets.all(40),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              _pdfText,
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
                      end: Alignment.bottomCenter)),
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

  // Function to build shimmer effect
  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.all(40),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(
            'Loading...',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}

