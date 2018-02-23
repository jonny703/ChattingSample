//
//  UserCell.swift
//  SocketSample
//
//  Created by John Nik on 21/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    var user: [String: Any]? {
        
        didSet {
            guard let user = user else { return }
            setupUser(user)
        }
    }
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "John Nik"
        return label
    }()
    
    let onlineLabel: UILabel = {
        let label = UILabel()
        label.text = "online"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: nil, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 100, width: 0, height: 30)
        usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(onlineLabel)
        onlineLabel.anchor(top: nil, left: usernameLabel.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        onlineLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUser(_ user: [String: Any]) {
        
        guard let username = user["nickname"] as? String else { return }
        guard let isConnected = user["isConnected"] as? Bool else { return }
        
        self.usernameLabel.text = username
        self.onlineLabel.text = isConnected ? "Online" : "Offline"
        self.onlineLabel.textColor = isConnected ? .green: .gray
    }
    
}

