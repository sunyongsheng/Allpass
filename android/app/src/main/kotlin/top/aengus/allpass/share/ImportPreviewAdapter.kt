package top.aengus.allpass.share

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import top.aengus.allpass.R

class ImportPreviewAdapter : ListAdapter<PreviewItem, ImportPreviewAdapter.ImportPreviewViewHolder>(ImportPreviewDiffCallback) {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ImportPreviewViewHolder {
        val rootView = LayoutInflater.from(parent.context).inflate(R.layout.item_import_password, parent, false)
        return ImportPreviewViewHolder(rootView)
    }

    override fun onBindViewHolder(holder: ImportPreviewViewHolder, position: Int) {
        holder.bind(getItem(position))
    }

    class ImportPreviewViewHolder(rootView: View) : RecyclerView.ViewHolder(rootView) {

        private val tvName: TextView = rootView.findViewById(R.id.tv_name)
        private val tvUsername: TextView = rootView.findViewById(R.id.tv_username)
        private val tvPassword: TextView = rootView.findViewById(R.id.tv_password)

        fun bind(data: PreviewItem) {
            tvName.text = data.name
            tvUsername.text = data.username
            tvPassword.text = data.password
        }
    }

    object ImportPreviewDiffCallback : DiffUtil.ItemCallback<PreviewItem>() {
        override fun areItemsTheSame(
            oldItem: PreviewItem,
            newItem: PreviewItem
        ): Boolean {
            return oldItem == newItem
        }

        override fun areContentsTheSame(
            oldItem: PreviewItem,
            newItem: PreviewItem
        ): Boolean {
            return true
        }
    }
}