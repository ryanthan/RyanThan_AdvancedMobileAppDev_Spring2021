package com.example.lab9_favoriteslist

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.lab9_favoriteslist.model.Item
import com.example.lab9_favoriteslist.model.ItemViewModel
import com.google.android.material.snackbar.Snackbar

class MyListAdapter(private val itemViewModel: ItemViewModel, private val clickListener: (Item) -> Unit): RecyclerView.Adapter<MyListAdapter.ViewHolder>() {
    private var myFavoritesList = itemViewModel.favoritesList.value

    //Custom ViewHolder class
    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val itemTextView: TextView = view.findViewById(R.id.textView)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        //Create an instance of LayoutInflater
        val layoutInflater = LayoutInflater.from(parent.context)
        //Inflate the view
        val itemViewHolder = layoutInflater.inflate(R.layout.list_item, parent, false)
        return ViewHolder(itemViewHolder)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        //Get data at the position
        val item = myFavoritesList?.get(position)
        //Fill the TextView
        holder.itemTextView.text = item?.name ?: ""

        //Create a context menu
        holder.itemView.setOnCreateContextMenuListener(){menu, view, menuInfo ->
            //Set the menu title
            menu.setHeaderTitle(R.string.delete)

            //Add the choices to the menu
            menu.add(R.string.yes).setOnMenuItemClickListener {
                //Remove item from the ViewModel if the user clicks 'yes' and display snackbar
                itemViewModel.delete(item!!)
                Snackbar.make(view, R.string.deleteItem, Snackbar.LENGTH_LONG)
                    .setAction(R.string.action, null).show()
                true
            }
            menu.add(R.string.no)
        }

        //Set onClickListener if the item is not null
        holder.itemView.setOnClickListener{
            if (item != null) {
                clickListener(item)
            }
        }
    }

    //Get the number of items in the list
    override fun getItemCount(): Int {
        if (myFavoritesList != null) { //Null check
            return myFavoritesList!!.size
        } else return 0
    }

    //Update the list and redraw the RecyclerView
    fun update(){
        myFavoritesList = itemViewModel.favoritesList.value
        notifyDataSetChanged()
    }
}