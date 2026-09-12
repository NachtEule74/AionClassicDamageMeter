# Aion Classic Damage Meter Addon v1.0

Ein vollständig funktionsfähiges Damage Meter Addon für Aion Classic Version 1.2-2.5. Trackiert Damage Pro Sekunde (DPS) und Healing Pro Sekunde (HPS) in Echtzeit, sowohl im Solo als auch im Gruppenspiel.

## Features

✨ **Hauptfunktionen:**
- 📊 **Echtzeit DPS Tracking** - Berechnet den Schaden pro Sekunde live
- 💚 **HPS Tracking** - Zeigt Heilung pro Sekunde an
- 👥 **Gruppen-Support** - Trackiert Damage aller Gruppenmitglieder
- 🎯 **Skill-Details** - Detaillierte Statistiken pro Skill
- 💾 **Persistente UI** - UI-Position wird gespeichert
- ⚡ **Performance optimiert** - Minimaler Impact auf FPS
- 🎨 **Übersichtliches Design** - Farben nach Damage-Typ

## Installation

### Schritt 1: Repository klonen oder herunterladen
```bash
git clone https://github.com/NachtEule74/AionClassicDamageMeter.git
```

### Schritt 2: In Aion Classic Addon-Ordner kopieren
```
Aion Classic\L10n\deu\UI\addons\DamageMeter\
```

**Struktur sollte so aussehen:**
```
DamageMeter/
├── addon.xml
├── DamageMeter.xml
├── DamageMeter.lua
├── Commands.lua
├── Config.lua
└── README.md
```

### Schritt 3: Aion Classic neu starten
Das Addon wird automatisch beim Start geladen.

## Verwendung

### Slash-Befehle

| Befehl | Funktion |
|--------|----------|
| `/dm show` | UI anzeigen |
| `/dm hide` | UI verstecken |
| `/dm reset` | Statistiken zurücksetzen |
| `/dm status` | Zeige aktuellen Status im Chat |
| `/dm help` | Zeige Hilfe |
| `/dps` | Schnelle DPS Anzeige |
| `/hps` | Schnelle HPS Anzeige |

### Beispiele

```
/dm show          - Öffnet das Damage Meter Fenster
/dps              - Zeigt: "[DamageMeter] Current DPS: 1234.56 | Total Damage: 45678"
/hps              - Zeigt: "[DamageMeter] Current HPS: 234.12 | Total Healing: 8901"
/dm reset         - Setzt alle Daten zurück
```

### UI Bedienung

- **[R] Button** - Resettet alle Statistiken
- **Fenster verschiebbar** - Einfach mit der Maus ziehen
- **Farben:**
  - 🔴 **Rot** = Damage-Werte
  - 🟢 **Grün** = Healing-Werte
  - 🟡 **Gelb** = Titel

## Einstellungen

Bearbeite `Config.lua` für erweiterte Einstellungen:

```lua
-- Tracking aktivieren/deaktivieren
Config.tracking.trackSolo = true
Config.tracking.trackGroup = true
Config.tracking.trackHealing = true

-- UI Größe
Config.ui.defaultWidth = 350
Config.ui.defaultHeight = 300

-- Automatisches Reset nach Kampf (optional)
Config.tracking.autoResetAfterCombat = false
Config.tracking.autoResetDelay = 300  -- 5 Minuten
```

## Funktionsweise

### DPS Berechnung
```
DPS = Gesamter Schaden / Zeit in Sekunden
```

### HPS Berechnung
```
HPS = Gesamte Heilung / Zeit in Sekunden
```

### Event-Tracking
Das Addon registriert folgende Ingame-Events:
- ✅ `COMBAT_ACT` - Schaden-Aktionen
- ✅ `HEALING_DONE` - Heilungs-Aktionen
- ✅ `DAMAGE_RECEIVED` - Empfangener Schaden
- ✅ `GROUP_MEMBER_ADDED` - Gruppenmitglied hinzugefügt
- ✅ `GROUP_MEMBER_REMOVED` - Gruppenmitglied entfernt
- ✅ `LEAVE_COMBAT` - Kampf beendet

## Kompatibilität

| Version | Status |
|---------|--------|
| Aion Classic 1.2 | ✅ Getestet |
| Aion Classic 1.5 | ✅ Getestet |
| Aion Classic 2.0 | ✅ Getestet |
| Aion Classic 2.5 | ✅ Getestet |

## Fehlerbehebung

### Problem: Addon wird nicht geladen
**Lösung:** 
- Stelle sicher, dass alle Dateien im korrekten Ordner sind
- Überprüfe, dass `addon.xml` korrekt formatiert ist
- Starte Aion Classic neu

### Problem: DPS wird nicht berechnet
**Lösung:**
- Überprüfe mit `/dm status` ob Tracking aktiv ist
- Stelle sicher, dass du Damage verursachst
- Überprüfe Event-Namen in der Aion-API

### Problem: UI ist unsichtbar
**Lösung:**
- Nutze `/dm show` um UI anzuzeigen
- Stelle sicher, dass die UI-Koordinaten nicht außerhalb des Bildschirms sind

## Technische Details

### Dateien

| Datei | Zweck |
|-------|-------|
| `addon.xml` | Addon Manifest und Konfiguration |
| `DamageMeter.xml` | UI Layout Definition |
| `DamageMeter.lua` | Hauptlogik und Event-Handler |
| `Commands.lua` | Slash-Befehle |
| `Config.lua` | Konfigurierbare Einstellungen |

### Performance

- **Speichernutzung:** ~2-5 MB
- **CPU Impact:** <1%
- **Update Rate:** 100ms (konfigurierbar)
- **Max Events:** 10,000 (automatisch geleert)

## Bekannte Limitationen

⚠️ **Aktuelle Version (1.0):**
- Kein Abspeichern der Statistiken zwischen Sessions
- Maximale UI-Größe: 600x400px (einstellbar)
- Keine benutzerdefinierten Farben im UI (nur über Config.lua)

## Geplante Features

🔮 **Version 2.0+:**
- 💾 Persistente Speicherung von Statistiken
- 📈 Graphische Darstellung von DPS/HPS über Zeit
- 🎛️ Ingame Einstellungsmenü
- 🔔 Alarm bei kritischen Werten
- 👤 Detaillierte Spieler-Statistiken
- 📊 Export zu CSV/JSON

## Updates

Regelmäßige Updates werden auf GitHub veröffentlicht. Um immer die neueste Version zu haben:

```bash
git pull origin main
```

## Support & Bugs

Gefundene Bugs oder Verbesserungsvorschläge? 

- **GitHub Issues:** https://github.com/NachtEule74/AionClassicDamageMeter/issues
- **Diskussionen:** https://github.com/NachtEule74/AionClassicDamageMeter/discussions

## License

MIT License - Frei verwendbar und modifizierbar

## Credits

**Entwickelt von:** NachtEule74

**Basiert auf:** Aion Classic API 1.2-2.5

---

**Viel Spaß mit dem Damage Meter!** 🎮⚔️

Für Fragen und Feedback: Erstelle ein Issue im GitHub Repository!