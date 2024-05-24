//
//  ViewController.swift
//  chatExample
//
//  Created by 전성훈 on 5/24/24.
//

import UIKit

class ViewController: UIViewController {
    private let socketManager = SocketManager()
    private var chatModel: [Chat] = []

    private let chatTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            ChatCell.self,
            forCellReuseIdentifier: ChatCell.identifier
        )
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        return tableView
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.textColor = .black
        
        return textField
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton()
        
        btn.setTitle("전송", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = .lightGray
        btn.layer.cornerRadius = 6
        
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        setupAttribute()
    }

    private func setupLayout() {
        [
            chatTableView,
            textField,
            sendButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 26),
            chatTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            chatTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: textField.topAnchor),
            
            textField.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            textField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -6),
            textField.heightAnchor.constraint(equalTo: sendButton.heightAnchor),
            
            sendButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            sendButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            sendButton.widthAnchor.constraint(equalToConstant: 55),
            sendButton.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    private func setupAttribute() {
        self.view.backgroundColor = .white
        
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        
        sendButton.addTarget(self, action: #selector(sendText(_:)), for: .touchUpInside)
        
        connectWebSocket()
    }
    
    private func connectWebSocket() {
        /// notify_self 삭제
        let url = URL(string: "wss://free.blr2.piesocket.com/v3/1?api_key=Tc2TOploqXkjPRZ8CBuzjQLxnI7XpL7YjZQAuuzS")!

        socketManager.connect(to: url)
        
        socketManager.receiveMessage { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    let chat = Chat(text: message, type: .other)
                    
                    self?.updateTableView(chat: chat)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc func sendText(_ sender: UIButton) {
        if let text = textField.text {
            sendMessage(with: text)
        }
    }
    
    private func sendMessage(with text: String) {
        socketManager.sendMessage(text: text) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let message):
                    let chat = Chat(text: message, type: .me)
                    
                    self?.updateTableView(chat: chat)
                    
                    self?.textField.text = ""
                    self?.textField.endEditing(true)
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
        }
    }
    
    private func updateTableView(chat: Chat) {
        chatModel.append(chat)
        
        let indexPath = IndexPath(row: chatModel.count - 1, section: 0)
        
        chatTableView.beginUpdates()
        chatTableView.insertRows(
            at: [indexPath],
            with: chat.type == .me ? .right : .left
        )
        chatTableView.endUpdates()
        
        chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        chatModel.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatCell.identifier,
            for: indexPath
        ) as? ChatCell

        cell?.bind(to: chatModel[indexPath.row])
        
        return cell ?? UITableViewCell()
    }
}
