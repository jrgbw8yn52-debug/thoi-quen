import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../mau.dart';

class ManCaiDat extends StatelessWidget {
  const ManCaiDat({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Chuoi.caiDat,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.4,
                color: Mau.muc,
              ),
            ),
            SizedBox(height: 20),
            Text(
              Chuoi.duLieuChiTrenMay,
              style: TextStyle(fontSize: 16, height: 1.4, color: Mau.muc),
            ),
          ],
        ),
      ),
    );
  }
}
