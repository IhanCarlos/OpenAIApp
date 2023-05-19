//
//  ChatService.swift
//  OpenAIApp
//
//  Created by ihan carlos on 04/05/23.
//

import UIKit

class ChatService: ServiceManeger {
    func sendOpenAIRequest(text: String, complition: @escaping (Result<String, OpenAIError>)-> Void) {
        token.sendCompletion(with: text, model: openAIModelType ,maxTokens: 4000, completionHandler: { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let model):
                    guard let text = model.choices?.first?.text else{
                        complition(.failure(.missingChoiseText))
                        return
                    }
                    complition(.success(text))
                case.failure(let error):
                    complition(.failure(.apiError(error)))
                }
            }
        })
    }
}
