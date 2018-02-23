//
//  ChatController.swift
//  SocketSample
//
//  Created by John Nik on 21/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit
import Toast_Swift

class ChatController: UIViewController {
    
    let cellId = "cellId"
    
    var messages = [[String: Any]]()
    
    var nickname: String?
    
    var configurationOK = false
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.keyboardDismissMode = .interactive
        return tv
    }()
    
    lazy var containerView: MessageInputAccessoryView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let commentInputAccessoryView = MessageInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        
        return commentInputAccessoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
        setupViews()
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchMessages()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ChatController {
    
    func fetchMessages() {
        
        SocketIOManager.sharedInstance.getChatMessage { (messages) in
            
            DispatchQueue.main.async {
                self.messages.append(messages)
                self.tableView.reloadData()
                self.scrollToBottom()
            }
            
        }
        
    }
    
    func scrollToBottom() {
        let delay = 0.1 * Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.messages.count > 0 {
                let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

extension ChatController: MessageInputAccessoryViewDelegate {
    func didSubmit(for comment: String) {
        guard let name = self.nickname else { return }
        SocketIOManager.sharedInstance.sendMessage(comment, nickname: name)
        containerView.clearCommentTextField()
    }
}

extension ChatController {
    
    @objc func handleConnectedUserUpdateNotification(_ notification: Notification) {
        guard let connectedUserInfo = notification.object as? [String: Any] else { return }
        guard let connectedUsername = connectedUserInfo["nickname"] as? String else { return }
        
        let text = "User \(connectedUsername.uppercased()) was just connected."
        self.handleShowToast(text: text)
    }
    
    @objc func handleDisconnectedUserUpdateNotification(_ notification: Notification) {
        guard let disconnectedUsername = notification.object as? String else { return }
        let text = "User \(disconnectedUsername.uppercased()) has left"
        self.handleShowToast(text: text)
    }
    
    @objc func handleUserTypingNotification(_ notification: Notification) {
        guard let typingUserDictionary = notification.object as? [String: Any] else { return }
        guard let name = nickname else { return }
        
        var names = ""
        var totalTypingUsers = 0
        
        for (typingUser, _) in typingUserDictionary {
            if typingUser != name {
                names = (names == "") ? typingUser : "\(names), \(typingUser)"
                totalTypingUsers += 1
            }
        }
        
        if totalTypingUsers > 0 {
            let verb = (totalTypingUsers == 1) ? "is" : "are"
            
            let text = "\(names) \(verb) now typing a message..."
            self.handleShowTypingToast(text: text)
        }
    }
    
    
    func handleShowToast(text: String) {
        
        guard let name = nickname else { return }
        let point = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
        self.view.makeToast(text, duration: 3.0, point: point, title: "Hey \(name)", image: nil, completion: nil)
    }
    
    func handleShowTypingToast(text: String) {
        
        let point = CGPoint(x: view.frame.width / 2, y: view.frame.height - 100)
        self.view.makeToast(text, duration: 2.0, point: point, title: nil, image: nil, completion: nil)
    }
}

extension ChatController {
    func setupKeyboardObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleConnectedUserUpdateNotification(_:)), name: .userWasConnectedNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDisconnectedUserUpdateNotification(_:)), name: .userWasDisconnectedNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUserTypingNotification(_:)), name: .userTypingNotification, object: nil)
        
        
        
    }
    
    @objc func handleKeyboardDidShow() {
        
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            DispatchQueue.main.async {
                if self.messages.count > 3 {
                    self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                }
                
            }
        }
        
    }
}

extension ChatController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatCell
        
        let message = messages[indexPath.row]
        cell.myName = self.nickname
        cell.message = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
extension ChatController {
    func setupViews() {
        
        view.backgroundColor = .white
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.title = "SocketChat"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        
        tableView.register(ChatCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        _ = tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 0, height: 0)
        
    }
}
