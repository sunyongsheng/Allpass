package top.aengus.allpass

import android.Manifest.permission.READ_EXTERNAL_STORAGE
import android.Manifest.permission.WRITE_EXTERNAL_STORAGE
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import androidx.core.app.ActivityCompat

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.android.FlutterActivity;

class ReceiveShareActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_import)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        val intent: Intent = intent
        val action: String? = intent.action
        val type: String = if (intent.type != null) intent.type!! else "unknown"
        if (Intent.ACTION_SEND == (action)) {
            if (type.startsWith("text/")) {
                val res = processIntent(intent)
                MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), "allpass.aengus.top/share").invokeMethod("getChromeData", res)
                Log.v("ShareActivity", "调用Dart方法完成")
            }
        }
    }


    private fun processIntent(intent: Intent): String {
        val uri: Uri? = intent.getParcelableExtra(Intent.EXTRA_STREAM)
        /**
         * 权限请求
         */
        val permission = ActivityCompat.checkSelfPermission(
                this,
                READ_EXTERNAL_STORAGE
        )
        val permissionStorage: Array<String> = arrayOf(READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE)
        if (permission != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(
                    this,
                    permissionStorage,
                    1
            )
        }
        val resolver = this.contentResolver
        if (uri != null) {
            resolver.openInputStream(uri).use {
                val reader = it?.reader()
                val fileContent = reader?.readText()
                return fileContent?:""
            }
        } else {
            Toast.makeText(this, "导入空文件！", Toast.LENGTH_SHORT).show()
            return ""
        }
    }
}
