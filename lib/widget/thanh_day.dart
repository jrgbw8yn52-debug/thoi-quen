import 'package:flutter/material.dart';

import '../chuoi.dart';
import '../mau.dart';

class ThanhDay extends StatelessWidget {
  const ThanhDay({
    super.key,
    required this.tab,
    required this.onTab,
    required this.onCong,
  });

  final int tab;
  final ValueChanged<int> onTab;
  final VoidCallback onCong;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Mau.beMat,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _Muc(
                icon: Icons.check_circle_outline,
                bat: Icons.check_circle,
                chu: Chuoi.homNay,
                chon: tab == 0,
                onTap: () => onTab(0),
              ),
              _Muc(
                icon: Icons.calendar_today_outlined,
                bat: Icons.calendar_today,
                chu: Chuoi.lich,
                chon: tab == 1,
                onTap: () => onTab(1),
              ),
              Expanded(
                child: Center(
                  child: Material(
                    color: Mau.reu,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onCong,
                      child: const SizedBox(
                        width: 48,
                        height: 48,
                        child: Icon(Icons.add, color: Mau.giay, size: 28),
                      ),
                    ),
                  ),
                ),
              ),
              _Muc(
                icon: Icons.insights_outlined,
                bat: Icons.insights,
                chu: Chuoi.tienDo,
                chon: tab == 2,
                onTap: () => onTab(2),
              ),
              _Muc(
                icon: Icons.person_outline,
                bat: Icons.person,
                chu: Chuoi.taiKhoan,
                chon: tab == 3,
                onTap: () => onTab(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Muc extends StatelessWidget {
  const _Muc({
    required this.icon,
    required this.bat,
    required this.chu,
    required this.chon,
    required this.onTap,
  });

  final IconData icon;
  final IconData bat;
  final String chu;
  final bool chon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(chon ? bat : icon, color: chon ? Mau.reu : Mau.mo),
            const SizedBox(height: 2),
            Text(
              chu,
              style: TextStyle(
                fontSize: 11,
                fontWeight: chon ? FontWeight.w600 : FontWeight.w500,
                color: chon ? Mau.muc : Mau.mo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
