# Multi-Stem Audio Player

A simple iOS app that allows playing and controlling multiple audio stems simultaneously.

## Features
- Play multiple audio stems (vocals, drums, bass) simultaneously
- Individual volume control for each stem
- Play/pause control
- Simple and intuitive UI

## Requirements
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Setup
1. Clone the repository
2. Open `MultiStemPlayer.xcodeproj` in Xcode
3. Build and run on your iOS device or simulator

## Project Structure
- `ContentView.swift`: Main UI view
- `AudioManager.swift`: Handles audio playback and mixing
- `StemPlayer.swift`: Individual stem player component
- `AudioStem.swift`: Model for audio stem data 