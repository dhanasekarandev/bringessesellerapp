import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverlayLoader extends StatelessWidget {
  final String message;
  final bool show;

  const OverlayLoader({
    super.key,
    required this.show,
    this.message = "Please wait...",
  });

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink(); // hide when not needed

    return Container(
      height: 1.sh,
      width: 1.sw,
      color: Colors.transparent.withOpacity(0.4),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
