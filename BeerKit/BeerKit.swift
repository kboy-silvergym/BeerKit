//
//  BeerKit.swift
//  BeerKit
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import MultipeerConnectivity

public typealias PeerBlock = ((_ myPeerID: MCPeerID, _ peerID: MCPeerID) -> Void)
public typealias EventBlock = ((_ peerID: MCPeerID, _ data: Data?) -> Void)

var onConnecting: PeerBlock?
var onConnect: PeerBlock?
var onDisconnect: PeerBlock?
var eventBlocks: [String: EventBlock] = [:]

#if os(iOS)
import UIKit
public let myName = UIDevice.current.name
#else
public let myName = Host.current().localizedName ?? ""
#endif

public var transceiver = Transceiver(displayName: myName)
public var session: MCSession?

public func onConnecting(_ block: PeerBlock?){
    onConnecting = block
}

public func onConnect(_ block: PeerBlock?){
    onConnect = block
}

public func onDisconnect(_ block: PeerBlock?){
    onDisconnect = block
}

public func onEvent(_ event: String, block: EventBlock?){
    eventBlocks[event] = block
}

public func removeAllEvents(){
    eventBlocks.removeAll()
}

// MARK: - Event Handling
func didConnecting(myPeerID: MCPeerID, peer: MCPeerID) {
    if let onConnecting = onConnecting {
        DispatchQueue.main.async {
            onConnecting(myPeerID, peer)
        }
    }
}

func didConnect(myPeerID: MCPeerID, peer: MCPeerID) {
    if session == nil {
        session = transceiver.session.mcSession
    }
    if let onConnect = onConnect {
        DispatchQueue.main.async {
            onConnect(myPeerID, peer)
        }
    }
}

func didDisconnect(myPeerID: MCPeerID, peer: MCPeerID) {
    if let onDisconnect = onDisconnect {
        DispatchQueue.main.async {
            onDisconnect(myPeerID, peer)
        }
    }
}

func didReceiveData(_ data: Data, fromPeer peer: MCPeerID) {
    do {
        let entity = try JSONDecoder().decode(EventEntity.self, from: data)
        DispatchQueue.main.async {
            if let eventBlock = eventBlocks[entity.event] {
                eventBlock(peer, entity.data)
            }
        }
    } catch {
        print(error.localizedDescription)
    }
}

// MARK: - Advertise/Browse
public func transceive(serviceType: String, discoveryInfo: [String: String]? = nil) {
    transceiver.startTransceiving(serviceType: serviceType, discoveryInfo: discoveryInfo)
}

public func stopTransceiving() {
    transceiver.stopTransceiving()
    session = nil
}

public func sendEvent(_ event: String, data: Data? = nil, toPeers peers: [MCPeerID]? = session?.connectedPeers) {
    let entity = EventEntity(event: event, data: data)
    sendEvent(entity, toPeers: peers)
}

func sendEvent(_ entity: EventEntity, toPeers peers: [MCPeerID]? = session?.connectedPeers) {
    guard let peers = peers, !peers.isEmpty else {
        return
    }
    do {
        let data = try JSONEncoder().encode(entity)
        try session?.send(data, toPeers: peers, with: .reliable)
    } catch {
        print(error.localizedDescription)
    }
}
