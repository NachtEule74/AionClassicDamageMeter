-- DamageMeter Commands
-- Slash-Befehle für das Damage Meter Addon

local Commands = {}

-- Register Slash Commands
function Commands:Initialize()
    self:RegisterCommand("/dm", self.OnDamageCommand)
    self:RegisterCommand("/damagemeter", self.OnDamageCommand)
    self:RegisterCommand("/dps", self.OnDPSCommand)
    self:RegisterCommand("/hps", self.OnHPSCommand)
end

-- Command Handler registrieren
function Commands:RegisterCommand(cmdName, handler)
    AddChatCommand(cmdName, handler)
end

-- Hauptbefehl /dm
function Commands:OnDamageCommand(args)
    if not args or args == "" then
        Commands:ShowHelp()
        return
    end
    
    local cmd = string.lower(args)
    
    if cmd == "show" or cmd == "on" then
        DamageMeter:ToggleUI()
        DamageMeter:DebugLog("UI toggled ON")
    elseif cmd == "hide" or cmd == "off" then
        DamageMeter:ToggleUI()
        DamageMeter:DebugLog("UI toggled OFF")
    elseif cmd == "reset" then
        DamageMeter:ResetData()
        DamageMeter:DebugLog("Data reset")
    elseif cmd == "status" then
        Commands:ShowStatus()
    elseif cmd == "help" then
        Commands:ShowHelp()
    else
        Commands:ShowHelp()
    end
end

-- /dps Befehl - Zeige aktuellen DPS
function Commands:OnDPSCommand(args)
    local dps, totalDamage = DamageMeter:CalculateDPS()
    print(string.format("[DamageMeter] Current DPS: %.2f | Total Damage: %d", dps, totalDamage))
end

-- /hps Befehl - Zeige aktuellen HPS
function Commands:OnHPSCommand(args)
    local hps, totalHealing = DamageMeter:CalculateHPS()
    print(string.format("[DamageMeter] Current HPS: %.2f | Total Healing: %d", hps, totalHealing))
end

-- Zeige Hilfe
function Commands:ShowHelp()
    print("======== Damage Meter Commands ========")
    print("/dm show - UI anzeigen")
    print("/dm hide - UI verstecken")
    print("/dm reset - Statistiken zurücksetzen")
    print("/dm status - Zeige aktuellen Status")
    print("/dps - Zeige DPS")
    print("/hps - Zeige HPS")
    print("=========================================")
end

-- Zeige Status
function Commands:ShowStatus()
    local dps, totalDamage = DamageMeter:CalculateDPS()
    local hps, totalHealing = DamageMeter:CalculateHPS()
    
    print("======== Damage Meter Status ========")
    print(string.format("DPS: %.2f | Total Damage: %d", dps, totalDamage))
    print(string.format("HPS: %.2f | Total Healing: %d", hps, totalHealing))
    print(string.format("Duration: %ds", math.floor(DamageMeter.sessionDuration)))
    print("Tracking Solo: " .. tostring(DamageMeter.trackingSolo))
    print("Tracking Group: " .. tostring(DamageMeter.trackingGroup))
    print("======================================")
end

-- Initialize Commands
Commands:Initialize()
