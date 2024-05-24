//
//  ChatView.swift
//  chatExample
//
//  Created by 전성훈 on 5/24/24.
//

import UIKit

final class ChatView: UIView {
    private lazy var chatLabel: UILabel = {
        let lbl = UILabel()
        
        lbl.numberOfLines = 0
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 16, weight: .regular)
        lbl.backgroundColor = .clear
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
        setupAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        [
            chatLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            chatLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            chatLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            chatLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            chatLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
    
    private func setupAttribute() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    func bind(to model: Chat) {
        chatLabel.text = model.text
        
        switch model.type {
        case .me:
            myTextLabel()
        case .other:
            otherTextLabel()
        }
    }
    
    private func myTextLabel() {
        chatLabel.textAlignment = .right
        self.backgroundColor = .lightGray
    }
    
    private func otherTextLabel() {
        chatLabel.textAlignment = .left
        self.backgroundColor = .systemGray6
    }
    
    func clearTextField() {
        chatLabel.text = ""
    }
}
