import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login Admin'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage("assets/images/wite.png"),
              // fit: BoxFit.cover,
              // height: 150,
              height: MediaQuery.of(context).size.width * 0.4,
              width: MediaQuery.of(context).size.width * 0.4,
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: TextFormField(
                  controller: emailController,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    labelText: "Email",
                    floatingLabelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: TextFormField(
                  obscureText: _obscureText,
                  controller: passwordController,
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                    labelText: "Password",
                    floatingLabelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColor),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  primary: Theme.of(context).primaryColor),
              onPressed: () {
                // try {
                //   FirebaseAuth.instance.signInWithEmailAndPassword(
                //       email: emailController.text.trim(),
                //       password: passwordController.text.trim());
                // } catch (e) {
                //   print("terjadi kesalahan : $e");
                // }
                signInWithEmailAndPassword(
                    emailController.text, passwordController.text, context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                child: Text(
                  'Login',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> signInWithEmailAndPassword(
    String email, String password, context) async {
  // Validasi email dan password
  if (email.isEmpty || password.isEmpty) {
    print('Email dan password harus diisi.');
    return showLoginErrorNullDialog(context);
  }

  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    // Lakukan tindakan setelah pengguna berhasil masuk
  } catch (e) {
    print('Terjadi kesalahan saat login: $e');
    showLoginErrorDialog(context);
    // Tangani kesalahan saat login, misalnya menampilkan pesan kesalahan
  }
}

void showLoginErrorDialog(BuildContext context) {
  Get.defaultDialog(
    title: 'Login Gagal',
    middleText: 'Email atau password salah. Silakan coba lagi.',
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
        onPressed: () {
          Get.back();
        },
        child: const Text('Ok'),
      ),
    ],
  );
}

void showLoginErrorNullDialog(BuildContext context) {
  Get.defaultDialog(
    title: 'Login Gagal',
    middleText: 'Email dan password harus diisi',
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Theme.of(context).accentColor),
        onPressed: () {
          Get.back();
        },
        child: const Text('Ok'),
      ),
    ],
  );
}
