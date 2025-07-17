Config = {}

Config.PoliceCallChance = 25 -- percent chance (0-100) police get notified on each sale
Config.DirtyMoneyItem = 'blackmoney'  -- change this to whatever your dirty money item is called
Config.NPCsThatCall911 = {     -- List of NPC labels that trigger police dispatch on sale
    "The Creep",               
    "Black Market Dealer",      
  --"NPC NAME HERE"       -- add more labels as you want
}



Config.NPCs = {
    {
        label = "Black Market Dealer",
        model = `g_m_y_strpunk_01`,
        coords = vector4(1553.0505, 3604.0542, 38.7752, 213.0468),
        items = {
            { label = "Stolen Phone",   item = "phone",         price = 100, dirtyMoney = true  },
            { label = "Gold Chain",     item = "goldchain",     price = 125, dirtyMoney = true  },
            { label = "Diamond Ring",   item = "diamond_ring",  price = 350, dirtyMoney = true  },
            { label = "Rolex",          item = "rolex",         price = 250, dirtyMoney = true  },
            { label = "Crypto Stick",   item = "cryptostick",   price = 50, dirtyMoney = true  },
            { label = "houselaptop",    item = "houselaptop",   price = 400, dirtyMoney = true  },
            { label = "mansion laptop", item = "mansionlaptop", price = 800, dirtyMoney = true  },
            { label = "Desktop",        item = "mddesktop",     price = 250, dirtyMoney = true  },
            { label = "Speakers",       item = "mdspeakers",    price = 250, dirtyMoney = true  },
            { label = "Tablet",         item = "mdtablet",      price = 250, dirtyMoney = true  },
            { label = "Art Piece",      item = "art1",          price = 200, dirtyMoney = true  },
            { label = "Art Piece",      item = "art2",          price = 300, dirtyMoney = true  },
            { label = "Art Piece",      item = "art3",          price = 400, dirtyMoney = true  },
            { label = "Art Piece",      item = "art4",          price = 500, dirtyMoney = true  },
            { label = "Art Piece",      item = "art5",          price = 500, dirtyMoney = true  },
            { label = "Art Piece",      item = "art6",          price = 500, dirtyMoney = true  },
            { label = "Art Piece",      item = "art7",          price = 800, dirtyMoney = true  },
            { label = "Check Book",     item = "checkbook",     price = 500, dirtyMoney = true  },
            { label = "Laptop",         item = "laptop",        price = 250, dirtyMoney = true  },

        }
    },
    {
        label = "Worker",
        model = `s_m_y_construct_02`,
        coords = vector4(2571.9136, 2718.1812, 42.6800, 213.4300),
        items = {
            { label = "Aluminum",   item = "aluminum", price = 35,}, -- Add , image = "nui://npc-sell/images/phone.png" If you want there to be item images, remember to add the images into the folder named "images"
            { label = "copper",     item = "copper", price = 35,},
            { label = "steel",      item = "steel", price = 35 },
            { label = "scrapmetal", item = "scrapmetal", price = 35 },
            { label = "plastic",    item = "plastic", price = 35 },
            { label = "rubber",     item = "rubber", price = 35 },
            { label = "iron",       item = "iron", price = 35 },
            { label = "glass",      item = "glass", price = 35 },
        },
        animation = {
            scenario = "WORLD_HUMAN_CLIPBOARD"
        }
    },  
    {
        label = "The Creep",
        model = `u_m_m_aldinapoli`,
        coords = vector4(-291.3465, 2544.1638, 75.4158, 330.5031),
        items = {
            { label = "Used Panties", item = "panties", price = 75, dirtyMoney = true },
        },
        animation = {
            dict = "amb@world_human_stand_impatient@female@no_sign@base",
            clip = "base"
        }

    }
}

Config.SellAnimation = {
    dict = 'mp_common',
    clip = 'givetake1_a',
    duration = 3000, -- ms
    label = 'Selling items...'
}
