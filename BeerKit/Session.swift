//
//  Session.swift
//  BeerKit
//
//  Created by Kei Fujikawa on 2019/01/16.
//  Copyright © 2019 kboy. All rights reserved.
//

import MultipeerConnectivity

public protocol SessionDelegate {
    func connecting(myPeerID: MCPeerID, toPeer peer: MCPeerID)
    func connected(myPeerID: MCPeerID, toPeer peer: MCPeerID)
    func disconnected(myPeerID: MCPeerID, fromPeer peer: MCPeerID)
    func receivedData(_ data: Data, fromPeer peer: MCPeerID)
}

public class Session: NSObject {
    public private(set) var myPeerID: MCPeerID
    public private(set) var mcSession: MCSession
    public private(set) var state: MCSessionState = .notConnected
    
    public init(displayName: String) {
        let validatedName = type(of: self)
            .validateDisplayName(displayName: displayName)
        
        myPeerID = MCPeerID(displayName: validatedName)
        mcSession = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        super.init()
        mcSession.delegate = self
    }

    public func disconnect() {
        mcSession.delegate = nil
        mcSession.disconnect()
    }
    
    // https://stackoverflow.com/a/44305215/10339551
    // The maximum allowable length is 63 bytes in UTF-8 encoding.
    // The displayName parameter may not be nil or an empty string.
    // This method throws an exception if the displayName value is too long, empty, or nil.
    private static func validateDisplayName(displayName original: String) -> String {
        var validated: String = original
        
        // If empty, put something string
        if validated.isEmpty {
            validated = "Beer"
        }
        
        // Allow only 10 bytes
        if validated.count > 10 {
            validated = String(validated.prefix(10))
        }
        return validated
    }
}

// MARK: - <#MCSessionDelegate#>
// http://stackoverflow.com/questions/18935288/why-does-my-mcsession-peer-disconnect-randomly
// needs to check peerID
extension Session: MCSessionDelegate {
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connecting:
            transceiver.connecting(myPeerID: myPeerID, toPeer: peerID)
        case .connected:
            transceiver.connected(myPeerID: myPeerID, toPeer: peerID)
            
            if self.state != .connected {
                //called n times when MCSession has n connected peers
                transceiver.advertiser.stopAdvertising()
            }
        case .notConnected:
            transceiver.disconnected(myPeerID: myPeerID, fromPeer: peerID)
            
            if self.state == .connected {
                // restart when something wrong
                transceiver.advertiser.restartAdvertising()
            }
        }
        self.state = state
    }
    
    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        transceiver.receivedData(data, fromPeer: peerID)
    }
    
    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
    
    public func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }
}
