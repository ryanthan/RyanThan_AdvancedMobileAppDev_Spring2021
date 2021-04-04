package com.example.lab8_trivia

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.lab8_trivia.model.Item

class ListAdapter(private val itemList: ArrayList<Item>, private val clickListener: (Item) -> Unit): RecyclerView.Adapter<ListAdapter.ViewHolder>() {
    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val itemTextView: TextView = view.findViewById(R.id.textView2)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        //Create an instance of LayoutInflater
        val layoutInflater = LayoutInflater.from(parent.context)

        //Inflate the view
        val itemViewHolder = layoutInflater.inflate(R.layout.list_item, parent, false)
        return ViewHolder(itemViewHolder)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        //Get data at the row
        val item = itemList[position]

        //Set the text of the textview to the name
        val concatenatedText = "[Category: " + item.category + ", Difficulty: " + item.difficulty + "] \n" + item.question
        holder.itemTextView.text = concatenatedText

        //Assign click listener to each item
        holder.itemView.setOnClickListener{clickListener(item)}
    }

    override fun getItemCount() = itemList.size
}