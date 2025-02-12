# BEN_test_project
test project

[![CI](https://github.com/virtuoussong/BEN_test_project/actions/workflows/swift-test.yml/badge.svg)](https://github.com/virtuoussong/BEN_test_project/actions/workflows/swift-test.yml)

Ben_test is a SwiftUI-based word game app that integrates speech recognition and speech synthesis to capture, animate, and speak words. The app displays words in sections, animates them from left to right, and uses speech input to capture words. The project is designed using clean architecture principles and is highly testable.

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
- The code follows clean architecture and SOLID principles to maximize testability and maintainability.

## Architecture & Design

The project is organized into several layers:

- **Presentation Layer (Views):** Contains SwiftUI views such as `WordGameView`, `WordListView`, and various subviews.
- **ViewModel Layer:** `WordGameViewModel` coordinates animations, speech recognition, and synthesis. It manages state and interacts with the services.
- **Service Layer:**
  - **Speech Recognizer:** `SpeechRecognizer` implements the `SpeechRecognizing` protocol (and is an `ObservableObject`) using Apple’s Speech framework.
  - **Speech Synthesizer:** `WordSynthesizer` implements the `WordSynthesizing` protocol to speak text via AVSpeechSynthesizer.
- **Domain Layer:** The `Word` model encapsulates properties such as text, animation duration, and state flags (e.g., isAnimating, isTapped).

### Component Diagram

Below is a Mermaid diagram illustrating how the key components interact:

```mermaid
graph TD
    A[WordGameView]
    B[WordListView]
    C[WordGameViewModel]
    D[SpeechRecognizer (SpeechRecognizing)]
    E[WordSynthesizer (WordSynthesizing)]
    F[Word Model]
    
    A --> B
    B --> C
    C --> D
    C --> E
    C --> F
    D -- Publishes recognized word --> C
    C -- Calls "speak" --> E
    C -- Updates state & animations --> F


