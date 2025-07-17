# npc-sell

**Version:** 1.0.0

NPC Sell Script for QBCore with quantity selection, animations, item images, dirty money support, police dispatch, and update checking.

---

## Features

- Sell items to NPC vendors with configurable prices  
- Select how many items to sell with input dialog  
- Configurable NPCs with different models, locations, animations, and item lists  
- Display item images in the sell menu  
- Option to receive dirty money for specific items  
- Police dispatch calls with configurable chance and NPC triggers  
- Automatic version update checking on server start  

---

## Installation

1. Clone or download this repository to your FiveM resources folder (e.g., `resources/[local]/npc-sell`)  
2. Add `ensure npc-sell` to your server.cfg  
3. Ensure dependencies are installed (`qb-core`, `ox_lib`, `ox_target`)  
4. Configure your NPCs, items, and settings inside `config.lua`  
5. Add item images in the `images` folder if you want to use custom icons  

---

## Configuration

- `Config.NPCs` — List of NPC vendors with label, model, coords, items, and optional animation  
- `Config.PoliceCallChance` — Percent chance police get notified on sales  
- `Config.NPCsThatCall911` — List of NPC labels that trigger police dispatch  
- `Config.DirtyMoneyItem` — Name of the dirty money item (default `blackmoney`)  
- Items support a `dirtyMoney = true` flag to give dirty money instead of cash  

---

## Usage

- Approach an NPC and interact to open the sell menu  
- Select an item and enter the quantity to sell  
- Animation plays while selling  
- Money (cash or dirty) is added to your inventory based on config  
- Police may be alerted based on chance and NPC  

---

## Update Checking

On server start, the resource checks the latest version from a URL defined in `server.lua`.  
Make sure to update the version text file online when releasing new versions.

---

## Dependencies

- [qb-core](https://github.com/qbcore-framework/qb-core)  
- [ox_lib](https://github.com/overextended/ox_lib)  
- [ox_target](https://github.com/overextended/ox_target)  

---

## Support

If you have issues or feature requests, please open an issue or contact me.

---

## License

MIT License — feel free to use and modify!

---

**Made with ❤️ by Wolfiye**
