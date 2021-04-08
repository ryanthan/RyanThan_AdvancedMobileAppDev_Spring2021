package com.example.lab8_trivia

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.lab8_trivia.data.JSONData
import com.example.lab8_trivia.model.Item
import com.google.android.material.snackbar.Snackbar

class MainActivity : AppCompatActivity() {
    var itemList = ArrayList<Item>()

    //When the instance is created
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //If statement to only get the json data one time
        if (savedInstanceState == null) {
            val data = JSONData()
            //Populate list with JSON data
            itemList = data.getJSON(this)
        }
        setupRecyclerView() //Set up the recycler view
    }

    //Function to set up the recycler view
    private fun setupRecyclerView(){
        //Get the recycler view
        val recyclerView: RecyclerView = findViewById(R.id.recyclerView)

        //Add a divider line between rows
        recyclerView.addItemDecoration(DividerItemDecoration(this, LinearLayoutManager.VERTICAL))

        //Define an adapter
        val adapter = ListAdapter(itemList, { item: Item -> itemClicked(item) })

        //assign the adapter to the recycle view
        recyclerView.adapter = adapter

        //set a layout manager on the recycler view
        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false)
    }

    //Function to present a snackbar when the question row is clicked
    private fun itemClicked(item : Item) {
        //Create and present snackbar with correct answer
        Snackbar.make(findViewById(R.id.recyclerView), "Correct Answer: " + item.answer, Snackbar.LENGTH_LONG).show()
    }

    //Function to save the data on rotation
    override fun onSaveInstanceState(outState: Bundle) {
        outState.putParcelableArrayList("itemlist", itemList)
        super.onSaveInstanceState(outState)
    }

    //Function to restore the data destroyed on rotation
    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
        itemList = savedInstanceState.getParcelableArrayList<Item>("itemlist") as ArrayList<Item>
        setupRecyclerView()
    }
}