import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  bool _isSigningIn = false; // 로그인 중인지 확인하는 플래그

  @override
  void initState() {
    super.initState();
    _checkSignedIn(); // 이미 로그인된 사용자가 있는지 확인
  }

  // 이미 로그인된 사용자가 있는지 확인
  Future<void> _checkSignedIn() async {
    final GoogleSignInAccount? user = await _googleSignIn.signInSilently();
    if (user != null && mounted) {
      Navigator.pushReplacementNamed(
          context, '/home_page'); // 이미 로그인된 사용자 홈 페이지로 이동
    }
  }

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
                    onTap: _isSigningIn ? null : _handleSignIn, // 로그인 중에는 클릭 방지
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
                          const SizedBox(width: 20),
                          const Text('Google')
                        ],
                      ),
                    ),
                  ),
                  if (_isSigningIn) // 로그인 중일 때 로딩 표시
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    setState(() {
      _isSigningIn = true; // 로그인 시작
    });

    try {
      // Google 계정으로 로그인
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isSigningIn = false; // 로그인 취소
        });
        return;
      }

      // 사용자 정보 가져오기
      print("User signed in: ${googleUser.displayName}");

      // 로그인 성공 후 첫 페이지로 이동
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home_page');
      }
    } catch (error) {
      print("Sign in failed: $error");
      _showErrorSnackBar('로그인에 실패했습니다.');
    } finally {
      setState(() {
        _isSigningIn = false; // 로그인 완료 후 상태 초기화
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
