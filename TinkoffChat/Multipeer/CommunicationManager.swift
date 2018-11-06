//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 05/11/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationManager: NSObject, CommunicatorDelegate {
    
    func didFoundUser(_ communicator: Communicator, user: User) {
      
    }
    
    func didLostUser(_ communicator: Communicator, user: User) {
        
    }
    
    func didReceiveMessage(_ communicator: Communicator, text: String, from user: User) {
       
    }
    
    func didFailed(_ communicator: Communicator, with error: Error) {
        
    }
    
    
}
