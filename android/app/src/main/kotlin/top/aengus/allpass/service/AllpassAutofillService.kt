package top.aengus.allpass.service

import android.app.assist.AssistStructure
import android.os.Build
import android.os.CancellationSignal
import android.service.autofill.*
import android.util.Log
import android.view.View
import android.view.autofill.AutofillValue
import android.widget.RemoteViews
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.BasicMessageChannel
import org.json.JSONArray
import org.json.JSONObject
import top.aengus.allpass.core.FlutterChannel
import top.aengus.allpass.util.createMessageChannel


@RequiresApi(Build.VERSION_CODES.O)
class AllpassAutofillService : AutofillService() {

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

        val appId = structure.activityComponent.packageName
        queryAutofillChannel.send(appId) { resultJson ->
            resultJson ?: return@send
            val jsonArray = JSONArray(resultJson)
            if (jsonArray.length() == 0) {
                callback.onSuccess(null)
                return@send
            }
            val fillResponseBuilder = FillResponse.Builder()
            for (index in 0 until jsonArray.length()) {
                val jsonObj = jsonArray.getJSONObject(index)
                val username = jsonObj.optString("username")
                val password = jsonObj.optString("password")
                if (username.isNotEmpty() || password.isNotEmpty()) {
                    if (!usernameStructure.isValid()) continue

                    val dataset = Dataset.Builder()
                    usernameStructure.usernameId?.let {
                        val usernamePresentation = RemoteViews(packageName, android.R.layout.simple_list_item_1)
                        usernamePresentation.setTextViewText(android.R.id.text1, username)
                        dataset.setValue(it, AutofillValue.forText(username), usernamePresentation)
                    }
                    usernameStructure.passwordId?.let {
                        val passwordPresentation = RemoteViews(packageName, android.R.layout.simple_list_item_1)
                        passwordPresentation.setTextViewText(android.R.id.text1, password)
                        dataset.setValue(it, AutofillValue.forText(password), passwordPresentation)
                    }
                    fillResponseBuilder.addDataset(dataset.build())
                }
            }
            callback.onSuccess(fillResponseBuilder.build())
        }
    }

    override fun onSaveRequest(request: SaveRequest, callback: SaveCallback) {
        val fillContext = request.fillContexts
        val structure = fillContext[fillContext.size - 1].structure

        val windowNodes: List<AssistStructure.WindowNode> = structure.run {
            (0 until windowNodeCount).map { getWindowNodeAt(it) }
        }

        val userData = SimpleUserData(null, null, null)
        windowNodes.forEach { windowNode: AssistStructure.WindowNode ->
            val viewNode: AssistStructure.ViewNode? = windowNode.rootViewNode
            obtainUsernamePasswordRecursive(viewNode, userData)
        }

        userData.appId = structure.activityComponent.packageName

        val jsonObj = JSONObject()
        jsonObj.put("username", userData.username)
        jsonObj.put("password", userData.password)
        jsonObj.put("appId", userData.appId)

        saveAutofillChannel.send(jsonObj.toString(0)) {
            if (it.isNullOrEmpty()) {
                callback.onSuccess()
            } else {
                callback.onFailure(it)
            }
        }
    }

    private fun findUsernamePasswordFillIdRecursive(viewNode: AssistStructure.ViewNode?, parsedStructure: ParsedStructure) {
        if (hasUsernameHint(viewNode?.autofillHints)) {
            viewNode?.autofillId?.let {
                parsedStructure.usernameId = it
            }
            return
        } else if (viewNode?.autofillHints?.contains(View.AUTOFILL_HINT_PASSWORD) == true) {
            viewNode.autofillId?.let {
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
        if (hasUsernameHint(viewNode?.autofillHints)) {
            viewNode?.text?.let {
                userData.username = it.toString()
            }
            return
        } else if (viewNode?.autofillHints?.contains(View.AUTOFILL_HINT_PASSWORD) == true) {
            viewNode.text?.let {
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

    private fun hasUsernameHint(array: Array<String>?): Boolean {
        array ?: return false
        return array.contains(View.AUTOFILL_HINT_USERNAME) || array.contains(View.AUTOFILL_HINT_EMAIL_ADDRESS)
                || array.contains(View.AUTOFILL_HINT_PHONE)
    }

}