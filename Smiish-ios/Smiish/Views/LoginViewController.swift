//
//  ViewController.swift
//  Smiish
//
//  Created by Michael Handria on 3/24/18.
//  Copyright © 2018 Michael Handria. All rights reserved.
//

import UIKit
import SocketIO

class LoginViewController: UIViewController{

    @IBOutlet weak var loginLogo: UILabel!

    @IBOutlet weak var nameField: JoinField!
    @IBOutlet weak var roomField: JoinField!
    
    @IBOutlet weak var joinButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        joinButton.layer.cornerRadius = 12
        Socket.default.establishConnection()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func joinRoom(_ sender: Any) {
        nameField.hasTouch = true
        roomField.hasTouch = true
        if(roomField.text != "" && nameField.text != ""){
            Socket.default.socket.emit("Join Room", roomField.text!)
        }
    }
    
    //this function is used to double check if a user has all the
    //required info to move to the next view or not.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "Join Chat"{
            return !(nameField.text == "" || roomField.text == "")
        }
        return false
    }
    
    //function provides the next view and passes some data to the next view.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "Join Chat"{
            if let cvc = segue.destination as? ChatViewController{
                cvc.userName = nameField.text!
                cvc.roomName = roomField.text!
            }
        }
    }

}

extension UIViewController{
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
