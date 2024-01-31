
import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:pdf_image_renderer/pdf_image_renderer.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
  
  
List<String> wordsArray = [];

void scantext(InputImage img)async{
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText = await textRecognizer.processImage(img);

String text = recognizedText.text;
for (TextBlock block in recognizedText.blocks) {
  final Rect rect = block.boundingBox;
  final List<Point<int>> cornerPoints = block.cornerPoints;
  final String text = block.text;
  final List<String> languages = block.recognizedLanguages;
  
  for (TextLine line in block.lines) {
    for (TextElement element in line.elements) {
      final String word = element.text;
        wordsArray.add(word);
        print(wordsArray);
    }
  }
}
textRecognizer.close();
}