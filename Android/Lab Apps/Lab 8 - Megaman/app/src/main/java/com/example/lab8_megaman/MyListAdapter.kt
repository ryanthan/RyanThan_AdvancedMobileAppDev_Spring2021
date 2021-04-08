package com.example.lab8_megaman

import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.example.lab8_megaman.model.RobotViewModel
import com.squareup.picasso.Picasso

class MyListAdapter(private val robotViewModel: RobotViewModel): RecyclerView.Adapter<MyListAdapter.ViewHolder>() {
    private var myRobotList = robotViewModel.robotList.value

    //Custom ViewHolder class
    class ViewHolder(view: View): RecyclerView.ViewHolder(view) {
        val nameTextView: TextView = view.findViewById(R.id.nameTextView)
        val weaponTextView: TextView = view.findViewById(R.id.weaponTextView)
        val imageView: ImageView = view.findViewById(R.id.imageView)
        val imageView2: ImageView = view.findViewById(R.id.imageView2)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        //Create an instance of LayoutInflater
        val layoutInflater = LayoutInflater.from(parent.context)
        //Inflate the view
        val itemViewHolder = layoutInflater.inflate(R.layout.card_list_item, parent, false)
        return ViewHolder(itemViewHolder)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        //Get data at the position and fill in text views
        val robot = myRobotList?.get(position)
        holder.nameTextView.text = robot?.name ?: ""
        holder.weaponTextView.text = "Weapon: " + robot?.weapon ?: ""

        //Load images using Picasso
        Picasso.get().load(robot?.spriteURL ?: "")
            .error(R.drawable.image_placeholder)
            .placeholder(R.drawable.image_placeholder)
            .into(holder.imageView)

        Picasso.get().load(robot?.avatarURL ?: "")
            .error(R.drawable.image_placeholder)
            .placeholder(R.drawable.image_placeholder)
            .into(holder.imageView2)

    }

    override fun getItemCount(): Int {
        if (myRobotList != null) {
            return myRobotList!!.size
        } else return 0
    }

    fun update(){
        myRobotList = robotViewModel.robotList.value
        notifyDataSetChanged()
        Log.i("adapter update", robotViewModel.robotList.value?.size.toString())
    }
}