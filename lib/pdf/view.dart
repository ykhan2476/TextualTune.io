import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class viewpdf extends StatefulWidget {
  const viewpdf({Key? key}) : super(key: key);

  @override
  State<viewpdf> createState() => _viewpdfState();
}

class _viewpdfState extends State<viewpdf> {
    GlobalKey<ScaffoldState> scaffState = GlobalKey<ScaffoldState>();
  String _pdfPath = "";
  
  void pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      setState(() {
        _pdfPath = result.files.single.path!;
      });
     }
  }


  @override
  Widget build(BuildContext context) {
    double hght = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      //key: scaffState,
     // drawer: Drawer(child: SingleChildScrollView(scrollDirection: Axis.vertical,child: drawer(),),),
      body: SingleChildScrollView(scrollDirection: Axis.vertical,child:Column(children: [
        SizedBox(height: 25,),
        Stack(children: [
             Container(height: 70,width: wid,child: Image.asset('assets/images/appbar.png',fit: BoxFit.cover,),),
             SizedBox(height: 70,child: IconButton(onPressed:()=>scaffState.currentState!.openDrawer(), icon: Icon(Icons.menu)),)
        ],),
            Container(child:
            _pdfPath.isNotEmpty
          ? Container(
                    height: 300,
                    child: PDFView(
                      filePath: _pdfPath,
                      enableSwipe: true,
                      swipeHorizontal: false,
                      autoSpacing: false,
                      pageSnap: true,
                      pageFling: false,
                      onRender: (pages) {
                        // PDF document is rendered
                      },
                      onError: (error) {
                        // Error occurred
                      },
                    ),
                  )
          : Center(
              child: Text('No PDF selected',style: TextStyle(color: Colors.white),),
            )
       ,height: hght,width: wid,
      decoration: BoxDecoration(gradient:LinearGradient(colors: [Colors.black,Colors.deepPurple],begin: Alignment.topCenter,end: Alignment.bottomCenter) ),),
      ],), 
    
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickFiles,
        tooltip: 'Pick PDF',
        child: Icon(Icons.file_upload),
      ),
    );
  }
}
