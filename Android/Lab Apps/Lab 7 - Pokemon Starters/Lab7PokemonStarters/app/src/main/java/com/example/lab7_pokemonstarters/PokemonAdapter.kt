package com.example.lab7_pokemonstarters

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ExpandableListView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.lab7_pokemonstarters.model.Pokemon

class PokemonAdapter(private val pokemonList: ArrayList<Pokemon>, private val clickListener:(Pokemon) -> Unit): RecyclerView.Adapter<PokemonAdapter.ViewHolder>() {

    //Define a custom ViewHolder class
    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val pokemonTextView: TextView = view.findViewById(R.id.textView)
    }

    //Create and return an instance of the ViewHolder
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val layoutInflater = LayoutInflater.from(parent.context) //Create LayoutInflater instance
        val itemViewHolder = layoutInflater.inflate(R.layout.list_item, parent, false) //Inflate the view
        return ViewHolder(itemViewHolder)
    }

    //Bind the data to the ViewHolder
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val pokemon = pokemonList[position] //Get the data at the position
        holder.pokemonTextView.text = pokemon.name //Set the textView text to the Pokemon's name
        holder.itemView.setOnClickListener{clickListener(pokemon)} //Assign click listener
    }

    //Get the number of items in the list
    override fun getItemCount() = pokemonList.size
}