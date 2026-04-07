import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/profile_provider.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/widgets/tm_appbar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    UserModel user = context.read<AuthProvider>().userModel!;
    _emailController.text = user.email;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _mobileController.text = user.mobile;
  }

  Future<void> _updateProfile() async {
    final profileProvider = context.read<ProfileProvider>();
    final authProvider = context.read<AuthProvider>();

    final response = await profileProvider.updateProfile(
      email: _emailController.text,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      mobile: _mobileController.text,
      password: _passwordController.text,
      token: authProvider.accessToken,
    );

    if (response.isSuccess) {
      UserModel model = UserModel(
        id: authProvider.userModel!.id,
        email: _emailController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        mobile: _mobileController.text,
        photo: profileProvider.base64Image ?? authProvider.userModel!.photo,
      );

      await authProvider.updateUserData(model);

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile Updated success..!')));
    } else {
      final errorMessage = response.responseData != null &&
              response.responseData is Map &&
              response.responseData['data'] != null
          ? response.responseData['data']
          : 'Profile update failed! Image might be too large.';
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TmAppbar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50),
                Text(
                  'Update profile',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                SizedBox(height: 25),
                Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    return InkWell(
                      onTap: () {
                        profileProvider.pickImage();
                      },
                      child: Container(
                        height: 50,
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 80,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomLeft: Radius.circular(10))),
                              child: Text('photo'),
                            ),
                            Expanded(
                              child: Text(
                                profileProvider.selectedImage?.name ?? '',
                                style:
                                    TextStyle(overflow: TextOverflow.ellipsis),
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(hintText: 'First name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter First name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(hintText: 'Last name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Last name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(hintText: 'Mobile'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter phone number';
                    } else if (value.length != 11) {
                      return 'Please enter correct phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
                Consumer<ProfileProvider>(
                  builder: (context, profileProvider, child) {
                    if (profileProvider.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return FilledButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _updateProfile();
                          }
                        },
                        child: Icon(Icons.arrow_circle_right_outlined));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}