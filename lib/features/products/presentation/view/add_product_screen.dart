import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';

class AddProductScreen extends StatefulWidget {
  final String userId;

  AddProductScreen({required this.userId});

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController nameController = TextEditingController();
  DateTime? expiryDate;
  File? imageFile;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _pickImage() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 1800,
        maxWidth: 1800,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
        print('Image picked: ${pickedFile.path}');
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Exception occurred while picking image: $e');
    }
  }

  Future<void> _pickExpiryDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != expiryDate) {
      setState(() {
        expiryDate = pickedDate;
      });
      print('Expiry date picked: $expiryDate');
    }
  }

  Future<String> _uploadImageToFirebase(File image) async {
    String fileName = path.basename(image.path);
    print('Uploading image: $fileName');

    try {
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('products/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(image);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        print('Task state: ${snapshot.state}');
        print(
            'Progress: ${(snapshot.bytesTransferred / snapshot.totalBytes) * 100} %');
      }, onError: (e) {
        print('Error during upload: $e');
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print('Image uploaded to Firebase: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      print('Exception occurred during image upload: $e');
      rethrow; // Rethrow the exception to handle it in the calling method
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавить продукт'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Название продукта'),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: _pickImage,
              child: Text('Выбрать изображение'),
            ),
            imageFile != null
                ? Image.file(imageFile!)
                : Text('Изображение не выбрано'),
            SizedBox(height: 8),
            TextButton(
              onPressed: () => _pickExpiryDate(context),
              child: Text('Выбрать срок годности'),
            ),
            expiryDate != null
                ? Text('Срок годности: ${expiryDate!.toLocal()}')
                : Text('Дата не выбрана'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isNotEmpty &&
                    imageFile != null &&
                    expiryDate != null) {
                  try {
                    final imageUrl = await _uploadImageToFirebase(imageFile!);
                    final uuid = Uuid();
                    final newProduct = ProductEntity(
                      id: uuid.v4(),
                      name: nameController.text,
                      imageUrl: imageUrl,
                      addedDate: DateTime.now(),
                      expiryDate: expiryDate!,
                    );
                    print('Product to be added: ${newProduct.toString()}');
                    context
                        .read<ProductBloc>()
                        .add(ProductAdded(widget.userId, newProduct));
                    print('ProductAdded event dispatched');
                    Navigator.pop(context);
                  } catch (e) {
                    print('Error uploading image or adding product: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Ошибка загрузки изображения или добавления продукта')),
                    );
                  }
                } else {
                  print('Validation failed. Fields are missing.');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Пожалуйста, заполните все поля')),
                  );
                }
              },
              child: Text('Добавить продукт'),
            ),
          ],
        ),
      ),
    );
  }
}
