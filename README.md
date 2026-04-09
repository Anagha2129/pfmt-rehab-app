# PFMT Rehab App

A Flutter-based mobile application for pelvic floor muscle training (PFMT) with real-time voice feedback and adaptive exercise control.

##  Features

-  Guided exercise timer (contract, hold, relax)
-  Voice input using speech recognition
-  Smart parsing of user input (e.g., "completed 10 reps")
-  Adaptive exercise control based on user feedback
-  Rep and set tracking

##  How It Works

The app follows a structured PFMT protocol:

- 10 reps per set
- 3 sets per session
- Phases:
  - Contract (1s)
  - Hold (8s)
  - Relax (6s)
  - Rest between sets

Voice input allows users to:
- Say "done" → skip phase
- Say "too hard" → adjust reps
- Say "completed X reps" → update progress
- Say "stop" → end session

##  Tech Stack

- Flutter (Dart)
- Provider (state management)
- speech_to_text (voice input)
- Firebase (planned)


##  App Interface 
Voice-enabled PFMT rehabilitation app that guides users through structured pelvic floor exercises and adapts sessions in real time based on spoken feedback (e.g., “too hard” or “completed 8 reps”).

link for full working demonstration of app: 

https://github.com/user-attachments/assets/9318ab10-7176-4c93-a4ac-960162eb065a


##  Getting Started

```bash
flutter pub get
flutter run
