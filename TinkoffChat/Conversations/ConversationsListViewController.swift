//
//  ConversationsListViewController.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 08/10/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import UIKit


class ConversationsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CommunicatorDelegate {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        appDelegate.mpcManager.delegate = self
        //
    }
    
    var sections : [[Conversation]] = [
        [Conversation(name: "Piter", message: "Привет, как дела?" , date: Date(), online: true, hasUnreadMessages: true),
         Conversation(name:"Sergo", message: nil, date: Date(), online: true, hasUnreadMessages: false),
         Conversation(name:"Nancy", message: "Hi", date: Date(), online: true, hasUnreadMessages: false),
         Conversation(name:"Kvill", message: "What's up", date: Date(), online: true, hasUnreadMessages: false),
         Conversation(name:"Pavel", message: "Maybe", date: (Date() - (60*60*24)), online: true, hasUnreadMessages: true),
         Conversation(name:"Oleg", message: "Font color много текста очень много, много много выапврыаорываорыволарыволарыоарываыовар как много текста", date: Date(), online: true, hasUnreadMessages: false),
         Conversation(name:"Joe", message: nil, date: Date(), online: true, hasUnreadMessages: false),
         Conversation(name:"Konor", message: "25+123+24", date: (Date() - (60*60*24)), online: true, hasUnreadMessages: true),
         Conversation(name:"Bill", message: "Tratata", date: Date(), online: true, hasUnreadMessages: false),
         Conversation(name:"Stefan", message: "So Long story So Long story So Long story So Long story So Long story gjkhfjkslhgsjfdlgkb sdjgnljaehfrlewj gwejlhrfewljh flwjfh", date: Date(), online: true, hasUnreadMessages: true)],
        [Conversation(name:"Piter", message: "Привет, как дела?" , date: (Date() - (60*60*24)), online: false, hasUnreadMessages: false),
         Conversation(name:"Sergo", message: nil, date: Date(), online: false, hasUnreadMessages: false),
         Conversation(name:"Nancy", message: "Hi", date: Date(), online: false, hasUnreadMessages: true),
         Conversation(name:"Kvill", message: "What's up", date: Date(), online: false, hasUnreadMessages: true),
         Conversation(name:"Pavel", message: "Maybe", date: Date(), online: false, hasUnreadMessages: true),
         Conversation(name:"Oleg", message: "Font color много текста очень много, много много выапврыаорываорыволарыволарыоарываыовар как много текста", date: Date(), online: false, hasUnreadMessages: false),
         Conversation(name:"Joe", message: nil, date: Date(), online: false, hasUnreadMessages: false),
         Conversation(name:"Konor", message: "25+123+24", date: (Date() - (60*60*24)), online: false, hasUnreadMessages: false),
         Conversation(name:"Bill", message: "Tratata", date: Date(), online: false, hasUnreadMessages: true),
         Conversation(name:"Stefan", message: "So Long story So Long story So Long story So Long story So Long story gjkhfjkslhgsjfdlgkb sdjgnljaehfrlewj gwejlhrfewljh flwjfh", date: (Date() - (60*60*24)), online: false, hasUnreadMessages: true)]]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
         case 0:
            return "Online"
        case 1:
            return "History"
        default:
            return "end"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.mpcManager.foundPeers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        if let cell = cell as? ConversationCellConfiguration {
            let item = sections[indexPath.section][indexPath.row]
            cell.name = appDelegate.mpcManager.foundPeers[indexPath.row].displayName
            cell.message = item.message
            cell.date = item.date
            cell.online = item.online
            cell.hasUnreadMessages = item.hasUnreadMessages
        }
        return cell
    }
       
    var path = IndexPath()
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        path = indexPath
        return indexPath
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MySeg" {
            segue.destination.title = appDelegate.mpcManager.foundPeers[path.row].displayName
           //appDelegate.mpcManager.advertiser.stopAdvertisingPeer()
           // appDelegate.mpcManager.browser.stopBrowsingForPeers()
           // print(users[path.row])
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: - MC Delegate
    
    func didFoundUser(_ communicator: Communicator, user: User) {
        tableView.reloadData()
    }
    
    func didLostUser(_ communicator: Communicator, user: User) {
        tableView.reloadData()
    }
    
    func didReceiveMessage(_ communicator: Communicator, text: String, from user: User) {
        
    }
    
    func didFailed(_ communicator: Communicator, with error: Error) {
        
    }
    
    
    
    
}
