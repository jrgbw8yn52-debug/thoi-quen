/// Mọi chữ hiện trên UI. Cấm thêm chuỗi Anh (Today/Done/Backup/Restore/Habits/Settings/Goal/Streak).
abstract final class Chuoi {
  static const tenApp = 'Thói quen';
  static const homNay = 'Hôm nay';
  static const coThe = 'Cơ thể';
  static const caiDat = 'Cài đặt';
  static const thoiQuen = 'Thói quen';
  static const themCan = 'Thêm cân';
  static const xong = 'Xong';
  static const luu = 'Lưu';
  static const huy = 'Huỷ';
  static const mucTieu = 'Mục tiêu';
  static const chuoiNgay = 'Chuỗi';
  static const duLieuChiTrenMay = 'Dữ liệu chỉ trên máy này.';
  static const day6Gio = 'Dậy 6 giờ';
  static const vanDong = 'Vận động';
  static const doc20Trang = 'Đọc 20 trang';
  static const tuDatTen = 'Tự đặt tên';
  static const tenThoiQuen = 'Tên thói quen';
  static const chonThoiQuen = 'Chọn thói quen';
  static const haiLamNamNgay = '25 ngày trong tháng này';
  static const datMucTieu = 'đạt mục tiêu';
  static const canHomNay = 'Cân hôm nay';
  static const kg = 'kg';
  static const thieuDuLieu = 'Thiếu dữ liệu';
  static const chuaCoCan = 'Chưa có lần cân.';
  static const themThoiQuen = 'Thêm thói quen';
  static const sua = 'Sửa';
  static const xoa = 'Xoá';
  static const daCoThoiQuen = 'Đã có thói quen này.';
  static const xoaKhoiMay = 'Xoá khỏi máy này? Không lấy lại được.';
  static const t2 = 'T2';
  static const t3 = 'T3';
  static const t4 = 'T4';
  static const t5 = 'T5';
  static const t6 = 'T6';
  static const t7 = 'T7';
  static const cn = 'CN';

  static const thu = [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ];

  static const thuNgan = [t2, t3, t4, t5, t6, t7, cn];

  static String dongNgay(DateTime d) {
    return '${thu[d.weekday - 1]}, ${d.day} tháng ${d.month}';
  }

  static String nTrenMHomNay(int n, int m) => '$n/$m hôm nay';

  static String nTrenMNgay(int n, int m, DateTime d) =>
      '$n/$m ngày ${d.day}/${d.month}';

  static String xTrenNThangNay(int x, int n) => '$x/$n tháng này';

  static String chipCan(String kg) => 'Cân $kg';

  static String chipCanCon(String kg, String con) => 'Cân $kg · còn $con kg';

  static String chipCanDat(String kg) => 'Cân $kg · $datMucTieu';

  static String nNgayTrongThang(int n) => '$n ngày trong tháng này';

  static String chuoiNNgay(int n) => 'Chuỗi $n ngày';

  static String conKDatN(int k, int n) {
    if (k <= 0) return 'Đã đạt $n';
    return 'Còn $k ngày nữa là đạt $n';
  }

  static String thang(int m) => 'Tháng $m';
}
