package top.aengus.allpass.core

object FlutterChannel {
    const val COMMON = "top.aengus.allpass"

    const val QUERY_FOR_AUTOFILL = "$COMMON/queryPasswordForAutofill"
    const val SAVE_FOR_AUTOFILL = "$COMMON/savePasswordForAutofill"
    const val IMPORT_CSV = "$COMMON/importCsv"

    object Method {
        const val SET_APP_DEFAULT_AUTOFILL = "setAppDefaultAutofill"
        const val IS_APP_DEFAULT_AUTOFILL = "isAppDefaultAutofill"

        const val OPEN_IMPORT_PAGE = "openImportPage"
    }
}