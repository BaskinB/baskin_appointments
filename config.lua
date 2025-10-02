
--      Written and Developed by Baskin
-- -----------------------------------------------------

Config = {
    defaultLang = "en_lang",
    Year = "1902",

    -- Global blip settings (business-level can override)
    Blips = {
        enabled    = true,
        defaultSprite = -369711600, -- default texture hash (editable)
        styleHash  = 1664425300     -- BLIP_ADD_FOR_COORDS style (safe default)
    },

    -- Prefer jobs = {...}; legacy job="..." still works.
    -- Use location = vector4(x,y,z,h); legacy heading fallback is kept.
    Businesses = {
        {
            name = "Western Union Bank",
            job  = "banker",
            location = vector4(-810.58, -1277.49, 43.69, 90.0),
            npc = true,
            model = 's_m_m_bankclerk_01',
            webhook = "https://discord.com/api/webhooks/1234567890/abcdefg",
            -- Optional per-business blip override:
            -- blip = { enabled=true, sprite=-369711600, style=1664425300, name="Bank" }
        },
        {
            name = "Redrock Marshals",
            jobs = { "marshal", "police", "sheriff" },
            location = vector4(-756.49, -1265.82, 44.09, 272.67),
            npc = true,
            model = 's_m_m_bankclerk_01',
            webhook = "https://discord.com/api/webhooks/1234567890/abcdefg",
            blip = {
                enabled = true,
                sprite  = -369711600,  -- per-location sprite (editable)
                -- style   = 1664425300, -- optional; falls back to Config.Blips.styleHash
                -- name    = "Marshal Office"
            }
        },
    }
}