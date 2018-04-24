//
//  ChatView.swift
//  Smiish
//
//  Created by Michael Handria on 3/27/18.
//  Copyright © 2018 Michael Handria. All rights reserved.
//

import UIKit

@IBDesignable
class ChatView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var padding: CGFloat = 0{
        didSet{
            textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        }
    }
    
    @IBInspectable var borderRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = borderRadius
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1){
        didSet{
            backgroundColor = color
        }
    }

}
