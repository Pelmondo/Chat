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
   // var session: MCSession!
    var sessions: [NSObject: MCSession] = [:]
    
    private let myPeerID: MCPeerID
    override init() {
        
        myPeerID = MultipeerCommunicator.myPeerID(displayName: UIDevice.current.name)
        
        super .init()
        
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        browser.delegate = self
       
        
        
        advertiser.delegate = self
      
        
    }
    
    private lazy var session: MCSession = {
        let session = MCSession(peer: myPeerID)
        session.delegate = self
        return session
    }()
    
    
    
    let userU = User(uid: MultipeerCommunicator.myPeerID(displayName: UIDevice.current.name), name: "имя")
    
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
        
        let message = ["eventType": "TextMessage",
                       "text": text,]
        print(text)
        do {
            let json = try! JSONSerialization.data(withJSONObject: message, options: .prettyPrinted)
            print(foundPeers)
            try session.send(json, toPeers: foundPeers, with: .reliable)
        }
        catch {
            print(error)
        }
            delegate?.didReceiveMessage(self, text: text, from: userU)
            
         
        return true
    }
    
    var delegate: CommunicatorDelegate?

    
    // MARK: - MC Delegate
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
       
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
        let users = User(uid: foundPeers[0], name: foundPeers[0].displayName)
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: String]
            
            if let text = json["text"] {
                delegate?.didReceiveMessage(self, text: text, from: users)
            }
        } catch {
            print("\nResponse cannot be parsed!\n")
        }
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
            let users = User(uid: foundPeers[0], name: foundPeers[0].displayName)
        
        
            delegate?.didFoundUser(self, user: users)
        
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
        delegate?.didLostUser(self, user: userU)
    }
    
    
    func sendData(dictionaryWithData dictionary: Dictionary<String, String>, toPeer targetPeer: MCPeerID) -> Bool {
        let dataToSend = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        let peersArray = NSArray(object: targetPeer)
        var error: NSError?
        
        return true
    }
    
}
    

