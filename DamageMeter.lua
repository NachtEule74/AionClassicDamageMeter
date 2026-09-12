-- DamageMeter Main Script
-- Aion Classic Damage Meter Addon v1.0
-- Tracks DPS and HPS in real-time

local DamageMeter = {}
DamageMeter.version = "1.0"
DamageMeter.enabled = true
DamageMeter.trackingSolo = false
DamageMeter.trackingGroup = false

-- Storage für Damage/Healing Daten
DamageMeter.damageData = {}
DamageMeter.healingData = {}
DamageMeter.sessionStartTime = 0
DamageMeter.sessionDuration = 0

-- UI Element Referenzen
DamageMeter.ui = {}

-- Initialisiierung
function DamageMeter:Initialize()
    self:RegisterEvents()
    self:CreateUI()
    self:DebugLog("DamageMeter initialized successfully")
end

-- Events registrieren
function DamageMeter:RegisterEvents()
    LuaObject.RegisterEventHandler(LuaEvent.COMBAT_ACT, self, self.OnCombatAction)
    LuaObject.RegisterEventHandler(LuaEvent.HEALING_DONE, self, self.OnHealingDone)
    LuaObject.RegisterEventHandler(LuaEvent.DAMAGE_RECEIVED, self, self.OnDamageReceived)
    LuaObject.RegisterEventHandler(LuaEvent.GROUP_MEMBER_ADDED, self, self.OnGroupMemberAdded)
    LuaObject.RegisterEventHandler(LuaEvent.GROUP_MEMBER_REMOVED, self, self.OnGroupMemberRemoved)
    LuaObject.RegisterEventHandler(LuaEvent.LEAVE_COMBAT, self, self.OnLeaveCombat)
end

-- Combat Action Handler (Damage Dealt)
function DamageMeter:OnCombatAction(args)
    if not self.enabled then return end
    
    local sourceId = args.SourceId
    local sourceName = args.SourceName
    local targetId = args.TargetId
    local targetName = args.TargetName
    local skillId = args.SkillId
    local skillName = args.SkillName
    local damageAmount = args.DamageAmount
    local damageType = args.DamageType -- PHYSICAL, MAGICAL, etc.
    
    -- Ignoriere wenn kein Schaden
    if damageAmount <= 0 then return end
    
    -- Prüfe ob Spieler selbst der Quelle ist
    local playerName = GetPlayerName()
    if sourceName == playerName then
        -- Start Session wenn nicht aktiv
        if self.sessionStartTime == 0 then
            self.sessionStartTime = GetTime()
            self:ResetData()
        end
        
        -- Speichere Damage
        if not self.damageData[sourceName] then
            self.damageData[sourceName] = {
                totalDamage = 0,
                skills = {},
                lastAction = GetTime(),
                targetHit = targetName
            }
        end
        
        self.damageData[sourceName].totalDamage = self.damageData[sourceName].totalDamage + damageAmount
        self.damageData[sourceName].lastAction = GetTime()
        self.damageData[sourceName].targetHit = targetName
        
        -- Speichere Skill Statistik
        if not self.damageData[sourceName].skills[skillName] then
            self.damageData[sourceName].skills[skillName] = {
                damage = 0,
                hits = 0
            }
        end
        
        self.damageData[sourceName].skills[skillName].damage = self.damageData[sourceName].skills[skillName].damage + damageAmount
        self.damageData[sourceName].skills[skillName].hits = self.damageData[sourceName].skills[skillName].hits + 1
        
        self:UpdateUI()
    end
end

-- Healing Handler
function DamageMeter:OnHealingDone(args)
    if not self.enabled then return end
    
    local sourceId = args.SourceId
    local sourceName = args.SourceName
    local targetId = args.TargetId
    local targetName = args.TargetName
    local healingAmount = args.HealAmount
    local skillName = args.SkillName or "Unknown Heal"
    
    -- Ignoriere wenn keine Heilung
    if healingAmount <= 0 then return end
    
    local playerName = GetPlayerName()
    if sourceName == playerName then
        -- Start Session wenn nicht aktiv
        if self.sessionStartTime == 0 then
            self.sessionStartTime = GetTime()
            self:ResetData()
        end
        
        -- Speichere Healing
        if not self.healingData[sourceName] then
            self.healingData[sourceName] = {
                totalHealing = 0,
                skills = {},
                lastAction = GetTime(),
                targetHealed = targetName
            }
        end
        
        self.healingData[sourceName].totalHealing = self.healingData[sourceName].totalHealing + healingAmount
        self.healingData[sourceName].lastAction = GetTime()
        self.healingData[sourceName].targetHealed = targetName
        
        -- Speichere Skill Statistik
        if not self.healingData[sourceName].skills[skillName] then
            self.healingData[sourceName].skills[skillName] = {
                healing = 0,
                casts = 0
            }
        end
        
        self.healingData[sourceName].skills[skillName].healing = self.healingData[sourceName].skills[skillName].healing + healingAmount
        self.healingData[sourceName].skills[skillName].casts = self.healingData[sourceName].skills[skillName].casts + 1
        
        self:UpdateUI()
    end
end

-- Damage Received Handler (für Gruppen-Tracking)
function DamageMeter:OnDamageReceived(args)
    if not self.enabled then return end
    
    local sourceName = args.SourceName
    local damageAmount = args.DamageAmount
    
    if damageAmount <= 0 then return end
    
    -- Nur tracken wenn in Gruppe und nicht von mir selbst
    if self.trackingGroup and sourceName ~= GetPlayerName() then
        if not self.damageData[sourceName] then
            self.damageData[sourceName] = {
                totalDamage = 0,
                skills = {},
                lastAction = GetTime(),
                targetHit = args.TargetName
            }
        end
        
        self.damageData[sourceName].totalDamage = self.damageData[sourceName].totalDamage + damageAmount
        self.damageData[sourceName].lastAction = GetTime()
        
        self:UpdateUI()
    end
end

-- Gruppe beigetreten
function DamageMeter:OnGroupMemberAdded(args)
    self.trackingGroup = true
    self:DebugLog("Group tracking enabled")
end

-- Gruppe verlassen
function DamageMeter:OnGroupMemberRemoved(args)
    if GetGroupSize() <= 1 then
        self.trackingGroup = false
        self:DebugLog("Group tracking disabled")
    end
end

-- Kampf verlassen
function DamageMeter:OnLeaveCombat(args)
    self:DebugLog("Left combat - Session end")
    -- Session bleibt aktiv für Statistiken, wird nur manuell reset
end

-- Berechne DPS
function DamageMeter:CalculateDPS()
    local playerName = GetPlayerName()
    if not self.damageData[playerName] then
        return 0, 0
    end
    
    if self.sessionStartTime == 0 then
        return 0, 0
    end
    
    self.sessionDuration = GetTime() - self.sessionStartTime
    if self.sessionDuration < 1 then
        self.sessionDuration = 1
    end
    
    local dps = self.damageData[playerName].totalDamage / self.sessionDuration
    return dps, self.damageData[playerName].totalDamage
end

-- Berechne HPS
function DamageMeter:CalculateHPS()
    local playerName = GetPlayerName()
    if not self.healingData[playerName] then
        return 0, 0
    end
    
    if self.sessionStartTime == 0 then
        return 0, 0
    end
    
    self.sessionDuration = GetTime() - self.sessionStartTime
    if self.sessionDuration < 1 then
        self.sessionDuration = 1
    end
    
    local hps = self.healingData[playerName].totalHealing / self.sessionDuration
    return hps, self.healingData[playerName].totalHealing
end

-- Erstelle UI
function DamageMeter:CreateUI()
    self.ui.window = UI.GetElement("DamageMeter")
    if not self.ui.window then
        self:DebugLog("Failed to create UI window")
        return
    end
    
    self.ui.dpsLabel = self.ui.window:GetElement("StatsPanel/DPSLabel")
    self.ui.hpsLabel = self.ui.window:GetElement("StatsPanel/HPSLabel")
    self.ui.timeLabel = self.ui.window:GetElement("StatsPanel/TimeLabel")
    self.ui.playersList = self.ui.window:GetElement("StatsPanel/PlayersList")
    self.ui.resetButton = self.ui.window:GetElement("TitleBar/ResetButton")
    
    -- Reset Button Handler
    if self.ui.resetButton then
        self.ui.resetButton:SetClickHandler(function() DamageMeter:ResetData() end)
    end
end

-- Update UI Display
function DamageMeter:UpdateUI()
    if not self.ui.window or not self.ui.window:IsVisible() then
        return
    end
    
    local dps, totalDamage = self:CalculateDPS()
    local hps, totalHealing = self:CalculateHPS()
    
    -- Update DPS Label
    if self.ui.dpsLabel then
        self.ui.dpsLabel:SetText(string.format("DPS: %.1f | Total: %d", dps, totalDamage))
    end
    
    -- Update HPS Label
    if self.ui.hpsLabel then
        self.ui.hpsLabel:SetText(string.format("HPS: %.1f | Total: %d", hps, totalHealing))
    end
    
    -- Update Time Label
    if self.ui.timeLabel then
        self.ui.timeLabel:SetText(string.format("Duration: %ds", math.floor(self.sessionDuration)))
    end
    
    -- Update Players List
    if self.ui.playersList then
        self:UpdatePlayersList()
    end
end

-- Update Spielerliste für Gruppe
function DamageMeter:UpdatePlayersList()
    if not self.ui.playersList then return end
    
    -- Clear existing elements
    self.ui.playersList:RemoveAllChildren()
    
    local yPos = 0
    local rowHeight = 15
    
    -- Zeige Damage Dealer
    for playerName, data in pairs(self.damageData) do
        if data.totalDamage > 0 then
            local playerText = string.format("%s: %d DMG (%.1f DPS)", 
                playerName, 
                data.totalDamage,
                data.totalDamage / self.sessionDuration
            )
            
            local element = UI.CreateTextElement(playerText)
            element:SetLeft(5)
            element:SetTop(yPos)
            element:SetWidth(330)
            element:SetHeight(12)
            element:SetTextColor(0xFFFF6B6B)
            element:SetFontSize(9)
            
            self.ui.playersList:AddChild(element)
            yPos = yPos + rowHeight
        end
    end
    
    -- Zeige Healer
    for playerName, data in pairs(self.healingData) do
        if data.totalHealing > 0 then
            local playerText = string.format("%s: %d HEAL (%.1f HPS)", 
                playerName, 
                data.totalHealing,
                data.totalHealing / self.sessionDuration
            )
            
            local element = UI.CreateTextElement(playerText)
            element:SetLeft(5)
            element:SetTop(yPos)
            element:SetWidth(330)
            element:SetHeight(12)
            element:SetTextColor(0xFF6BFF6B)
            element:SetFontSize(9)
            
            self.ui.playersList:AddChild(element)
            yPos = yPos + rowHeight
        end
    end
end

-- Reset Daten
function DamageMeter:ResetData()
    self.damageData = {}
    self.healingData = {}
    self.sessionStartTime = 0
    self.sessionDuration = 0
    self:UpdateUI()
    self:DebugLog("Data reset")
end

-- Toggle UI Sichtbarkeit
function DamageMeter:ToggleUI()
    if self.ui.window then
        local visible = self.ui.window:IsVisible()
        self.ui.window:SetVisible(not visible)
    end
end

-- Debug Log
function DamageMeter:DebugLog(message)
    if self.enabled then
        print("[DamageMeter] " .. message)
    end
end

-- Export für Commands
_G.DamageMeter = DamageMeter

-- Auto Initialize
if not DamageMeterInitialized then
    DamageMeter:Initialize()
    DamageMeterInitialized = true
end
