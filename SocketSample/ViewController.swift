//
//  ViewController.swift
//  SocketSample
//
//  Created by John Nik on 21/02/2018.
//  Copyright © 2018 John Nik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let cellId = "cellId"
    
    var users = [[String: Any]]()
    
    var nickname: String?
    
    var configurationOK = false
    
    lazy var tableView: UITableView = {
        
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = nickname {
            return 
        }
        
        askForNickname()
    }


}

extension ViewController {
    
    @objc func handleJoin() {
        
        guard let name = nickname else { return }
        
        let chatController = ChatController()
        chatController.nickname = name
        
        navigationController?.pushViewController(chatController, animated: true)
        
    }
    
    @objc func exitChat() {
        
        guard let nickname = nickname else { return }
        
        SocketIOManager.sharedInstance.exitChatWithNickname(nickname) {
            DispatchQueue.main.async {
                self.nickname = nil
                self.users.removeAll()
                self.tableView.reloadData()
                self.askForNickname()
            }
        }
        
    }
    
}

extension ViewController {
    
    func askForNickname() {
        
        let alert = UIAlertController(title: "SocketChat", message: "Please enter a nickname", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            let textField = alert.textFields![0]
            if textField.text?.count == 0 {
                self.askForNickname()
            } else {
                self.nickname = textField.text
                
                guard let nickname = self.nickname else { return }
                SocketIOManager.sharedInstance.connectToServerWithNickname(nickname, completionHandler: { (userList) in
                    
                    DispatchQueue.main.async {
                        self.users = userList
                        self.tableView.reloadData()
                    }
                    
                })
            }
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        
        cell.user = users[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension ViewController {
    func setupViews() {
        
        view.backgroundColor = .white
        setupNavBar()
        setupTableView()
    }
    
    private func setupNavBar() {
        navigationItem.title = "Users"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let exitButton = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitChat))
        let joinButton = UIBarButtonItem(title: "Join", style: .plain, target: self, action: #selector(handleJoin))
        navigationItem.rightBarButtonItem = joinButton
        navigationItem.leftBarButtonItem = exitButton
    }
    
    private func setupTableView() {
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        view.addSubview(tableView)
        _ = tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
}

