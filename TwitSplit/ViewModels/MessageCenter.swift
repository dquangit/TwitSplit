//
//  MessageCenter.swift
//  TwitSplit
//
//  Created by thuydunq on 9/4/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import Foundation

protocol MessageCenterDelegate: class {
    
    func onReceivedMessages(_ appendableMessages: [String]!)
    
    func onMessageSplitFailed(_ errorDescription: String!)
}

protocol MessageCenter: class {
    
    var delegate: MessageCenterDelegate? { get set }
    
    func sendMessage(_ message: String!)
}
