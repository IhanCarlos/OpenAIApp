//
//  ChatView.swift
//  OpenAIApp
//
//  Created by ihan carlos on 04/05/23.
//

import UIKit
import AVFoundation

protocol ChatScreenProtocol: AnyObject {
    func sendMessage(text: String)
}

class ChatScreen: UIView {
    
    var player: AVAudioPlayer?
    private weak var delegate: ChatScreenProtocol?
    
    public func delegate(delegate: ChatScreenProtocol?) {
        self.delegate = delegate
    }
    
    lazy var messageInPutView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backGround
        return view
    }()
    
    lazy var messageBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.3
        button.setImage(UIImage(systemName: "location"), for: .normal)
        button.tintColor = .black
        button.isEnabled = false
        button.transform = .init(scaleX: 0.8, y: 0.8)
        button.addTarget(self, action: #selector(tappedSendButton), for: .touchUpInside)
        return button
    }()
    
    lazy var inputMessageTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.delegate = self
        tf.placeholder = "Digite aqui:"
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .darkGray
        tf.autocorrectionType = .no
        tf.keyboardType = .asciiCapable
        return tf
    }()
    
    lazy var tableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(OutgoingTextMessageTableViewCell.self, forCellReuseIdentifier: OutgoingTextMessageTableViewCell.identifier)
        tableview.register(IncomingTextMessageTableViewCell.self, forCellReuseIdentifier: IncomingTextMessageTableViewCell.identifier)
        tableview.backgroundColor = .clear
        tableview.separatorStyle = .none
        return tableview
    }()
    
    public func configTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backGround
        addElements()
        configConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addElements() {
        addSubview(tableView)
        addSubview(messageInPutView)
        addSubview(sendButton)
        messageInPutView.addSubview(messageBarView)
        messageInPutView.addSubview(inputMessageTextField)
    }
    
    private func configConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: messageInPutView.topAnchor),
            
            messageInPutView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor),
            messageInPutView.leadingAnchor.constraint(equalTo: leadingAnchor),
            messageInPutView.trailingAnchor.constraint(equalTo: trailingAnchor),
            messageInPutView.heightAnchor.constraint(equalToConstant: 80),
            
            messageBarView.leadingAnchor.constraint(equalTo: messageInPutView.leadingAnchor, constant: 20),
            messageBarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            messageBarView.heightAnchor.constraint(equalToConstant: 55),
            messageBarView.centerYAnchor.constraint(equalTo: messageInPutView.centerYAnchor),
            
            sendButton.trailingAnchor.constraint(equalTo: messageBarView.trailingAnchor, constant: -15),
            sendButton.heightAnchor.constraint(equalToConstant: 55),
            sendButton.widthAnchor.constraint(equalToConstant: 55),
            sendButton.bottomAnchor.constraint(equalTo: messageBarView.bottomAnchor, constant: -10),
            
            inputMessageTextField.leadingAnchor.constraint(equalTo: messageBarView.leadingAnchor, constant: 20),
            inputMessageTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -5),
            inputMessageTextField.heightAnchor.constraint(equalToConstant: 45),
            inputMessageTextField.centerYAnchor.constraint(equalTo: messageBarView.centerYAnchor),
            
        ])
    }
    
    @objc func tappedSendButton() {
        sendButton.touchAnimation()
        playSound()
        delegate?.sendMessage(text: inputMessageTextField.text ?? "")
        pushMessage()
    }
    
    private func pushMessage() {
        inputMessageTextField.text = ""
        sendButton.isEnabled = false
        sendButton.transform = .init(scaleX: 0.8, y: 0.8)
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "send", withExtension: "wav") else {return}
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            guard let player = self.player else {return}
            player.play()
        }catch let error {
            print("Error playing sound")
        }
    }
    public func reloadTableView() {
        tableView.reloadData()
    }
}

extension ChatScreen: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string : String)-> Bool {
        guard let text = textField.text as NSString? else {return false}
        let txtAfterUpDate = text.replacingCharacters(in: range, with: string)
        
        if txtAfterUpDate.isEmpty {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut,animations: {
                self.sendButton.isEnabled = false
                self.sendButton.transform = .init(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
            })
            
        }else{
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4,initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.sendButton.isEnabled = true
                self.sendButton.transform = .identity
            }, completion: { _ in
            })
        }
        return true
    }
    func textFieldShouldReturn(_ textFiield: UITextField) -> Bool{
        textFiield.resignFirstResponder()
        return true
    }
}
