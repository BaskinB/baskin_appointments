Config = {
    defaultLang = "en_lang",
    Debug = false,
    Year = "1901",
    Businesses = {
    --[[{
            name = "Example", -- Business Name
            job = "example", -- Business Job
            location = vector3(-810.58, -1277.49, 43.69) -- Blackwater Bank
            npc = true, -- wether or not to spawn an NPC at the location coords
            model = 's_m_m_bankclerk_01', -- NPC Model Name.
            heading = 90, -- NPC Heading.
        },]]
        {
            name = "Western Union Bank", -- Business Name
            job = "banker", -- Business Job
            location = vector3(-810.58, -1277.49, 43.69), -- Blackwater Bank
            npc = true,
            model = 's_m_m_bankclerk_01',
            heading = 90,
        },
    }
}
