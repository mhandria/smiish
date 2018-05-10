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
            message.backgroundColor = #colorLiteral(red: 0.3921568627, green: 0.5921568627, blue: 1, alpha: 0.970267715)
            message.textColor = UIColor.white
        }else{
            message.backgroundColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            message.textColor = #colorLiteral(red: 0.2588235294, green: 0.2588235294, blue: 0.2588235294, alpha: 1)
        }
    }

}
