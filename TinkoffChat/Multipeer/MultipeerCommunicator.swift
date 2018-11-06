//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 05/11/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate, Communicator {
    
    var foundPeers = [MCPeerID]()
    let serviceType = "tinkoff-chat"
    
    var browser: MCNearbyServiceBrowser!
    
    var advertiser: MCNearbyServiceAdvertiser!
    var session: MCSession!
    
    private let myPeerID: MCPeerID
    override init() {
        
        myPeerID = MultipeerCommunicator.myPeerID(displayName: UIDevice.current.name)
        super .init()
        session = MCSession(peer: myPeerID)
        session.delegate = self
        
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        browser.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        
    }
    
    let user = User(uid: MultipeerCommunicator.myPeerID(displayName: UIDevice.current.name), name: "имя")
    
    static func myPeerID(displayName: String) -> MCPeerID {
        let defaults = UserDefaults.standard
        let key = "MyPeerID"
        
        if let data = defaults.data(forKey: key),
            let peerID = NSKeyedUnarchiver.unarchiveObject(with: data) as? MCPeerID,
            peerID.displayName == displayName {
            return peerID
        }
        
        let newPeerID = MCPeerID(displayName: displayName)
        let data = NSKeyedArchiver.archivedData(withRootObject: newPeerID)
        defaults.set(data, forKey: key)
        defaults.synchronize()
        return newPeerID
    }
    
    func sendMessage(text: String, to user: User) -> Bool {
        return true
    }
    
    var delegate: CommunicatorDelegate?

    
    // MARK: - MC Delegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
        let session = MCSession(peer: myPeerID)
        session.delegate = self
        invitationHandler(true, session)
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state{
        case MCSessionState.connected:
            print("Connected to session: \(session)")
            //delegate?.connectedWithPeer(peerID: peerID)
            
            
        case MCSessionState.connecting:
            print("Connecting to session: \(session)")
            
        default:
            print("Did not connect to session: \(session)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let dictionary: [String: AnyObject] = ["data": data as AnyObject, "fromPeer": peerID]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "receivedMPCDataNotification"), object: dictionary)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
            foundPeers.append(peerID)
            print(foundPeers[0].displayName)
        
            delegate?.didFoundUser(MultipeerCommunicator(), user: user)
        
            let session = MCSession(peer: myPeerID)
            session.delegate = self
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30.0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        for (index, aPeer) in foundPeers.enumerated(){
            if aPeer == peerID {
                foundPeers.remove(at: index)
                break
            }
        }
        delegate?.didLostUser(MultipeerCommunicator(), user: user)
    }
    
}
    

