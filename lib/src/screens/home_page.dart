import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In 사용

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Google Sign-In 객체 생성

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "DK's Apps",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.yellow,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.yellow,
            ),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/1.png'),
              ),
              otherAccountsPictures: const [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/2.png'),
                )
              ],
              accountName: const Text('DK'),
              accountEmail: const Text('holic9068@gmail.com'),
              onDetailsPressed: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _handleLogout, // 로그아웃 처리
            ),
          ],
        ),
      ),
      body: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [],
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    try {
      // Google 로그아웃
      await _googleSignIn.signOut();
      if (!mounted) return;
      _navigateToLoginPage(); // 로그아웃 후 로그인 페이지로 이동
    } catch (error) {
      debugPrint("Logout failed: $error");
      if (!mounted) return;
      _showErrorSnackBar('로그아웃에 실패했습니다.');
    }
  }

  void _navigateToLoginPage() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}