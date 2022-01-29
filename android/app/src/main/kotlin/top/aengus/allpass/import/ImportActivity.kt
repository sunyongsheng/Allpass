package top.aengus.allpass.import

import android.animation.ObjectAnimator
import android.animation.ValueAnimator
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.View
import android.view.ViewGroup
import android.view.animation.LinearInterpolator
import android.widget.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import top.aengus.allpass.R
import top.aengus.allpass.core.FlutterChannel
import top.aengus.allpass.databinding.ActivityImportBinding
import top.aengus.allpass.import.adapter.ImportPreviewAdapter
import top.aengus.allpass.import.model.ImportPreview
import top.aengus.allpass.import.model.ImportState
import top.aengus.allpass.util.CsvUtil
import top.aengus.allpass.util.createMessageChannel

class ImportActivity : FlutterActivity() {

    private val importMessageChannel: BasicMessageChannel<String> by lazy {
        createMessageChannel(this, FlutterChannel.IMPORT_CSV)
    }

    private var currState: ImportState = ImportState.NotYet

    private lateinit var binding: ActivityImportBinding

    private val rotateAnimator: ObjectAnimator by lazy {
        ObjectAnimator.ofFloat(binding.ivConfirm, "rotation", 0F, 360F).apply {
            duration = 800
            repeatCount = ValueAnimator.INFINITE
            repeatMode = ValueAnimator.RESTART
            interpolator = LinearInterpolator()
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val intentType = intent.type
        if (intentType == null || !intentType.startsWith("text/")) {
            Toast.makeText(this, "只支持文本文件导入！", Toast.LENGTH_LONG).show()
            finish()
            return
        }

        binding = ActivityImportBinding.inflate(layoutInflater)
        setContentView(binding.root)

        modifyTopUI()

        val previewAdapter = ImportPreviewAdapter()
        binding.previewRecyclerview.adapter = previewAdapter

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
            ImportPreview(name, it[usernameIndex], it[passwordIndex])
        }
        previewAdapter.submitList(dataList)

        binding.btnConfirm.setOnClickListener {
            when (currState) {
                ImportState.NotYet, ImportState.Failed -> {
                    Toast.makeText(this, "开始导入", Toast.LENGTH_SHORT).show()
                    startRotating(binding.ivConfirm)
                    importMessageChannel.send(content) {
                        stopRotating(binding.ivConfirm, it != null)
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
            binding.mainContainer.visibility = View.GONE
            binding.errorContainer.visibility = View.VISIBLE
        } else {
            binding.mainContainer.visibility = View.VISIBLE
            binding.errorContainer.visibility = View.GONE
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

        val lp1 = binding.mainContainer.layoutParams as ViewGroup.MarginLayoutParams
        lp1.topMargin += statusHeight
        binding.mainContainer.layoutParams = lp1

        val lp2 = binding.errorContainer.layoutParams as ViewGroup.MarginLayoutParams
        lp2.topMargin += statusHeight
        binding.errorContainer.layoutParams = lp2
    }
}
