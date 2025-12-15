import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:image_picker/image_picker.dart';

class UploadSwitcherView extends StatefulWidget {
  const UploadSwitcherView({super.key});

  @override
  State<UploadSwitcherView> createState() => _UploadSwitcherViewState();
}

class _UploadSwitcherViewState extends State<UploadSwitcherView> {
  int currentIndex = 0;

  /// IMAGE STATE
  XFile? selectedImage;

  /// FILE STATE
  String? fileName;
  String? filePath;

  /// PICK IMAGE
  Future<void> pickImage() async {
    final picked =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = picked);
    }
  }

  /// PICK FILE
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'doc', 'jpg'],
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
        filePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
          
            children: [
              const SizedBox(height: 20),
          
              /// SWITCHER
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: _switchButton("Image", 0)),
                  Expanded(child: _switchButton("File", 1)),
                ],
              ),
          
              /// SPACE تحت الـ switchers
              const SizedBox(height: 40),
          
              /// CONTENT
              Center(
                child: IndexedStack(
                  index: currentIndex,
                  children: [
                    Center(child: _imageView()),
                    _fileView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// SWITCH BUTTON
  Widget _switchButton(String title, int index) {
    final isActive = currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => currentIndex = index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.black87,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  /// IMAGE VIEW
  Widget _imageView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 50,),
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: selectedImage == null
              ? const Icon(Icons.image, size: 60, color: Colors.grey)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    File(selectedImage!.path),
                    fit: BoxFit.cover,
                  ),
                ),
        ),

        const SizedBox(height: 24),

        GestureDetector(
          onTap: pickImage,
          child: _actionButton(
            selectedImage == null ? "Upload Image" : "Change Image",
            Colors.black87,
            Colors.white,
          ),
        ),
        

        const SizedBox(height: 10),
if (selectedImage != null)
          GestureDetector(
            onTap: () => setState(() {
              showDialog(
                
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87,
        title: const Text("Done",style: TextStyle(color: Colors.green)),
        content: const Text("Your Image Uploaded Successfully.",style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK",style: TextStyle(color: Colors.green),),
          ),
        ],
      ),
    );
            }),
            child: _actionButton(
              "Done",
              Colors.green,
              Colors.white,
            ),
          ),
          const SizedBox(height: 10),
        if (selectedImage != null)
          GestureDetector(
            onTap: () => setState(() => selectedImage = null),
            child: _actionButton(
              "Remove Image",
               Colors.red,
              Colors.white,
             
            ),
          ),
      ],
    );
  }

  /// FILE VIEW
  Widget _fileView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 350,
          height: 65,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: [
              const Icon(Icons.upload_file, size: 48),

              const SizedBox(width: 8),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName ?? "Upload File",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text("pdf, docx, doc, jpg"),
                ],
              ),

              const Spacer(),

              PopupMenuButton(
                color: Colors.blue,
                itemBuilder: (_) => [
                  PopupMenuItem(
                    
                    onTap: pickFile,
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.arrow_up_doc),
                        SizedBox(width: 12),
                        Text("Upload",style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: pickFile,
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.refresh),
                        SizedBox(width: 12),
                        Text("Change",style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () =>
                        setState(() => {fileName = null, filePath = null}),
                    child: const Row(
                      children: [
                        Icon(CupertinoIcons.delete_solid, color: Color.fromARGB(255, 125, 34, 27)),
                        SizedBox(width: 12),
                        Text("Delete",
                            style: TextStyle(color: Color.fromARGB(255, 120, 31, 25))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        if (filePath != null && filePath!.endsWith("pdf"))
          SizedBox(
            width: 260,
            height: 360,
            child: PDFView(
              filePath: filePath!,
              enableSwipe: true,
              autoSpacing: true,
              pageFling: true,
              onError: (error) {
                debugPrint("PDF Error: $error");
              },
            ),
          ),
      ],
    );
  }

  /// COMMON BUTTON
  Widget _actionButton(String text, Color bg, Color textColor) {
    return Container(
      width: 180,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
