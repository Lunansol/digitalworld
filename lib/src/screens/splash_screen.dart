import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();  // 수정된 부분
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;
  Timer? _timer;  // nullable로 변경

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
        debugPrint('Video initialization error: $error');  // print를 debugPrint로 변경
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

  void _navigateToNext() {
    if (!mounted) return;

    _controller.removeListener(_checkVideo);
    FirebaseAuth.instance.authStateChanges().first.then((user) {
      if (!mounted) return;

      if (user == null) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        Navigator.pushReplacementNamed(context, '/home_page');
      }
    });
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
    _timer?.cancel();  // null 체크와 함께 취소
    super.dispose();
  }
}