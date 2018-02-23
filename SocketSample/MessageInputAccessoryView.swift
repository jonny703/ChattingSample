//
//  MessageInputAccessoryView.swift
//  InstaChain
//
//  Created by John Nik on 16/02/2018.
//  Copyright © 2018 johnik703. All rights reserved.
//

import UIKit

protocol MessageInputAccessoryViewDelegate {
    func didSubmit(for comment: String)
}

class MessageInputAccessoryView: UIView {
    
    var delegate: MessageInputAccessoryViewDelegate?
    
    func clearCommentTextField() {
        commentTextView.resignFirstResponder()
        commentTextView.text = nil
        commentTextView.showPlaceholderLabel()
    }
    
    let commentTextView: CommentInputTextView = {
        let tv = CommentInputTextView()
        tv.placeholderLabel.text = "Write a message"
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.backgroundColor = .clear
        tv.textColor = .black
        return tv
    }()
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        
        let image = UIImage(named: "send")?.withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 1.
        autoresizingMask = .flexibleHeight
        
        backgroundColor = .white
        
        addSubview(submitButton)
        submitButton.anchor(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 60, height: 50)
        
        addSubview(commentTextView)
        // 3.
        if #available(iOS 11.0, *) {
            commentTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        } else {
            // Fallback on earlier versions
        }
        
        setupLineSeparatorView()
        
    }
    
    // 2.
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    fileprivate func setupLineSeparatorView() {
        let lineSeparatorView = UIView()
        lineSeparatorView.backgroundColor = .lightGray
        addSubview(lineSeparatorView)
        lineSeparatorView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    @objc func handleSubmit() {
        
        guard let comment = commentTextView.text, comment.count > 0 else { return }
        
        delegate?.didSubmit(for: comment)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


