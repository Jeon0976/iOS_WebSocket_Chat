//
//  ChatCell.swift
//  chatExample
//
//  Created by 전성훈 on 5/24/24.
//

import UIKit

enum Sender {
    case me
    case other
}

struct Chat {
    let text: String
    let type: Sender
}


final class ChatCell: UITableViewCell {
    static let identifier = String(describing: ChatCell.self)
    
    private lazy var chatView = ChatView()
    
    private var chatLabelLeadingConstraint: NSLayoutConstraint?
    private var chatLabelTrailingConstraint: NSLayoutConstraint? 
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        chatView.clearTextField()
        
        chatLabelLeadingConstraint?.isActive = false
        chatLabelTrailingConstraint?.isActive = false
        
        chatLabelLeadingConstraint = nil
        chatLabelTrailingConstraint = nil
    }
    
    private func setupLayout() {
        [
            chatView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            chatView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            chatView.bottomAnchor.constraint(
                equalTo: self.contentView.bottomAnchor,
                constant: -6
            ),
            chatView.widthAnchor.constraint(
                lessThanOrEqualTo: self.contentView.widthAnchor,
                multiplier: 0.8,
                constant: 0
            )
        ])
    }
    
    private func setupAttribute() {
        self.backgroundColor = .white
        self.selectionStyle = .none
    }
    
    func bind(to model: Chat) {
        chatView.bind(to: model)
        
        switch model.type {
        case .me:
            myTextLabel()
        case .other:
            otherTextLabel()
        }
    }
    
    private func myTextLabel() {
        chatLabelLeadingConstraint?.isActive = false
        chatLabelLeadingConstraint = nil
        
        chatLabelTrailingConstraint = chatView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -6)
        
        chatLabelTrailingConstraint?.isActive = true
    }
    
    private func otherTextLabel() {
        chatLabelTrailingConstraint?.isActive = false
        chatLabelTrailingConstraint = nil
        
        chatLabelLeadingConstraint = chatView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 6)
        
        chatLabelLeadingConstraint?.isActive = true
    }
}
