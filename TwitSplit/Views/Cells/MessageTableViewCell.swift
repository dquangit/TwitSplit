//
//  MessageTableViewCell.swift
//  TwitSplit
//
//  Created by thuydunq on 9/4/18.
//  Copyright © 2018 dquang. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var message: UILabel!
    
    @IBOutlet weak var messageBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackground.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
