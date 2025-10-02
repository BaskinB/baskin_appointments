
-- -----------------------------------------------------
--      Written and Developed by Baskin
-- -----------------------------------------------------

--[[ Credits to Fistofury for the general menu code formatting ]]

VORPcore   = exports.vorp_core:GetCore()
BccUtils   = exports['bcc-utils'].initiate()
FeatherMenu= exports['feather-menu'].initiate()

-- ---------- NPC + Prompt Tunables ----------
local INTERACT_RADIUS  = 1.5
local SPAWN_RADIUS     = 50.0
local DESPAWN_RADIUS   = 60.0
local CLEANUP_RADIUS   = 3.0
local TICK_NEAR_MS     = 0
local TICK_FAR_MS      = 250

-- ---------- State ----------
local CreatedNpcs  = {}     -- businessName -> ped (wrapper/handle)
local BusinessBlips= {}     -- businessName -> blip handle

-- ---------- Job helpers (why: legacy compat) ----------
local function normalizeJobs(b)
    if b.jobs and type(b.jobs) == 'table' then return b.jobs end
    if b.job  and type(b.job)  == 'string' then return { b.job } end
    return {}
end
local function canonicalJob(b) local t=normalizeJobs(b); return t[1] end

local function playerHasAccess(business)
    local st = LocalPlayer.state
    local pj = st and st.Character and (st.Character.Job or st.Character.job)
    if not pj then return false end
    for _, j in ipairs(normalizeJobs(business)) do if j == pj then return true end end
    return false
end

-- ---------- Entity helpers ----------
local function pedHandleOf(p)
    if type(p) == 'number' then return p end
    if type(p) == 'table' then return p.ped or p.entity or p.id or p.handle end
    return nil
end

local function DeletePedSafe(p)
    local h = pedHandleOf(p)
    if h and DoesEntityExist(h) then
        SetEntityAsMissionEntity(h, true, true) -- why: ensure deletable
        DeleteEntity(h)
    elseif type(p) == 'table' and p.Delete then p:Delete()
    elseif type(p) == 'table' and p.delete then p:delete()
    end
end

-- Enumerators (for one-time cleanup)
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local handle, entity = initFunc()
        if not handle or handle == -1 then disposeFunc(handle) return end
        local ok = true
        repeat coroutine.yield(entity); ok, entity = moveFunc(handle) until not ok
        disposeFunc(handle)
    end)
end
local function EnumeratePeds() return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed) end

local function DeleteExistingBusinessPeds(business, radius)
    local loc = business.location
    local center = vector3(loc.x, loc.y, loc.z)
    local modelHash = GetHashKey(business.model)
    local r = radius or CLEANUP_RADIUS
    for ped in EnumeratePeds() do
        if DoesEntityExist(ped) and not IsPedAPlayer(ped) then
            if GetEntityModel(ped) == modelHash then
                if #(GetEntityCoords(ped) - center) <= r then
                    SetEntityAsMissionEntity(ped, true, true)
                    DeleteEntity(ped)
                end
            end
        end
    end
end

-- ---------- NPC spawn/despawn (stable; no flicker) ----------
local function EnsureSpawn(business)
    if not business.npc or CreatedNpcs[business.name] ~= nil then return end
    local loc = business.location
    local ped = BccUtils.Ped:Create(business.model, loc.x, loc.y, loc.z, -1, 'world', false)
    CreatedNpcs[business.name] = ped
    local h = pedHandleOf(ped)
    local heading = (loc.w or business.heading or 0.0)
    if h and DoesEntityExist(h) then
        SetEntityAsMissionEntity(h, true, true)
        FreezeEntityPosition(h, true)
        SetEntityInvincible(h, true)
        SetEntityHeading(h, heading)
    else
        if ped.Freeze then ped:Freeze() end
        if ped.Invincible then ped:Invincible() end
        if ped.SetHeading then ped:SetHeading(heading) end
    end
end

local function EnsureDespawn(business)
    local cached = CreatedNpcs[business.name]
    if not cached then return end
    DeletePedSafe(cached)
    CreatedNpcs[business.name] = nil
end

-- ---------- BLIPS (configurable) ----------
-- why: per-business override > global defaults
local function BlipEnabledFor(b)
    if b.blip and b.blip.enabled ~= nil then return b.blip.enabled end
    return (Config.Blips and Config.Blips.enabled) ~= false
end

local function ResolveBlipSprite(b)
    if b.blip and b.blip.sprite then return b.blip.sprite end
    return (Config.Blips and Config.Blips.defaultSprite) or -369711600
end

local function ResolveBlipStyle(b)
    if b.blip and b.blip.style then return b.blip.style end
    return (Config.Blips and Config.Blips.styleHash) or 1664425300
end

local function ResolveBlipName(b)
    if b.blip and b.blip.name and b.blip.name ~= "" then return b.blip.name end
    return b.name
end

local function CreateBusinessBlip(business)
    if not business or not business.location then return end
    if not BlipEnabledFor(business) then return end
    if BusinessBlips[business.name] then return end

    local loc = business.location
    local style = ResolveBlipStyle(business)
    local sprite = ResolveBlipSprite(business)
    local label = ResolveBlipName(business)

    -- MAP::BLIP_ADD_FOR_COORDS(styleHash, x, y, z)
    local blip = Citizen.InvokeNative(0x554D9D53F696D002, style, loc.x + 0.0, loc.y + 0.0, loc.z + 0.0)
    -- MAP::SET_BLIP_SPRITE blip, spriteHash, p2
    Citizen.InvokeNative(0x74F74D3207ED525C, blip, sprite, true)
    -- MAP::SET_BLIP_NAME blip, name
    Citizen.InvokeNative(0x9CB1A1623062F402, blip, label)

    BusinessBlips[business.name] = blip
end

local function RemoveBusinessBlip(name)
    local blip = BusinessBlips[name]
    if blip and blip ~= 0 then
        RemoveBlip(blip) -- fallback native: 0x86A652570E5F25DD
        BusinessBlips[name] = nil
    end
end

local function CreateAllBusinessBlips()
    for _, b in pairs(Config.Businesses) do CreateBusinessBlip(b) end
end

local function RemoveAllBusinessBlips()
    for name, _ in pairs(BusinessBlips) do RemoveBusinessBlip(name) end
end

-- ---------- Nearest business ----------
local function NearestBusinessWithin(pos, maxDist)
    local nearestB, nearestD = nil, maxDist
    for _, b in pairs(Config.Businesses) do
        local bpos = vector3(b.location.x, b.location.y, b.location.z)
        local d = #(pos - bpos)
        if d < nearestD then nearestB, nearestD = b, d end
    end
    return nearestB, nearestD
end

-- ---------- Main loop (spawn/despawn + prompt; blips on start) ----------
CreateThread(function()
    local PromptGroup = BccUtils.Prompts:SetupPromptGroup()
    local firstPrompt = PromptGroup:RegisterPrompt(_U("schedulePrompt"), 0x760A9C6F, 1, 1, true, 'hold', { timedeventhash = "MEDIUM_TIMED_EVENT" })

    -- One-time cleanup (old NPCs)
    for _, v in pairs(Config.Businesses) do
        if v.npc and v.location then DeleteExistingBusinessPeds(v, CLEANUP_RADIUS) end
    end

    -- Create blips once
    CreateAllBusinessBlips()

    local didOpenMenu = false
    local lastShownName = nil

    while true do
        local sleepMs = TICK_FAR_MS
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, business in pairs(Config.Businesses) do
            local bpos = vector3(business.location.x, business.location.y, business.location.z)
            local dist = #(playerCoords - bpos)
            if dist <= SPAWN_RADIUS then
                EnsureSpawn(business)
            elseif dist >= DESPAWN_RADIUS then
                EnsureDespawn(business)
            end
        end

        local nearBusiness = nil
        do
            local nb, _ = NearestBusinessWithin(playerCoords, INTERACT_RADIUS)
            nearBusiness = nb
        end

        if nearBusiness then
            sleepMs = TICK_NEAR_MS
            if lastShownName ~= nearBusiness.name then lastShownName = nearBusiness.name end
            PromptGroup:ShowGroup(lastShownName)
            if firstPrompt:HasCompleted() and not didOpenMenu then
                OpenMainMenu()
                didOpenMenu = true
            end
        else
            didOpenMenu = false
            lastShownName = nil
        end

        Wait(sleepMs)
    end
end)

-- Cleanup on stop (NPCs + BLIPs)
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for name, ped in pairs(CreatedNpcs) do DeletePedSafe(ped); CreatedNpcs[name] = nil end
    RemoveAllBusinessBlips()
end)

-- ---------- UI (unchanged; vector4-ready) ----------
local mainMenu, mainPage, viewPage, schedulePage, appointmentPage, checkAppointmentPage

function OpenMainMenu()
    mainPage, viewPage, schedulePage, checkAppointmentPage, appointmentPage = nil, nil, nil, nil, nil

    for _, business in pairs(Config.Businesses) do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local dist = #(playerCoords - vector3(business.location.x, business.location.y, business.location.z))

        if not mainMenu then
            mainMenu = FeatherMenu:RegisterMenu('baskin_appointment:mainMenu', {
                top = '10%', left = '2%',
                ['720width'] = '600px', ['1080width'] = '700px',
                ['2kwidth'] = '800px',  ['4kwidth']  = '1000px',
                contentslot = { style = { ['max-height'] = '550px' } },
                draggable = false, canclose = true
            })
        end

        if dist < INTERACT_RADIUS then
            if not mainPage then
                mainPage = mainMenu:RegisterPage('mainmenu:first:page')
                mainPage:RegisterElement("header", { value = business.name, slot = "header", style = {} })
                mainPage:RegisterElement('subheader', { value = _U("optionText"), slot = "header", style = {} })
                mainPage:RegisterElement('line', { slot = "header", style = {} })
                mainPage:RegisterElement('button', {
                    label = _U("scheduleButton"),
                    style = {},
                    sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" },
                }, function() schedulePage:RouteTo() end)
                mainPage:RegisterElement('bottomline', { slot = "footer", style = {} })
                mainPage:RegisterElement('button', {
                    label = _U("closeButton"), slot = "footer", style = {},
                    sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" },
                }, function() mainMenu:Close({}) end)
            end

            if not schedulePage then
                schedulePage = mainMenu:RegisterPage('mainmenu:appointment:page')
                schedulePage:RegisterElement('header', { value = business.name, slot = "header", style = {} })
                schedulePage:RegisterElement('subheader', { value = _U('scheduleText'), slot = "header", style = {} })
                schedulePage:RegisterElement('line', { slot = "header", style = {} })
                local charname, telegram, reason = '', '', ''
                schedulePage:RegisterElement('input', {
                    label = _U('nameLabel'), placeholder = _U('namePlace'), persist = false,
                    style = { ['border-color'] = "#513e23" }
                }, function(data) charname = data.value end)
                schedulePage:RegisterElement('input', {
                    label = _U('teleLabel'), placeholder = _U('telePlace'), persist = false, style = {}
                }, function(data) telegram = data.value end)
                schedulePage:RegisterElement('subheader', { value = _U('reasonLabel'), slot = "content", style = {} })
                schedulePage:RegisterElement('textarea', {
                    placeholder = _U('reasonPlace'), rows = "4", resize = false, persist = false, style = {}
                }, function(data) reason = data.value end)
                schedulePage:RegisterElement('line', { slot = "footer" })
                schedulePage:RegisterElement('button', {
                    label = _U('submitButton'), slot = "footer", style = {},
                    sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" },
                }, function()
                    local appointmentData = {
                        job = canonicalJob(business),
                        charname = charname or "",
                        reason   = reason or "",
                        telegram = telegram or ""
                    }
                    TriggerServerEvent("baskin_appointments:InsertCreatedAppointmentIntoDB", appointmentData)
                    VORPcore.NotifyObjective(_U("scheduleNotify") .. business.name, 5000)
                    mainPage:RouteTo()
                end)
                schedulePage:RegisterElement('button', {
                    label = _U("backButton"), slot = "footer", style = {},
                    sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" },
                }, function() mainPage:RouteTo() end)
                schedulePage:RegisterElement('bottomline', { slot = "footer" })
            end

            if not viewPage then
                viewPage = mainMenu:RegisterPage('mainmenu:view:page')
                if playerHasAccess(business) and dist < INTERACT_RADIUS then
                    mainPage:RegisterElement('button', {
                        label = _U('viewButton'), style = {},
                        sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" },
                    }, function()
                        TriggerServerEvent('baskin_appointments:GetAllAppointmentsForBusiness', business.name)
                    end)
                end
            end

            if not checkAppointmentPage then
                checkAppointmentPage = mainMenu:RegisterPage('mainmenu:checkappoint:page')
                checkAppointmentPage:RegisterElement('header', { value = business.name, slot = "header", style = {} })
                checkAppointmentPage:RegisterElement('subheader', { value = _U('pickText'), slot = "header", style = {} })
                checkAppointmentPage:RegisterElement('bottomline', { slot = "footer" })
                checkAppointmentPage:RegisterElement('button', {
                    label = _U('backButton'), slot = "footer", style = {},
                    sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" },
                }, function() mainPage:RouteTo() end)
            end

            mainMenu:Open({ startupPage = mainPage, sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" } })
        end
    end
end

RegisterNetEvent('baskin_appointments:DisplayAllAppointments', function (appointments)
    checkAppointmentPage = nil
    OpenMainMenu(true)
    for _, a in ipairs(appointments) do
        local label = (a.charname or "Unknown") .. " | " .. (a.created_at or "")
        checkAppointmentPage:RegisterElement('button', {
            label = label, style = {},
            sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" },
        }, function() CheckAppointment(a) end)
        checkAppointmentPage:RouteTo()
    end
end)

function CheckAppointment(a)
    appointmentPage = mainMenu:RegisterPage('viewmenu:appointment:page')
    appointmentPage:RegisterElement('header',    { value = a.charname,   slot = "header", style = {} })
    appointmentPage:RegisterElement('subheader', { value = a.created_at, slot = "header", style = {} })
    appointmentPage:RegisterElement('bottomline',{ slot = "header", style = {} })
    appointmentPage:RegisterElement('subheader', { value = _U('telegramText'), slot = "content", style = {} })
    appointmentPage:RegisterElement('textdisplay',{ value = a.telegram, style = {} })
    appointmentPage:RegisterElement('subheader', { value = _U("reasonText"), slot = "content", style = {} })
    appointmentPage:RegisterElement('textdisplay',{
        value = a.reason,
        style = { ['padding'] = '10px 20px', ['max-height'] = '200px', ['overflow-y'] = 'auto', ['overflow-x'] = 'hidden' }
    })
    appointmentPage:RegisterElement('line', { slot = "content", style = {} })
    appointmentPage:RegisterElement('button', {
        label = _U('backButton'), slot = "footer", style = {},
        sound = { action = "SELECT", soundset = "RDRO_Character_Creator_Sounds" },
    }, function() checkAppointmentPage:RouteTo() end)
    appointmentPage:RegisterElement('button', {
        label = _U('deleteButton'), slot = "footer", style = { ['color'] = '#ff454b' },
    }, function()
        TriggerServerEvent('baskin_appointments:DeleteAppointment', a.id)
        VORPcore.NotifyObjective(_U('deleteNotify'), 5000)
        mainPage:RouteTo()
    end)
    appointmentPage:RouteTo()
end
