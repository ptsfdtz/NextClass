# Timetable App (Flutter)

A local-first timetable app for students. Android + iOS only. Designed to be visually polished with subtle animations.

**Product Goals**
- Local-first storage (no login/sync for MVP)
- Fast weekly view of classes
- Easy course editing
- Clean, good-looking UI with motion

**Scope (MVP)**
- Weekly timetable view
- Course add/edit/delete
- Period time settings (1..N periods per day)
- Semester settings (start/end date, week start day)
- Reminder settings (placeholder UI for now)

**Out of Scope (Later)**
- Cloud sync and accounts
- Complex rules: odd/even weeks, holiday exceptions
- Conflict detection
- Multi-semester archive

**Screens**
1. Home (Weekly Timetable)
2. Course Edit (Bottom Sheet or Full Screen)
3. Course List (All courses)
4. Periods (Edit class time slots)
5. Settings

**Core Flows**
1. Open app -> weekly timetable
2. Tap empty slot -> create course
3. Tap course card -> edit or delete
4. Settings -> adjust semester dates and periods

**Data Models**
**Course**
- id
- name
- teacher
- location
- weekday (1-7)
- startPeriod
- endPeriod
- weekStart
- weekEnd
- colorHex
- note
- reminderEnabled
- reminderMinutes

**Period**
- index
- startTime (HH:mm)
- endTime (HH:mm)

**Semester**
- startDate
- endDate
- weekStartDay (Mon or Sun)

**Architecture**
- Feature-based structure
- Repository layer (local storage)
- State management with a simple provider (TBD)

**Suggested Folder Structure**
```
lib/
  app/
    app.dart
    routes.dart
    theme.dart
  data/
    models/
    repositories/
    local/
  features/
    timetable/
    courses/
    settings/
  widgets/
  utils/
```

**UI Direction**
- Strong visual hierarchy
- Card-based timetable blocks
- Smooth page transitions and subtle entry animations
- Warm gradient or textured background (no flat white)

**Roadmap**
1. Build UI shell and navigation
2. Implement timetable rendering with dummy data
3. Add course CRUD forms
4. Add local storage persistence
5. Hook up reminders
6. Polish animations

**Decisions**
- Local-only data for MVP
- Android + iOS only
- Keep complex scheduling rules for later
