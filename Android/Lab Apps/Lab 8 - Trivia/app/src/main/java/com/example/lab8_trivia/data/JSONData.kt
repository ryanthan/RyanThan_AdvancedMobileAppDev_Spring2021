package com.example.lab8_trivia.data

import android.content.Context
import com.example.lab8_trivia.R
import com.example.lab8_trivia.model.Item
import org.json.JSONException
import org.json.JSONObject
import java.security.AccessControlContext

//JSON data from this API: https://opentdb.com/api_config.php
class JSONData {
    var itemList = ArrayList<Item>()

    //Function in charge of calling the other functions
    fun getJSON(context: Context): ArrayList<Item> {
        var json = loadJSONFromResource(context)
        itemList = parseJSON(json)
        return itemList
    }

    //Load the json data from the data source
    fun loadJSONFromResource(context: Context): String {
        //Opens the JSON file and assigns it to an instance of InputStream
        val inputStream = context.resources.openRawResource(R.raw.trivia)

        //Creates a buffered reader on the InputStream and readText() returns a String
        return inputStream.bufferedReader().use {it.readText()}
    }

    //Parse json data and populate item list
    fun parseJSON(jsonstring: String): ArrayList<Item> {
        try {
            //Create a JSONObject
            val jsonObject = JSONObject(jsonstring)

            //Create a JSONArray with the value from the items key
            val itemArray = jsonObject.getJSONArray("items")

            //Loop through each object in the array
            for (i in 0 until itemArray.length()){
                val item = itemArray.getJSONObject(i)

                //Get values for the question and correct_answer keys
                val question = item.getString("question")
                val answer = item.getString("correct_answer")
                val category = item.getString("category")
                val difficulty = item.getString("difficulty")

                //Create new Item object
                val newItem = Item(question, answer, category, difficulty)

                //Add Item object to the list
                itemList.add(newItem)
            }
        //Error handling
        } catch (e: JSONException) {
            e.printStackTrace()
        }
        return itemList
    }
}