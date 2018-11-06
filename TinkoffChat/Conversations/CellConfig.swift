//
//  CellConfig.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 08/10/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import UIKit

protocol ConversationCellConfiguration: class {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}


class CellConfig: UITableViewCell, ConversationCellConfiguration{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    let mcConfid = MultipeerCommunicator()
    
    var name: String? {
        didSet {
             nameLabel.text = name
        }
    }
    
    var message: String? {
        didSet {
            if message != nil {
                messageLabel.text = message
                messageLabel.font = UIFont.systemFont(ofSize: 17)
                messageLabel.textColor = UIColor.black
            } else {
                messageLabel.text = "Not message yet"
                messageLabel.font = UIFont.systemFont(ofSize: 15)
                messageLabel.textColor = UIColor.gray
            }
        }
    }
   
    var date: Date? {
        didSet {
        guard let date = self.date else {
            dateLabel.text = nil
            return
        }
        let format = Calendar.current.isDateInToday(date)
            ? "HH:mm"
            : "dd MMM"
        let formatter = DateFormatter()
        formatter.dateFormat = format
        dateLabel.text = formatter.string(from: date)
    }
  }
    
    var online: Bool = false {
        didSet {
            if online == true {
                backgroundColor = UIColor(red: 251/255.0, green: 236/255.0, blue: 93/255.0, alpha: 0.6)
            } else {
               backgroundColor = UIColor.white
        }
    }
}
    
    var hasUnreadMessages: Bool = false {
        didSet {
            if hasUnreadMessages == true {
               messageLabel.font = UIFont.boldSystemFont(ofSize: 17)
            } else {
                messageLabel.font = UIFont.systemFont(ofSize: 17)
            }
        }
    }
    
    
    override func prepareForReuse() {
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        messageLabel.textColor = UIColor.black
        name = nil
        message = nil
        online = false
        hasUnreadMessages = false
    }
}




