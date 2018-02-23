//
//  ChatCell.swift
//  SocketSample
//
//  Created by John Nik on 21/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit



class ChatCell: UITableViewCell {
    
    var myName: String?
    
    var message: [String: Any]? {
        didSet {
            guard let message = message else { return }
            self.setupMessage(message)
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Nik"
        label.textColor = .lightGray
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "I'm working now"
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 5, paddingRight: 15, width: 0, height: 0)
        
        addSubview(messageLabel)
        messageLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 30)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: messageLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ChatCell {
    
    fileprivate func setupMessage(_ message: [String: Any]) {
        
        guard let myName = myName else { return }
        guard let senderName = message["nickname"] as? String else  { return }
        guard let messageText = message["message"] as? String else  { return }
        guard let date = message["date"] as? String else { return }
        
        self.usernameLabel.text = "by \(senderName.uppercased()) @ \(date)"
        self.messageLabel.text = messageText
        
        if senderName == myName {
            self.usernameLabel.textAlignment = .right
            self.messageLabel.textAlignment = .right
        }
    }
}
