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
                self.addMessage(message: success, type: .chatGPT)
                self.delegate?.success()
            case.failure(let failure):
                print(failure.localizedDescription)
                self.delegate?.error(message: failure.localizedDescription)
            }
        }
    }
    
    public func addMessage(message: String, type: TypeMessage) {
        messageList.append(Message(message: message.trimmingCharacters(in: .whitespacesAndNewlines), date: Date(), typeMessage: type))
        //messageList.insert(Message(message: message.trimmingCharacters(in: .whitespacesAndNewlines), date: Date(), typeMessage: type), at: .zero)
    }
    
    public var numberOfRowsInsection: Int {
        return messageList.count
    }
    
    public func loadCurrentMessage(indexPath: IndexPath) -> Message {
        return messageList[indexPath.row]
    }
    
    public func heightForRow (indexPath: IndexPath) -> CGFloat {
        
        let message = loadCurrentMessage(indexPath: indexPath).message
        let font = UIFont.helveticaNeueMedium(size: 16)
        let estimateHeight = message.heightWithConstrainedWidth(width: 220, font: font)
        
        return estimateHeight + 65
    }
}
