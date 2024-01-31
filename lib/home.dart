import 'package:VSmart/pdf/language.dart';
import 'package:VSmart/pdf/pdftoimage.dart';
import 'package:VSmart/pdf/pickpdf.dart';
import 'package:VSmart/pdf/view.dart';
import 'package:VSmart/voice.dart';
import 'package:flutter/material.dart';
class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
   
  @override
  Widget build(BuildContext context) {
    double hght = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(children: [
         SizedBox(height: 25,),
          Container(height: 70,width: wid,child: Image.asset('assets/images/appbar.png',fit: BoxFit.cover,),)
         ,Container(height: hght-95,width: wid,
      decoration: BoxDecoration(gradient:LinearGradient(colors: [Colors.black,Colors.deepPurple],begin: Alignment.topCenter,end: Alignment.bottomCenter)
     ),child:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => voice()),
                );
              },
              child: Text('Voice Assisstant Help'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => viewpdf()),
                );
              },
              child: Text('View PDF'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PickPdf()),
                );
              },
              child: Text('Get PDF Text'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PdfToImage()),
                );
              },
              child: Text('Identify Language'),
            ),
           SizedBox(height: 16),
          ],
        ),
      ), )
      ],),);
  }
}


