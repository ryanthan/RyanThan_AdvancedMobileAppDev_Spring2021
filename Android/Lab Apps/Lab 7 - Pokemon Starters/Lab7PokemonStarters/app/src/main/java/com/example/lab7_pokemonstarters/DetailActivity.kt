package com.example.lab7_pokemonstarters

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.snackbar.Snackbar

class DetailActivity : AppCompatActivity() {
    lateinit var pokemonNameSnackbar : String

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_detail)

        //Get data from the intent
        val name = intent.getStringExtra("name")
        val description = intent.getStringExtra("description")
        val resourceID = intent.getIntExtra("resourceID", -1)

        //Update the detail view with the data
        val pokemonImage: ImageView = findViewById(R.id.pokemonImageView)
        val pokemonName: TextView = findViewById(R.id.nameTextView)
        val pokemonDescription: TextView = findViewById(R.id.descriptionTextView)

        pokemonImage.setImageResource(resourceID)
        pokemonName.text = name
        pokemonDescription.text = description

        pokemonNameSnackbar = name.toString() //Set the Pokemon name for use with the snackbar
    }

    //Inflate the options menu
    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.main_menu, menu)
        return true
    }

    //Function that is called when an options item is selected
    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        val id = item.itemId

        if (id == R.id.catchPokemon) {
            //Display a snack bar when the options item is clicked
            Snackbar.make(findViewById(android.R.id.content), "You caught a " + pokemonNameSnackbar + "!", Snackbar.LENGTH_LONG).setAction("Action", null).show()
            return true
        }
        return super.onOptionsItemSelected(item)
    }
}