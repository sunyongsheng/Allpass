package top.aengus.allpass

import android.os.Bundle
import android.content.Intent

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class ShareActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent: Intent = intent
        val action: String? = intent.action
        val type: String? = intent.type
        if (Intent.ACTION_SEND == (type)) {
            if ("text/plain" == type) {
                dealTextMessage(intent)
            }
        }
    }

    private fun dealTextMessage(intent: Intent) {
        val share: String? = intent.getStringExtra(Intent.EXTRA_TEXT)
        val title: String? = intent.getStringExtra(Intent.EXTRA_TITLE)
        print(share)
        print(title)
    }
}