# JP-Energize
Add alternativ Energy System

Willkommen zu meinem neuen Projekt in IOS/SwiftUI JP Energize



JP Energize wird eine coole App, die es Leuten ermöglicht, ihre Solarenergie optimal zu nutzen, zu speichern und sogar mit der Community zu teilen. Sie ist perfekt für alle, die ihren eigenen Strom produzieren und Teil einer smarten Energie-Zukunft sein wollen!


## Design

<p>


 <img src="screenVorschau.jpg" alt="Bild 1" width="600" height="300">
</p>



Features


Intelligentes Energiemanagement: 
Automatische Steuerung deiner Solaranlage und deines Batteriespeichers.

Peer-to-Peer Energiehandel: Teile oder handel deine überschüssige Energie mit deinen Nachbarn.

Gemeinsame Batteriespeicher: Investiere zusammen mit anderen in größere Speicher und nutzt sie gemeinsam.

Notfallreserven: Teile Energie für den Notfall, damit alle sicher durch den Stromausfall kommen.

Energiebilanz: Behalte den Überblick über deine Einsparungen und deinen Beitrag zur Umwelt.


Technologien

Xcode und SwiftUI: 
Ich baue die App in SwiftUI.

MVVM-Architektur: Für sauberen und gut strukturierten Code.

API-Anbindung: Damit die App mit Solar- und Batteriesystemen und dem Marktplatz reden kann.

Firebase: Für die einfache Handhabung von User-Daten, Authentifizierung und Echtzeit-Datenbanken.
Setup



1. Xcode Projekt erstellen:

Projekt anlegen.

2. MVVM-Architektur einrichten:
Models:  Swift-Dateien für alle Datenmodelle (z.B. User, EnergyData).

Views: UI in SwiftUI, ich werde darauf achten, den Code schlank zu halten.

ViewModels: Hier kommt die Logik rein, die zwischen den Views und Modellen vermittelt.

3. API-Anbindung:
Ich verwende PVWatts V8, um Daten von Photovoltaik zu erhalten
und Echtzeit Synchronisierung zu ermöglichen.

4. Firebase einbinden:
Ich erstelle in Firebase ein neues Projekt.
In Xcode, Firebase SDK hinzufügen (über Swift Package Manager oder CocoaPods).
Firebase Auth: Einfache Anmeldung und Registrierung.
Firebase Firestore: Zum Speichern von User-Daten und Energie-Transaktionen.
Firebase Realtime Database: Für die Echtzeit-Aktualisierung der Energie-Daten.

5. UI bauen:
Dashboard: Zeigt den Energieverbrauch und -produktion an.
Marketplace: Hier können Nutzer Energie handeln.
Settings: Für die Konfiguration der Speicheroptionen und Notfallreserven.
3 Screens CHECK

6. Testen:
JP Energize App auf verschiedenen Geräten (iPhone, iPad) in der Xcode-Simulation.
Ich teste die API-Calls und Firebase-Verbindungen mit Mock-Daten.






