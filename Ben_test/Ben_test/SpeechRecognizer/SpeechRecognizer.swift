//
//  SpeechRecognizer.swift
//  Ben_test
//
//  Created by Chiman Song on 2/11/25.
//

import Foundation
import Speech

protocol SpeechRecognizing: AnyObject {
    func startListening()
    func stopListening()
}

class SpeechRecognizer: SpeechRecognizing {
    private let audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    
    @Published var word: String?
    
    init() {
        askPermission()
    }
    
    func askPermission() {
        AVAudioApplication.requestRecordPermission { granted in
            if granted {
                print("Microphone permission granted")
            } else {
                print("Microphone permission denied")
            }
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized:
                    print("Speech recognition authorized")
                case .denied:
                    print("Speech recognition denied")
                case .restricted:
                    print("Speech recognition restricted")
                case .notDetermined:
                    print("Speech recognition not determined")
                @unknown default:
                    print("Unknown speech recognition status")
                }
            }
        }
    }
    
    func startListening() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                guard authStatus == .authorized else {
                    return
                }
                self.startAudioEngine()
            }
        }
    }
    
    func startAudioEngine() {
        recognitionTask?.cancel()
        recognitionTask = nil
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            print("Unable to create recognition request.")
            return
        }
        recognitionRequest.shouldReportPartialResults = true
        
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            recognitionRequest.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            print("Audio Engine couldn't start: \(error.localizedDescription)")
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(
            with: recognitionRequest,
            resultHandler: { [weak self] result, error in
                guard let self else { return }
                
                if let result = result {
                    if let lastSegment = result.bestTranscription.segments.last {
                        let recognizedWord = lastSegment.substring
                        print("Recognized word: \(recognizedWord)")
                        word = recognizedWord
                    }
                }
                
                if error != nil || (result?.isFinal ?? false) {
                    self.stopListening()
                }
            }
        )
    }
    
    func stopListening() {
        if audioEngine.isRunning {
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        recognitionTask = nil
    }
}
