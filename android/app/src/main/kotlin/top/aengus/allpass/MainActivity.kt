package top.aengus.allpass

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.provider.Settings
import android.util.Log
import android.view.autofill.AutofillManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import top.aengus.allpass.core.FlutterChannel

class MainActivity: FlutterFragmentActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FlutterChannel.COMMON).setMethodCallHandler { call, result ->
            if (call.method == FlutterChannel.Method.IS_APP_DEFAULT_AUTOFILL) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    packageManager.hasSystemFeature(PackageManager.FEATURE_AUTOFILL)
                    val autofillManager = getSystemService(AutofillManager::class.java)
                    result.success(autofillManager?.hasEnabledAutofillServices() ?: false)
                } else {
                    result.success(true)
                }
            } else if (call.method == FlutterChannel.Method.SET_APP_DEFAULT_AUTOFILL) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val intent = Intent(Settings.ACTION_REQUEST_SET_AUTOFILL_SERVICE, Uri.parse("package:${packageName}"))
                    startActivity(intent)
                }
                result.success(null)
            }
        }

    }

}