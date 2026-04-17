# 🧠 STAMPZY – FULL PRODUCT CONTEXT

---

## 1. 🌍 Overview

Stampzy is a **social storytelling platform** where users capture real-life moments as **collectible stamps**.

Each stamp is not just an image, but a **story-driven artifact** that represents:

* a memory
* a place
* an emotion
* a personal narrative

---

## 2. 🎯 Core Philosophy

> “Capture your world, one story at a time.”

* Not about showing off photos
* Not about vanity metrics
* About **preserving meaningful memories**

---

## 3. 🧩 Core Entities

### 🔹 Stamp (Core Unit)

Each stamp represents a real-world moment.

```yaml
Stamp:
  id: string
  owner_id: string
  image_url: string
  location:
    name: string
    lat: number
    lng: number
  timestamp: datetime
  story:
    raw: string
    ai_enhanced: string
    summary: string
  emotion_tag: string
  rarity: enum(Common, Rare, Epic, Legendary)
  metadata:
    weather: string
    companions: string[]
    activity: string
  social:
    likes: number
    saves: number
    comments: number
```

---

### 🔹 Collection (User-curated sets)

```yaml
Collection:
  id: string
  owner_id: string
  title: string
  description: string
  theme: string
  stamps: Stamp[]
  cover_image: string
```

👉 Represents a **chapter of life**

---

### 🔹 User

```yaml
User:
  id: string
  name: string
  avatar: string
  bio: string
  followers: number
  following: number
  stats:
    total_stamps: number
    countries: number
    collections: number
  level: enum(Explorer, Traveler, Collector, Legend)
```

---

## 4. 🌐 Social Layer

### 🔹 Social Actions

Users can:

* ❤️ Like a stamp (emotional reaction)
* 📌 Save a stamp (collect it)
* 💬 Comment (engage with story)
* 🔁 Share (spread discovery)

---

### 🔹 Feed Types

#### Explore Feed

* Trending stamps
* Nearby stamps
* AI-recommended stamps

#### Following Feed

* From users you follow

#### Collection Feed

* Curated collections from community

---

### 🔹 Follow System

Users can:

* Follow users
* Follow collections

---

## 5. 🧠 Narrative Layer (Most Important)

Each stamp must include a **story**.

Story structure:

```yaml
Story:
  raw_input: string
  ai_enhanced: string
  mood: string
  summary: string
```

Example:

> “Watching the sunset at Eiffel Tower, I realized how far I’ve come.”

👉 This transforms:

* image → memory
* app → personal archive

---

## 6. 🎮 Gamification

### 🔹 Rarity System

```yaml
Rarity:
  Common
  Rare
  Epic
  Legendary
```

Based on:

* uniqueness of location
* story depth
* special conditions

---

### 🔹 Levels

```yaml
Levels:
  Explorer
  Traveler
  Collector
  Legend
```

---

### 🔹 Achievements

* First 10 stamps
* 5 countries visited
* First viral stamp

---

## 7. 🔄 Viral Loop

1. User A posts a stamp
2. User B sees → likes → saves
3. User B creates a collection
4. User C discovers collection
5. User C joins platform

👉 Key mechanic:
**Stamps are collectible, not just consumable**

---

## 8. 🤖 AI Integration

### AI Responsibilities:

* Generate story from image + metadata
* Enhance user-written stories
* Tag emotions
* Suggest hashtags
* Rank feed (discovery engine)

---

### Example AI Prompt Context

```
Stampzy is a storytelling-based social platform.

Each stamp represents a meaningful moment with:
- image
- location
- story
- emotional context

Prioritize emotional depth and narrative quality over visual aesthetics.

Help users:
- write meaningful stories
- organize stamps
- discover relevant content
```

---

## 9. 🌍 Community Layer

### 🔹 Hashtags

* #ParisSunset
* #HiddenGem
* #SoloTrip

---

### 🔹 Location-based discovery

* Explore stamps by city / country
* Discover nearby stamps

---

### 🔹 Challenges

* “Capture something blue”
* “Hidden places week”

---

## 10. 📱 Core User Flows

### 🧭 New User

1. Open app
2. Explore feed
3. Read stories
4. Save stamps
5. Follow users

---

### 📸 Create Stamp

1. Capture image
2. Add location
3. AI suggests story
4. User edits
5. Publish

---

### 📌 Collecting

1. See a stamp
2. Save to collection
3. Organize personal archive

---

## 11. 🧠 UX Principles

* Story-first design
* Emotional connection > engagement metrics
* Stamp feels like a “real object”
* Collections feel like “memory albums”

---

## 12. 🚀 Product Positioning

Stampzy combines:

* Instagram (visual)
* Pinterest (collection)
* Diary (storytelling)
* Pokémon (collectible system)

---

## 13. 🔥 Final Insight

> If Stampzy fails → it becomes a photo gallery
> If Stampzy succeeds → it becomes a **memory ecosystem**

---

## 14. 📌 One-line Definition

Stampzy is a social platform where people capture, share, and collect meaningful life moments as story-driven stamps.
