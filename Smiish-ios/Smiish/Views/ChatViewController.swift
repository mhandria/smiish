//
//  ChatViewController.swift
//  Smiish
//
//  Created by Michael Handria on 3/26/18.
//  Copyright © 2018 Michael Handria. All rights reserved.
//

import UIKit

struct Messages{
    var name: String
    var message: String
    
    init(name: String, message: String){
        self.name = name
        self.message = message
    }
}
class ChatViewController: UIViewController {
    
    var userName: String = ""
    var roomName: String = ""
    var displayName: Bool = true
    private var lastSender: String = ""
    var messages = [Messages]()
    
    @IBOutlet weak var sendButton: UIButton!
    //@IBOutlet weak var msgContent: ChatField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var msgContent: ChatField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        let rightSwipeBack = UISwipeGestureRecognizer(target: self, action: #selector(ChatViewController.goBack))
        rightSwipeBack.direction = .right
        view.addGestureRecognizer(rightSwipeBack)
        
        sendButton.layer.cornerRadius = 12
        
        
        //give table delegate.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        
        //socket event
        Socket.default.socket.on("Chat Message") { (data, ack) in
            //make sure that you get a name and msg from the Chat Message event.
            guard let name = data[0] as? String else {return}
            guard let msg = data[1] as? String else {return}
            
            //if the name is self then don't append it to view.
            self.insertMsgArray(name: name, msg: msg)
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func goBack(sender: UISwipeGestureRecognizer){
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func insertMsgArray(name: String, msg: String){
        //displayName = !(lastSender == name)
        //lastSender = name
        lastSender = ""
        displayName = true
        messages.append(Messages(name: name, message: msg))
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendMsg(_ sender: UIButton) {
        Socket.default.socket.emit("Chat Message", self.roomName, self.userName, msgContent.text)
        //for physical device testing if server is not up
        //insertMsgArray(name: userName, msg: msgContent.text)
        msgContent.text = ""
        view.endEditing(true)
    }
    
    

}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messageNew = self.messages[indexPath.row]
        if(indexPath.row > 0){
            self.displayName = (self.lastSender != messageNew.name)
        }
        self.lastSender = messageNew.name
        
        if(self.displayName){
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellView") as! MessageCellWithName
            cell.setCell(name: messageNew.name, msg: messageNew.message, senderName: self.userName)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellViewNoName") as! MessageCellNoName
            cell.setCell(name: messageNew.name, msg: messageNew.message, senderName: self.userName)
            return cell
        }
    }
}
