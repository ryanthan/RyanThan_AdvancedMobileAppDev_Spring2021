package com.example.lab9_favoriteslist.util

import android.content.Context
import com.example.lab9_favoriteslist.model.Item

//Class to store the shared preferences functions:
class SharedPreferences {
    private val prefsFile = "ITEMS" //File to store the list data

    //Function to save data to the file
    fun saveDataSP(itemList: ArrayList<Item>, context: Context) {
        val sharedPrefs = context.getSharedPreferences(prefsFile, Context.MODE_PRIVATE) //Get access to a shared preferences file
        val editor = sharedPrefs.edit() //Create an editor to write to the shared preferences file

        //Add size to the editor
        if (itemList != null) { //Null check
            editor.putInt("size", itemList.size)
        }

        //Add the item name property with a unique key for each item
        for ((index, item) in itemList.withIndex()){
            editor.putString("item$index", item.name)
        }

        editor.apply() //Save the data
    }

    //Function to load data from the file
    fun loadDataSP(context: Context):ArrayList<Item>{
        var loadedItemList = ArrayList<Item>()

        val sharedPrefs = context.getSharedPreferences(prefsFile, Context.MODE_PRIVATE) //Get access to a shared preferences file
        val size = sharedPrefs.getInt("size", 0) //Get size of ArrayList in the file

        //Add all of the items from the shared preferences file into the ArrayList
        for (i in 0 until size){
            loadedItemList.add(Item(sharedPrefs.getString("item$i", "")!!))
        }
        return loadedItemList //Return the loaded list
    }
}