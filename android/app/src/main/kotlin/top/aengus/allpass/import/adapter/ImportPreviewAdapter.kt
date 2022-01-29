package top.aengus.allpass.import.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.DiffUtil
import androidx.recyclerview.widget.ListAdapter
import androidx.recyclerview.widget.RecyclerView
import top.aengus.allpass.R
import top.aengus.allpass.import.model.ImportPreview

class ImportPreviewAdapter : ListAdapter<ImportPreview, ImportPreviewAdapter.ImportPreviewViewHolder>(ImportPreviewDiffCallback) {

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

        fun bind(data: ImportPreview) {
            tvName.text = data.name
            tvUsername.text = data.username
            tvPassword.text = data.password
        }
    }

    object ImportPreviewDiffCallback : DiffUtil.ItemCallback<ImportPreview>() {
        override fun areItemsTheSame(
            oldItem: ImportPreview,
            newItem: ImportPreview
        ): Boolean {
            return oldItem == newItem
        }

        override fun areContentsTheSame(
            oldItem: ImportPreview,
            newItem: ImportPreview
        ): Boolean {
            return true
        }
    }
}