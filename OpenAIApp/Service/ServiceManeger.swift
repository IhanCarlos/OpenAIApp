//
//  ServiceManeger.swift
//  OpenAIApp
//
//  Created by ihan carlos on 04/05/23.
//

import UIKit
import OpenAISwift

enum OpenAIError: Error {
    case missingChoiseText
    case apiError(Error)
}

class ServiceManeger: NSObject {
    let openAIModelType: OpenAIModelType = .gpt3(.davinci)
    let token: OpenAISwift = OpenAISwift(authToken: API.authToken)
}
