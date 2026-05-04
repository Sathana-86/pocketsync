# NoteSync - Offline-First Notes App with Sync Queue

A Flutter application demonstrating offline-first architecture with reliable sync queue, idempotent retries, and last-write-wins conflict resolution.

## Features

- ✅ **Local-first UX**: Notes load instantly from Hive cache
- ✅ **Offline writes**: Create, edit, like, and delete notes without internet
- ✅ **Sync Queue**: Actions queued and synced when online
- ✅ **Idempotency**: Unique keys prevent duplicate operations on retry
- ✅ **Last-Write-Wins**: Timestamp-based conflict resolution
- ✅ **Retry with backoff**: Exponential backoff (2s, 4s, 6s) up to 3 attempts
- ✅ **Observability**: Real-time logs and counters in Sync Queue screen
- ✅ **Dark/Light mode**: Full theme support with consistent accent color
- ✅ **Firebase Auth**: Email/password authentication
- ✅ **Edit & Delete**: Full CRUD operations with offline support

## Tech Stack

| Technology | Purpose |
|------------|---------|
| Flutter | UI Framework |
| Riverpod | State Management |
| Hive | Local Persistence |
| Firebase Auth | User Authentication |
| Firebase Realtime DB | Cloud Sync |
| Connectivity Plus | Network Detection |

## Architecture
┌─────────────────────────────────────────────────────────┐
│ UI Layer │
│ HomeScreen | AddNoteScreen | SyncQueueScreen │
└─────────────────────┬───────────────────────────────────┘
│ Riverpod
┌─────────────────────▼───────────────────────────────────┐
│ State Management │
│ NotesNotifier | SyncQueueNotifier │
└─────────────────────┬───────────────────────────────────┘
│
┌─────────────────────▼───────────────────────────────────┐
│ Repository Layer │
│ NoteRepository (Hive + Firebase Realtime DB) │
└─────────────────────┬───────────────────────────────────┘
│
┌────────────┼────────────┐
▼ ▼ ▼
┌─────────────┐ ┌───────────┐ ┌──────────────┐
│ Hive (Local)│ │ Firebase │ │ Sync Queue │
│ - Notes │ │ Auth │ │ - Actions │
│ - Queue │ │ RTDB │ │ - Retries │
└─────────────┘ └───────────┘ └──────────────┘


## Project Structure
lib/
├── core/
│ ├── models/
│ │ ├── note.dart
│ │ ├── sync_action.dart
│ │ ├── note_adapter.dart
│ │ └── sync_action_adapter.dart
│ ├── providers/
│ │ └── providers.dart
│ ├── repositories/
│ │ └── note_repository.dart
│ ├── services/
│ │ └── sync_service.dart
│ └── theme/
│ └── app_theme.dart
├── presentation/
│ └── screens/
│ ├── signin_screen.dart
│ ├── signup_screen.dart
│ ├── home_screen.dart
│ ├── add_note_screen.dart
│ ├── edit_note_screen.dart
│ ├── sync_queue_screen.dart
│ └── profile_screen.dart
├── firebase_options.dart
└── main.dart

## Setup Instructions

### Prerequisites
- Flutter SDK (>=3.0.0)
- Firebase account
- Android Studio / VS Code