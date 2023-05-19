//
//  ViewController.swift
//  OpenAIApp
//
//  Created by ihan carlos on 04/05/23.
//

import UIKit

class ChatViewController: UIViewController {
    
    var viewModel: ChatViewModel = ChatViewModel()
    var screen: ChatScreen?
    
    override func loadView() {
        self.screen = ChatScreen()
        view = screen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addLogoToNavigationBarItem(image: UIImage(systemName: "brain") ?? UIImage())
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.delegate(delegate: self)
        screen?.configTableView(delegate: self, dataSource: self)
        viewModel.delegate(delegate: self)
        // viewModel.featMessage(message: "Crie uma receita de boto de chocolate")
    }
}
extension ChatViewController: ChatViewModelProtocol {
    func success() {
        print("Warning!, the application was well implemented")
    }
    
    func error(message: String) {
        print("Warning!,the application was not well implemented\(message)")
    }
}

extension ChatViewController: ChatScreenProtocol {
    func sendMessage(text: String) {
        print(text)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInsection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = viewModel.loadCurrentMessage(indexPath: indexPath)
        
        switch message.typeMessage {
        case.user:
            let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingTextMessageTableViewCell.identifier, for: indexPath) as? OutgoingTextMessageTableViewCell
            cell?.setUpCell(data: message)
            return cell ?? UITableViewCell()
            
        case.chatGPT:
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomingTextMessageTableViewCell.identifier, for: indexPath) as? IncomingTextMessageTableViewCell
            cell?.setUpCell(data: message)
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.heightForRow(indexPath: indexPath)
    }
}
