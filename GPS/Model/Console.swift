//
//  Console.swift
//  GPS
//
//  Created by Marin on 18.01.2025.
//
import UIKit


class Console:UIView {
    var textToServer = UITextField()
    var textFromServer = UILabel()
    var sendText = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.width * 0.33, y: frame.height * 0.33, width: frame.width * 0.33, height: frame.height * 0.33))
        backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.5)
        setTextToServer()
        setTextFromServer()
        setSendText()
    }
    func setTextToServer() {
        textToServer.frame = CGRect(x: frame.width * 0.33, y: frame.height * 0.15, width: frame.width * 0.33, height: frame.height * 0.15)
        textToServer.backgroundColor = .white
        textToServer.textColor = .black
        self.addSubview(textToServer)
    }
    func setTextFromServer() {
        
    }
    func setSendText() {
        sendText.frame = CGRect(x: frame.width * (0.33+0.10), y: frame.height * 0.35, width: frame.width * (0.33-0.10), height: frame.height * 0.15)
        sendText.backgroundColor = .brown
        sendText.layer.cornerRadius = 8
        sendText.layer.borderWidth = 2
        self.addSubview(sendText)
        sendText.addTarget(self, action: #selector(sendDataToServer), for: .touchUpInside)
    }
    @objc func sendDataToServer() {
        g_server.sendMessage(text:textToServer.text!)
        print(textToServer.text!)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
