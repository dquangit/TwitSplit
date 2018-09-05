//
//  MessageLogicTest.swift
//  TwitSplitTests
//
//  Created by thuydunq on 9/4/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import XCTest

class MessageLogicTest: XCTestCase {
    
    var messageLogic: MessageLogic!
    
    override func setUp() {
        super.setUp()
        messageLogic = MessageLogic()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSplitMessage() {
        // Split empty message, expected splitted message contains 1 element, and it's empty
        let message1 = ""
        let expected1 = [message1]
        let splittedMessage1 = try? messageLogic.splitMessage(message1)
        XCTAssertEqual(splittedMessage1, expected1)
        
        // Split message not excessed 50 characters, expected splitted message contains 1 element is message input
        let message2 = "Message below 50 characters"
        let expected2 = [message2]
        let splittedMessage2 = try? messageLogic.splitMessage(message2)
        XCTAssertEqual(splittedMessage2, expected2)
        
        // Split message not excess 50 characters, but whitespaces make it more than 50 characters
        // Expected splitted message contains 1 element is input message without unnecessary whitspaces
        let message3 = "         Message          with        unnecessary         whitespaces                 "
        let expected3 = ["Message with unnecessary whitespaces"]
        let splittedMessage3 = try? messageLogic.splitMessage(message3)
        XCTAssertEqual(splittedMessage3, expected3)
        
        // Split message 91 characters whith no word excessed 50 characters, expected splitted message contains 2 elements
        // each element contains indicator and not excess 50 character.
        let message4 = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected4 = ["1/2 I can't believe Tweeter now supports chunking", "2/2 my messages, so I don't have to do it myself."]
        let splittedMessage4 = try? messageLogic.splitMessage(message4)
        XCTAssertEqual(splittedMessage4, expected4)
    }
}
