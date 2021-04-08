package com.example.lab8_megaman.model

import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel

//View model
class RobotViewModel: ViewModel() {
    val robotList = MutableLiveData<ArrayList<Robot>>()
}