//
//  MessageLogic.swift
//  TwitSplit
//
//  Created by thuydunq on 9/3/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import UIKit

class MessageLogic: NSObject {
    
    static let chunkCapacity = 50
    
    /**
     * Split text message into chunks with each not excess `chunkCapacity` characters
     * -
     */
    func splitMessage(_ message: String!) throws -> [String]! {
        let processMessage: String! = standardlizeString(message)
        if processMessage!.count <= MessageLogic.chunkCapacity {
            return [processMessage]
        }
        let words = processMessage.components(separatedBy: .whitespacesAndNewlines)
        let totalChunkWidthRange = try estimatedTotalChunkWidthRangeOfMessage(processMessage)
        for chunkTotalWidth in totalChunkWidthRange {
            let splittedMessage = try splitMessageWithWords(words, withTotalChunkWitdhEstimated: chunkTotalWidth)
            if !(splittedMessage?.isEmpty)! {
                return splittedMessage!
                    .enumerated()
                    .map { (index, chunk) in
                        String(format: "%d/%d %@", index + 1, splittedMessage!.count, chunk)
                    }
            }
        }
        return [String]()
    }
    
    private func estimatedTotalChunkWidthRangeOfMessage(_ message: String!) throws -> CountableRange<Int> {
        let words = message.components(separatedBy: .whitespacesAndNewlines)
        var minimumChunkQuantity: Int = message.count / MessageLogic.chunkCapacity
        if message.count % MessageLogic.chunkCapacity > 0 {
            minimumChunkQuantity = minimumChunkQuantity + 1
        }
        let maximumChunkQuanity = words.count
        guard minimumChunkQuantity <= maximumChunkQuanity else {
            throw SplitMessageError.wordExcessedCapacity
        }
        return String(minimumChunkQuantity).count..<String(maximumChunkQuanity).count+1
    }
    
    private func splitMessageWithWords(_ words: [String]!,
                               withTotalChunkWitdhEstimated totalChunkWidthEstimated: Int) throws -> [String]! {
        var count: Int = 1
        var sum: Int = 0
        var chunkStartPosition: Int = 0
        var chunkEndPosition: Int = 0
        var result: [String]! = [String]()
        for (index, word) in words.enumerated() {
            let indicatorWidth = totalChunkWidthEstimated + String(count).count + 2
            let capacity = MessageLogic.chunkCapacity - indicatorWidth
            guard word.count <= capacity else {
                throw SplitMessageError.wordExcessedCapacity
            }
            sum += word.count
            if sum < capacity && index < words.count - 1 {
                sum += 1
                continue
            }
            if String(count).count > totalChunkWidthEstimated {
                return [String]()
            }
            chunkEndPosition = (sum > capacity) ? (index - 1) : index
            let chunk = createChunkFromWords(words, withStartPosition: chunkStartPosition, endPosition: chunkEndPosition)
            result.append(chunk)
            chunkStartPosition = chunkEndPosition + 1
            sum = (sum > capacity) ? (word.count + 1) : 0
            count += 1
        }
        return result
    }
    
    private func createChunkFromWords(_ words: [String]!,
                                      withStartPosition start:Int, endPosition end:Int) -> String {
        return words[start...end].joined(separator: " ")
    }
    
    private func standardlizeString(_ string: String!) -> String! {
        return string
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { element in
                !element.isEmpty
            }.joined(separator: " ")
    }
}
