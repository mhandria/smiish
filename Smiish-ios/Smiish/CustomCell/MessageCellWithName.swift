//
//  MessageCell.swift
//  Smiish
//
//  Created by Michael Handria on 3/27/18.
//  Copyright © 2018 Michael Handria. All rights reserved.
//

import UIKit

class MessageCellWithName: UITableViewCell {
    
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var message: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(name: String, msg: String, senderName: String){
        self.senderName.text = name
        self.message.text = msg
        
        if(name == senderName){
            message.backgroundColor = UIColor.blue
            message.textColor = UIColor.white
        }else{
            message.backgroundColor = UIColor.lightGray
            message.textColor = UIColor.black
        }
    }

}
