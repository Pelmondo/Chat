//
//  CommunicatorProtocol.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 05/11/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation

protocol Communicator: class {
    func sendMessage(text: String, to user: User) -> Bool
    var delegate: CommunicatorDelegate? { get set }
}

struct User {
    let uid: NSObject // Идентификатор клиента
    let name: String
}

protocol CommunicatorDelegate: class {
    func didFoundUser(_ communicator: Communicator, user: User)
    func didLostUser(_ communicator: Communicator, user: User)
    func didReceiveMessage(_ communicator: Communicator,
                           text: String,
                           from user: User)
    func didFailed(_ communicator: Communicator, with error: Error)
}
