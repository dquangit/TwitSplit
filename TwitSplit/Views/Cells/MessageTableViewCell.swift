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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
