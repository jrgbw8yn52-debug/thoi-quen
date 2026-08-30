/// Mọi chữ hiện trên UI. Cấm thêm chuỗi Anh (Today/Done/Backup/Restore/Habits/Settings/Goal/Streak).
abstract final class Chuoi {
  static const tenApp = 'Thói quen';
  static const homNay = 'Hôm nay';
  static const tienDo = 'Tiến độ';
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
  static const chiXem = 'Chỉ xem.';
  static const chonNgay = 'Chọn ngày';
  static const uocTinh = 'Ước tính, không thay lời bác sĩ. Không chẩn đoán hay điều trị.';
  static const nguon = 'Nguồn';
  static const gioi = 'Giới';
  static const nam = 'Nam';
  static const nu = 'Nữ';
  static const chieuCao = 'Chiều cao';
  static const cm = 'cm';
  static const ngaySinh = 'Ngày sinh';
  static const mucHoatDong = 'Mức hoạt động';
  static const canDich = 'Cân đích';
  static const tenGoi = 'Tên gọi';
  static const bmi = 'BMI';
  static const bmr = 'BMR';
  static const tdee = 'TDEE';
  static const mocA = 'Mốc Á 18,5 / 23 / 27,5';
  static const saiSo = 'sai số ±200–400';
  static const kcalBuoi = 'Kcal buổi';
  static const phut = 'phút';
  static const hoSoChiSo = 'Hồ sơ & chỉ số';
  static const xuatBanSao = 'Xuất bản sao';
  static const khoiPhuc = 'Khôi phục';
  static const xoaDuLieu = 'Xoá dữ liệu';
  static const phienBan = 'Phiên bản 0.1.0';
  static const haiMayLech = 'Hai máy cùng ghi sẽ lệch. Chỉ một máy ghi.';
  static const thayToanBo = 'Thay toàn bộ dữ liệu trên máy này. Không gộp.';
  static const daXuat = 'Đã xuất bản sao trên máy này.';
  static const khongCoBanSao = 'Không có bản sao.';
  static const ghiThemCan = 'Ghi thêm cân để thấy đường';
  static const canKg = 'Cân kg';
  static const tuanNhan = 'Tuần';
  static const itVanDong = 'Ít · 1,2';
  static const nheVanDong = 'Nhẹ · 1,375';
  static const vuaVanDong = 'Vừa · 1,55';
  static const nhieuVanDong = 'Nhiều · 1,725';
  static const ratNhieuVanDong = 'Rất nhiều · 1,9';

  static const heSoNhan = [
    itVanDong,
    nheVanDong,
    vuaVanDong,
    nhieuVanDong,
    ratNhieuVanDong,
  ];
  static const mifflin = 'Mifflin 1990 (BMR)';
  static const whoA = 'WHO châu Á (mốc BMI)';
  static const compendium = 'Compendium of Physical Activities (MET)';
  static const heSoKhongMifflin =
      'Hệ số hoạt động TDEE không nằm trong paper Mifflin.';
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
    return '${thu[d.weekday - 1]}, ${d.day} tháng ${d.month} ${d.year}';
  }

  static String nTrenMHomNay(int n, int m) => '$n/$m hôm nay';

  static String nTrenMNgay(int n, int m, DateTime d) =>
      '$n/$m ngày ${d.day}/${d.month}';

  static String xTrenNThangNay(int x, int n) => '$x/$n tháng này';

  static String chipCan(String kg) => 'Cân $kg';

  static String chipCanCon(String kg, String con) => 'Cân $kg · còn $con kg';

  static String conToiDich(String con) => 'Còn $con kg tới đích';

  static String kcalBuoiSo(String n) => 'Kcal buổi $n';

  static String chipCanDat(String kg) => 'Cân $kg · $datMucTieu';

  static String nNgayTrongThang(int n) => '$n ngày trong tháng này';

  static String chuoiNNgay(int n) => 'Chuỗi $n ngày';

  static String conKDatN(int k, int n) {
    if (k <= 0) return 'Đã đạt $n';
    return 'Còn $k ngày nữa là đạt $n';
  }

  static String thang(int m) => 'Tháng $m';

  static String phanTram(int p) => '$p%';

  static String nTrenM(int n, int m) => '$n/$m';
}
