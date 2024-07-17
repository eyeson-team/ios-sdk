//
//  EyesonCoordinator.swift
//  ExampleApp
//
//  Created by Michael Maier on 15.12.21.
//

import SwiftUI
import EyesonSdk
import AVFoundation

class EyesonCoordinator: ObservableObject {
    
    // MARK: Initial states
    
    @Published var startMicEnabled = true {
        didSet {
            audioMuted = !startMicEnabled
        }
    }
    @Published var startAudioOnly = false {
        didSet {
            if startAudioOnly {
                startVideoEnabled = false
                startUseRearCam = false
            }
        }
    }
    @Published var startVideoEnabled = true {
        didSet {
            videoMuted = !startVideoEnabled
            if startVideoEnabled {
                startAudioOnly = false
            }
        }
    }
    @Published var startUseRearCam = false
    
    // MARK: Controls
    
    @Published var orientation: UIDeviceOrientation = .portrait
    @Published var showsMenu = false {
        didSet {
            controlsTimer?.invalidate()
        }
    }
    @Published var showsEventLog = false
    @Published var controlsHidden: Bool = false {
        didSet {
            controlsTimer?.invalidate()
            if !controlsHidden {
                controlsTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { _ in
                    self.controlsHidden = true
                })
            }
        }
    }
    
    // MARK: Meeting
    
    @Published var localVideoView: UIView?
    @Published var remoteVideoView: UIView?
    @Published var showsLocalVideoView = false
    @Published var isLoading = false
    @Published var isReady = false
    @Published var isScreencasting = false
    @Published var isRecording = false { didSet { isRecording ? meeting?.startRecording() : meeting?.stopRecording() } }
    @Published var audioMuted = false { didSet { mute(.audio, audioMuted) } }
    @Published var videoMuted = false { didSet { mute(.video, videoMuted) } }
    @Published var remoteAudioMuted = false { didSet { mute(.remoteAudio, remoteAudioMuted) } }
    @Published var showsChat = false
    @Published var messages = [LogMessage]()
    @Published var chatMessages = [ChatMessage]()
    @Published var audioParticipants = 0
    @Published var isPresenter = false { didSet { setPresenter(isPresenter) } }
    @Published var overlayImage: UIImage? { didSet {
        overlayImage != nil ? meeting?.addLayer(image: overlayImage!, index: 1) : meeting?.removeLayer(index: 1)
    } }
        
    private var meeting: EyesonMeeting?
    private var statsTimer: Timer?
    private var controlsTimer: Timer?
    
    func load(accessKey: String) {
        isLoading = true
        Eyeson.shared.join(accessKey,
                           video: !startAudioOnly,
                           camera: startUseRearCam ? .back : .front,
                           videoMuted: videoMuted,
                           audioMuted: audioMuted,
                           completion: didJoin)
    }
    
    func load(guestToken: String, name: String) {
        isLoading = true
        Eyeson.shared.join(guestToken,
                           name: name,
                           video: !startAudioOnly,
                           camera: startUseRearCam ? .back : .front,
                           videoMuted: videoMuted,
                           audioMuted: audioMuted,
                           completion: didJoin)
    }
    
    func start(permalink userToken: String) {
        isLoading = true
        Eyeson.shared.start(permalink: userToken,
                            completion: didJoin)
    }
    
    func mute(_ device: Eyeson.Device, _ mute: Bool) {
        meeting?.mute(device, mute)
    }
    
    func muteAll() {
        meeting?.muteAll()
    }
    
    func lock() {
        meeting?.lock()
    }
    
    func snapshot() {
        meeting?.snapshot()
    }
    
    func send(chat message: String) {
        meeting?.send(chat: message)
    }
    
    private func setPresenter(_ isActive: Bool) {
        meeting?.setPresenter(isActive)
    }
    
    func toggleCam() {
        let cam: AVCaptureDevice.Position = meeting?.camera == .front ? .back : .front
        meeting?.camera = cam
    }
    
    func dismiss() {
        statsTimer?.invalidate()
        statsTimer = nil
        meeting?.leave()
    }
    
    private func didJoin(_ meeting: EyesonMeeting?, _ terminated: Eyeson.Event.Terminated?) {
        isLoading = false
        messages = []
        chatMessages = []
        guard let meeting = meeting, terminated == nil else { return }
        messages.append(LogMessage(primaryInfo: "State", secondaryInfo: "Room ready"))
        self.meeting = meeting
        self.meeting?.delegate = self
        self.statsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gatherStats), userInfo: nil, repeats: true)
        localVideoView = meeting.localVideoView
        remoteVideoView = meeting.remoteVideoView
        observeScreencast()
        isReady = true
    }
    
    private func observeScreencast() {
        meeting?.screencast.observe() { isRunning in
            self.isScreencasting = isRunning
            if !isRunning {
                self.isPresenter = false
            }
        }
    }
    
    @objc private func gatherStats() {
        meeting?.stats() { stats in
            print("ExampleApp | didReceive stats: \(stats)")
        }
    }
    
}

// MARK: EyesonDelegate methods

extension EyesonCoordinator: EyesonDelegate {
    func eyeson(_ meeting: EyesonMeeting, didReceive event: EyesonEvent) {
        print("ExampleApp | didReceive event: \(event)")
        
        switch event {
        case is Eyeson.Event.Setup:
            
            messages.append(LogMessage(primaryInfo: "Room Setup", secondaryInfo: "\(event)"))
        
        case is Eyeson.Event.Mode:
            
            guard let mode = event as? Eyeson.Event.Mode else { return }
            self.showsLocalVideoView = mode.p2p
            messages.append(LogMessage(primaryInfo: "Audio only", secondaryInfo: "\(!mode.video)"))
            messages.append(LogMessage(primaryInfo: "P2P", secondaryInfo: "\(mode.p2p)"))
        
        case is Eyeson.Event.Locked:
            
            messages.append(LogMessage(primaryInfo: "Meeting locked", secondaryInfo: ""))
        
        case is Eyeson.Event.Participants:
            
            guard let participants = event as? Eyeson.Event.Participants else { return }
            self.audioParticipants = participants.audio.count
            messages.append(LogMessage(primaryInfo: "Audio Participants", secondaryInfo: "\(participants.audio.map({ $0.name }))"))
            messages.append(LogMessage(primaryInfo: "Video Participants", secondaryInfo: "\(participants.video.map({ $0.name }))"))
            messages.append(LogMessage(primaryInfo: "Presenter", secondaryInfo: "\(String(describing: participants.presenter?.name))"))
        
        case is Eyeson.Event.Recording:
            
            guard let recording = event as? Eyeson.Event.Recording else { return }
            print(recording)
            let active = recording.duration == nil && recording.links.download == nil
            messages.append(LogMessage(primaryInfo: "Recording", secondaryInfo: "active: \(active) - ready: \(recording.links.download != nil)"))
        
        case is Eyeson.Event.Snapshots:
            
            guard let snapshots = event as? Eyeson.Event.Snapshots else { return }
            messages.append(LogMessage(primaryInfo: "New Snapshot", secondaryInfo: "Total: \(snapshots.items.count)"))
        
        case is Eyeson.Event.Voice:
            
            guard let voice = event as? Eyeson.Event.Voice else { return }
            messages.append(LogMessage(primaryInfo: "Voice Activity", secondaryInfo: "\(voice.user.name) - active: \(voice.active)"))
            
        case is Eyeson.Event.Chat:
            
            guard let chat = event as? Eyeson.Event.Chat else { return }
            let message = LogMessage(primaryInfo: chat.user.name,
                                          secondaryInfo: chat.message)
            messages.append(message)
            chatMessages.append(ChatMessage(timestamp: chat.timestamp,
                                            user: chat.user,
                                            isMe: chat.user.id == meeting.user.id,
                                            message: chat.message))
            
        case is Eyeson.Event.Muted:
            
            guard let muted = event as? Eyeson.Event.Muted else { return }
            audioMuted = true
            messages.append(LogMessage(primaryInfo: "You've got muted", secondaryInfo: "by \(muted.by.name)"))
            
        case is Eyeson.Event.Custom:
            
            guard let custom = event as? Eyeson.Event.Custom else { return }
            messages.append(LogMessage(primaryInfo: "Custom Message", secondaryInfo: custom.content))
            
        case is Eyeson.Event.Terminated:
            
            guard let terminated = event as? Eyeson.Event.Terminated else { return }
            messages.append(LogMessage(primaryInfo: "Dismiss", secondaryInfo: "Reason: \(terminated.reason)"))
            isReady = false
            
        default: break
        }
    }
}
