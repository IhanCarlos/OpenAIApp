//
//  ChatViewModel.swift
//  OpenAIApp
//
//  Created by ihan carlos on 04/05/23.
//

import UIKit

protocol ChatViewModelProtocol: AnyObject {
    func success()
    func error(message: String)
}

class ChatViewModel {
    
    private var service: ChatService = ChatService()
    private weak var delegate: ChatViewModelProtocol?
    private var messageList: [Message] = []
    
    public func delegate(delegate: ChatViewModelProtocol?) {
        self.delegate = delegate
    }
    public func featMessage(message: String) {
        service.sendOpenAIRequest(text: message) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let success):
                print(success)
                self.delegate?.success()
            case.failure(let failure):
                print(failure.localizedDescription)
                self.delegate?.error(message: failure.localizedDescription)
            }
        }
    }
    
    public var numberOfRowsInsection: Int {
        return messageList.count
    }
    
    public func loadCurrentMessage(indexPath: IndexPath) -> Message {
        return messageList[indexPath.row]
    }
    
    public func heightForRow (indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
