//
//  Message.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 16/10/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation


protocol MessageCellConfiguration : class {
    var textMessage: String? {get set}
    var isInComing: Bool? {get set}
}

class Message: MessageCellConfiguration {
    
    var textMessage: String?
    
    var isInComing : Bool?
    
    init(textMessage: String?, isInComing: Bool) {
        self.textMessage = textMessage
        self.isInComing = isInComing
    }
}
