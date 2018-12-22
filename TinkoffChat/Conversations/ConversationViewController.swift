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
    
   
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        self.tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        registerForKeyboardNotifications()
        self.hideKeyboard()
        messegeTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)),
                                   for: UIControl.Event.editingChanged)
       appDelegate.mpcManager.advertiser.startAdvertisingPeer()
        appDelegate.mpcManager.browser.startBrowsingForPeers()
        appDelegate.mpcManager.delegate = self
    }
    
    
    deinit {
        removeKeyboardNotifications()
    }
    
    private var messages = [Message]()
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
     return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: message.isInComing, for: indexPath)
            if let cell = cell as? MessageCellConfiguration {
                let item = message
                cell.textMessage = item.textMessage
                cell.isInComing = item.isInComing
          
        }
            return cell
  }
 
    var path = IndexPath()
    // MARK: - MC Delegate
    
   
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == messegeTextField {
            if let text = messegeTextField.text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
                turnButtonWithAnimation(sendButton, on: true)
            } else {
                turnButtonWithAnimation(sendButton, on: false)
            }
        }
    }
    
    
    func didFoundUser(_ communicator: Communicator, user: User) {
        tableView.reloadData()
    }
    
    func didLostUser(_ communicator: Communicator, user: User) {
        tableView.reloadData()
    }
    var message = "text"
    var meme = [String]()
    // testing
   
    var inComingMessages = [Message]()
    var isOutMessages = [Message]()

    
    func didReceiveMessage(_ communicator: Communicator, text: String, from user: User) {
        if user.name != UIDevice.current.name {
          messages.append(Message(textMessage: text, isInComing: comingCell))
          DispatchQueue.main.async {
              self.tableView.reloadData()
           }
        }
    }
    
    func didFailed(_ communicator: Communicator, with error: Error) {
        
    }
    
    
    
    @IBAction func sendButtonDo(_ sender: UIButton) {
        guard let text = messegeTextField.text else { return}
        messages.append(Message(textMessage: text, isInComing: outCell))
        print(isOutMessages)
        let user = User(uid: appDelegate.mpcManager.foundPeers[0], name: appDelegate.mpcManager.foundPeers[0].displayName)
        tableView.reloadData()
        if appDelegate.mpcManager.sendMessage(text: text, to: user ) {
                self.messegeTextField.text = nil
                self.turnButtonWithAnimation(sendButton, on: false)
     } else {
                let alert = UIAlertController(title: "Ошибка",
                                              message: text,
                                              preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
    }
    
    
    private func turnButtonWithAnimation(_ button: UIButton, on: Bool) {
        guard button.isEnabled != on else {
            return
        }
        
        let color = on ? #colorLiteral(red: 0.1058823529, green: 0.6784313725, blue: 0.9725490196, alpha: 1) : #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        
        UIView.animate(withDuration: 0.5, animations: {
            button.isEnabled = on
            button.setTitleColor(color, for: .normal)
            button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                button.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
     // MARK - Keyboard
    
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
