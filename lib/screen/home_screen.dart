import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:faceapp/api.dart';
import 'package:faceapp/widgets/image_display.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _imageUrls = [];
  File? _imageFile;
  final List<String> _currentImageUrls = [];
  bool _isLoading = false;
  int _currentIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const Text('Home Screen'),
    const Text('Contact Options'),
  ];

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _startTimer() {
    _fetchNewImage();
  }

  Future<void> _fetchNewImage() async {
    setState(() {
      _isLoading = true;
    });
    int currentImageIndex = 0;
    try {
      final imageUrls = await ApiService.uploadImage(_imageFile!.path);
      print(imageUrls);
      Timer.periodic(const Duration(seconds: 2), (timer) {
        setState(() {
          _currentImageUrls.add(imageUrls[currentImageIndex++]);
          _isLoading = false;
        });
        if(imageUrls.length == currentImageIndex) {
          timer.cancel();
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching image: $e');
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FaceSearch'),
        centerTitle: true,
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(25.0),
        child: 
       



        
        Column(
           
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: _getImage,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 280,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _imageFile != null && !_isLoading ? _startTimer : null,
              icon: const Icon(Icons.search),
              label: const Text('Search'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: _imageFile != null && !_isLoading ? Colors.green : Colors.grey,
                padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else ImageDisplay(imageUrls: _currentImageUrls),
          ],
        ),
      ),
       bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
      ),
    );
  }
}
