# eyeson iOS SDK

## Prerequisites

A webservice to host and maintain eyeson meetings is required.
The eyeson iOS SDK acts as communication client for a valid meeting room *accessKey* or *guestToken*.
The respective keys can be obtained in exchange for an API key.
See API documentation at [eyeson developers](https://developers.eyeson.team/).

## Installation

The SDK is available via Swift Package Manager.
You will find the example app in the main branch of the [git repository](https://github.com/eyeson-team/ios-sdk).

## Simulator Runs

Since the WebRTC library does not allow to run on Simulator devices yet, 
you will need to test your implementation on a real device.

## Usage

```swift
import EyesonSdk
```

### Join a meeting room

```swift
// Join meeting with accessKey
Eyeson.shared.join(accessKey) { meeting, terminated in
  // returns a running meeting instance or terminated event
}

// Join meeting with guestToken
Eyeson.shared.join(guestToken, name: "Guest Name") { meeting, terminated in
  // ...
}

// For initial start options, you can make use of the following properties
// Same is valid for guestToken join
Eyeson.shared.join(accessKey, video: true, camera: .front, videoMuted: false, audioMuted: false) { _, _ in }
```

### Instance methods

```swift
// Handle delegate methods
meeting.delegate = self

// Share meeting link
let guestLink = meeting.links.guestLink

// Local and remote video views:
let localVideoView: UIView = meeting.localVideoView
let remoteVideoView: UIView = meeting.remoteVideoView

// Mute devices
meeting.mute(.video, true) // set false to unmute
meeting.mute(.audio, true)

// Mute all participants
meeting.muteAll()

// Set streaming camera
meeting.camera = .front // set .back for back camera

// Send a chat message
meeting.send(chat: String)

// Send a custom message
meeting.send(custom: String)

// Set self as presenter
meeting.setPresenter(true) // set false to disable

// Leave meeting
meeting.leave()

// Gathering connection stats
meeting.stats() { stats in
  // evaluate stats
}
```

### Delegate methods

```swift
// Implement the EyesonDelegate protocol
func eyeson(_ meeting: EyesonMeeting, didReceive event: EyesonEvent) {
  // Receive certain events
}
```

### Events

```swift
struct Setup: EyesonEvent {
  var locked: Bool
  var recording: Recording?
  var snapshots: [Snapshots.Item]?
  var broadcasts: [Broadcasts.Item]?
}

struct Mode: EyesonEvent {
  var video: Bool // false if audio only
  var p2p: Bool   // determines if MCU or SFU mode
}

struct Locked: EyesonEvent {
  var locked: Bool
}

struct Chat: EyesonEvent {
  var user: User
  var message: String
}

struct Custom: EyesonEvent {
  var content: String
}

struct Participants: EyesonEvent {
  var audio: [User]
  var video: [User]
  var presenter: User?
}

struct Recording: EyesonEvent {
  var id: String
  var duration: Double? // nil if recording is currently active
  var links: Links // present if recording file has been processed
  var user: User
  var createdAt: Date
}

struct Muted: EyesonEvent {
  var by: User
}

struct Voice: EyesonEvent {
  var user: user
  var active: Bool
}

struct Snapshots: EyesonEvent {
  var items: [Item]
    
  struct Item: Identifiable {
    var id: String
    var name: String
    var links: Links
    var user: User
    var createdAt: Date
  }
}

struct Broadcasts: EyesonEvent {
  var items: [Item]
    
  struct Item: Identifiable {
    var id: String
    var platform: String
    var playerUrl: URL
    var user: User
  }
}

struct Playback: EyesonEvent {
  var items: [Item]
  
  struct Item: Identifiable {
    var id: String
    var name: String
    var url: URL
    var replacementId: String
    var audio: Bool
  }
}

struct Terminated: EyesonEvent {
  var reason: TerminateReason
}

struct Stats: EyesonEvent {
  var jitter: Double
  var packetLoss: Double
  var roundTripTime: Double
  var nack: Double
  var bitrateSend: Double // Bits per second sent
  var bitrateReceive: Double  // Bits per second received
  var status: Status // Average quality good|ok|bad|unknown
  var bytesSent: Double
  var bytesReceived: Double
  var time: TimeInterval
}

// ...
```

### TerminateReason

```swift
enum TerminateReason {
    case locked
    case unwanted
    case busy
    case declined
    case terminated
    case gone
    case other
}
```

## Author

Michael Maier
eyeson GmbH
