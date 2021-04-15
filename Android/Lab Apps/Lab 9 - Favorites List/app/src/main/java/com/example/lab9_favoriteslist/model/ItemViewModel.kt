package com.example.lab9_favoriteslist.model

import android.app.Application
import android.util.Log
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.example.lab9_favoriteslist.util.SharedPreferences

class ItemViewModel(application: Application) : AndroidViewModel(application) {
    //Variables:
    val favoritesList = MutableLiveData<ArrayList<Item>>()
    private var newList = ArrayList<Item>()
    val context = application.applicationContext
    val SharedPreferences = SharedPreferences()

    //Add item to the list
    fun add(item: Item) {
        newList.add(item)
        favoritesList.value = newList
    }

    //Delete item from the list
    fun delete(item: Item) {
        newList.remove(item)
        favoritesList.value = newList
    }

    //Save the data using shared preferences
    fun saveData() {
        favoritesList.value?.let{ SharedPreferences.saveDataSP(favoritesList.value!!, context)}
    }

    //Load the data using shared preferences
    fun loadData() {
        newList = SharedPreferences.loadDataSP(context)
        favoritesList.value = newList
    }
}