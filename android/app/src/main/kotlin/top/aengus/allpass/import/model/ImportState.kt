package top.aengus.allpass.`import`.model

sealed class ImportState {

    object NotYet : ImportState()

    object Importing : ImportState()

    object Success : ImportState()

    object Failed : ImportState()
}