//
//  ViewController.swift
//  Smiish
//
//  Created by Michael Handria on 3/24/18.
//  Modified by Ethan Park 4/28/18
//  Copyright © 2018 Michael Handria. All rights reserved.
//

import UIKit
import SocketIO
import Toaster

class LoginViewController: UIViewController{

    @IBOutlet weak var nameField: JoinField!
    @IBOutlet weak var roomField: JoinField!

    @IBOutlet weak var joinButton: UIButton!

    //Create UILabel Login Logo
    let loginLogo = UIImageView(image: #imageLiteral(resourceName: "smiish_Logo"))

    //Add Login Logo Image
    //let loginLogoImg = UIImageView(image: #imageLiteral(resourceName: "smiish_splash_logo"))

    override func viewDidAppear(_ animated: Bool) {
        Socket.default.establishConnection()
    }

    //What it does when login view controller moves to next segue
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        //navigationController?.setNavigationBarHidden(false, animated: true)
        AppDelegate.AppUtility.lockOrientation(.all)

        //Cancel all Toasters
        ToastCenter.default.cancelAll()
    }

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)

        //What the viewcontroller should when entering into Login View Controller
        // Remove Navi Bar on Login View
        navigationController?.setNavigationBarHidden(true, animated: false)

        //Lock Orientation to Portait Mode
        AppDelegate.AppUtility.lockOrientation(.portrait)
        //This will initialize ViewController in portrait regardless of the device orientation - Change
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)

        //Show Keyboard as soon as VC is entered
        //userName.becomeFirstResponder()

    }



    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        SMIISH LOGO IMAGE
         */
        view.addSubview(loginLogo)

        //Add Standard Constraint without KeyBoard
        configureLayout()
        
        //Add Styling 
        styleViews()

        //Hid the Navigation Controller Bar
        self.navigationController?.isNavigationBarHidden = true

        //Create Tap Gesture to dismiss Keyboard when tapped.
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
            let args = ["roomName": roomField.text!, "username":nameField.text!]
            Socket.default.socket.emit("login", args)
        }else{
            if((nameField.text?.isEmpty)! && (roomField.text?.isEmpty)!){
                Toast(text: "Please Enter User and Room Name").show()
            }else if(roomField.text?.isEmpty)!{
                Toast(text: "Please Enter Room Name").show()
            }else if(nameField.text?.isEmpty)!{
                Toast(text: "Please Enter User Name").show()
            }
        }
        view.endEditing(true)
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

    private func addSubview(){
        view.addSubview(loginLogo)
    }

    private func styleViews(){
        
        //Add Font style to Place holder for Name and Room Field
        
        
        //Make button borner Radius 12
        joinButton.layer.cornerRadius = 12
        joinButton.setTitle("Join", for: .normal);
        joinButton.titleLabel?.font = UIFont(name: "Pacifico-Regular", size: 20)
        
    }

    private func configureLayout(){
        //Add constraints for SMIISH LOGO
        loginLogo.translatesAutoresizingMaskIntoConstraints = false
        loginLogo.centerXAnchor.constraint(equalTo: loginLogo.superview!.centerXAnchor).isActive = true
        loginLogo.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 20)
        loginLogo.bottomAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true

        //Add constraints for User Name
        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        nameField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        nameField.centerXAnchor.constraint(equalTo: nameField.superview!.centerXAnchor).isActive = true
        nameField.topAnchor.constraint(equalTo: loginLogo.bottomAnchor,constant: 20).isActive = true
        nameField.bottomAnchor.constraint(equalTo: roomField.topAnchor, constant: -10).isActive = true

        //Add Constraints for Room Name
        roomField.translatesAutoresizingMaskIntoConstraints = false
        roomField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        roomField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        roomField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        roomField.centerXAnchor.constraint(equalTo: roomField.superview!.centerXAnchor).isActive = true
        roomField.topAnchor.constraint(equalTo: nameField.bottomAnchor,constant: -20).isActive = true
        roomField.bottomAnchor.constraint(equalTo: joinButton.topAnchor, constant: -10).isActive = true

        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        roomField.bottomAnchor.constraint(equalTo: joinButton.topAnchor, constant: -20).isActive = true


        //Add Constraints for Join Button
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        joinButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        joinButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        joinButton.centerXAnchor.constraint(equalTo: joinButton.superview!.centerXAnchor).isActive = true
        joinButton.topAnchor.constraint(equalTo: roomField.bottomAnchor).isActive = true
    }
}


extension UIViewController{
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
}
