package top.aengus.allpass.service

import android.view.autofill.AutofillId

data class ParsedStructure(
    var usernameId: AutofillId?,
    var passwordId: AutofillId?
) {
    fun isValid(): Boolean {
        return usernameId != null || passwordId != null
    }
}