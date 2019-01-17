//
//  Advertiser.swift
//  BeerKit
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import MultipeerConnectivity

class Advertiser: NSObject {
    let mcSession: MCSession
    init(mcSession: MCSession) {
        self.mcSession = mcSession
        super.init()
    }
    private var advertiser: MCNearbyServiceAdvertiser?

    func startAdvertising(serviceType: String, discoveryInfo: [String: String]? = nil) {
        advertiser = MCNearbyServiceAdvertiser(peer: mcSession.myPeerID, discoveryInfo: discoveryInfo, serviceType: serviceType)
        advertiser?.delegate = self
        advertiser?.startAdvertisingPeer()
    }

    func stopAdvertising() {
        advertiser?.delegate = nil
        advertiser?.stopAdvertisingPeer()
    }

    func restartAdvertising() {
        advertiser?.startAdvertisingPeer()
        advertiser?.delegate = self
    }
}

extension Advertiser: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // https://developer.apple.com/library/content/qa/qa1869/_index.html
        invitationHandler(true, mcSession)
    }
}
