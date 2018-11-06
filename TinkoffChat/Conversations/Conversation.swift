//
//  Conversation.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 15/10/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import UIKit


class Conversation: ConversationCellConfiguration{
    
    var name: String?
    
    var message: String?
    
    var date: Date?
    
    var online: Bool = false
    
    var hasUnreadMessages: Bool = false
    
    init(name: String, message: String?, date: Date, online: Bool, hasUnreadMessages:Bool) {
        self.name = name
        self.message = message
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
    }
    
}
