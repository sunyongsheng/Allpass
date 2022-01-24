package top.aengus.allpass.share

sealed class ImportState {

    object NotYet : ImportState()

    object Importing : ImportState()

    object Success : ImportState()

    object Failed : ImportState()
}