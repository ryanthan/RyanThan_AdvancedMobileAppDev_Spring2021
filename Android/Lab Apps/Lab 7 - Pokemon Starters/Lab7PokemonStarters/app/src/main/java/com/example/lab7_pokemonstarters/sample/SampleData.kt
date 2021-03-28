package com.example.lab7_pokemonstarters.sample

import com.example.lab7_pokemonstarters.R
import com.example.lab7_pokemonstarters.model.Pokemon

//List of Pokemon data
object SampleData {
    val pokemonList = ArrayList<Pokemon>()

    init {
        pokemonList.add(Pokemon("Charmander", "Lizard Pokémon", R.drawable.charmander))
        pokemonList.add(Pokemon("Squirtle", "Tiny Turtle Pokémon", R.drawable.squirtle))
        pokemonList.add(Pokemon("Bulbasaur", "Seed Pokémon", R.drawable.bulbasaur))

        pokemonList.add(Pokemon("Cyndaquil", "Fire Mouse Pokémon", R.drawable.cyndaquil))
        pokemonList.add(Pokemon("Totodile", "Big Jaw Pokémon", R.drawable.totodile))
        pokemonList.add(Pokemon("Chikorita", "Leaf Pokémon", R.drawable.chikorita))

        pokemonList.add(Pokemon("Torchic", "Chick Pokémon", R.drawable.torchic))
        pokemonList.add(Pokemon("Mudkip", "Mud Fish Pokémon", R.drawable.mudkip))
        pokemonList.add(Pokemon("Treecko", "Wood Gecko Pokémon", R.drawable.treecko))

        pokemonList.add(Pokemon("Chimchar", "Chimp Pokémon", R.drawable.chimchar))
        pokemonList.add(Pokemon("Piplup", "Penguin Pokémon", R.drawable.piplup))
        pokemonList.add(Pokemon("Turtwig", "Tiny Leaf Pokémon", R.drawable.turtwig))

        pokemonList.add(Pokemon("Tepig", "Fire Pig Pokémon", R.drawable.tepig))
        pokemonList.add(Pokemon("Oshawott", "Sea Otter Pokémon", R.drawable.oshawott))
        pokemonList.add(Pokemon("Snivy", "Grass Snake Pokémon", R.drawable.snivy))

        pokemonList.add(Pokemon("Fennekin", "Fox Pokémon", R.drawable.fennekin))
        pokemonList.add(Pokemon("Froakie", "Bubble Frog Pokémon", R.drawable.froakie))
        pokemonList.add(Pokemon("Chespin", "Spiny Nut Pokémon", R.drawable.chespin))

        pokemonList.add(Pokemon("Litten", "Fire Cat Pokémon", R.drawable.litten))
        pokemonList.add(Pokemon("Popplio", "Sea Lion Pokémon", R.drawable.popplio))
        pokemonList.add(Pokemon("Rowlet", "Grass Quill Pokémon", R.drawable.rowlet))

        pokemonList.add(Pokemon("Scorbunny", "Rabbit Pokémon", R.drawable.scorbunny))
        pokemonList.add(Pokemon("Sobble", "Water Lizard Pokémon", R.drawable.sobble))
        pokemonList.add(Pokemon("Grookey", "Chimp Pokémon", R.drawable.grookey))
    }
}