//
//  CellChatConfig.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 16/10/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import UIKit


class CellChatConfig: UITableViewCell, MessageCellConfiguration {
    
    @IBOutlet weak var messageCome: UILabel!
    @IBOutlet weak var messageOut: UILabel!
    
    var textMessage : String?
    
    var test :Bool?
    
    
    var isInComing : Bool = true {
        didSet {
            let test = isInComing
            print(test)
            if test == false {
                if let text = textMessage {
                    messageOut.text = text
                    messageOut.layer.masksToBounds = true
                    messageOut.layer.cornerRadius = 6
                }
                
            } else {
                if let text = textMessage {
                    
                    messageCome.text = text
                    messageCome.layer.masksToBounds = true
                    messageCome.layer.cornerRadius = 6
                }
            }
        }
    }
    
}
    
