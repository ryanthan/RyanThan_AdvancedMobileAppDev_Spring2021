package com.example.lab8_trivia.model

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize data class Item(val question: String, val answer: String, val category: String, val difficulty: String): Parcelable {}