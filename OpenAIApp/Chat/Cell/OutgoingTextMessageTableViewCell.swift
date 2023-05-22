//
//  OutgoingTextMessageTableViewCell.swift
//  OpenAIApp
//
//  Created by ihan carlos on 05/05/23.
//

import UIKit

class OutgoingTextMessageTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: OutgoingTextMessageTableViewCell.self)
    
    lazy var myMessage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: "LightOrange")
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner, .layerMaxXMinYCorner ]
        
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.helveticaNeueMedium(size: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //transform = CGAffineTransform(scaleX: 1, y: -1)
        selectionStyle = .none
        backgroundColor = .backGround
        addElements()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addElements(){
        addSubview(myMessage)
        myMessage.addSubview(messageLabel)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            myMessage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            myMessage.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            myMessage.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            messageLabel.leadingAnchor.constraint(equalTo: myMessage.leadingAnchor, constant: 15),
            messageLabel.topAnchor.constraint(equalTo: myMessage.topAnchor, constant: 15),
            messageLabel.bottomAnchor.constraint(equalTo: myMessage.bottomAnchor, constant: -15),
            messageLabel.trailingAnchor.constraint(equalTo: myMessage.trailingAnchor, constant: -15),
        ])
    }
    
    public func setUpCell(data: Message) {
        messageLabel.text = data.message
    }
}
