//
//  Transceiver.swift
//  BeerKit
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import MultipeerConnectivity

public class Transceiver {
    let session: Session
    let advertiser: Advertiser
    let browser: Browser

    public init(displayName: String!) {
        session = Session(displayName: displayName)
        advertiser = Advertiser(mcSession: session.mcSession)
        browser = Browser(mcSession: session.mcSession)
    }

    func startTransceiving(serviceType: String, discoveryInfo: [String: String]? = nil) {
        advertiser.startAdvertising(serviceType: serviceType, discoveryInfo: discoveryInfo)
        browser.startBrowsing(serviceType: serviceType)
    }

    func stopTransceiving() {
        advertiser.stopAdvertising()
        browser.stopBrowsing()
        session.disconnect()
    }
}

extension Transceiver: SessionDelegate {
    public func connecting(myPeerID: MCPeerID, toPeer peer: MCPeerID) {
        didConnecting(myPeerID: myPeerID, peer: peer)
    }
    
    public func connected(myPeerID: MCPeerID, toPeer peer: MCPeerID) {
        didConnect(myPeerID: myPeerID, peer: peer)
    }
    
    public func disconnected(myPeerID: MCPeerID, fromPeer peer: MCPeerID) {
        didDisconnect(myPeerID: myPeerID, peer: peer)
    }
    
    public func receivedData(_ data: Data, fromPeer peer: MCPeerID) {
        didReceiveData(data, fromPeer: peer)
    }
}
