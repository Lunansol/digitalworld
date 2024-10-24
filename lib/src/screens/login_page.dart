import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          signInWithGoogle();
                        },
                        child: Card(
                          margin: const EdgeInsets.all(20),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7)),
                          elevation: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  margin: const EdgeInsets.all(15.0),
                                  height: 50,
                                  width: 50,
                                  child: Image.asset('assets/images/google.png')),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text('Google')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
    );
  }

  Future<User?> signInWithGoogle() async {
    // 로그인 전에 기존 세션 로그아웃
    await GoogleSignIn().signOut(); // 이전 로그인 상태 해제
    // 필요 시 기존 연결까지 완전히 해제하려면 아래 줄을 추가할 수 있습니다.
    // await GoogleSignIn().disconnect();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null; // 로그인 취소
    }

    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Firebase로 인증
    final UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential.user != null && mounted) {
      Navigator.pushReplacementNamed(context, '/first_page');
    }

    return userCredential.user;
  }
}
