package com.example.lab9_favoriteslist

import android.os.Bundle
import android.util.Log
import com.google.android.material.floatingactionbutton.FloatingActionButton
import com.google.android.material.snackbar.Snackbar
import androidx.appcompat.app.AppCompatActivity
import android.view.Menu
import android.view.MenuItem
import android.widget.EditText
import androidx.activity.viewModels
import androidx.appcompat.app.AlertDialog
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.lab9_favoriteslist.model.Item
import com.example.lab9_favoriteslist.model.ItemViewModel

class MainActivity : AppCompatActivity() {
    private val viewModel: ItemViewModel by viewModels()

    //Function that is called when the instance is created
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        setSupportActionBar(findViewById(R.id.toolbar))

        //Only load saved data once per app lifetime
        if (viewModel.favoritesList.value == null) {
            viewModel.loadData()
        }

        //RecyclerView and Adapter Setup:
        val recyclerView: RecyclerView = findViewById(R.id.recyclerView) //Get the recycler view
        recyclerView.addItemDecoration(DividerItemDecoration(this, LinearLayoutManager.VERTICAL)) //Add divider line between rows
        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false) //Set a layout manager on the RecyclerView
        val adapter = MyListAdapter(viewModel, { item: Item -> itemClicked(item) }) //Define an adapter
        recyclerView.adapter = adapter //Assign the adapter to the RecyclerView

        //FAB Setup:
        findViewById<FloatingActionButton>(R.id.fab).setOnClickListener {view ->
            val dialog = AlertDialog.Builder(this) //Create alert dialog
            val editText = EditText(applicationContext) //Create edit text
            dialog.setView(editText) //Add edit text to dialog
            dialog.setTitle(R.string.addItem) //Set dialog title

            //Set action for when user clicks 'Add'
            dialog.setPositiveButton(R.string.add) {dialog, which ->
                val newItem = editText.text.toString()
                if (!newItem.isEmpty()){ //If the text is not empty:
                    viewModel.add(Item(newItem)) //Add new item to list
                    Snackbar.make(view, R.string.itemAdded, Snackbar.LENGTH_LONG).setAction(R.string.action, null).show() //Create and present a SnackBar
                }
            }
            //Set action for when user clicks 'Cancel'
            dialog.setNegativeButton(R.string.cancel) { dialog, which -> }
            dialog.show() //Present the dialog
        }

        //Create the observer to check if the list is changed
        viewModel.favoritesList.observe(this, Observer {
            adapter.update() //Update the RecyclerView
            viewModel.saveData() //Save the data
        })
    }

    //Function to present a SnackBar when an item is clicked
    private fun itemClicked(item : Item) {
        Snackbar.make(
            findViewById(R.id.recyclerView),
            "You like ${item.name}? Cool!",
            Snackbar.LENGTH_LONG
        ).show()
    }
}