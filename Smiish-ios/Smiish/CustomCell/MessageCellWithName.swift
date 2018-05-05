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
    
    func setCell(name: String?, msg: String, senderName: String){
        if(name == nil){
            self.senderName = nil
        }else{
            self.senderName.text = name
            self.senderName.font = UIFont(name: "Pacifico-Regular", size: 15)
        }
        self.message.text = msg
        
        if(name == senderName){
            message.backgroundColor = #colorLiteral(red: 0, green: 0.5604334677, blue: 1, alpha: 1)
            message.textColor = UIColor.white
        }else{
            message.backgroundColor = UIColor.lightGray
            message.textColor = UIColor.black
        }
    }

}
