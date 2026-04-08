import 'dart:async';
import 'package:flutter/material.dart';

enum ExercisePhase { rest, contract, hold, relax }

class ExerciseService extends ChangeNotifier {
  Timer? _timer;

  ExercisePhase _phase = ExercisePhase.rest;
  int _secondsRemaining = 5;

  int _currentRep = 0;
  int _currentSet = 0;

  final int repsPerSet = 10;
  final int sets = 3;

  bool _isRunning = false;

  // Getters
  ExercisePhase get phase => _phase;
  int get secondsRemaining => _secondsRemaining;
  int get currentRep => _currentRep;
  int get currentSet => _currentSet;
  bool get isRunning => _isRunning;

  // 🚀 START EXERCISE
  void startExercise() {
    _timer?.cancel();

    _currentRep = 0;
    _currentSet = 1;
    _isRunning = true;

    _startPhase(ExercisePhase.contract);
  }

  // 🔄 PHASE HANDLER
  void _startPhase(ExercisePhase newPhase) {
    _phase = newPhase;

    switch (newPhase) {
      case ExercisePhase.contract:
        _secondsRemaining = 1;
        break;
      case ExercisePhase.hold:
        _secondsRemaining = 8;
        break;
      case ExercisePhase.relax:
        _secondsRemaining = 6;
        break;
      case ExercisePhase.rest:
        _secondsRemaining = 10;
        break;
    }

    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;

      if (_secondsRemaining <= 0) {
        _nextPhase();
      }

      notifyListeners();
    });
  }

  // 🔁 STATE MACHINE LOGIC
  void _nextPhase() {
    if (!_isRunning) return;

    switch (_phase) {
      case ExercisePhase.contract:
        _startPhase(ExercisePhase.hold);
        break;

      case ExercisePhase.hold:
        _startPhase(ExercisePhase.relax);
        break;

      case ExercisePhase.relax:
        _currentRep++;

        if (_currentRep >= repsPerSet) {
          if (_currentSet >= sets) {
            stopExercise();
          } else {
            _currentRep = 0;
            _currentSet++;
            _startPhase(ExercisePhase.rest);
          }
        } else {
          _startPhase(ExercisePhase.contract);
        }
        break;

      case ExercisePhase.rest:
        _startPhase(ExercisePhase.contract);
        break;
    }
  }

  // 🛑 STOP
  void stopExercise() {
    _timer?.cancel();
    _isRunning = false;
    _phase = ExercisePhase.rest;
    _secondsRemaining = 5;
    notifyListeners();
  }

  // =========================
  // 🎤 VOICE CONTROL METHODS
  // =========================

  // Skip current phase
  void completeEarly() {
    if (_isRunning) {
      _nextPhase();
    }
  }

  // User says "too hard"
  void markTooHard() {
    if (_currentRep > 0) {
      _currentRep = (_currentRep - 1).clamp(0, repsPerSet);
      notifyListeners();
    }
  }

  // User says "completed X reps"
  void updateRepsFromVoice(int reps) {
    if (reps >= 0 && reps <= repsPerSet) {
      _currentRep = reps;
      notifyListeners();
    }
  }

  // User says "stop"
  void stopFromVoice() {
    stopExercise();
  }
}