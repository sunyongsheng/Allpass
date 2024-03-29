package top.aengus.allpass.util

data class CsvStructure(
    val header: List<String>,
    val content: List<List<String>>
) {
    fun isEmpty() = content.isEmpty()
}

object CsvUtil {

    fun parse(total: String?): CsvStructure {
        if (total.isNullOrBlank()) return CsvStructure(emptyList(), emptyList())
        val row = total.split("\n")
        if (row.size <= 1) return CsvStructure(emptyList(), emptyList())
        val headerRow = row[0]
        val header = headerRow.split(",")
        val length = header.size
        val contentList = mutableListOf<List<String>>()
        for (i in 1 until row.size) {
            val column = row[i].split(",")
            if (length == column.size) {
                contentList.add(column)
            }
        }
        return CsvStructure(header, contentList)
    }
}