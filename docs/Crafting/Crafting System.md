# Crafting System
### How its coded
crafting system is dynamic means there is 3 things crafting manager the mange thing which controls crafting, Recipe this is an resource in Godot which has everything what a recipe needs what result item is how much of it is and what Ingredients are needed,
Ingredient this is also an resource in Godot you use this inside recipe data this has quantity and item nothing else 

crafting manager checks if player has item and everything require
- if player has Ingredient
- if player has space
- if player has Tool Data required to craft the Item

after crafted all Ingredient and durability of Tool Data as well as hunger of player is taken and crafted item is given to player
