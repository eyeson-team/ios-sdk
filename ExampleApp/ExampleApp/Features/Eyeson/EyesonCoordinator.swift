//
//  EyesonCoordinator.swift
//  ExampleApp
//
//  Created by Michael Maier on 15.12.21.
//

import SwiftUI
import Eyeson
import AVFoundation

class EyesonCoordinator: ObservableObject {
    
    @Published var localVideoView: UIView?
    @Published var remoteVideoView: UIView?
    @Published var showsLocalVideoView = false
    @Published var isLoading = false
    @Published var isReady = false
    @Published var messages = [LogView.Message]()
    
    private var meeting: EyesonMeeting?
    private var statsTimer: Timer?
    
    func load(accessKey: String) {
        isLoading = true
        Eyeson.shared.join(accessKey,
                           completion: didJoin)
    }
    
    func load(guestToken: String, name: String) {
        isLoading = true
        Eyeson.shared.join(guestToken,
                           name: name,
                           completion: didJoin)
    }
    
    func mute(_ device: Eyeson.Device, _ mute: Bool) {
        meeting?.mute(device, mute)
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
        guard let meeting = meeting, terminated == nil else { return }
        messages.append(LogView.Message(primaryInfo: "State", secondaryInfo: "Room ready"))
        self.meeting = meeting
        self.meeting?.delegate = self
        self.statsTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(gatherStats), userInfo: nil, repeats: true)
        localVideoView = meeting.localVideoView
        remoteVideoView = meeting.remoteVideoView
        isReady = true
    }
    
    @objc private func gatherStats() {
        meeting?.stats() { stats in
            print("Eyeson | didReceive stats: \(stats)")
        }
    }
    
}

// MARK: EyesonDelegate methods

extension EyesonCoordinator: EyesonDelegate {
    func eyeson(_ meeting: EyesonMeeting, didReceive event: EyesonEvent) {
        print("Eyeson | didReceive event: \(event)")
        
        if let setup = event as? Eyeson.Event.Setup {
            messages.append(LogView.Message(primaryInfo: "Room Setup", secondaryInfo: "\(setup)"))
            return
        }
        
        if let mode = event as? Eyeson.Event.Mode {
            self.showsLocalVideoView = mode.p2p
            messages.append(LogView.Message(primaryInfo: "Audio only", secondaryInfo: "\(mode.video)"))
            messages.append(LogView.Message(primaryInfo: "P2P", secondaryInfo: "\(mode.p2p)"))
            return
        }
        
        if let _ = event as? Eyeson.Event.Locked {
            messages.append(LogView.Message(primaryInfo: "Meeting locked", secondaryInfo: ""))
            return
        }
        
        if let participants = event as? Eyeson.Event.Participants {
            messages.append(LogView.Message(primaryInfo: "Audio Participants", secondaryInfo: "\(participants.audio.map({ $0.name }))"))
            messages.append(LogView.Message(primaryInfo: "Video Participants", secondaryInfo: "\(participants.video.map({ $0.name }))"))
            messages.append(LogView.Message(primaryInfo: "Presenter", secondaryInfo: "\(String(describing: participants.presenter?.name))"))
            return
        }
        
        if let recording = event as? Eyeson.Event.Recording {
            let active = recording.duration == nil && recording.links.download == nil
            messages.append(LogView.Message(primaryInfo: "Recording", secondaryInfo: "active: \(active) - ready: \(recording.links.download != nil)"))
            return
        }
        
        if let snapshots = event as? Eyeson.Event.Snapshots {
            messages.append(LogView.Message(primaryInfo: "New Snapshot", secondaryInfo: "Total: \(snapshots.items.count)"))
            return
        }
        
        if let voice = event as? Eyeson.Event.Voice {
            messages.append(LogView.Message(primaryInfo: "Voice Activity", secondaryInfo: "\(voice.user.name) - active: \(voice.active)"))
            return
        }
        
        if let chat = event as? Eyeson.Event.Chat {
            let message = LogView.Message(primaryInfo: chat.user.name,
                                          secondaryInfo: chat.message)
            messages.append(message)
            return
        }
        
        if let muted = event as? Eyeson.Event.Muted {
            meeting.mute(.video, true)
            messages.append(LogView.Message(primaryInfo: "You've got muted", secondaryInfo: "by \(muted.by.name)"))
            return
        }
        
        if let terminated = event as? Eyeson.Event.Terminated {
            messages.append(LogView.Message(primaryInfo: "Dismiss", secondaryInfo: "Reason: \(terminated.reason)"))
            isReady = false
        }
    }
}
