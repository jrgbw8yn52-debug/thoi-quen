package vn.thoiquen.thoi_quen

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.view.View
import android.widget.RemoteViews

class HabisLichWidgetProvider : AppWidgetProvider() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == HabisWidgetProvider.ACTION_XONG) {
            val id = intent.getIntExtra(HabisWidgetProvider.EXTRA_ID, -1)
            val loai = intent.getStringExtra(HabisWidgetProvider.EXTRA_LOAI)
                ?: HabisWidgetProvider.LOAI_F
            HabisWidgetProvider.xuLyXong(context, id, loai)
            return
        }
        super.onReceive(context, intent)
    }

    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        for (id in ids) capNhatMot(context, manager, id)
    }

    companion object {
        private val fO = intArrayOf(R.id.wid_f1, R.id.wid_f2)
        private val fGio = intArrayOf(R.id.wid_f1_gio, R.id.wid_f2_gio)
        private val fTen = intArrayOf(R.id.wid_f1_ten, R.id.wid_f2_ten)
        private val fXong = intArrayOf(R.id.wid_f1_xong, R.id.wid_f2_xong)
        private val hO = intArrayOf(R.id.wid_h1, R.id.wid_h2)
        private val hGio = intArrayOf(R.id.wid_h1_gio, R.id.wid_h2_gio)
        private val hTen = intArrayOf(R.id.wid_h1_ten, R.id.wid_h2_ten)
        private val hXong = intArrayOf(R.id.wid_h1_xong, R.id.wid_h2_xong)

        fun capNhatTatCa(context: Context) {
            val manager = AppWidgetManager.getInstance(context)
            val ids = manager.getAppWidgetIds(
                ComponentName(context, HabisLichWidgetProvider::class.java),
            )
            for (id in ids) capNhatMot(context, manager, id)
        }

        fun capNhatMot(context: Context, manager: AppWidgetManager, id: Int) {
            val p = context.getSharedPreferences(HabisWidgetProvider.PREF, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.habis_widget_lich)
            views.setTextViewText(R.id.wid_l_so, p.getInt(HabisWidgetProvider.K_LUA, 0).toString())
            ganMeta(views, p)
            val cls = HabisLichWidgetProvider::class.java
            val focus = HabisWidgetProvider.docHang(p.getString(HabisWidgetProvider.K_FOCUS, "[]"))
            HabisWidgetProvider.bindO(
                context, views, 0, focus, fO, fGio, fTen, fXong,
                HabisWidgetProvider.LOAI_F, cls,
            )
            HabisWidgetProvider.bindO(
                context, views, 1, focus, fO, fGio, fTen, fXong,
                HabisWidgetProvider.LOAI_F, cls,
            )
            if (focus.isEmpty()) {
                views.setViewVisibility(R.id.wid_het_f, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.wid_het_f, View.GONE)
            }
            val hang = HabisWidgetProvider.docHang(p.getString(HabisWidgetProvider.K_HANG, "[]"))
            HabisWidgetProvider.bindO(
                context, views, 0, hang, hO, hGio, hTen, hXong,
                HabisWidgetProvider.LOAI_H, cls,
            )
            HabisWidgetProvider.bindO(
                context, views, 1, hang, hO, hGio, hTen, hXong,
                HabisWidgetProvider.LOAI_H, cls,
            )
            if (hang.isEmpty()) {
                views.setViewVisibility(R.id.wid_het_v, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.wid_het_v, View.GONE)
            }
            val pi = HabisWidgetProvider.homePi(context, 3)
            views.setOnClickPendingIntent(R.id.wid_l_root, pi)
            views.setOnClickPendingIntent(R.id.wid_l_dai, pi)
            manager.updateAppWidget(id, views)
        }

        /// 1–2 dòng: «Thứ Tư 16/9 · 3/4 · 1333/2592 kcal». Không cắt giữa từ/số.
        internal fun ganMeta(views: RemoteViews, p: android.content.SharedPreferences) {
            val ngay = p.getString(HabisWidgetProvider.K_NGAY, "") ?: ""
            val nm = p.getString(HabisWidgetProvider.K_HABIT_NM, "0/0") ?: "0/0"
            val kcal = gonKcal(p.getString(HabisWidgetProvider.K_KCAL, "") ?: "")
            val ds = ArrayList<String>(3)
            if (ngay.isNotEmpty()) ds.add(ngay)
            if (nm.isNotEmpty()) ds.add(nm)
            if (kcal.isNotEmpty()) ds.add(kcal)
            views.setTextViewText(R.id.wid_l_meta, ds.joinToString(" · "))
        }

        /** «2425 / 2600 kcal» → «2425/2600 kcal» — số không bị cắt giữa. */
        internal fun gonKcal(raw: String): String = raw.replace(" / ", "/").trim()
    }
}
