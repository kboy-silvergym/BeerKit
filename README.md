# BeerKit 🍺

![platform](https://img.shields.io/badge/platform-ios-blue.svg) ![swift](https://img.shields.io/badge/swift-4.2-orange.svg) ![license](https://img.shields.io/badge/license-MIT-lightgrey.svg)
<a href="https://twitter.com/kboy_silvergym">![tw](https://img.shields.io/badge/twitter-%40kboy__silvergym-blue.svg)</a>

## About

The framework which is for **MultipeerConnectivity** inspired by [PeerKit](https://github.com/jpsim/PeerKit). 🍻

[PeerKit](https://github.com/jpsim/PeerKit) has some bags and it hasn't maintained recently, so I made this repository.

## Requirements
Swift 4.2. Ready for use on iOS 10.0+

## Installation

### via Cocoapods

```ruby
pod 'BeerKit'
```

## Usage

See [Example](https://github.com/kboy-silvergym/BeerKit/tree/master/Example).

### Initialize

```swift
BeerKit.transceive(serviceType: "BeerDemo")
```

### Send data

```swift
let message = MessageEntity(name: UIDevice.current.name, message: "Hi")
let data: Data = try! JSONEncoder().encode(message)
BeerKit.sendEvent("message", data: data)
```

### Observe Connected

```swift
BeerKit.onEvent("message") { (peerId, data) in
    DispatchQueue.main.async {
        self.deviceNameLabel.text = peerId.displayName
    }
}
```

### Observe Event

```swift
BeerKit.onEvent { (peerId, event, data) in
    guard let data = data,
        let message = try? JSONDecoder().decode(MessageEntity.self, from: data) else {
            return
    }
    self.messages.append(message)
    
    DispatchQueue.main.async {
        self.tableView.reloadData()
    }
}
```

## Author 🍻

<img src ="https://avatars3.githubusercontent.com/u/17683316?s=460&v=4" width=150>

**KBOY (Kei Fujikawa)**

iOS Developer in Tokyo Japan, working on AR startup named [Graffity Inc.](https://www.graffity.jp/)

- [Twitter](https://twitter.com/kboy_silvergym) / [Facebook](https://www.facebook.com/kei.fujikawa1)
- [LinkedIn](https://www.linkedin.com/in/kei-fujikawa) / [Wantedly](https://www.wantedly.com/users/17820205)

## License

BeerKit is available under the MIT license. See the LICENSE file for more info.
