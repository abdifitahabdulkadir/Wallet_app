import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

// custom imports
import '../wallet_providers/authentication_provider.dart';

class Register extends ConsumerStatefulWidget {
  static final String routeName = "/register";

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  // my input contorllers
  String _emailController = "";

  String _passwordController = "";

  String _usernameController = "";
  bool _isAuthenticatin = false;

  File? imageFile;

// key for managing forms
  final _globalKey = GlobalKey<FormState>();

// sending data to the firebaseAuthemtication
  _submitData() async {
    final isValid = _globalKey.currentState?.validate();

    if (imageFile == null && !ref.read(loginRegisterProvider)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Image Is required",
        style: TextStyle(
          color: Colors.red,
        ),
      )));
      return;
    }
    ;
    if (!ref.read(loginRegisterProvider) || isValid == true)
      _globalKey.currentState!.save();
    setState(() {
      FocusScope.of(context).unfocus();
      _isAuthenticatin = true;
    });

    if (!ref.read(loginRegisterProvider))
      await registerData(
          context: context,
          ref: ref,
          email: _emailController,
          password: _passwordController,
          username: _usernameController,
          profile_image: imageFile!);
    else
      await doLogin(
          ref: ref,
          context: context,
          email: _emailController,
          password: _passwordController);

    if (mounted)
      setState(() {
        _isAuthenticatin = false;
      });
  }

// pickes from from device using gallery source
  void _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    final _loginRegisterMode = ref.watch(loginRegisterProvider);
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: _loginRegisterMode ? 400 : 300,
              width: _loginRegisterMode ? 400 : 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/images/loginImage.png"),
              )),
            ),
            Card(
              elevation: 0,
              child: Form(
                  key: _globalKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (!_loginRegisterMode)
                          Stack(
                            children: [
                              imageFile != null
                                  ? CircleAvatar(
                                      radius: 64,
                                      backgroundImage: FileImage(imageFile!))
                                  : CircleAvatar(
                                      radius: 64,
                                      backgroundImage: NetworkImage(
                                          ref.watch(defualtImagelinkProvider)),
                                    ),
                              Positioned(
                                  bottom: -16,
                                  left: 90,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add_a_photo,
                                      size: 30,
                                      color: Colors.black,
                                    ),
                                    onPressed: _pickImage,
                                  ))
                            ],
                          ),

                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Email address",
                            prefixIcon: Icon(Icons.email),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          obscureText: false,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          validator: (enterdValue) {
                            //
                            if (enterdValue == null)
                              return "Email field* is mondotory";

                            if (enterdValue.trim().isEmpty ||
                                !enterdValue.contains("@"))
                              return "Please enter valid email addreess";
                            return null;
                          },
                          onSaved: (enteredValue) =>
                              _emailController = enteredValue!,
                        ),
                        // for username and appears for registaion only
                        if (!_loginRegisterMode)
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "username",
                              prefixIcon: Icon(Icons.person_2),
                            ),
                            autocorrect: false,
                            enableSuggestions: false,
                            obscureText: false,
                            textCapitalization: TextCapitalization.none,
                            keyboardType: TextInputType.name,
                            validator: (usernameEntered) {
                              if (usernameEntered == null)
                                return "Username field* is mondotory";
                              if (usernameEntered.trim().isEmpty)
                                return "Username can not be empty";

                              return null;
                            },
                            onSaved: (enteredUsername) =>
                                _usernameController = enteredUsername!,
                          ),
                        // for passord
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock),
                          ),
                          autocorrect: false,
                          enableSuggestions: false,
                          obscureText: true,
                          textCapitalization: TextCapitalization.none,
                          validator: (enteredPassowrd) {
                            if (enteredPassowrd == null)
                              return "Passoword* field is mondotory";

                            if (enteredPassowrd.trim().isEmpty ||
                                enteredPassowrd.trim().length < 6)
                              return "please Enter at least 6 digits";
                            return null;
                          },
                          onSaved: (value) => _passwordController = value!,
                        ),

                        // buttons for creating account or login
                        ElevatedButton(
                            onPressed: _submitData,
                            child:
                                Text(_loginRegisterMode ? "Login" : "SignUp")),
                        TextButton(
                            onPressed: () => ref
                                    .watch(loginRegisterProvider.notifier)
                                    .state =
                                !ref
                                    .watch(loginRegisterProvider.notifier)
                                    .state,
                            child: Text(_loginRegisterMode
                                ? "Don't have an Account ?"
                                : "I already have account")),

                        SizedBox(height: 10),
                        // splashScreen
                        if (_isAuthenticatin) CircularProgressIndicator(),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    )));
  }
}

// is the class that saving the Data into Firebase and fireStorage
// we can extract this inot new file not problem but I will keap here this now

Future<void> doLogin(
    {required String email,
    required String password,
    required BuildContext context,
    required WidgetRef ref}) async {
  try {
    await ref
        .watch(firebaseAuthProvider)
        .signInWithEmailAndPassword(email: email, password: password);
  } catch (exception) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$exception")));
  }
}

Future<void> registerData(
    {required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String username,
    required String password,
    required File profile_image}) async {
  try {
    ref.read(firebaseStorageProvider).ref().getData();
    // authenticating first
    final userCredential = await ref
        .watch(firebaseAuthProvider)
        .createUserWithEmailAndPassword(email: email, password: password);

    // creating the firebaseStorga and storing picked image of the  user.

    final storagePath = await ref
        .read(firebaseStorageProvider)
        .ref()
        .child("usersImage")
        .child("${userCredential.user!.uid}.jpng");

    // putting the file the speicfied path
    await storagePath.putFile(profile_image);

    await ref
        .watch(firebaseFirestoreProvider)
        .collection("userInfo")
        .doc("${userCredential.user!.uid}")
        .set({
      "username": username,
      "user_email": email,
      "user_password": password,
      "profile_image": await storagePath.getDownloadURL(),
      "userid": userCredential.user!.uid,
    });
  } on FirebaseAuthException catch (exception) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("$exception")));
  }
}
