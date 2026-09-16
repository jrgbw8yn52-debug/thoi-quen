package vn.thoiquen.thoi_quen

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.database.sqlite.SQLiteDatabase
import android.net.Uri
import android.view.View
import android.widget.RemoteViews
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.util.Calendar
import java.util.Locale

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
        const val K_HANG = "hang"
        const val K_FOCUS = "focus"
        const val K_HET_VIEC = "hetViec"
        const val K_N = "n"
        const val K_M = "m"
        const val ACTION_XONG = "vn.thoiquen.thoi_quen.WID_XONG"
        const val EXTRA_ID = "habitId"
        const val EXTRA_LOAI = "loai"
        const val LOAI_H = "h"
        const val LOAI_F = "f"

        data class HangO(
            val id: Int,
            val ten: String,
            val gio: String,
            val minutes: Int?,
            val phut: Int?,
            val choXong: Boolean = true,
        )

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

        fun xongPi(context: Context, id: Int, loai: String, cls: Class<*>): PendingIntent {
            val intent = Intent(context, cls).apply {
                action = ACTION_XONG
                putExtra(EXTRA_ID, id)
                putExtra(EXTRA_LOAI, loai)
                data = Uri.parse("habis://xong/$loai/$id")
            }
            val req = if (loai == LOAI_F) 200_000 + id else 100_000 + id
            return PendingIntent.getBroadcast(
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
            HabisLichWidgetProvider.capNhatTatCa(context)
        }

        fun luuDs(p: android.content.SharedPreferences.Editor, key: String, hang: List<*>?) {
            val arr = JSONArray()
            if (hang != null) {
                for (x in hang) {
                    val m = x as? Map<*, *> ?: continue
                    val o = JSONObject()
                    o.put("id", (m["id"] as? Number)?.toInt() ?: 0)
                    o.put("ten", m["ten"] as? String ?: "")
                    o.put("gio", m["gio"] as? String ?: "")
                    val phut = m["phut"]
                    if (phut is Number) o.put("phut", phut.toInt()) else o.put("phut", JSONObject.NULL)
                    val minutes = m["minutes"]
                    if (minutes is Number) o.put("minutes", minutes.toInt()) else o.put("minutes", JSONObject.NULL)
                    val cho = m["choXong"]
                    o.put("choXong", if (cho is Boolean) cho else true)
                    arr.put(o)
                }
            }
            p.putString(key, arr.toString())
        }

        fun luuHang(p: android.content.SharedPreferences.Editor, hang: List<*>?) {
            luuDs(p, K_HANG, hang)
        }

        fun luuFocus(p: android.content.SharedPreferences.Editor, hang: List<*>?) {
            luuDs(p, K_FOCUS, hang)
        }

        fun capNhatMot(context: Context, manager: AppWidgetManager, id: Int) {
            val p = context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.habis_widget)
            views.setTextViewText(R.id.wid_ngay, p.getString(K_NGAY, "Thứ Hai 1/1") ?: "Thứ Hai 1/1")
            views.setTextViewText(R.id.wid_habit, p.getString(K_HABIT, "0/0 thói quen") ?: "0/0 thói quen")
            views.setTextViewText(R.id.wid_kcal, p.getString(K_KCAL, "0 kcal") ?: "0 kcal")
            views.setTextViewText(R.id.wid_so, p.getInt(K_LUA, 0).toString())
            val pi = homePi(context, 0)
            views.setOnClickPendingIntent(R.id.wid_root, pi)
            views.setOnClickPendingIntent(R.id.wid_dai, pi)
            manager.updateAppWidget(id, views)
        }

        fun tabPi(context: Context, tab: Int, req: Int): PendingIntent {
            val intent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or
                    Intent.FLAG_ACTIVITY_CLEAR_TOP or
                    Intent.FLAG_ACTIVITY_SINGLE_TOP
                action = Intent.ACTION_MAIN
                addCategory(Intent.CATEGORY_LAUNCHER)
                putExtra(MainActivity.EXTRA_TAB, tab)
            }
            return PendingIntent.getActivity(
                context,
                req,
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
            )
        }

        fun metaChu(p: android.content.SharedPreferences): String {
            val ngay = p.getString(K_NGAY, "") ?: ""
            val nm = p.getString(K_HABIT_NM, "0/0") ?: "0/0"
            val kcal = p.getString(K_KCAL, "") ?: ""
            val ds = ArrayList<String>(3)
            if (ngay.isNotEmpty()) ds.add(ngay)
            if (nm.isNotEmpty()) ds.add(nm)
            if (kcal.isNotEmpty()) ds.add(kcal)
            return ds.joinToString(" · ")
        }

        private fun soPhut(v: Any?): Int? {
            if (v == null || v == JSONObject.NULL) return null
            if (v is Number) return v.toInt()
            if (v is String) return v.toIntOrNull()
            return null
        }

        fun docHang(raw: String?): List<HangO> {
            val arr = JSONArray(raw ?: "[]")
            val ds = ArrayList<HangO>(arr.length())
            var coMinutes = false
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                val minutes: Int? = if (o.has("minutes")) {
                    coMinutes = true
                    if (o.isNull("minutes")) null else soPhut(o.opt("minutes"))
                } else {
                    null
                }
                val phut: Int? = if (o.isNull("phut")) null else soPhut(o.opt("phut"))
                val choXong = if (o.has("choXong")) o.optBoolean("choXong", true) else true
                ds.add(
                    HangO(
                        id = o.optInt("id", 0),
                        ten = o.optString("ten", ""),
                        gio = o.optString("gio", ""),
                        minutes = minutes,
                        phut = phut,
                        choXong = choXong,
                    ),
                )
            }
            if (coMinutes) {
                ds.sortWith(
                    compareBy<HangO> { it.minutes ?: Int.MAX_VALUE }.thenBy { it.id },
                )
            }
            return ds
        }

        fun bindO(
            context: Context,
            views: RemoteViews,
            i: Int,
            hang: List<HangO>,
            oIds: IntArray,
            gioIds: IntArray,
            tenIds: IntArray,
            xongIds: IntArray,
            loai: String,
            cls: Class<*>,
        ) {
            if (i >= hang.size) {
                views.setViewVisibility(oIds[i], View.GONE)
                return
            }
            val o = hang[i]
            views.setViewVisibility(oIds[i], View.VISIBLE)
            if (o.gio.isEmpty()) {
                views.setViewVisibility(gioIds[i], View.GONE)
            } else {
                views.setViewVisibility(gioIds[i], View.VISIBLE)
                views.setTextViewText(gioIds[i], o.gio)
            }
            views.setTextViewText(tenIds[i], o.ten)
            if (o.choXong) {
                views.setViewVisibility(xongIds[i], View.VISIBLE)
                if (o.id > 0) {
                    views.setOnClickPendingIntent(xongIds[i], xongPi(context, o.id, loai, cls))
                }
                views.setOnClickPendingIntent(oIds[i], homePi(context, 500_000 + o.id))
            } else {
                views.setViewVisibility(xongIds[i], View.GONE)
                if (o.id > 0) {
                    val pi = if (loai == LOAI_F) {
                        tabPi(context, 2, 400_000 + o.id)
                    } else {
                        homePi(context, 500_000 + o.id)
                    }
                    views.setOnClickPendingIntent(oIds[i], pi)
                }
            }
        }

        fun xuLyXong(context: Context, id: Int, loai: String) {
            if (id <= 0) return
            if (loai == LOAI_F) {
                ghiFocusSqlite(context, id)
                boO(context, K_FOCUS, id)
            } else {
                ghiTickSqlite(context, id)
                boO(context, K_HANG, id)
                tangN(context)
            }
            capNhatTatCa(context)
            if (loai == LOAI_F) MainActivity.baoTickFocus(id) else MainActivity.baoTick(id)
        }

        private fun boO(context: Context, key: String, id: Int) {
            val p = context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
            val arr = JSONArray(p.getString(key, "[]") ?: "[]")
            val moi = JSONArray()
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                if (o.optInt("id") != id) moi.put(o)
            }
            p.edit().putString(key, moi.toString()).apply()
        }

        private fun tangN(context: Context) {
            val p = context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
            val n = p.getInt(K_N, 0) + 1
            val m = p.getInt(K_M, 0)
            p.edit()
                .putInt(K_N, n)
                .putString(K_HABIT, "$n/$m thói quen")
                .putString(K_HABIT_NM, "$n/$m")
                .apply()
        }

        private fun homNayIso(): String {
            val c = Calendar.getInstance()
            return String.format(
                Locale.US,
                "%04d-%02d-%02d",
                c.get(Calendar.YEAR),
                c.get(Calendar.MONTH) + 1,
                c.get(Calendar.DAY_OF_MONTH),
            )
        }

        private fun phutCua(context: Context, habitId: Int): Int? {
            val hang = docHang(
                context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
                    .getString(K_HANG, "[]"),
            )
            for (o in hang) {
                if (o.id == habitId) return o.phut
            }
            return null
        }

        private fun ghiTickSqlite(context: Context, habitId: Int) {
            val f = File(context.filesDir, "thoi_quen.sqlite")
            if (!f.exists()) return
            val ngay = homNayIso()
            val phut = phutCua(context, habitId)
            var db: SQLiteDatabase? = null
            try {
                db = SQLiteDatabase.openDatabase(
                    f.absolutePath,
                    null,
                    SQLiteDatabase.OPEN_READWRITE or SQLiteDatabase.ENABLE_WRITE_AHEAD_LOGGING,
                )
                val sql = "INSERT OR IGNORE INTO ticks (habit_id, ngay, phut) VALUES (?, ?, ?)"
                val stmt = db.compileStatement(sql)
                try {
                    stmt.bindLong(1, habitId.toLong())
                    stmt.bindString(2, ngay)
                    if (phut == null) stmt.bindNull(3) else stmt.bindLong(3, phut.toLong())
                    stmt.executeInsert()
                } finally {
                    stmt.close()
                }
            } catch (_: Exception) {
            } finally {
                db?.close()
            }
        }

        private fun ghiFocusSqlite(context: Context, focusId: Int) {
            val f = File(context.filesDir, "thoi_quen.sqlite")
            if (!f.exists()) return
            var db: SQLiteDatabase? = null
            try {
                db = SQLiteDatabase.openDatabase(
                    f.absolutePath,
                    null,
                    SQLiteDatabase.OPEN_READWRITE or SQLiteDatabase.ENABLE_WRITE_AHEAD_LOGGING,
                )
                val sql = "UPDATE focus_tasks SET done = 1 WHERE id = ?"
                val stmt = db.compileStatement(sql)
                try {
                    stmt.bindLong(1, focusId.toLong())
                    stmt.executeUpdateDelete()
                } finally {
                    stmt.close()
                }
            } catch (_: Exception) {
            } finally {
                db?.close()
            }
        }
    }
}
