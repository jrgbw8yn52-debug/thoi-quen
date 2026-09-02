package vn.thoiquen.thoi_quen

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "habis/widget")
            .setMethodCallHandler { call, result ->
                if (call.method == "capNhat") {
                    val p = getSharedPreferences(HabisWidgetProvider.PREF, MODE_PRIVATE).edit()
                    p.putString(HabisWidgetProvider.K_NGAY, call.argument<String>("ngay") ?: "Thứ Hai 1/1")
                    p.putString(HabisWidgetProvider.K_HABIT, call.argument<String>("habit") ?: "0/0 thói quen")
                    p.putString(HabisWidgetProvider.K_KCAL, call.argument<String>("kcal") ?: "0 / 0 kcal")
                    val lua = call.argument<Number>("lua")?.toInt() ?: 0
                    p.putInt(HabisWidgetProvider.K_LUA, lua)
                    p.apply()
                    HabisWidgetProvider.capNhatTatCa(this)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
    }
}
