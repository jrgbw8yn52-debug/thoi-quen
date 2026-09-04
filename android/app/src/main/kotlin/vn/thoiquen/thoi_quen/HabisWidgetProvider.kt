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
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action == ACTION_XONG) {
            val id = intent.getIntExtra(EXTRA_ID, -1)
            if (id > 0) xuLyXong(context, id)
            return
        }
        super.onReceive(context, intent)
    }

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
        const val K_N = "n"
        const val K_M = "m"
        const val ACTION_XONG = "vn.thoiquen.thoi_quen.WID_XONG"
        const val EXTRA_ID = "habitId"

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

        fun xongPi(context: Context, habitId: Int): PendingIntent {
            val intent = Intent(context, HabisWidgetProvider::class.java).apply {
                action = ACTION_XONG
                putExtra(EXTRA_ID, habitId)
                data = Uri.parse("habis://xong/$habitId")
            }
            return PendingIntent.getBroadcast(
                context,
                habitId,
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

        fun luuHang(p: android.content.SharedPreferences.Editor, hang: List<*>?) {
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
                    arr.put(o)
                }
            }
            p.putString(K_HANG, arr.toString())
        }

        fun capNhatMot(context: Context, manager: AppWidgetManager, id: Int) {
            val p = context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
            val views = RemoteViews(context.packageName, R.layout.habis_widget)
            views.setTextViewText(R.id.wid_so, p.getInt(K_LUA, 0).toString())
            val hang = JSONArray(p.getString(K_HANG, "[]") ?: "[]")
            bindO(context, views, 0, hang)
            bindO(context, views, 1, hang)
            bindO(context, views, 2, hang)
            if (hang.length() == 0) {
                views.setViewVisibility(R.id.wid_het, View.VISIBLE)
            } else {
                views.setViewVisibility(R.id.wid_het, View.GONE)
            }
            val pi = homePi(context, 0)
            views.setOnClickPendingIntent(R.id.wid_root, pi)
            views.setOnClickPendingIntent(R.id.wid_dai, pi)
            manager.updateAppWidget(id, views)
        }

        private val oIds = intArrayOf(R.id.wid_o1, R.id.wid_o2, R.id.wid_o3)
        private val gioIds = intArrayOf(R.id.wid_o1_gio, R.id.wid_o2_gio, R.id.wid_o3_gio)
        private val tenIds = intArrayOf(R.id.wid_o1_ten, R.id.wid_o2_ten, R.id.wid_o3_ten)
        private val xongIds = intArrayOf(R.id.wid_o1_xong, R.id.wid_o2_xong, R.id.wid_o3_xong)

        private fun bindO(context: Context, views: RemoteViews, i: Int, hang: JSONArray) {
            if (i >= hang.length()) {
                views.setViewVisibility(oIds[i], View.GONE)
                return
            }
            val o = hang.getJSONObject(i)
            val hid = o.optInt("id", 0)
            val gio = o.optString("gio", "")
            val ten = o.optString("ten", "")
            views.setViewVisibility(oIds[i], View.VISIBLE)
            if (gio.isEmpty()) {
                views.setViewVisibility(gioIds[i], View.GONE)
            } else {
                views.setViewVisibility(gioIds[i], View.VISIBLE)
                views.setTextViewText(gioIds[i], gio)
            }
            views.setTextViewText(tenIds[i], ten)
            if (hid > 0) {
                views.setOnClickPendingIntent(xongIds[i], xongPi(context, hid))
            }
        }

        fun xuLyXong(context: Context, habitId: Int) {
            ghiTickSqlite(context, habitId)
            boO(context, habitId)
            tangN(context)
            capNhatTatCa(context)
            MainActivity.baoTick(habitId)
        }

        private fun boO(context: Context, habitId: Int) {
            val p = context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
            val arr = JSONArray(p.getString(K_HANG, "[]") ?: "[]")
            val moi = JSONArray()
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                if (o.optInt("id") != habitId) moi.put(o)
            }
            p.edit().putString(K_HANG, moi.toString()).apply()
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
            val arr = JSONArray(
                context.getSharedPreferences(PREF, Context.MODE_PRIVATE)
                    .getString(K_HANG, "[]") ?: "[]",
            )
            for (i in 0 until arr.length()) {
                val o = arr.getJSONObject(i)
                if (o.optInt("id") == habitId) {
                    if (o.isNull("phut")) return null
                    return o.optInt("phut")
                }
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
                if (phut == null) {
                    db.execSQL(
                        "INSERT OR IGNORE INTO ticks (habit_id, ngay, phut) VALUES (?, ?, NULL)",
                        arrayOf(habitId, ngay),
                    )
                } else {
                    db.execSQL(
                        "INSERT OR IGNORE INTO ticks (habit_id, ngay, phut) VALUES (?, ?, ?)",
                        arrayOf(habitId, ngay, phut),
                    )
                }
            } catch (_: Exception) {
            } finally {
                db?.close()
            }
        }
    }
}
