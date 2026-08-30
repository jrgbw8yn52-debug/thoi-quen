# Thói quen

App Flutter offline. Một máy. SQLite qua Drift.

Không AEGIS. Không website. Không PWA. Không localhost:5173.
Không IndexedDB. Không account. Không iCloud/Drive làm nguồn.

Sandbox / mạng / AI / preview web: **tắt** trừ khi người dùng hỏi.

Cổng hiện tại: **4 xong**. Không làm cổng 5 cho đến khi được bảo chạy tiếp.

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
- Chip đầu trang: chưa cân → `Thêm cân`. Có cân + đích → `Cân kg · còn x kg` (còn = cân − đích, giả định giảm). Có cân chưa đích → `Cân kg`. Tap mở tab Cơ thể. Không hiện kcal thừa/thiếu trên Home.
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

### 4) Cơ thể — cổng 4
Cân hôm nay, cân đích, sparkline (≥2 lần cân), BMI mốc Á 23 / 27,5, BMR Mifflin–St Jeor 1990 lúc đọc,
TDEE = BMR × hệ số, không persist BMI/BMR/TDEE/kcal.
Cạnh TDEE: `sai số ±200–400`.
Thiếu chiều cao hoặc cân hoặc ngày sinh hoặc giới → ẩn số, hiện `Thiếu dữ liệu` / `Thêm cân`. Không bịa 70 kg.

Disclaimer dưới số và first-run Cơ thể:
`Ước tính, không thay lời bác sĩ. Không chẩn đoán hay điều trị.`

Một tap Nguồn:
- Mifflin 1990 (BMR)
- WHO châu Á (mốc BMI)
- Compendium of Physical Activities (MET)
- Hệ số hoạt động TDEE: **không** nằm trong paper Mifflin — ghi riêng.

Kcal tập: `0.0175 × MET × kg × phút`. kg = cân gần nhất. Thiếu cân → không tính.

BMR:
- Nam: `10*kg + 6.25*cm − 5*tuổi + 5`
- Nữ: `10*kg + 6.25*cm − 5*tuổi − 161`

### 5) Cài đặt — cổng 6, chưa đủ
Cổng 2: dòng cố định `Dữ liệu chỉ trên máy này.`
Cổng 6: Xuất một tệp `VACUUM INTO` sqlite (habits + ticks + profile + weigh_ins).
Khôi phục = thay toàn bộ. Cảnh báo: `Thay toàn bộ dữ liệu trên máy này. Không gộp.`
Thêm: `Hai máy cùng ghi sẽ lệch. Chỉ một máy ghi.`

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
- `lib/man/co_the.dart` — Cơ thể (mỏng ở cổng 2).
- `lib/man/cai_dat.dart` — Cài đặt (mỏng ở cổng 2).
- `lib/ten.dart` — chuẩn hoá tên, một tên = một hàng.
- `lib/man/them_habit.dart` — thêm / sửa, stepper N.
- `lib/cong_thuc.dart` — BMI / BMR / TDEE lúc đọc, không persist.

Test không được bịa số. Test UI không được chứa chuỗi cấm.
