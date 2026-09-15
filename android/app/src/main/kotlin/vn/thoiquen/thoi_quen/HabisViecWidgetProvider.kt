package vn.thoiquen.thoi_quen

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews

class HabisViecWidgetProvider : AppWidgetProvider() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == HabisWidgetProvider.ACTION_XONG) {
            val id = intent.getIntExtra(HabisWidgetProvider.EXTRA_ID, -1)
            val loai = intent.getStringExtra(HabisWidgetProvider.EXTRA_LOAI)
                ?: HabisWidgetProvider.LOAI_H
            HabisWidgetProvider.xuLyXong(context, id, loai)
            return
        }
        super.onReceive(context, intent)
    }

    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) capNhatMot(context, manager, id)
    }

    companion object {
        private val oIds = intArrayOf(R.id.wid_o1, R.id.wid_o2, R.id.wid_o3)
        private val gioIds = intArrayOf(R.id.wid_o1_gio, R.id.wid_o2_gio, R.id.wid_o3_gio)
        private val tenIds = intArrayOf(R.id.wid_o1_ten, R.id.wid_o2_ten, R.id.wid_o3_ten)
        private val xongIds = intArrayOf(R.id.wid_o1_xong, R.id.wid_o2_xong, R.id.wid_o3_xong)

        fun capNhatTatCa(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, HabisViecWidgetProvider::class.java),
            )
            for (id in ids) capNhatMot(context, manager, id)
        }

        fun capNhatMot(context: Context, manager: AppWidgetManager, id: Int) {
            val p = context.getSharedPreferences(HabisWidgetProvider.PREF, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.habis_widget_viec)
            views.setTextViewText(R.id.wid_v_so, p.getInt(HabisWidgetProvider.K_LUA, 0).toString())
            views.setTextViewText(R.id.wid_v_meta, HabisWidgetProvider.metaChu(p))
            val hang = HabisWidgetProvider.docHang(p.getString(HabisWidgetProvider.K_HANG, "[]"))
            val cls = HabisViecWidgetProvider::class.java
            HabisWidgetProvider.bindO(
                context, views, 0, hang, oIds, gioIds, tenIds, xongIds,
                HabisWidgetProvider.LOAI_H, cls,
            )
            HabisWidgetProvider.bindO(
                context, views, 1, hang, oIds, gioIds, tenIds, xongIds,
                HabisWidgetProvider.LOAI_H, cls,
            )
            HabisWidgetProvider.bindO(
                context, views, 2, hang, oIds, gioIds, tenIds, xongIds,
                HabisWidgetProvider.LOAI_H, cls,
            )
            if (hang.isEmpty()) {
                views.setViewVisibility(R.id.wid_het, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.wid_het, View.GONE)
            }
            val pi = HabisWidgetProvider.homePi(context, 2)
            views.setOnClickPendingIntent(R.id.wid_v_root, pi)
            views.setOnClickPendingIntent(R.id.wid_v_dai, pi)
            manager.updateAppWidget(id, views)
        }
    }
}
