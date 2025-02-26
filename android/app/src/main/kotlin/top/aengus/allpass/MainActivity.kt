package top.aengus.allpass

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import android.view.autofill.AutofillManager
import android.widget.Toast
import androidx.lifecycle.lifecycleScope
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import top.aengus.allpass.core.FlutterChannel

class MainActivity: FlutterFragmentActivity(), MethodChannel.MethodCallHandler {

    private var pendingHandleIntent = false

    private lateinit var importDataChannel: MethodChannel

    private lateinit var commonChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // call before configureFlutterEngine
        pendingHandleIntent = true
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        GeneratedPluginRegistrant.registerWith(flutterEngine)

        commonChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FlutterChannel.COMMON)
        importDataChannel =  MethodChannel(flutterEngine.dartExecutor.binaryMessenger, FlutterChannel.IMPORT_CSV)

        commonChannel.setMethodCallHandler(this)

        if (pendingHandleIntent) {
            pendingHandleIntent = false
            handleIntent(intent)
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            FlutterChannel.Method.SUPPORT_AUTOFILL -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    result.success(packageManager.hasSystemFeature(PackageManager.FEATURE_AUTOFILL))
                } else {
                    result.success(false)
                }
            }
            FlutterChannel.Method.IS_APP_DEFAULT_AUTOFILL -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val autofillManager = getSystemService(AutofillManager::class.java)
                    result.success(autofillManager?.hasEnabledAutofillServices() ?: false)
                } else {
                    result.success(true)
                }
            }
            FlutterChannel.Method.SET_APP_DEFAULT_AUTOFILL -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val intent = Intent(Settings.ACTION_REQUEST_SET_AUTOFILL_SERVICE, Uri.parse("package:${packageName}"))
                    startActivity(intent)
                }
                result.success(null)
            }
            FlutterChannel.Method.OPEN_APP_SETTINGS_PAGE -> {
                startActivity(
                    Intent(
                        Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        Uri.fromParts("package", packageName, null)
                    )
                )
            }
        }
    }

    private fun handleIntent(intent: Intent) {
        if (intent.action != Intent.ACTION_SEND) {
            return
        }

        val intentType = intent.type
        if (intentType == null || !intentType.startsWith("text/")) {
            Toast.makeText(this, "只支持文本文件导入！", Toast.LENGTH_LONG).show()
            return
        }

        lifecycleScope.launch {
            val content = readContentFromIntent(intent)
            if (content.isNullOrBlank()) {
                Toast.makeText(this@MainActivity, "导入空文件！", Toast.LENGTH_LONG).show()
                return@launch
            }

            if (this@MainActivity::importDataChannel.isInitialized) {
                importDataChannel.invokeMethod(FlutterChannel.Method.OPEN_IMPORT_PAGE, content)
            }
        }
    }

    private suspend fun readContentFromIntent(intent: Intent): String? {
        val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            intent.getParcelableExtra(Intent.EXTRA_STREAM, Uri::class.java)
        } else {
            intent.getParcelableExtra(Intent.EXTRA_STREAM)
        } ?: return null
        return withContext(Dispatchers.IO) {
            contentResolver.openInputStream(uri).use {
                it?.reader()?.readText()
            }
        }
    }

}