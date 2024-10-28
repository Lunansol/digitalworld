import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In 사용
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  Timer? _timer; // nullable로 변경
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Google Sign-In 객체 초기화

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/splash2.mp4')
      ..initialize().then((_) {
        if (!mounted) return;

        setState(() {});
        _controller.play();
        _controller.addListener(_checkVideo);

        // 비디오 재생 시작 후 백업 타이머 설정 (5초 후 자동 이동)
        _timer = Timer(const Duration(seconds: 4), () {
          _navigateToNext();
        });
      }).catchError((error) {
        debugPrint('Video initialization error: $error');
        // 비디오 로드 실패시 바로 다음 화면으로 이동
        _navigateToNext();
      });
  }

  void _checkVideo() {
    // duration과 정확히 같을 필요 없이 이상이면 됨
    if (_controller.value.position >= _controller.value.duration) {
      _navigateToNext();
    }
  }

  void _navigateToNext() async {
    if (!mounted) return;

    _controller.removeListener(_checkVideo);
    // Google Sign-In 상태 확인
    final GoogleSignInAccount? user = await _googleSignIn.signInSilently();

    if (!mounted) return;

    if (user == null) {
      Navigator.pushReplacementNamed(context, '/login_page'); // 로그인 페이지로 이동
    } else {
      Navigator.pushReplacementNamed(context, '/home_page'); // 홈 페이지로 이동
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040053),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel(); // null 체크와 함께 취소
    super.dispose();
  }
}