//
//  Message.swift
//  OpenAIApp
//
//  Created by ihan carlos on 15/05/23.
//

import UIKit

enum TypeMessage {
    case user
    case chatGPT
}

struct Message {
    var message: String
    var date: Date
    var typeMessage: TypeMessage
}
