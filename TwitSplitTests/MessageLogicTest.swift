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
        messageLogic = MessageModel()
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
        
        // Split message contained 1 word had size excess 50 characters, expected `SplitMessageError.wordExcessedCapacity`
        let message5 = "ThisIsAMessageWithWordExcess50CharactersAndExpectedAnError"
        let expected5 = SplitMessageError.wordExcessedCapacity
        XCTAssertThrowsError(try messageLogic.splitMessage(message5)) { error in
            XCTAssertEqual(error as! SplitMessageError, expected5)
        }
        
        // Split message contained 2 words, had size greater than 46 but not excess 50,
        // expected `SplitMessageError.wordExcessedCapacity`
        let message6 = "ThisIsAMessageWithWordExcess50CharactersAndExpe AMessageWithWordExcess50CharactersAndExpet"
        let expected6 = SplitMessageError.wordExcessedCapacity
        XCTAssertThrowsError(try messageLogic.splitMessage(message6)) { error in
            XCTAssertEqual(error as! SplitMessageError, expected6)
        }
        
        // Split message too long, but no word excess capacity, expected all chunks have size less than 50
        // Merge all chunks without indicators expected input.
        let message7 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."
        let splittedMessage7 = try? messageLogic.splitMessage(message7)
        let sizeExcess50array = splittedMessage7?.filter { element in
            element.count > 50
        }
        XCTAssertTrue((sizeExcess50array?.isEmpty)!)
        
        let removedIndicator = splittedMessage7?.map { element in
            element.components(separatedBy: .whitespaces).dropFirst().joined(separator: " ")
        }
        let mergedString = removedIndicator?.joined(separator: " ")
        XCTAssertEqual(mergedString, message7)
    }
}
