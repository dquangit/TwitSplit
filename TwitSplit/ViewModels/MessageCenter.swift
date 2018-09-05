//
//  MessageCenter.swift
//  TwitSplit
//
//  Created by thuydunq on 9/4/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import Foundation

protocol MessageCenterDelegate: class {
    
    /// Called when MessageLogic splitted message
    ///
    /// - Parameter appendableMessages: result of MessageLogic split processing
    func onReceivedMessages(_ appendableMessages: [String]!)
    
    /// Called when MessageLogic could not split message, error occurred
    ///
    /// - Parameter errorDescription: the reason why MessageLogic could not split message
    func onMessageSplitFailed(_ errorDescription: String!)
}

protocol MessageCenter: class {
    
    var delegate: MessageCenterDelegate? { get set }
    
    /// Request message logic split message and update to view after received result
    ///
    /// - Parameter message: need to split
    func sendMessage(_ message: String!)
}
