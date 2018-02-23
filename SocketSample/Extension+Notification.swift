//
//  Extension+Notification.swift
//  InstaChain
//
//  Created by John Nik on 2/1/18.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

extension Notification.Name {
    
    static let reloadPostsData = Notification.Name("reloadPostsData")
    static let reloadEventsData = Notification.Name("reloadEventsData")
    static let reloadSideMenu = Notification.Name("reloadSideMenu")
    
    static let userWasConnectedNotification = Notification.Name("userWasConnectedNotification")
    static let userWasDisconnectedNotification = Notification.Name("userWasDisconnectedNotification")
    static let userTypingNotification = Notification.Name("userTypingNotification")
}
