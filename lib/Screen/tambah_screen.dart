import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahScreen extends StatefulWidget {
  // const MyWidget({Key? key}) : super(key: key);

  @override
  State<TambahScreen> createState() => _TambahScreenState();
}

class _TambahScreenState extends State<TambahScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // XFile? selectedImage;

  // Uint8List? _image;

  // Baru
  File? _imageFile;
  String? _imageUrl;

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      // Jika gambar belum dipilih, tidak melakukan upload
      return print("object");
    }

    try {
      // Upload gambar ke Firebase Storage
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}.jpg');
      firebase_storage.UploadTask uploadTask = ref.putFile(_imageFile!);

      // Menunggu penyelesaian upload
      await uploadTask.whenComplete(() {});

      // Dapatkan URL download gambar
      String downloadUrl = await ref.getDownloadURL();

      // Simpan URL download gambar
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      // Tangani kesalahan jika ada
      print('Error uploading image: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        _uploadImage();
      }
    });
  }

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    // Mendapatkan referensi ke Firebase Storage berdasarkan URL gambar
    final ref = FirebaseStorage.instance.refFromURL(imageUrl);

    // Menghapus gambar dari Firebase Storage
    await ref.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Tambah Data Wisata",
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // ElevatedButton(
                  //   style: ButtonStyle(
                  //     backgroundColor:
                  //         MaterialStateProperty.all<Color>(Colors.white),
                  //   ),
                  //   onPressed: UploadImage,
                  //   child: const Text(
                  //     'Pilih Gambar',
                  //     style: TextStyle(color: Colors.blue),
                  //   ),
                  // ),
                  InkWell(
                    onTap: () => _pickImage(),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: _imageUrl != null
                          ? Image.network(
                              _imageUrl!.toString(),
                              fit: BoxFit.cover,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                Text('Upload',
                                    style: TextStyle(color: Colors.blue)),
                                Text('Gambar',
                                    style: TextStyle(color: Colors.blue)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Nama Wisata",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Desa",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Kecamatan",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _imageFile != null ? true : false,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      onPressed: _uploadImage,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Text(
                          'Simpan',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // InkWell(
                  //   onTap: _uploadImage,
                  //   child: Container(
                  //     color: Colors.red,
                  //     width: 50,
                  //     height: 40,
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       primary: Theme.of(context).primaryColor),
                  //   onPressed: _uploadImage,
                  //   child: Text(
                  //     'Simpan',
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  //   ),
                  // ),
                ],
              ),
            )));
  }
}

// Future<String> UploadFile(File file) async {
//   FirebaseStorage storage = FirebaseStorage.instance;

//   Reference reference = storage.ref().child('images/${file.path}');
//   UploadTask uploadTask = reference.putFile(file);
//   TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
//   String downloadUrl = await taskSnapshot.ref.getDownloadURL();
//   return downloadUrl;
// }
