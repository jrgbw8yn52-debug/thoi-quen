package vn.thoiquen.thoi_quen

import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val ch = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "habis/widget")
        kenh = ch
        ch.setMethodCallHandler { call, result ->
            if (call.method == "capNhat") {
                val p = getSharedPreferences(HabisWidgetProvider.PREF, MODE_PRIVATE).edit()
                p.putString(HabisWidgetProvider.K_NGAY, call.argument<String>("ngay") ?: "Thứ Hai 1/1")
                p.putString(HabisWidgetProvider.K_HABIT, call.argument<String>("habit") ?: "0/0 thói quen")
                p.putString(HabisWidgetProvider.K_KCAL, call.argument<String>("kcal") ?: "0 / 0 kcal")
                p.putString(HabisWidgetProvider.K_HABIT_NM, call.argument<String>("habitNm") ?: "0/0")
                p.putString(HabisWidgetProvider.K_KCAL_NGAN, call.argument<String>("kcalNgan") ?: "0 kcal")
                val lua = (call.argument<Number>("lua"))?.toInt() ?: 0
                p.putInt(HabisWidgetProvider.K_LUA, lua)
                p.putInt(HabisWidgetProvider.K_N, (call.argument<Number>("n"))?.toInt() ?: 0)
                p.putInt(HabisWidgetProvider.K_M, (call.argument<Number>("m"))?.toInt() ?: 0)
                val hangRaw = (call.arguments as? Map<*, *>)?.get("hang") as? List<*>
                HabisWidgetProvider.luuHang(p, hangRaw)
                p.apply()
                HabisWidgetProvider.capNhatTatCa(this)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    companion object {
        @JvmStatic
        var kenh: MethodChannel? = null

        @JvmStatic
        fun baoTick(id: Int): Boolean {
            val ch = kenh ?: return false
            Handler(Looper.getMainLooper()).post {
                try {
                    ch.invokeMethod("tickWid", id)
                } catch (_: Exception) {
                }
            }
            return true
        }
    }
}
