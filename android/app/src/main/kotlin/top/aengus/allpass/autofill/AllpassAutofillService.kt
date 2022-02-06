package top.aengus.allpass.autofill

import android.app.assist.AssistStructure
import android.os.Build
import android.os.Bundle
import android.os.CancellationSignal
import android.service.autofill.*
import android.text.InputType
import android.view.View
import android.view.autofill.AutofillId
import android.view.autofill.AutofillValue
import android.view.inputmethod.EditorInfo
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.BasicMessageChannel
import org.json.JSONArray
import org.json.JSONObject
import top.aengus.allpass.R
import top.aengus.allpass.autofill.model.ParsedStructure
import top.aengus.allpass.autofill.model.SimpleUserData
import top.aengus.allpass.core.FlutterChannel
import top.aengus.allpass.util.AndroidUtil
import top.aengus.allpass.util.createMessageChannel


@RequiresApi(Build.VERSION_CODES.O)
class AllpassAutofillService : AutofillService() {

    companion object {
        const val AUTOFILL_ID_USERNAME = "usernameAutofillId"
        const val AUTOFILL_ID_PASSWORD = "passwordAutofillId"
    }

    private val queryAutofillChannel: BasicMessageChannel<String> by lazy {
        createMessageChannel(this, FlutterChannel.QUERY_FOR_AUTOFILL)
    }

    private val saveAutofillChannel: BasicMessageChannel<String> by lazy {
        createMessageChannel(this, FlutterChannel.SAVE_FOR_AUTOFILL)
    }

    override fun onFillRequest(
        request: FillRequest,
        cancellationSignal: CancellationSignal,
        callback: FillCallback
    ) {

        val fillContext = request.fillContexts
        val structure = fillContext[fillContext.size - 1].structure

        val windowNodes: List<AssistStructure.WindowNode> = structure.run {
            (0 until windowNodeCount).map { getWindowNodeAt(it) }
        }

        val usernameStructure = ParsedStructure(null, null)
        windowNodes.forEach { windowNode: AssistStructure.WindowNode ->
            val viewNode: AssistStructure.ViewNode? = windowNode.rootViewNode
            findUsernamePasswordFillIdRecursive(viewNode, usernameStructure)
        }
        if (!usernameStructure.isValid()) {
            callback.onFailure("暂不支持此页面自动填充")
            return
        }

        val appId = structure.activityComponent.packageName
        val appName = AndroidUtil.getAppName(this, appId)
        // TODO 使用包签名进行查询以提升安全性
        queryAutofillChannel.send("$appId,$appName") { resultJson ->
            resultJson ?: return@send
            val jsonArray = JSONArray(resultJson)
            if (jsonArray.length() == 0) {
                callback.onSuccess(null)
                return@send
            }

            val fillResponseBuilder = FillResponse.Builder()
            val clientState = Bundle()
            // 设置自动填充数据
            for (index in 0 until jsonArray.length()) {
                val jsonObj = jsonArray.getJSONObject(index)
                val name = jsonObj.optString("name")
                val username = jsonObj.optString("username")
                val password = jsonObj.optString("password")
                if (username.isNotEmpty() || password.isNotEmpty()) {
                    val autofillItem = Dataset.Builder()
                    val usernamePresentation = RemoteViews(packageName, R.layout.item_autofill).apply {
                        AndroidUtil.getAppIcon(this@AllpassAutofillService, appId)?.let { it ->
                            setImageViewBitmap(R.id.iv_app_icon, it)
                        }
                        setTextViewText(R.id.tv_name, name.ifEmpty { "Unknown" })
                        setTextViewText(R.id.tv_username, username)
                    }
                    usernameStructure.usernameId?.let {
                        clientState.putParcelable(AUTOFILL_ID_USERNAME, it)
                        autofillItem.setValue(it, AutofillValue.forText(username), usernamePresentation)
                    }
                    usernameStructure.passwordId?.let {
                        clientState.putParcelable(AUTOFILL_ID_PASSWORD, it)
                        autofillItem.setValue(it, AutofillValue.forText(password), usernamePresentation)
                    }
                    fillResponseBuilder.addDataset(autofillItem.build())
                }
            }
            // 设置保存信息
            fillResponseBuilder.setSaveInfo(SaveInfo.Builder(
                SaveInfo.SAVE_DATA_TYPE_USERNAME or SaveInfo.SAVE_DATA_TYPE_PASSWORD,
                arrayOf(usernameStructure.usernameId, usernameStructure.passwordId)
            ).build())
            callback.onSuccess(fillResponseBuilder.build())
        }
    }

    override fun onSaveRequest(request: SaveRequest, callback: SaveCallback) {
        val fillContext = request.fillContexts
        val structure = fillContext[fillContext.size - 1].structure

        // TODO 使用 AutofillId 查找 ViewNode, ViewNode#autofillValue#textValue#toString() 获取值
//        val usernameAutofillId = request.clientState?.getParcelable<AutofillId>(AUTOFILL_ID_USERNAME)
//        val passwordAutofillId = request.clientState?.getParcelable<AutofillId>(AUTOFILL_ID_PASSWORD)

        val windowNodes: List<AssistStructure.WindowNode> = structure.run {
            (0 until windowNodeCount).map { getWindowNodeAt(it) }
        }

        val userData = SimpleUserData(null, null)

        windowNodes.forEach { windowNode: AssistStructure.WindowNode ->
            val viewNode: AssistStructure.ViewNode? = windowNode.rootViewNode
            obtainUsernamePasswordRecursive(viewNode, userData)
        }

        val packageName = structure.activityComponent.packageName
        val name = AndroidUtil.getAppName(this, packageName) ?: packageName

        val jsonObj = JSONObject()
        jsonObj.put("name", name)
        jsonObj.put("username", userData.username)
        jsonObj.put("password", userData.password)
        jsonObj.put("appName", name)
        jsonObj.put("appId", packageName)

        saveAutofillChannel.send(jsonObj.toString(0)) {
            if (it.isNullOrEmpty()) {
                callback.onSuccess()
            } else {
                callback.onFailure(it)
            }
        }
    }

    private fun findUsernamePasswordFillIdRecursive(viewNode: AssistStructure.ViewNode?, parsedStructure: ParsedStructure) {
        if (isUsernameNode(viewNode)) {
            viewNode?.autofillId?.let {
                parsedStructure.usernameId = it
            }
            return
        } else if (isPasswordNode(viewNode)) {
            viewNode?.autofillId?.let {
                parsedStructure.passwordId = it
            }
            return
        }

        val children: List<AssistStructure.ViewNode>? = viewNode?.run {
            (0 until childCount).map { getChildAt(it) }
        }

        children?.forEach { childNode: AssistStructure.ViewNode ->
            findUsernamePasswordFillIdRecursive(childNode, parsedStructure)
        }
    }

    private fun obtainUsernamePasswordRecursive(viewNode: AssistStructure.ViewNode?, userData: SimpleUserData) {
        if (isUsernameNode(viewNode)) {
            viewNode?.text?.let {
                userData.username = it.toString()
            }
            return
        } else if (isPasswordNode(viewNode)) {
            viewNode?.text?.let {
                userData.password = it.toString()
            }
            return
        }

        val children: List<AssistStructure.ViewNode>? = viewNode?.run {
            (0 until childCount).map { getChildAt(it) }
        }

        children?.forEach { childNode: AssistStructure.ViewNode ->
            obtainUsernamePasswordRecursive(childNode, userData)
        }
    }

    private fun isUsernameNode(viewNode: AssistStructure.ViewNode?): Boolean {
        viewNode ?: return false
        val autofillHints = viewNode.autofillHints
        if (autofillHints != null) {
            return autofillHints.contains(View.AUTOFILL_HINT_USERNAME) || autofillHints.contains(View.AUTOFILL_HINT_EMAIL_ADDRESS)
                    || autofillHints.contains(View.AUTOFILL_HINT_PHONE)
        }
        val inputType = viewNode.inputType
        return inputType == InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
                || inputType == InputType.TYPE_CLASS_PHONE
    }

    private fun isPasswordNode(viewNode: AssistStructure.ViewNode?): Boolean {
        viewNode ?: return false
        val autofillHints = viewNode.autofillHints
        if (autofillHints != null) {
            return autofillHints.contains(View.AUTOFILL_HINT_PASSWORD)
        }
        val inputType = viewNode.inputType
        return isPasswordInputType(inputType) || isVisiblePasswordInputType(inputType)
    }

    private fun isPasswordInputType(inputType: Int): Boolean {
        val variation = inputType and (EditorInfo.TYPE_MASK_CLASS or EditorInfo.TYPE_MASK_VARIATION)
        return (variation
                == EditorInfo.TYPE_CLASS_TEXT or EditorInfo.TYPE_TEXT_VARIATION_PASSWORD) || (variation
                == EditorInfo.TYPE_CLASS_TEXT or EditorInfo.TYPE_TEXT_VARIATION_WEB_PASSWORD) || (variation
                == EditorInfo.TYPE_CLASS_NUMBER or EditorInfo.TYPE_NUMBER_VARIATION_PASSWORD)
    }

    private fun isVisiblePasswordInputType(inputType: Int): Boolean {
        val variation = inputType and (EditorInfo.TYPE_MASK_CLASS or EditorInfo.TYPE_MASK_VARIATION)
        return (variation
                == EditorInfo.TYPE_CLASS_TEXT or EditorInfo.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD)
    }

}