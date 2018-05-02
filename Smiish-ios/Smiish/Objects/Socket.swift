//
//  Socket.swift
//  Smiish
//
//  Created by Michael Handria on 3/24/18.
//  Copyright © 2018 Michael Handria. All rights reserved.
//

import Foundation
import SocketIO

open class Socket{
    // establish the connection to the socket as static (shared among all instance of this class)
    open static let `default` = Socket()
    
    //have the manager be private, however, set the socket as a public
    //to allow variable decleration in other classes.
    private let manager : SocketManager
    let socket : SocketIOClient
    
    //intialize socket.
    private init(){
        manager = SocketManager(socketURL: URL(string: "https://smiish.com")!, config: [.log(false), .compress])
        socket = manager.defaultSocket
    }
    
    //establish connection
    func establishConnection(){
        addBaseHandler()
        socket.connect()
    }
    
    //add basic event handler.
    func addBaseHandler(){
        //use this for debuging to see if there are any missed events
        socket.onAny {print("Got event: \($0.event), with items: \(String(describing: $0.items))")}
        
        //do something on connected.
        socket.on(clientEvent: .connect) {
            data, ack in print("socket connected")
        }
        
        socket.on(clientEvent: .disconnect){
            data, ack in print("socket disconnected")
        }
    }
    
    func closeConnection(){
        socket.disconnect()
    }
}
