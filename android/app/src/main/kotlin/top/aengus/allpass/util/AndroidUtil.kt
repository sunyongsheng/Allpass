package top.aengus.allpass.util

import android.content.Context
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.PixelFormat
import android.graphics.drawable.Drawable
import android.util.Log

object AndroidUtil {

    fun getAppIcon(context: Context, appId: String): Bitmap? {
        return try {
            val drawable = context.packageManager.getApplicationIcon(appId)
            drawableToBitmap(drawable)
        } catch (e: Exception) {
            Log.e("getAppIcon", "getAppIcon error", e)
            null
        }
    }

    fun getAppName(context: Context, appId: String): String? {
        return try {
            val appInfo = context.packageManager.getApplicationInfo(appId, PackageManager.GET_META_DATA)
            appInfo.loadLabel(context.packageManager).toString()
        } catch (e: Exception) {
            Log.e("getAppName", "getAppName error", e)
            null
        }
    }

    fun drawableToBitmap(drawable: Drawable): Bitmap {

        // 获取 drawable 长宽
        val width = drawable.intrinsicWidth
        val height = drawable.intrinsicHeight
        drawable.setBounds(0, 0, width, height)

        // 获取drawable的颜色格式
        val config: Bitmap.Config = if (drawable.opacity != PixelFormat.OPAQUE) Bitmap.Config.ARGB_8888 else Bitmap.Config.RGB_565
        // 创建bitmap
        val bitmap: Bitmap = Bitmap.createBitmap(width, height, config)
        // 创建bitmap画布
        val canvas = Canvas(bitmap)
        // 将drawable 内容画到画布中
        drawable.draw(canvas)
        return bitmap
    }
}