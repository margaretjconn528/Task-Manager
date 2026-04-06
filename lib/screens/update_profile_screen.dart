import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/Controller/auth_controller.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

import '../data/models/api_response.dart';
import '../data/services/api_caller.dart';
import '../utils/urls.dart';


class UpdateProfileScreen extends StatefulWidget {
  // constructor
  const UpdateProfileScreen({super.key});

  @override
  // state create করা হচ্ছে
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // form validation key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // input field controller গুলো
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // image picker instance
  final ImagePicker _imagePicker = ImagePicker();
  
  // selected image রাখার variable
  XFile? _selectedImage;
  
  // loading state
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    
    // logged-in user data নেওয়া হচ্ছে
    UserModel user = AuthController.userModel!;

    // controller গুলোতে initial data set করা হচ্ছে
    _emailController.text = user.email;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _mobileController.text = user.mobile;
  }

  // gallery থেকে image pick করার function
  Future<void> pickImage() async {
    final XFile? image =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    
    // image select হলে assign করা হচ্ছে
    if (image != null) {
      _selectedImage = image;
      
      // UI refresh
      setState(() {});
    }
  }

  // profile update করার method
  Future<void> updateProfile() async {
    
    // request body তৈরি
    Map<String, dynamic> requestBody = {
      "email": _emailController.text,
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "mobile": _mobileController.text,
    };

    // যদি password দেওয়া হয় তাহলে add করা হচ্ছে
    if (_passwordController.text.isNotEmpty) {
      requestBody['password'] = _passwordController.text;
    }

    // loading true
    setState(() {
      isLoading = true;
    });

    // API call
    final ApiResponse response = await ApiCaller.PostRequest(
      URL: Urls.ProfileUpdateURL,
      body: requestBody,
    );

    // loading false
    setState(() {
      isLoading = false;
    });

    // success হলে
    if (response.isSuccess) {
      
      // নতুন user model তৈরি করা হচ্ছে
      UserModel model = UserModel(
        id: AuthController.userModel!.id,
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        mobile: _mobileController.text,
        photo: '', // ⚠️ image handle করা হয়নি
      );

      // local storage update
      AuthController.updateUserData(model);

      // success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile Updated success..!'))
      );
    } else {
      // error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.responseData['data']))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // custom appbar
      appBar: TmAppbar(),
      
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(30.0),
        
        child: Form(
          key: _formKey,
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              SizedBox(height: 50,),
              
              // title
              Text(
                'Update profile',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              
              SizedBox(height: 25,),
              
              // image picker section
              InkWell(
                onTap: () {
                  pickImage(); // image select
                },
                
                child: Container(
                  height: 50,
                  width: double.maxFinite,
                  
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  
                  child: Row(
                    children: [
                      
                      // left label
                      Container(
                        child: Text('photo'),
                        height: 50,
                        width: 80,
                        alignment: Alignment.center,
                        
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)
                          )
                        ),
                      ),
                      
                      // selected image name show
                      Expanded(
                        child: Text(
                          _selectedImage?.name.toString() ?? '',
                          
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          maxLines: 1,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 10,),
              
              // email field
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(hintText: 'Email'),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter email';
                  } else {
                    return null;
                  }
                },
              ),
              
              SizedBox(height: 10,),
              
              // first name
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(hintText: 'First name'),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter First name';
                  } else {
                    return null;
                  }
                },
              ),
              
              SizedBox(height: 10,),
              
              // last name
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(hintText: 'Last name'),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Last name';
                  } else {
                    return null;
                  }
                },
              ),
              
              SizedBox(height: 10,),
              
              // mobile field
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(hintText: 'Mobile'),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter phone number';
                  } else if (value.length != 11) {
                    return 'Please enter correct phone number';
                  } else {
                    return null;
                  }
                },
              ),
              
              SizedBox(height: 10,),
              
              // password field (optional)
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Password'),
              ),
              
              // loading হলে spinner
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  
                  // না হলে button
                  : FilledButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          updateProfile(); // update call
                        }
                      },
                      child: Icon(Icons.arrow_circle_right_outlined)
                    ),
            ],
          ),
        ),
      ),
      ),
    );
  }
}