//
//  JoinField.swift
//  Smiish
//
//  Created by Michael Handria on 3/24/18.
//  Copyright © 2018 Michael Handria. All rights reserved.
//

import UIKit


@IBDesignable
class JoinField: UITextField, UITextFieldDelegate {
    
    
    var hasTouch: Bool = false{
        didSet{
            updateRightView()
        }
    }
    
    //visible properties that can be set by inspecter view.
    @IBInspectable var leftImage: UIImage?{
        didSet{
            updateLeftView()
        }
    }
    @IBInspectable var rightImageTrue: UIImage?{
        didSet{
            updateRightView()
        }
    }
    @IBInspectable var rightImageFalse: UIImage?{
        didSet{
            updateRightView()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0 {
        didSet{
            updateLeftView()
        }
    }
    @IBInspectable var rightPadding: CGFloat = 0 {
        didSet{
            updateRightView()
        }
    }
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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        delegate = self
    }
    
    //function to update the view of the ui.
    func updateLeftView(){
        if let image = leftImage{
            leftViewMode = .always
            let leftImageView = UIImageView(frame: CGRect(x: leftPadding, y: 0.0, width: 20, height: 20))
            leftImageView.image = image
            let width = leftPadding + 20
            let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
            view.addSubview(leftImageView)
            
            leftView = view
        }else{
            //image is nil
            leftViewMode = .never
        }
    }
    
    func updateRightView(){
        if hasTouch{
            let image: UIImage?
            if self.text == "" {
                image = rightImageFalse
            }else{
                image = rightImageTrue
            }
            if image != nil{
                rightViewMode = .always
                let rightImageView = UIImageView(frame: CGRect(x: -1*rightPadding, y: 0.0, width: 20, height: 20))
                rightImageView.image = image
                let width = leftPadding + 20
                let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
                view.addSubview(rightImageView)
                rightView = view
            }else{
                rightViewMode = .never
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hasTouch = true
    }
    
}
