//
//  MessageViewController.swift
//  TwitSplit
//
//  Created by thuydunq on 9/3/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var messageTableView: UITableView!
    
    @IBOutlet weak var messageInput: UITextView!
    
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        send()
    }
    
    func send() {
        let message = messageInput.text
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
        let result = appendableMessages.filter { element in
            return element.count > MessageLogic.chunkCapacity
        }
        print(result)
    }
}
