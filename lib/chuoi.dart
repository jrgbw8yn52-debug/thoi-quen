import 'so.dart';

/// Mọi chữ hiện trên UI. Cấm thêm chuỗi Anh (Today/Done/Backup/Restore/Habits/Settings/Goal/Streak).
abstract final class Chuoi {
  static const tenApp = 'Habits';
  static const homNay = 'Hôm nay';
  static const tienDo = 'Tiến độ';
  static const caiDat = 'Cài đặt';
  static const taiKhoan = 'Tài khoản';
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
  static const lich = 'Lịch';
  static const sua = 'Sửa';
  static const xoa = 'Xoá';
  static const daCoThoiQuen = 'Đã có thói quen này.';
  static const xoaKhoiMay = 'Xoá khỏi máy này? Không lấy lại được.';
  static const xoaKhoiNgay = 'Xóa khỏi ngày đang xem';
  static const xoaKhoiTuanSau = 'Xóa khỏi tuần tiếp theo';
  static const xoaKhoiThangSau = 'Xóa khỏi tháng tiếp theo';
  static const xoaKhoiDs = 'Xóa thói quen khỏi danh sách';
  static const thoiKhoaBieu = 'Thống kê';
  static const thongKe = 'Thống kê';
  static const motTuan = '1 tuần';
  static const motThang = '1 tháng';
  static const sauThang = '6 tháng';
  static const muoiHaiThang = '12 tháng';
  static const tuNgay = 'Từ ngày';
  static const chuaTick = 'Chưa tick';
  static const xuatSac = 'Xuất sắc';
  static const tot = 'Tốt';
  static const kha = 'Khá';
  static const te = 'Tệ';
  static const danhGiaNhan = 'Đánh giá';
  static const gioNhac = 'Giờ nhắc';
  static const tat = 'Tắt';
  static const batNhac = 'Bật';
  static const sa = 'SA';
  static const ch = 'CH';
  static const phaiChonThu = 'Chọn ít nhất một thứ.';
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
  static const hoSoChiSo = 'Hồ sơ & mục tiêu';
  static const xuatBanSao = 'Xuất bản sao';
  static const khoiPhuc = 'Khôi phục';
  static const xoaDuLieu = 'Xoá hết';
  static const nguonDisclaimer = 'Nguồn & disclaimer';
  static const phienBan = 'Phiên bản 0.1.0';
  static const haiMayLech = 'Hai máy cùng ghi sẽ lệch. Chỉ một máy ghi.';
  static const thayToanBo = 'Thay toàn bộ dữ liệu trên máy này. Không gộp.';
  static const daXuat = 'Đã xuất bản sao.';
  static const khongCoBanSao = 'Không có bản sao.';
  static const daKhoiPhuc = 'Đã khôi phục.';
  static const fileKhongPhaiBanSao = 'File không phải bản sao.';
  static const canKg = 'Cân kg';
  static const tuanNhan = 'Tuần';
  static const thangNhan = 'Tháng';
  static const hienTai = 'Hiện tại';
  static const mucTieuPhan = 'Mục tiêu';
  static const ghiTrongNgay = 'Ghi trong ngày';
  static const ghi = 'Ghi';
  static const luuHoSo = 'Lưu hồ sơ';
  static const tap = 'Tập';
  static const diBo = 'Đi bộ';
  static const chay = 'Chạy';
  static const dapXe = 'Đạp xe';
  static const khangLuc = 'Kháng lực';
  static const yoga = 'Yoga';
  static const boi = 'Bơi';
  static const daBong = 'Đá bóng';
  static const cauLong = 'Cầu lông';
  static const nhayDay = 'Nhảy dây';
  static const gianCo = 'Giãn cơ';
  static const canBanDau = 'Cân ban đầu';
  static const anUong = 'Ăn uống';
  static const nhatKy = 'Nhật ký';
  static const seLam = 'Sẽ làm';
  static const uocMo = 'Ước tính ±5–8';
  static const kcalTapNhan = 'Kcal tập';
  static const kcalTieuThu = 'Kcal tiêu thụ';
  static const kcalNap = 'Kcal nạp';
  static const kcalNapHomNay = 'Kcal nạp hôm nay';
  static const chuaGhiNap = 'Chưa ghi kcal nạp';
  static const bmiTheoThoiGian = 'BMI theo thời gian';
  static const soDoBanDau = 'Số đo ban đầu';
  static const vuotChiTieu = 'Vượt chỉ tiêu';
  static const dungChiTieu = 'Đúng chỉ tiêu';
  static const hoiThap = 'Hơi thấp';
  static const quaThap = 'Quá thấp so với chỉ tiêu';
  static const taoCongThuc = 'Tạo công thức';
  static const monDaLuu = 'Món đã lưu';
  static const thucDon = 'Thực đơn';
  static const thucDonHomNay = 'Thực đơn hôm nay';
  static const danChuGrok = 'Dán chữ Grok';
  static const khoiLuongG = 'Khối lượng (g)';
  static const tinhVaoThucDon = 'Thực đơn ngày này';
  static const chiLuuKho = 'Chỉ kho';
  static const themMon = 'Thêm món';
  static const dam = 'Đạm';
  static const bot = 'Bột';
  static const beo = 'Béo';
  static const eoCm = 'Eo';
  static const hongCm = 'Hông';
  static const ngucCm = 'Ngực';
  static const bapTayCm = 'Bắp tay';
  static const moPhanTram = '% mỡ';
  static const nhipTuan = 'Nhịp kg/tuần';
  static const nhip05 = '0,5 kg/tuần';
  static const kcalGoiY = 'Kcal/ngày gợi ý';
  static const canNang = 'Cân nặng';
  static const hoatDongO = 'Hoạt động';
  static const chiSo = 'Chỉ số';
  static const xemBaoCao = 'Xem báo cáo';
  static const nangLuong = 'Năng lượng';
  static const ngayDangXem = 'Ngày đang xem';
  static const banDau = 'Ban đầu';
  static const moiNhat = 'Mới nhất';
  static const soVoiLanTruoc = 'so với lần trước';
  static const soVoiBanDau = 'so với ban đầu';
  static const soDoSoVoiBanDau = 'Số đo · so với ban đầu';
  static const doi = 'Đổi';
  static const phinNgay = 'Ngày';
  static const namNhan = 'Năm';
  static const baoCao = 'Báo cáo';
  static const hoanThanhTheoThu = 'Hoàn thành theo thứ';
  static const hoanThanhTheoNgay = 'Hoàn thành theo ngày';
  static const hoanThanhTheoThang = 'Hoàn thành theo tháng';
  static const tieuVongNgay = 'Thói quen · Ngày này';
  static const tieuVongTuan = 'Thói quen · Tuần này';
  static const tieuVongThang = 'Thói quen · Tháng này';
  static const tieuVongNam = 'Thói quen · Năm này';
  static const trenNhipBacSi = 'Trên 0,5 kg/tuần nên có bác sĩ.';
  static const duKienHoanThanh = 'Dự kiến hoàn thành';
  static const itVanDong = '1,2 Ít vận động — ngồi nhiều';
  static const nheVanDong = '1,375 Nhẹ — 1–3 buổi/tuần';
  static const vuaVanDong = '1,55 Vừa — 3–5 buổi/tuần';
  static const nhieuVanDong = '1,725 Nhiều — 6–7 buổi hoặc kháng lực gần mỗi ngày';
  static const ratNhieuVanDong = '1,9 Rất nặng — tập 2 buổi/ngày';

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

  static String denNgay(DateTime d) =>
      'đến ${d.day}/${d.month}/${d.year}';

  static String dongNgay(DateTime d) {
    return '${thu[d.weekday - 1]}, ${d.day} tháng ${d.month} ${d.year}';
  }

  static String nTrenMHomNay(int n, int m) => '$n/$m hôm nay';

  static String homNayNgay(DateTime d) =>
      'hôm nay ${d.day}/${d.month}/${d.year}';

  static String nTrenMHomNayCoNam(int n, int m, DateTime d) =>
      '$n/$m ${homNayNgay(d)}';

  static String nTrenMNgay(int n, int m, DateTime d) =>
      '$n/$m ngày ${d.day}/${d.month}';

  static String xTrenNThangNay(int x, int n) => '$x/$n tháng này';

  static String chipCan(String kg) => 'Cân $kg';

  static String chipCanCon(String kg, String con) => 'Cân $kg · còn $con kg';

  static String conToiDich(String con) => 'Còn $con kg tới đích';

  static String canHienTai(String x, String y, String z) =>
      'Cân hiện tại $x · đích $y · còn $z';

  static String canHienTaiKhongDich(String x) => 'Cân hiện tại $x';

  static String kcalBuoiSo(String n) => 'Kcal buổi $n';

  static String kcalTapSo(int n) => 'Kcal tập $n';

  static String kcalTieuThuHomNay(int n) => 'Kcal tiêu thụ hôm nay $n';

  static String daDoi(String x) => 'Đã đổi $x kg';

  static String tuoiCanCao(String tuoi, String kg, String cm) =>
      '$tuoi tuổi · $kg kg · $cm cm';

  static String duKienNgay(DateTime d) =>
      '$duKienHoanThanh ${dongNgay(d)}';

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

  static String daTick(int n, int m) => '$n/$m đã tick';

  static String tieuVong(int phin) {
    switch (phin) {
      case 1:
        return tieuVongTuan;
      case 2:
        return tieuVongThang;
      case 3:
        return tieuVongNam;
      default:
        return tieuVongNgay;
    }
  }

  static String tenMon(String loai) {
    switch (loai) {
      case 'di_bo':
        return diBo;
      case 'chay':
        return chay;
      case 'dap_xe':
        return dapXe;
      case 'khang_luc':
        return khangLuc;
      case 'yoga':
        return yoga;
      case 'boi':
        return boi;
      case 'da_bong':
        return daBong;
      case 'cau_long':
        return cauLong;
      case 'nhay_day':
        return nhayDay;
      case 'gian_co':
        return gianCo;
      default:
        return loai;
    }
  }

  static String tongHomNay(int n) => 'Tổng hôm nay $n kcal';

  static String doiCm(double delta, int soNgay) {
    final n = So.kg(delta);
    final s = delta > 0.05 ? '+$n' : n;
    return '$s cm · $soNgay ngày';
  }

  static String soVoiLanTruocDong(double delta, int soNgay) =>
      '$soVoiLanTruoc: ${doiCm(delta, soNgay)}';

  static String soVoiBanDauDong(double delta, int soNgay) =>
      '$soVoiBanDau: ${doiCm(delta, soNgay)}';

  static String goiYTdee(int goi, int tdee) => 'Gợi ý $goi kcal · TDEE $tdee';

  static String tdeeGoiY(int tdee, int goi) => 'TDEE $tdee · Gợi ý $goi';

  static String docNKcal(int n) => 'Đọc $n kcal';

  static String tongKcalNap(int n) => 'Tổng kcal nạp: $n';

  static String tongKcalTieuThu(int n) => 'Tổng kcal tiêu thụ: $n';

  static String napTieu(int n, int m) => 'Nạp $n · Tiêu thụ $m';

  static String theNgayDangXem({
    required int n,
    required int m,
    required int nap,
    required int? goi,
    required int tieu,
    required int lua,
  }) {
    final napChu = goi == null ? '$nap' : '$nap/$goi';
    return '$n/$m · Nạp $napChu · Tiêu thụ $tieu · Lửa $lua';
  }

  static String dongMon(String ten, int kcal, {double? g}) {
    if (g == null) return '$ten · $kcal';
    return '$ten · ${So.kg(g)} g · $kcal';
  }

  static String damBotBeo(double dam, double bot, double beo) =>
      'Đạm ${So.kg(dam)} · Bột ${So.kg(bot)} · Béo ${So.kg(beo)}';

  static String napTrenGoi(int nap, int goi) => '$nap / $goi';

  static String dongPhien(String mon, int soPhut, int? kcal) {
    if (kcal == null) return '$mon · $soPhut $phut · $thieuDuLieu';
    return '$mon · $soPhut $phut · $kcal kcal';
  }

  static String hoanThanhThoiQuen(int n, int m) =>
      'Hoàn thành $n/$m thói quen';

  static String hoanThanhDanhGia(int n, int m, String dg) =>
      'Hoàn thành $n/$m · Đánh giá: $dg';

  static String danhGia(int n, int m) {
    if (m <= 0) return te;
    final p = n / m;
    if (p >= 0.9) return xuatSac;
    if (p >= 0.75) return tot;
    if (p >= 0.5) return kha;
    return te;
  }

  static String gioNhacChu(int phut) {
    var h = phut ~/ 60;
    final m = (phut % 60).toString().padLeft(2, '0');
    final chieu = h >= 12;
    var h12 = h % 12;
    if (h12 == 0) h12 = 12;
    return '$h12:$m ${chieu ? ch : sa}';
  }
}
