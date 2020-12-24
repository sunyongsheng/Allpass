package top.aengus.allpass.share

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.widget.Toast

import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import top.aengus.allpass.R
import top.aengus.allpass.core.CHANNEL
import top.aengus.allpass.core.METHOD_IMPORT_CHROME_DATA

class ReceiveShareActivity : FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_import)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        val intent: Intent = intent
        val action: String? = intent.action
        val type: String = intent.type ?: "unknown"
        if (Intent.ACTION_SEND == (action)) {
            if (type.startsWith("text/")) {
                val data = parseDataFromIntent(intent)
                MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).invokeMethod(METHOD_IMPORT_CHROME_DATA, data)
            }
        }
    }

    private fun parseDataFromIntent(intent: Intent): String {
        val uri: Uri? = intent.getParcelableExtra(Intent.EXTRA_STREAM)
        if (uri != null) {
            this.contentResolver.openInputStream(uri).use {
                return it?.reader()?.readText() ?: ""
            }
        } else {
            Toast.makeText(this, "导入空文件！", Toast.LENGTH_SHORT).show()
            return ""
        }
    }
}
