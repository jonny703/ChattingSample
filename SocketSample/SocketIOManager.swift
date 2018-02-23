//
//  SocketIOManager.swift
//  SocketSample
//
//  Created by John Nik on 21/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import SocketIO
let chatServerUrl = "http://192.168.2.100:3000"
class SocketIOManager: NSObject {
    
    
    
    static let sharedInstance = SocketIOManager()
    
    var manager = SocketManager(socketURL: URL(string: chatServerUrl)!)
    lazy var defaultNamespaceSocket = manager.defaultSocket
    lazy var swiftSocket = manager.socket(forNamespace: "/swift")
    
    lazy var socket: SocketIOClient = SocketIOClient(manager: manager, nsp: chatServerUrl)
    
    override init() {
        super.init()
        
    }
    
    func establishConnection() {
        defaultNamespaceSocket.connect()
    }
    
    func closeConnection() {
        defaultNamespaceSocket.disconnect()
    }
    
    func connectToServerWithNickname(_ nickname: String, completionHandler: @escaping ([[String: Any]]) -> ()) {
        defaultNamespaceSocket.emit("connectUser", nickname)
        defaultNamespaceSocket.on("userList") { (dataArray, ack) in
            completionHandler(dataArray[0] as! [[String: Any]])
        }
        
        listenForOtherMessage()
    }
    
    func exitChatWithNickname(_ nickname: String, completionHandler: () -> ()) {
        
        defaultNamespaceSocket.emit("exitUser", nickname)
        completionHandler()
        
    }
    
    func sendMessage(_ message: String, nickname: String) {
        defaultNamespaceSocket.emit("chatMessage", nickname, message)
        
    }
    
    func getChatMessage(completionHandler: @escaping ([String: Any]) -> ()) {
        
        defaultNamespaceSocket.on("newChatMessage") { (dataArray, socketAck) in
            
            var messageDictionary = [String: Any]()
            messageDictionary["nickname"] = dataArray[0] as! String
            messageDictionary["message"] = dataArray[1] as! String
            messageDictionary["date"] = dataArray[2] as! String
            
            completionHandler(messageDictionary)
        }
    }
    
    func listenForOtherMessage() {
        
        defaultNamespaceSocket.on("userConnectUpdate") { (dataArray, socketAck) in
            
            
            guard let data = dataArray[0] as? [String: Any] else { return }
            NotificationCenter.default.post(name: .userWasConnectedNotification, object: data)
            
        }
        defaultNamespaceSocket.on("userExitUpdate") { (dataArray, socketAck) in
            guard let data = dataArray[0] as? [String: Any] else { return }
            NotificationCenter.default.post(name: .userWasDisconnectedNotification, object: data)
            
        }
        defaultNamespaceSocket.on("userTypingUpdate") { (dataArray, socketAck) in
            guard let data = dataArray[0] as? [String: Any] else { return }
            NotificationCenter.default.post(name: .userTypingNotification, object:data)
            
        }
        
        
    }
    
    func sendStartTypingMessage(nickname: String) {
        defaultNamespaceSocket.emit("startType", nickname)
    }
    
    func sendStopTypingMessage(nickname: String) {
        defaultNamespaceSocket.emit("stopType", nickname)
    }
    
}
