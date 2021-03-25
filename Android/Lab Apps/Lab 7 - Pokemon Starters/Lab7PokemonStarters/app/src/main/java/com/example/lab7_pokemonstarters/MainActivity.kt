package com.example.lab7_pokemonstarters

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.lab7_pokemonstarters.model.Pokemon
import com.example.lab7_pokemonstarters.sample.SampleData

class MainActivity : AppCompatActivity() {
    private val pokemonList = SampleData.pokemonList

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //Recycler View:
        val recyclerView: RecyclerView = findViewById(R.id.recyclerView) //Get the recycler view
        val adapter = PokemonAdapter(pokemonList, {item: Pokemon -> pokemonClicked(item)}) //Define an adapter
        recyclerView.adapter = adapter //Assign the adapter to the recycler view
        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false) //Set a layout manager on the recycler view
        recyclerView.addItemDecoration(DividerItemDecoration(this, LinearLayoutManager.VERTICAL)) //Add divider lines in between list items
    }

    //Function that is called when a list item is clicked
    private fun pokemonClicked(item: Pokemon) {
        //Create the intent
        val intent = Intent(this, DetailActivity::class.java)
        intent.putExtra("name", item.name)
        intent.putExtra("description", item.description)
        intent.putExtra("resourceID", item.imageID)

        startActivity(intent) //Start activity
    }
}