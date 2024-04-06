import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  File? _image;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String _selectedFilter = 'All'; // Default filter value

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _addData() async {
    final FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("images/${DateTime.now().millisecondsSinceEpoch}");

    final UploadTask uploadTask = ref.putFile(_image!);
    final TaskSnapshot downloadUrl = await uploadTask;
    final String url = await downloadUrl.ref.getDownloadURL();

    _db.collection('contacts').add({
      'name': _nameController.text,
      'phoneNumber': _phoneNumberController.text,
      'age': _ageController.text,
      'imageUrl': url,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Added successfully')),
      );
      _nameController.clear();
      _phoneNumberController.clear();
      _ageController.clear();
      setState(() {
        _image = null;
      });
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add: $error')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.location_on),
            Text('nilambur'),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showFilterOptions();
                  },
                  icon: Icon(Icons.sort),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder(
                stream: _db.collection('contacts').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  var contacts = snapshot.data!.docs;

                  if (_selectedFilter == 'Elder') {
                    contacts.sort((a, b) => int.parse(b['age']).compareTo(int.parse(a['age'])));
                  } else if (_selectedFilter == 'Younger') {
                    contacts.sort((a, b) => int.parse(a['age']).compareTo(int.parse(b['age'])));
                  }

                  return ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      var contact = contacts[index];
                     return ListTile(
  leading: CircleAvatar(
    backgroundImage: NetworkImage(contact['imageUrl']), // Use NetworkImage for network images
  ),
  title: Text(contact['name']),
  subtitle: Text(contact['age']),
  trailing: IconButton(
    icon: Icon(Icons.delete),
    onPressed: () {
      _db.collection('contacts').doc(contact.id).delete();
    },
  ),
);

                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _image != null
                        ? Image.file(
                            _image!,
                            height: 100,
                          )
                        : SizedBox(
                            height: 100,
                          ),
                    ElevatedButton(
                      onPressed: _uploadImage,
                      child: Text('Pick Image'),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    TextField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Age'),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: _addData,
                      child: Text('Add'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('All'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'All';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Elder'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Elder';
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Younger'),
                onTap: () {
                  setState(() {
                    _selectedFilter = 'Younger';
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
