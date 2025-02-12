# BEN_test_project
test project

[![CI](https://github.com/virtuoussong/BEN_test_project/actions/workflows/swift-test.yml/badge.svg)](https://github.com/virtuoussong/BEN_test_project/actions/workflows/swift-test.yml)

Ben_test is a SwiftUI-based word game app that integrates speech recognition and speech synthesis to capture, animate, and speak words. The app displays words in sections, animates them from left to right, and uses speech input to capture words. The project is designed using clean architecture and SOLID principles to ensure that it is modular, testable, and maintainable.

## Table of Contents

- [Overview](#overview)
- [Architecture & Design](#architecture--design)
  - [Component Diagram](#component-diagram)
- [Main Components](#main-components)
  - [WordGameViewModel](#wordgameviewmodel)
  - [SpeechRecognizer](#speechrecognizer)
  - [WordSynthesizer](#wordsynthesizer)
  - [Views](#views)
- [How It Works](#how-it-works)
- [Unit Testing](#unit-testing)
- [Setup & Requirements](#setup--requirements)
- [License](#license)

## Overview

Ben_test is an interactive word game where:

- **Words** are organized in sections and displayed on screen.
- **Animation:** Words animate from left to right.
- **Speech Recognition:** The app listens for spoken words and, if the spoken word matches one in the active word list, it captures that word.
- **Speech Synthesis:** When a word is captured (via speech or tap), the app speaks the word using AVFoundation’s speech synthesizer.

## Architecture & Design

The project is organized into several layers:

- **Presentation Layer (Views):** Contains SwiftUI views such as `WordGameView`, `WordListView`, and various subviews.
- **ViewModel Layer:** The `WordGameViewModel` coordinates animations, speech recognition, and speech synthesis. It manages the app state and bridges the UI with the service layer.
- **Service Layer:**
  - **Speech Recognizer:** The `SpeechRecognizer` implements the `SpeechRecognizing` protocol (which extends `ObservableObject`) using Apple’s Speech framework.
  - **Speech Synthesizer:** The `WordSynthesizer` implements the `WordSynthesizing` protocol to speak text via AVSpeechSynthesizer.
- **Domain Layer:** The `Word` model encapsulates properties such as text, animation duration, and state flags (e.g., isAnimating, isTapped).

### Component Diagram

Below is a Mermaid diagram illustrating the interactions between the key components:

```mermaid
graph TD;
    A[WordGameView] --> B[WordListView]
    B[WordListView] --> C[WordGameViewModel]
    C[WordGameViewModel] --> D[SpeechRecognizer (SpeechRecognizing)]
    C[WordGameViewModel] --> E[WordSynthesizer (WordSynthesizing)]
    C[WordGameViewModel] --> F[Word Model]
    D[SpeechRecognizer (SpeechRecognizing)] -- Publishes recognized word --> C[WordGameViewModel]
    C[WordGameViewModel] -- Calls "speak" --> E[WordSynthesizer (WordSynthesizing)]
    C[WordGameViewModel] -- Updates state & animations --> F[Word Model]
```

## Main Components

### WordGameViewModel

- **Responsibilities:**
  - Manages arrays of words (active, finished, captured).
  - Coordinates animations (starting, updating, scheduling, and completing).
  - Captures words based on speech recognition or tap events.
  - Bridges interactions between the UI and the speech services.
- **Key Methods:**
  - `startAnimation()`: Initiates animations across sections.
  - `animateNextWord(in:)`: Animates the next available word in a section.
  - `captureWord(for:)`: Captures a recognized word.
  - `speakWord(_:)`: Uses the synthesizer to speak the word while controlling the listening state.
  - `bindSpeechListener()`: Subscribes to the speech recognizer’s publisher to receive recognized words.

### SpeechRecognizer

- **Responsibilities:**
  - Requests microphone and speech recognition permissions.
  - Configures and starts an AVAudioEngine with an audio tap.
  - Uses SFSpeechRecognizer to convert audio to text.
- **Key Points:**
  - Conforms to the `SpeechRecognizing` protocol and `ObservableObject`.
  - Exposes a `@Published var word` and a `wordPublisher` for external binding.
  - Stops listening on errors or when recognition is complete.

### WordSynthesizer

- **Responsibilities:**
  - Uses AVSpeechSynthesizer to speak given text.
  - Notifies when speaking is finished via a delegate callback.
- **Key Points:**
  - Caches a default voice and creates new utterances for each speak call.
  - Implements `AVSpeechSynthesizerDelegate` to trigger finish callbacks.

### Views

- **WordGameView:** The main view that sets up the environment and assembles subviews.
- **WordListView & WordScapeCapuredListView:** Display active words, finished words, and captured words.
- **WordButtonView:** Displays individual words with animations and handles tap events.

## How It Works

1. **Animation Flow:**
   - The view model starts animations for each section.
   - Each word animates from left to right.
   - When a word finishes animating or is tapped, it is marked as hidden and moved to the finished or captured list.
2. **Speech Integration:**
   - The `SpeechRecognizer` listens for spoken words and publishes them.
   - The view model binds to this publisher and captures recognized words that match an active word.
   - When a word is captured, the view model calls `speakWord(_:)` to speak it using the `WordSynthesizer`.
3. **State Updates:**
   - Updates to published properties (`words`, `finishedWords`, `capturedWords`) trigger SwiftUI to update the UI.

## Unit Testing

The project is designed to be testable by using dependency injection:

- **Dependency Injection:**  
  The view model receives its speech synthesizer and speech recognizer via its initializer, allowing you to inject mock implementations in unit tests.
- **Combine Publishers:**  
  The use of `@Published` properties and the exposed `wordPublisher` make it easy to test asynchronous updates.
- **SOLID Principles:**  
  Each component has a single responsibility, enabling isolated testing.

## Setup & Requirements

- **Xcode 14 or later**
- **iOS 16+**
- **Info.plist Permissions:**  
  Ensure your Info.plist includes:
  - `NSMicrophoneUsageDescription`
  - `NSSpeechRecognitionUsageDescription`

## License

This project is licensed under the MIT License.

