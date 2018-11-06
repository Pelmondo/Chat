//
//  ConversationViewController.swift
//  TinkoffChat
//
//  Created by Сергей Прокопьев on 08/10/2018.
//  Copyright © 2018 Tinkoff Fintech. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CommunicatorDelegate{
    
   
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messegeTextField: UITextField!
    private let comingCell = "come"
    private let outCell = "out"
    
    let mcConfig = MultipeerCommunicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        registerForKeyboardNotifications()
        self.hideKeyboard()
        
    }
    
    
    deinit {
        removeKeyboardNotifications()
    }
    
    var messages : [[Message]] = [[Message(textMessage:"H" ,isInComing: true),
                                Message(textMessage:"Тридцать символов вот прям точ" ,isInComing: true),
                                Message(textMessage:"Первые попытки изучения транскриптома были предприняты в начале 1990-х годов. Благодаря развитию новых технологий в конце 1990-х транскриптомика стала важной биологической наукой. В настоящий момент в транскриптомике есть два основополагающих метода: проларвлопрлоарплоплоарпвапораолврвп олврпаорп р р",isInComing: true)],
                                [Message(textMessage:"H" ,isInComing: false),
                                Message(textMessage:"Тридцать символов вот прям точ",isInComing: false),
                                Message(textMessage:"Первые попытки изучения транскриптома были предприняты в начале 1990-х годов. Благодаря развитию новых технологий в конце 1990-х транскриптомика стала важной биологической наукой. В настоящий момент в транскриптомике есть два основополагающих метода: проларвлопрлоарплоплоарпвапораолврвп олврпаорп р р" ,isInComing: false)]]
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(messages[0].count)
        return messages[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: comingCell, for: indexPath)
            if let cell = cell as? MessageCellConfiguration {
                let item = messages[indexPath.section][indexPath.row]
                cell.textMessage = message
                cell.isInComing = item.isInComing
              //  print(item.isInComing)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: outCell, for: indexPath)
            if let cell = cell as? MessageCellConfiguration {
                let item = messages[indexPath.section][indexPath.row]
                cell.textMessage = item.textMessage
                cell.isInComing = item.isInComing
               // print(item.isInComing)
        }
            return cell
  }
 }
    var path = IndexPath()
    // MARK: - MC Delegate
    
    func didFoundUser(_ communicator: Communicator, user: User) {
        tableView.reloadData()
    }
    
    func didLostUser(_ communicator: Communicator, user: User) {
        tableView.reloadData()
    }
    var message = ""
    func didReceiveMessage(_ communicator: Communicator, text: String, from user: User) {
        message = text
    }
    
    func didFailed(_ communicator: Communicator, with error: Error) {
        
    }
    
    func getMessage () -> [String:String]{
        var message = ["text":""]
        if let text = messegeTextField.text {
            message.updateValue(text, forKey: "text")
        return message
        } else {
            return message
        }
    }
    
   
    @IBAction func sendButtonDo(_ sender: UIButton) {
        let jsonData = try! JSONSerialization.data(withJSONObject: getMessage())
        do {
            try mcConfig.session.send(jsonData, toPeers: [mcConfig.foundPeers[path.row]], with: .reliable)
        } catch {
            print(error)
            
        }
    }
    
    
    
    
    // MARK: - Keyboard
    
    func removeKeyboardNotifications () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func registerForKeyboardNotifications () {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow (_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentOffset = CGPoint(x: 0, y: kbFrameSize.height)
    }
    
    @ objc func keyboardWillHide (_ notification: Notification) {
        scrollView.contentOffset = CGPoint.zero
    }
    
}


extension ConversationViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ConversationViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
