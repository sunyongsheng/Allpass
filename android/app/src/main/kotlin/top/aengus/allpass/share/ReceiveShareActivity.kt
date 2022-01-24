package top.aengus.allpass.share

import android.animation.ObjectAnimator
import android.animation.ValueAnimator
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.view.animation.LinearInterpolator
import android.widget.*
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.recyclerview.widget.RecyclerView
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import top.aengus.allpass.R
import top.aengus.allpass.core.FlutterChannel
import top.aengus.allpass.util.CsvUtil
import top.aengus.allpass.util.createMessageChannel

class ReceiveShareActivity : FlutterActivity() {

    private val importMessageChannel: BasicMessageChannel<String> by lazy {
        createMessageChannel(this, FlutterChannel.IMPORT_CSV)
    }

    private var currState: ImportState = ImportState.NotYet

    private lateinit var mainContainer: ConstraintLayout
    private lateinit var errorContainer: ConstraintLayout
    private lateinit var recyclerView: RecyclerView
    private lateinit var btnConfirm: FrameLayout
    private lateinit var ivConfirm: ImageView

    private val rotateAnimator: ObjectAnimator by lazy {
        ObjectAnimator.ofFloat(ivConfirm, "rotation", 0F, 360F).apply {
            duration = 800
            repeatCount = ValueAnimator.INFINITE
            repeatMode = ValueAnimator.RESTART
            interpolator = LinearInterpolator()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        if (intent.type == null || !intent.type!!.startsWith("text/")) {
            Toast.makeText(this, "只支持文本文件导入！", Toast.LENGTH_LONG).show()
            finish()
            return
        }

        setContentView(R.layout.activity_import)

        mainContainer = findViewById(R.id.main_container)
        errorContainer = findViewById(R.id.error_container)
        recyclerView = findViewById(R.id.preview_recyclerview)
        btnConfirm = findViewById(R.id.btn_confirm)
        ivConfirm = findViewById(R.id.iv_confirm)

        modifyTopUI()

        val previewAdapter = ImportPreviewAdapter()
        recyclerView.adapter = previewAdapter

        val content = readContentFromIntent(intent)
        val structure = CsvUtil.parse(content)
        if (structure.isEmpty()) {
            Toast.makeText(this, "导入空文件！", Toast.LENGTH_LONG).show()
            finish()
            return
        }

        val nameIndex = structure.header.indexOfFirst { it == "name" }
        val usernameIndex = structure.header.indexOfFirst { it.contains("username") }
        val passwordIndex = structure.header.indexOfFirst { it.contains("password") }

        if (usernameIndex < 0 || passwordIndex < 0) {
            setError(true)
            return
        }

        setError(false)

        val dataList = structure.content.map {
            val name = if (nameIndex >= 0) {
                it[nameIndex]
            } else {
                "未知名称"
            }
            PreviewItem(name, it[usernameIndex], it[passwordIndex])
        }
        previewAdapter.submitList(dataList)

        btnConfirm.setOnClickListener {
            when (currState) {
                ImportState.NotYet, ImportState.Failed -> {
                    Toast.makeText(this, "开始导入", Toast.LENGTH_SHORT).show()
                    startRotating(ivConfirm)
                    importMessageChannel.send(content) {
                        stopRotating(ivConfirm, it != null)
                        if (it == null) {
                            Toast.makeText(this, "导入失败", Toast.LENGTH_SHORT).show()
                        } else {
                            val count = it.toInt()
                            if (count == 0) {
                                Toast.makeText(this, "导入了0条数据，可能是文件格式不正确", Toast.LENGTH_LONG).show()
                            } else {
                                Toast.makeText(this, "导入了${count}条数据", Toast.LENGTH_LONG).show()
                            }
                        }
                    }
                }
                ImportState.Importing -> {
                    Toast.makeText(this, "导入中，请稍后", Toast.LENGTH_SHORT).show()
                }
                ImportState.Success -> {
                    finish()
                }
            }
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
    }

    private fun readContentFromIntent(intent: Intent): String? {
        return intent.getParcelableExtra<Uri?>(Intent.EXTRA_STREAM)?.let { uri ->
            contentResolver.openInputStream(uri).use {
                it?.reader()?.readText()
            }
        }
    }

    private fun startRotating(view: ImageView) {
        currState = ImportState.Importing
        view.setImageResource(R.drawable.ic_rotate)
        rotateAnimator.start()
    }

    private fun stopRotating(view: ImageView, success: Boolean) {
        rotateAnimator.cancel()
        view.rotation = 0F
        if (success) {
            currState = ImportState.Success
            view.setImageResource(R.drawable.ic_done)
        } else {
            currState = ImportState.Failed
            view.setImageResource(R.drawable.ic_import)
        }
    }

    private fun setError(error: Boolean) {
        if (error) {
            mainContainer.visibility = View.GONE
            errorContainer.visibility = View.VISIBLE
        } else {
            mainContainer.visibility = View.VISIBLE
            errorContainer.visibility = View.GONE
        }
    }

    private fun getStatusBarHeight(): Int {
        var statusBarHeight = 0
        val resourceId = resources.getIdentifier("status_bar_height", "dimen", "android")
        if (resourceId > 0) {
            statusBarHeight = resources.getDimensionPixelSize(resourceId)
        }
        return statusBarHeight
    }

    private fun modifyTopUI() {
        val statusHeight = getStatusBarHeight()

        val lp1 = mainContainer.layoutParams as ViewGroup.MarginLayoutParams
        lp1.topMargin += statusHeight
        mainContainer.layoutParams = lp1

        val lp2 = errorContainer.layoutParams as ViewGroup.MarginLayoutParams
        lp2.topMargin += statusHeight
        errorContainer.layoutParams = lp2
    }
}
