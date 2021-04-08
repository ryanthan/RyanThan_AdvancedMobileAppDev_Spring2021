package com.example.lab8_megaman

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import androidx.activity.viewModels
import androidx.lifecycle.Observer
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.example.lab8_megaman.model.RobotViewModel
import com.example.lab8_megaman.util.JSONData

class MainActivity : AppCompatActivity() {

    private val viewModel: RobotViewModel by viewModels()

    //Function that is called when the instance is created
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        //Load the JSON data ONLY once per app lifetime
        if (viewModel.robotList.value == null){
            val loader = JSONData()
            loader.loadJSON(this, viewModel)
        }

        val recyclerView: RecyclerView = findViewById(R.id.recyclerView) //Get the recycler view
        recyclerView.layoutManager = LinearLayoutManager(this, LinearLayoutManager.VERTICAL, false) //Set a layout manager on the recycler view

        val adapter = MyListAdapter(viewModel) //Define an adapter
        recyclerView.adapter = adapter //Assign the adapter to the recycler view

        //Create the observer
        viewModel.robotList.observe(this, Observer {
            adapter.update()
        })
    }
}