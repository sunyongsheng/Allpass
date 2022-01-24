package top.aengus.allpass.share

data class CsvStructure(
    val header: List<String>,
    val content: List<List<String>>
) {
    fun isEmpty() = content.isEmpty()
}