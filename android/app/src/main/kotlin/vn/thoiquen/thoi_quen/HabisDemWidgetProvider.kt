package vn.thoiquen.thoi_quen

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.widget.RemoteViews

class HabisDemWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) capNhatMot(context, manager, id)
    }

    companion object {
        fun capNhatTatCa(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, HabisDemWidgetProvider::class.java),
            )
            for (id in ids) capNhatMot(context, manager, id)
        }

        fun capNhatMot(context: Context, manager: AppWidgetManager, id: Int) {
            val p = context.getSharedPreferences(HabisWidgetProvider.PREF, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.habis_widget_dem)
            views.setTextViewText(
                R.id.wid_dem_so,
                p.getInt(HabisWidgetProvider.K_LUA, 0).toString(),
            )
            views.setTextViewText(
                R.id.wid_dem_habit,
                p.getString(HabisWidgetProvider.K_HABIT_NM, "0/0") ?: "0/0",
            )
            views.setTextViewText(
                R.id.wid_dem_kcal,
                p.getString(HabisWidgetProvider.K_KCAL_NGAN, "0 kcal") ?: "0 kcal",
            )
            val pi = HabisWidgetProvider.homePi(context, 1)
            views.setOnClickPendingIntent(R.id.wid_dem_root, pi)
            manager.updateAppWidget(id, views)
        }
    }
}
