package com.example.lab8_megaman.util

import android.content.Context
import android.util.Log
import com.android.volley.Request
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.example.lab8_megaman.model.Robot
import com.example.lab8_megaman.model.RobotViewModel
import org.json.JSONArray
import org.json.JSONException


class JSONData {
    val api_url = "https://megaman-robot-masters.herokuapp.com/"

    //Function to load the JSON from the API URL
    fun loadJSON(context: Context, robotViewModel: RobotViewModel) {
        //Instantiate the Volley request queue
        val queue = Volley.newRequestQueue(context)

        //Request a string response from the provided URL
        val stringRequest = StringRequest(
            Request.Method.GET, api_url,
            { response ->
                parseJSON(response, robotViewModel)
            },
            {
                Log.e("ERROR", error("request failed")) //Error catching
            })
        //Add the request to the RequestQueue
        queue.add(stringRequest)
    }

    //Function to parse the JSON Data
    fun parseJSON(response: String, robotViewModel: RobotViewModel){
        val dataList = ArrayList<Robot>()
        try {
            //Create JSONArray with the response
            var resultsArray = JSONArray(response)

            //Loop through each object in the array
            for (i in 0 until resultsArray.length()){
                val robotObject = resultsArray.getJSONObject(i)

                //Get values
                val name = robotObject.getString("name")
                val weapon = robotObject.getString("weapon")
                val baseSpriteURL = robotObject.getString("sprite1")
                val baseAvatarURL = robotObject.getString("avatar")
                val spriteURL = baseSpriteURL.replace("http:", "https:") //The images didn't load unless I switched the http to https
                val avatarURL = baseAvatarURL.replace("http:", "https:") //The images didn't load unless I switched the http to https

                //Create new Robot object
                val newRobot = Robot(name, weapon, spriteURL, avatarURL)

                //Add object to the list
                dataList.add(newRobot)
            }
        } catch (e: JSONException) { //Error catching
            e.printStackTrace()
        }
        robotViewModel.robotList.value = dataList //Set the ViewModel to the updated list
    }
}