import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_yarab/Screens/Camera/recomended_screen.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../Styles/colors.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  ImagePicker picker = ImagePicker();
  final User? user = FirebaseAuth.instance.currentUser;

  late File file;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickdFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickdFile != null) {
      file = File(pickdFile.path);
      setState(() {});
    } else {
      print('error');
    }
  }

  Future<void> uploadImage() async {
    var stream = http.ByteStream(file.openRead());
    stream.cast();
    var length = await file.length();

    var uri = Uri.parse(
        'https://graduation-project-nodejs.onrender.com/api/model/predict/${user!.uid}');
    var request = http.MultipartRequest('POST', uri);
    var multiport = http.MultipartFile(
      'file',
      stream,
      length,
    );

    request.files.add(multiport);

    var response = await request.send();

    if (response.statusCode == 200) {
      print('image sended');
    } else {
      print('fild');
      print('${response.statusCode}');
    }
  }

  Future<void> postImageToApiFromCamera() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image!= null) {
      File file = File(image.path);
      var request = http.MultipartRequest('POST', Uri.parse('https://graduation-project-nodejs.onrender.com/api/model/predict/${user!.uid}'));
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        await file.readAsBytes(),
        filename: file.path,
        contentType: MediaType('image', 'jpeg'),
      ));
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        showMessage('Your skin type has been recognized');
      } else {
        print('Error uploading image: ${response.statusCode}');
        showMessage('Your skin type has not been recognized');
      }
    } else {
      print('No image selected');
      showMessage('No image selected');
    }
  }

  Future<void> postImageToApiFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image!= null) {
      File file = File(image.path);
      var request = http.MultipartRequest('POST', Uri.parse('https://graduation-project-nodejs.onrender.com/api/model/predict/${user!.uid}'));
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        await file.readAsBytes(),
        filename: file.path,
        contentType: MediaType('image', 'jpeg'),
      ));
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        showMessage('Your skin type has been recognized');
      } else {
        print('Error uploading image: ${response.statusCode}');
        showMessage('Your skin type has not been recognized');
      }
    } else {
      print('No image selected');
      showMessage('No image selected');
    }
  }

  double textScaleFactor = 1.0;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
          padding: const EdgeInsets.all(30.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Center(
                    child: Text(
                      'Identify my skin type'.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: defaultColor,
                      ),
                    )
                ),
                SizedBox(height: screenHeight * 0.02),
                const Text(
              '1.Wash your face with your denser',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            const Text(
              '2.Dry you skin with paper towels',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            const Text(
              '3.Wait for a minute or two',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
                 const Flexible(
                  child: Text(
                    'Note : Analyzing your skin features takes time, So please be patient!',
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0 ,
                    ),
                  ),
                ),


            SizedBox(height: screenHeight * 0.05,),
            ElevatedButton(
                onPressed:postImageToApiFromCamera,
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                ),
                child: const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Camera ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                )),
                SizedBox(height: screenHeight * 0.005),
            ElevatedButton(
                onPressed: postImageToApiFromGallery,
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                ),
                child:  const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                )),
                SizedBox(height: screenHeight * 0.005),

                const Flexible(
                  child: Text(
                    'You will be notified when the result is ready.',
                    maxLines: 3,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0 ,
                    ),
                  ),
                ),

            const Spacer(),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const RecomendedProductsScreen();
                  }));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                ),
                child:  const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Recommended Products',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                )),
          ])),
    );
  }
  void showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

