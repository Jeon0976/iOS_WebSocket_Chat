//
//  SocketManager.swift
//  chatExample
//
//  Created by 전성훈 on 5/24/24.
//

import Foundation

final class SocketManager {
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession = URLSession(configuration: .default)
    
    func connect(to url: URL) {
        webSocketTask = urlSession.webSocketTask(with: url)
        webSocketTask?.resume()
    }
    
    func receiveMessage(completion: @escaping (Result<String,Error>) -> Void) {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Data received: \(data)")
                case .string(let strData):
                    print("receiveMessage: \(strData)")
                    completion(.success(strData))
                default:
                    break
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
            self?.receiveMessage(completion: completion)
        }
    }
    
    func sendMessage(text: String, completion: @escaping (Result<String,Error>) -> Void) {
        let message = URLSessionWebSocketTask.Message.string(text)
        
        webSocketTask?.send(
            message,
            completionHandler: { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(text))
                }
            }
        )
    }
    
    func disConnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
