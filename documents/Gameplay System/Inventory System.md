# Inventory System
## 1. How it works

Inventory system is fully dynamic which means adding new inventory to something like chest is easy as few clicks and few lines since I use resource to spawn slots and stuff and a inventory data to store inventory max slots and more data

## 2. Slot

Slot is one scene a single scene is used as slot everywhere a slot has
- Item texture
- Item counts label
- Tool Data's durability progress bar 
- selection indicator
Note: - Both progress bar and selection indicator will be removed and made dynamic since not all slots needs both loaded into memory at same time

## 3. Item Adding 

If an  Item is need to be added to players inventory you have to access `player_inventory` , you can access it using `global_inventory_access` , then function (`player_inventory.add_item`) which returns `int` this number is left over  Item that has not been able to add to inventory.

Note:- leftover of an Item is explained at bottom with example

inside `player_inventory.add_item` another function 
`player_inventory.add_to_inventory` 
is called this to make inventory of player dynamic imagine if we backpack or something else so `player_inventory.add_item` goes through all inventory that player has and tells `player_inventory.add_to_inventory` to add this much number of this  Item to the given inventory and `int` is given as new leftover  Item

### `add_to_inventory`

this function goes through all occupied slots first (all non empty) if slot is empty that slot is skipped, this is to check if  Item that is going to be added already exists in the inventory if it exists `slot.add_item` is called which tries to add and give `int` which is new leftover, this loop runs until we check all slots or leftover reaches 0 then this breaks

now if all occupied slot is different type of Item then next loop checks all empty slots then tries to add into it till leftover is 0 or all slots been checked if leftover is 0 it breaks and if not 0 leftover is returned
### Example

- item log
- log max quantity `max_item_quantity` = 16
- number of log on ground (drop) `item_to_add` = 12
- `left_over = item_to_add`(12)
#### Condition 1

- player inventory is full empty or not same type of Item and there is available empty space

 Steps:-
 - checks all occupied slots (0, since all slots are empty this is fully skipped)
 - find first empty slot gives item to slot and adds 12 Item fully to slot
 - first calculates `available_space` `max_item_quantity - item_quantity` which in this case is 16 - 0 since slot is empty so maximum space 16
 - now `items_adding` is minimum which is either `available_space`(16) or `item_to_add`(12) in this case `item_to_add`(12) 
 - then make `slot_data` in slot and set `item_data` 
 - then `slot.slot_data.quantity += items_adding`
 - so `left_over = item_to_add - items_adding` in this case its 12 - 12 = 0
 - since leftover is 0 which means all Item is added successfully
#### Condition 2

- player has 6 log and at least one empty slot

Steps:-
 - checks all occupied slots, finds the non empty of same type since we said we adding log so it checks for first non empty slot which has log
 - then calculates `available_space` `max_item_quantity - item_quantity` which in this case is 16 - 6 = 10
 - now `items_adding` is minimum which is either `available_space`(10) or `item_to_add`(12) in this case it is `available_space`(10)
 - no need to make `slot_data` since it already has it
 - now `slot.slot_data.quantity += items_adding`
 - so `left_over = item_to_add - items_adding` in this case its 12 - 10= 2
 - since leftover is 2 the for loop keep going and checks for next slot which has log and is not full

incase if leftover is not 0 then function returns what ever leftover it is and let sender handle it if its dropped item dropped item quantity = leftover and sits in ground without freeing itself

To Prevent Inventory bug done by players each time any item adding or anything happening to slot this will cause slot to update itself this will check if item quantity is overflowing like more than the maximum if it is it is handled Immediately

## 4. Item Removal

this is same as adding it search for given item and how much of item and removes that much of item


## 5. Miscellaneous

Player Inventory contains several functions for crafting needs


| Function       | Use                                                                                                  |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| `has_item`     | checks if given item exists in inventory used mostly for crafting to check if player has ingredients |
| `has_tool_tag` | checks if player has given tool in inventory                                                         |
|                |                                                                                                      |

