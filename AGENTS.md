# Thói quen

App Flutter offline. Một máy. SQLite qua Drift.

Không AEGIS. Không website. Không PWA. Không localhost:5173.
Không IndexedDB. Không account. Không iCloud/Drive làm nguồn.

Sandbox / mạng / AI / preview web: **tắt** trừ khi người dùng hỏi.

Cổng hiện tại: **Lịch + thứ tuần + nhắc local**. Không foods. Không Health. Không IAP.

---

## Giao diện

Nền `#0c0d0b`. Mặt `#161714`. Chữ `#e7e4dc`. Thép `#b9c0b8`. Xong `#3d9a7a`. Cảnh báo `#c45c4a`.
Toàn app. Không neon, không tím, không vàng gold. Hàng ≥ 44pt.

---

## Sản phẩm

V1: tick thói quen theo ngày + cân. Dữ liệu chỉ trên máy này.
Tối đa 8 habit. Home là việc hôm nay, không poster, không lưới habit×31.

UI **tiếng Việt toàn bộ**. Cấm chuỗi Anh trên UI:

| Cấm | Dùng |
|---|---|
| Today | Hôm nay |
| Done | Xong |
| Backup | Xuất bản sao |
| Restore | Khôi phục |
| Habits | Thói quen |
| Settings | Cài đặt |
| Goal | Mục tiêu |
| Streak | Chuỗi |

Tap cả hàng ≥ 44pt. Một tay. Tick một lần, tap lại hoàn tác, không dialog, không tick 2 bước.

---

## Cấm v1

Lưới habit×31 trên Home. Checkbox 12px. Tick 2 bước. Dialog xác nhận khi tick.
Account. iCloud/Drive làm nguồn. HealthKit/Fit. AI/voice/barcode. Clone Wao.
Nhật ký ăn. P/C/F. XP. Thông báo. Excel grid. IndexedDB. Bịa số khi thiếu.
Persist BMI/TDEE/kcal. Bảng foods. Website. PWA. Web platform Flutter.
Chuỗi Anh trên UI.

---

## Schema (Drift)

`schemaVersion` bắt đầu = 1. Mỗi đổi cấu trúc: bump + migration. Không sửa
cột im lặng.

### habits
- id INTEGER PK autoincrement
- ten TEXT
- muc_tieu_thang INTEGER DEFAULT 25
- met REAL NULL
- phut_mac_dinh INTEGER NULL
- thu_tu INTEGER DEFAULT 0
- tao_luc DATETIME

### ticks
PK kép `(habit_id, ngay)`. UNIQUE theo spec.
- habit_id INTEGER FK habits ON DELETE CASCADE
- ngay TEXT `yyyy-MM-dd` (local, không giờ)
- phut INTEGER NULL — ghi phút mặc định lúc tick Home nếu habit có MET

### profile
Một hàng `id = 1`.
- sex TEXT NULL (`nam` / `nu`)
- height_cm REAL NULL
- dob TEXT NULL `yyyy-MM-dd`
- activity REAL DEFAULT 1.2 (chỉ 1.2 / 1.375 / 1.55 / 1.725 / 1.9)
- target_kg REAL NULL
- ten_goi TEXT NULL

`schemaVersion` = 4. `tap_ins` (loại + phút, PK ngày). `eo_ins` tuỳ. Không persist % mỡ.

Không cột bmr / tdee / bmi / kcal.

### weigh_ins
PK `ngay TEXT yyyy-MM-dd`. UNIQUE.
- kg REAL

Không bảng foods. Không macro.

---

## Màn hình

### 1) Home — cổng 2
- Dòng ngày: `Thứ …, d tháng m yyyy`. **Tap dòng ngày** mở con lăn ngày/tháng/năm. Đổi lăn = đổi `selectedDate` + list. Huỷ trả ngày lúc mở.
- `n/m hôm nay` khi đang xem hôm nay. Ngày khác: `n/m ngày d/m`. Ngày khóa ghi thêm `· Chỉ xem.`
- Hàng habit: tên + `x/N tháng này`. Cả hàng tick ngày đang xem nếu còn ghi được; tap lại hoàn tác; không dialog.
- Dải 7 chấm tuần của ngày đang xem: **chỉ hiển thị**, không đổi ngày.
- Khóa ghi: ngày cách hôm nay > 7 ngày (và ngày tương lai) chỉ đọc — không tick, không hoàn tác, không thêm habit.
- Thêm thói quen dưới list, theo ngày đang xem. Habit mới tự tick đúng ngày đó. Không backfill ngày khác.
- Một `selectedDate` dùng chung. Back về Home hiện mọi habit của ngày đó (kể cả tháng trước).
- Chip đầu trang: chưa cân → `Thêm cân`. Có cân + đích → `Cân kg · còn x kg`. Tap mở tab **Tiến độ**. Không hiện kcal thừa/thiếu trên Home.
- Tối đa 8 habit.
- First-run (0 habit): chip `Dậy 6 giờ` / `Vận động` / `Đọc 20 trang` + `Tự đặt tên`. Không carousel. Không seed rượu/porn. Không tự insert trước khi tap.
- Một tên = một hàng. Chip đã chọn không tạo thêm. Tap liên tiếp không nhân bản. `gopTenTrung()` lúc mở DB.
- Tick: UI đổi ngay, ghi Drift sau (hàng đợi theo habit+ngày).
- `Vận động`: met = 5.5 (Compendium, health club exercise general), phút mặc định 30. Tick Home ghi 30 vào ticks.phut.

### 2) Thêm thói quen — cổng 3
Một màn. Tên. Stepper mục tiêu tháng, mặc định 25 (`N ngày trong tháng này`). Lưu / Huỷ.
Trùng tên → không lưu, hiện `Đã có thói quen này.`
Habit vận động: MET + phút mặc định (cổng 5 hiện kcal).

### 3) Một habit — cổng 3
Dải 28–31 ngày của tháng đang xem (chỉ màn này, không đưa lên Home).
`Chuỗi n ngày`. `Còn k ngày nữa là đạt N` (k=0 → `Đã đạt N`).
Sửa / Xoá. Confirm xoá đúng câu: `Xoá khỏi máy này? Không lấy lại được.`
Nếu có MET: hiện kcal buổi (tính lúc đọc) — cổng 5.

### 4) Tiến độ + Cài đặt
Tab: **Hôm nay | Tiến độ | Cài đặt**. Không tab Cơ thể. Không clone Wao. Không P/C/F. Không Health.

**Tiến độ** (cùng `selectedDate` với Home):
1. Ngày đang xem: % hoàn thành + `n/m`. Vòng.
2. Tuần chứa ngày đó: 7 cột % T2→CN. Tap cột → `selectedDate`.
3. Tháng chứa ngày đó: một hàng cột % theo ngày (không lưới habit×31). Tap cột → `selectedDate`.
4. Cân: 1 mốc = chấm. ≥2 = sparkline + vạch đích. Cấm câu «Ghi thêm cân để thấy đường» khi ≥1 mốc. Ô không xóa. Dưới ô: `Cân hiện tại x · đích y · còn z`.
Ngày >7 ngày trước: chỉ xem, không tick, không ghi cân mới.

**Cài đặt**
- `Dữ liệu chỉ trên máy này.` + `Hai máy cùng ghi sẽ lệch. Chỉ một máy ghi.`
- Hồ sơ & mục tiêu: hiện tại / mục tiêu (cân đích + nhịp 0,25|0,5 mặc định 0,5) / ghi trong ngày (cân, eo tuỳ, % mỡ tuỳ, ô không xóa). BMI/BMR/TDEE/kcal gợi ý cuối trang.
- Xuất bản sao / Khôi phục (thay toàn bộ, không gộp) / Xoá hết / Nguồn & disclaimer / Phiên bản 0.1.0.

BMI mốc Á: <18,5 thiếu · 18,5–22,9 bình thường · 23–27,4 thừa · ≥27,5 béo.
BMR Mifflin 1990 lúc đọc. TDEE = BMR × hệ số, không persist.
Cạnh TDEE: `sai số ±200–400`.
Thiếu chiều cao hoặc cân hoặc ngày sinh hoặc giới → ẩn số. Không bịa 70 kg.
Disclaimer: `Ước tính, không thay lời bác sĩ. Không chẩn đoán hay điều trị.`

Kcal tập: `0.0175 × MET × kg × phút`. Thiếu cân → không tính.

BMR:
- Nam: `10*kg + 6.25*cm − 5*tuổi + 5`
- Nữ: `10*kg + 6.25*cm − 5*tuổi − 161`

---

---

## Thứ tự cổng

1. Drift + 4 bảng + schemaVersion.
2. First-run chips + Home tick + 7 chấm + chip cân.
3. Thêm habit (N mặc định 25) + màn một habit (dải tháng + chuỗi + xoá).
4. Cơ thể + sparkline + công thức lúc đọc + disclaimer + nguồn. **← đang dừng ở đây**
5. MET/phút trên habit vận động + kcal lúc đọc.
6. Xuất VACUUM INTO / khôi phục thay toàn bộ. Round-trip một máy.

Dừng sau cổng 4 để chạy tay trước khi làm cổng 5.

---

## Chạy trên máy

Flutter 3.47+ / Dart 3.13+. Platforms: **ios, android, macos**. Không thêm `web`.

```
cd thoi_quen
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter run
```

Sau khi sửa bảng: bump `schemaVersion`, viết `onUpgrade`, chạy lại build_runner.

---

## File

- `lib/chuoi.dart` — mọi chuỗi UI. Không hardcode chữ Anh.
- `lib/ngay.dart` — ngày local `yyyy-MM-dd`, tuần bắt đầu Thứ Hai.
- `lib/db/database.dart` — bảng + AppDatabase.
- `lib/man/hom_nay.dart` — Home.
- `lib/man/tien_do.dart` — % ngày/tuần/tháng + cân.
- `lib/man/ho_so.dart` — hồ sơ & chỉ số trong Cài đặt.
- `lib/man/cai_dat.dart` — xuất / khôi phục / xoá / nguồn.
- `lib/man/cai_dat.dart` — Cài đặt (mỏng ở cổng 2).
- `lib/ten.dart` — chuẩn hoá tên, một tên = một hàng.
- `lib/man/them_habit.dart` — thêm / sửa, stepper N.
- `lib/cong_thuc.dart` — BMI / BMR / TDEE lúc đọc, không persist.

Test không được bịa số. Test UI không được chứa chuỗi cấm.
