package vn.thoiquen.thoi_quen

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews

class HabisWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) capNhatMot(context, manager, id)
    }

    companion object {
        const val PREF = "habis_wid"
        const val K_NGAY = "ngay"
        const val K_HABIT = "habit"
        const val K_KCAL = "kcal"
        const val K_LUA = "lua"
        const val K_HABIT_NM = "habitNm"
        const val K_KCAL_NGAN = "kcalNgan"

        fun homePi(context: Context, req: Int): PendingIntent {
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                action = Intent.ACTION_MAIN
                addCategory(Intent.CATEGORY_LAUNCHER)
            }
            return PendingIntent.getActivity(
                context,
                req,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }

        fun capNhatTatCa(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, HabisWidgetProvider::class.java),
            )
            for (id in ids) capNhatMot(context, manager, id)
            HabisDemWidgetProvider.capNhatTatCa(context)
        }

        fun capNhatMot(context: Context, manager: AppWidgetManager, id: Int) {
            val p = context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.habis_widget)
            views.setTextViewText(R.id.wid_ngay, p.getString(K_NGAY, "Thứ Hai 1/1") ?: "Thứ Hai 1/1")
            views.setTextViewText(R.id.wid_habit, p.getString(K_HABIT, "0/0 thói quen") ?: "0/0 thói quen")
            views.setTextViewText(R.id.wid_kcal, p.getString(K_KCAL, "0 / 0 kcal") ?: "0 / 0 kcal")
            views.setTextViewText(R.id.wid_so, p.getInt(K_LUA, 0).toString())
            val pi = homePi(context, 0)
            views.setOnClickPendingIntent(R.id.wid_root, pi)
            views.setOnClickPendingIntent(R.id.wid_dai, pi)
            manager.updateAppWidget(id, views)
        }
    }
}
