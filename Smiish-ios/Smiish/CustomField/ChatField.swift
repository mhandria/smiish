//
//  ChatField.swift
//  Smiish
//
//  Created by Michael Handria on 3/26/18.
//  Copyright © 2018 Michael Handria. All rights reserved.
//

import UIKit

@IBDesignable
class ChatField: UITextView{
    
    @IBInspectable var borderColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1){
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderRadius: CGFloat = 0{
        didSet{
            layer.cornerRadius = borderRadius
        }
    }
    

}
