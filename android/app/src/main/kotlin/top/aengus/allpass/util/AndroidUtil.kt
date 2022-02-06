package top.aengus.allpass.util

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.PixelFormat
import android.graphics.drawable.Drawable
import android.os.Build
import android.util.Log
import java.security.MessageDigest
import kotlin.collections.ArrayList
import kotlin.experimental.and

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

    fun getCertificatesHash(context: Context, packageName: String): String {
        val pm: PackageManager = context.packageManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            val info: PackageInfo = pm.getPackageInfo(packageName, PackageManager.GET_SIGNING_CERTIFICATES)
            val hashes = ArrayList<String>(info.signingInfo.apkContentsSigners.size)
            for (sig in info.signingInfo.apkContentsSigners) {
                val cert: ByteArray = sig.toByteArray()
                val md: MessageDigest = MessageDigest.getInstance("SHA-256")
                md.update(cert)
                hashes.add(bytesToHex(md.digest()))
            }
            hashes.sort()
            val hash = StringBuilder()
            for (i in 0 until hashes.size) {
                hash.append(hashes[i])
            }
            return hash.toString()
        } else {
            val info: PackageInfo = pm.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
            val hashes = ArrayList<String>(info.signatures.size)
            for (sig in info.signatures) {
                val cert: ByteArray = sig.toByteArray()
                val md: MessageDigest = MessageDigest.getInstance("SHA-256")
                md.update(cert)
                hashes.add(bytesToHex(md.digest()))
            }
            hashes.sort()
            val hash = StringBuilder()
            for (i in 0 until hashes.size) {
                hash.append(hashes[i])
            }
            return hash.toString()
        }
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {

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

    private val HEX_ARRAY = "0123456789ABCDEF".toCharArray()

    fun bytesToHex(bytes: ByteArray): String {
        val hexChars = CharArray(bytes.size * 2)
        for (j in bytes.indices) {
            val v: Int = (bytes[j] and 0xFF.toByte()).toInt()
            hexChars[j * 2] = HEX_ARRAY[v ushr 4]
            hexChars[j * 2 + 1] = HEX_ARRAY[v and 0x0F]
        }
        return String(hexChars)
    }
}