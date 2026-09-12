-- DamageMeter Configuration
-- Aion Classic 1.2-2.5 Addon Configuration

local Config = {}

-- Addon Settings
Config.addon = {
    name = "DamageMeter",
    version = "1.0",
    author = "NachtEule74",
    description = "Real-time DPS and HPS tracking for Aion Classic",
    minVersion = "1.2",
    maxVersion = "2.5"
}

-- UI Settings
Config.ui = {
    defaultWidth = 350,
    defaultHeight = 300,
    defaultX = 100,
    defaultY = 100,
    backgroundColor = 0x00000000,
    borderColor = 0xFF808080,
    borderWidth = 1,
    movable = true,
    resizable = false,
    locked = false
}

-- Farben für verschiedene Damage-Typen
Config.colors = {
    dps = 0xFFFF6B6B,      -- Rot für Damage
    hps = 0xFF6BFF6B,      -- Grün für Healing
    title = 0xFFFFFF00,    -- Gelb für Titel
    border = 0xFF404040,   -- Grau für Border
    text = 0xFFFFFFFF      -- Weiß für normalen Text
}

-- Tracking Settings
Config.tracking = {
    trackSolo = true,                    -- Track Solo Damage
    trackGroup = true,                   -- Track Gruppe Damage
    trackHealing = true,                 -- Track Healing
    minDamageThreshold = 0,              -- Minimaler Damage zum Tracking
    updateInterval = 0.1,                -- Update Intervall in Sekunden
    autoResetAfterCombat = false,        -- Auto Reset nach Kampf
    autoResetDelay = 300                 -- Delay in Sekunden (5 Minuten)
}

-- Skill Tracking (spezielle Skills)
Config.skillTracking = {
    enableDetailedSkills = true,         -- Zeige Detail pro Skill
    maxSkillsDisplayed = 10,             -- Max Skills in UI
    trackCriticals = true,               -- Track kritische Treffer
    trackResists = true                  -- Track Resists/Misses
}

-- Logging Settings
Config.logging = {
    enableLogging = true,                -- Enable Debug Logging
    logDamage = false,                   -- Log jeden Damage Event
    logHealing = false,                  -- Log jeden Healing Event
    logFile = "DamageMeter.log"          -- Log Dateiname
}

-- Hotkeys
Config.hotkeys = {
    toggleUI = "ALT+D",                  -- Toggle UI
    resetStats = "ALT+R",                -- Reset Statistiken
    showDetails = "ALT+S"                -- Show Details
}

-- Stat Display Format
Config.format = {
    dpsFormat = "%.1f",                  -- DPS Format (1 Dezimal)
    hpsFormat = "%.1f",                  -- HPS Format (1 Dezimal)
    damageFormat = "%d",                 -- Total Damage Format
    timeFormat = "%d",                   -- Zeit Format (Sekunden)
    showThousandSeparator = true         -- Zeige Tausender-Trennzeichen
}

-- Particle und visuelle Effekte
Config.effects = {
    enableDamageNumbers = true,          -- Zeige Damage-Zahlen im UI
    enableHealingNumbers = true,         -- Zeige Healing-Zahlen im UI
    damageColor = 0xFFFF0000,            -- Rot
    healingColor = 0xFF00FF00,           -- Grün
    criticalColor = 0xFFFFFF00           -- Gelb
}

-- Combat Detection
Config.combat = {
    autoStartOnCombat = true,            -- Start Session bei Kampf
    autoStopOnCombat = false,            -- Stop Session beim Kampf verlassen
    trackPvP = true,                     -- Track PvP Kämpfe
    trackPvE = true,                     -- Track PvE Kämpfe
    minCombatDuration = 5                -- Min Kampfdauer in Sekunden
}

-- Group Detection
Config.group = {
    autoDetectGroup = true,              -- Auto-Erkennung Gruppe
    trackGroupDamage = true,             -- Track Gruppen-Damage
    groupUpdateInterval = 0.5,           -- Update Intervall Gruppe (Sekunden)
    maxGroupMembers = 12                 -- Max Gruppen-Mitglieder
}

-- Performance Settings
Config.performance = {
    enablePerformanceMode = false,       -- Leichte Performance Mode
    updateFrequency = 0.1,               -- UI Update Häufigkeit
    maxStoredEvents = 10000,             -- Max Events im Speicher
    enableGarbageCollection = true       -- Enable Garbage Collection
}

-- Export
_G.DamageMeterConfig = Config

return Config
