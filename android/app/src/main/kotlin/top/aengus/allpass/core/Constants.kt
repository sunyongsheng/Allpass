package top.aengus.allpass.core

const val CHANNEL = "top.aengus.allpass"

// Android -> Flutter
const val METHOD_IMPORT_FROM_CSV = "importChromeData"
const val METHOD_SAVE_PASSWORD_FOR_AUTOFILL = "savePasswordForAutofill"

const val MESSAGE_QUERY_PASSWORD_FOR_AUTOFILL = "queryPasswordForAutofill:"

// Flutter -> Android
const val METHOD_SET_APP_DEFAULT_AUTOFILL = "setAppDefaultAutofill"
const val METHOD_FINISH_IMPORT_FROM_CSV = "finishImportFromCsv"

object FlutterChannel {
    const val QUERY_AUTOFILL = "$CHANNEL/queryPasswordForAutofill"
    const val SAVE_FOR_AUTOFILL = "$CHANNEL/savePasswordForAutofill"
    const val IMPORT_CSV = "$CHANNEL/importCsv"
}