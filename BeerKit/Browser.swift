//
//  Browser.swift
//  BeerKit
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import MultipeerConnectivity

class Browser: NSObject {
    private let mcSession: MCSession

    init(mcSession: MCSession) {
        self.mcSession = mcSession
        super.init()
    }
    private var mcBrowser: MCNearbyServiceBrowser?

    func startBrowsing(serviceType: String) {
        mcBrowser = MCNearbyServiceBrowser(peer: mcSession.myPeerID, serviceType: serviceType)
        mcBrowser?.delegate = self
        mcBrowser?.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        mcBrowser?.delegate = nil
        mcBrowser?.stopBrowsingForPeers()
    }
}

extension Browser: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 30)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
}
