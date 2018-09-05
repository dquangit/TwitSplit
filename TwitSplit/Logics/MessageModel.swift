//
//  MessageLogic.swift
//  TwitSplit
//
//  Created by thuydunq on 9/3/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import UIKit

class MessageModel: MessageLogic {
    
    func splitMessage(_ message: String!) throws -> [String]! {
        let processMessage: String! = standardlizeString(message)
        if processMessage!.count <= MessageModel.chunkCapacity {
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
    
    /// Estimate range of character quantity of total chunk's size.
    ///
    /// - Parameter message: need to estimate
    /// - Returns: a CountableRange that describe range of width of total chunk's quantity.
    ///             Example: string can split into 3 chunks, that width of total chunk is String(3).count = 1
    /// - Throws: `SplitMessageError.wordExcessedCapacity`
    ///             if start range is greater than end range
    private func estimatedTotalChunkWidthRangeOfMessage(_ message: String!) throws -> CountableRange<Int> {
        let words = message.components(separatedBy: .whitespacesAndNewlines)
        var minimumChunkQuantity: Int = message.count / MessageModel.chunkCapacity
        if message.count % MessageModel.chunkCapacity > 0 {
            minimumChunkQuantity = minimumChunkQuantity + 1
        }
        let maximumChunkQuanity = words.count
        guard minimumChunkQuantity <= maximumChunkQuanity else {
            throw SplitMessageError.wordExcessedCapacity
        }
        return String(minimumChunkQuantity).count..<String(maximumChunkQuanity).count+1
    }
    
    
    /// Split message into chunks with estimated total chunks width
    ///
    /// - Parameters:
    ///   - words: word array
    ///   - totalChunkWidthEstimated: total chunk quantity with estimated witdh.
    ///                               Example: if estimated witdth is 1 that total chunks cannot excess 9
    ///                                         (width number just 1 character)
    ///                                         if estimated witdth is 2 that total chunks can not excess 99
    ///                                         (width number just 2 characters).
    /// - Returns: chunk array splitted with size of array is a number has exactly `totalChunkWidthEstimated` characters,
    ///             an empty array if could not split with estimated width.
    /// - Throws: `SplitMessageError.wordExcessedCapacity`
    ///             if contain one word that sum of it's size and indicator's size excess `chunkCapacity`
    private func splitMessageWithWords(_ words: [String]!,
                               withTotalChunkWitdhEstimated totalChunkWidthEstimated: Int) throws -> [String]! {
        var count: Int = 1
        var sum: Int = 0
        var chunkStartPosition: Int = 0
        var chunkEndPosition: Int = 0
        var result: [String]! = [String]()
        for (index, word) in words.enumerated() {
            let indicatorWidth = totalChunkWidthEstimated + String(count).count + 2
            let capacity = MessageModel.chunkCapacity - indicatorWidth
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
    
    
    /// Create a chunk by joind words from subarray
    ///
    /// - Parameters:
    ///   - words: word array
    ///   - start: subarray begin position
    ///   - end: subarray end position
    /// - Returns: chunk created by subarray.
    ///             Example: We have word array ["this", "is", "an", "example"]
    ///                     The start position is 1 and end position is 2
    ///                     Then subarray is ["is", "an"]
    ///                     And chunk has value "is an".
    private func createChunkFromWords(_ words: [String]!,
                                      withStartPosition start:Int, endPosition end:Int) -> String {
        return words[start...end].joined(separator: " ")
    }
    
    
    /// Standardlize `string`.
    /// Remove all whitespaces at the begin and the end of `string`
    /// Remove duplicate whitespaces by replace all two squent white spaces with one white space.
    ///
    /// - Parameter string: need to standardlize
    /// - Returns: string with no unnecessary whitespace.
    private func standardlizeString(_ string: String!) -> String! {
        return string
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { element in
                !element.isEmpty
            }.joined(separator: " ")
    }
}
