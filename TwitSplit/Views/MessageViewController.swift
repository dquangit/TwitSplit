//
//  MessageViewController.swift
//  TwitSplit
//
//  Created by thuydunq on 9/3/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import UIKit
import UITextView_Placeholder

class MessageViewController: UIViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageInput: UITextView!
    
    @IBOutlet weak var sendButton: UIButton!
    
    var messageCenter: MessageCenter!
    var messages: [String]! = [String]()
    lazy var splitMessageFailedAlert: UIAlertController = {
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: {[weak self] _ in
            self?.splitMessageFailedAlert.dismiss(animated: true, completion: nil)
        })
        alert.addAction(okAction)
        return alert
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageCenter = MessageViewModel()
        messageCenter.delegate = self
        messageTableView.dataSource = self
        messageTableView.delegate = self
        messageInput.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    /// Set up chat view.
    /// Hide send button
    /// Set place holder text and color for inputMessage
    func setupView() {
        messageInput.textContainerInset = UIEdgeInsetsMake(4, 4, 4, self.messageInput.frame.size.width - sendButton.frame.origin.x + 8)
        sendButton.isHidden = true
        messageInput.placeholder = "Tweet me..."
        messageInput.placeholderColor = UIColor.lightText
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        messageInputEndEditting()
    }
    
    /// Called when user pressed send or done button.
    /// Hide keyboard and take view to begin position after IQKeyboardManager bring it up.
    /// Hide send button.
    /// Send message.
    func messageInputEndEditting() {
        let message = messageInput.text
        messageInput.endEditing(true)
        self.view.bounds = CGRect(origin: CGPoint(x: 0, y: 0), size: self.view.bounds.size);
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        sendButton.isHidden = true
        messageCenter.sendMessage(message)
    }
}

extension MessageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageTableViewCell
        cell.message.text = messages[indexPath.row]
        return cell
    }
}

extension MessageViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MessageViewController: MessageCenterDelegate {
    
    func onMessageSplitFailed(_ errorDescription: String!) {
        splitMessageFailedAlert.title = "Split failed"
        splitMessageFailedAlert.message = errorDescription
        self.present(splitMessageFailedAlert, animated: true, completion: nil)
    }
    
    func onReceivedMessages(_ appendableMessages: [String]!) {
        let messageSize = messages.count
        let updateIndexes = appendableMessages.enumerated().map { (index, _) in
            IndexPath(row: index + messageSize, section: 0)
        }
        messages.append(contentsOf: appendableMessages)
        messageTableView.beginUpdates()
        messageTableView.insertRows(at: updateIndexes, with: .fade)
        messageTableView.endUpdates()
        let bottomIndex = IndexPath(row: messages.count - 1, section: 0)
        messageTableView.scrollToRow(at: bottomIndex, at: .bottom, animated: true)
        messageInput.text = ""
    }
}

extension MessageViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            messageInputEndEditting()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        sendButton.isHidden = false
    }
}
