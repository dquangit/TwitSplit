//
//  MessageViewModel.swift
//  TwitSplit
//
//  Created by thuydunq on 9/3/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import UIKit

class MessageViewModel: MessageCenter {
    
    var delegate: MessageCenterDelegate?
    
    var messageLogic: MessageLogic!
    
    init() {
        messageLogic = MessageLogic()
    }
    
    func sendMessage(_ message: String!) {
        if message.isEmpty {
            return
        }
        
        do {
            let messages = try messageLogic.splitMessage(message)
            delegate?.onReceivedMessages(messages)
        } catch SplitMessageError.wordExcessedCapacity {
            let errorMessage = String(format: "Message has word excessed %d characters.", MessageLogic.chunkCapacity)
            delegate?.onMessageSplitFailed(errorMessage)
        } catch {
            let errorMessage = "Unknown reason."
            delegate?.onMessageSplitFailed(errorMessage)
        }
    }
}